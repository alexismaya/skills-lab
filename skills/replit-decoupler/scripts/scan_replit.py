#!/usr/bin/env python3
"""Scanner de candidatos de acoplamiento Replit, sin red y de solo lectura."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Any, Iterable

SCHEMA_VERSION = 1
SKIP_DIRS = {".git", "node_modules", "dist", "build", "out", "target", "vendor", ".venv", "venv", "__pycache__", ".cache"}
PATH_NAMES = {".replit", "replit.nix", "replit.md", ".replitignore"}
PATH_SEGMENTS = {".replit-artifact"}
MANIFEST_NAMES = {
    "package.json", "package-lock.json", "pnpm-lock.yaml", "pnpm-workspace.yaml",
    "yarn.lock", "bun.lock", "bun.lockb", "pyproject.toml", "requirements.txt",
    "poetry.lock", "pipfile", "pipfile.lock", "replit.nix", "flake.nix",
}
TEXT_PATTERNS = (
    ("replit-package", re.compile(r"@replit/[A-Za-z0-9._/-]+", re.IGNORECASE)),
    ("replit-env", re.compile(r"\b(?:REPL|REPLIT)_[A-Z0-9_]+\b")),
    ("replit-domain", re.compile(r"\b(?:[a-z0-9-]+\.)*(?:replit\.dev|replit\.app|repl\.co)\b", re.IGNORECASE)),
    ("replit-token", re.compile(r"\breplit\b", re.IGNORECASE)),
)
PLATFORM_RE = re.compile(r"\b(linux|win32|windows|darwin|macos)[-_](x64|amd64|arm64|aarch64|ia32)\b", re.IGNORECASE)
OS_ALIASES = {"linux": "linux", "win32": "windows", "windows": "windows", "darwin": "macos", "macos": "macos"}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", nargs="?", default=".", help="raíz a inspeccionar")
    parser.add_argument("--format", choices=("json", "markdown"), default="json")
    parser.add_argument("--output", help="archivo de salida; stdout si se omite")
    parser.add_argument("--target-os", choices=("linux", "windows", "macos"))
    parser.add_argument("--allowlist", help="JSON con lista de coincidencias intencionales")
    parser.add_argument("--ignore-file", action="append", default=[], help="archivo auxiliar a excluir; repetible")
    parser.add_argument("--max-bytes", type=int, default=2_000_000)
    return parser.parse_args()


def git_files(root: Path) -> list[Path] | None:
    try:
        proc = subprocess.run(
            ["git", "-C", str(root), "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
            stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, check=False,
        )
    except OSError:
        return None
    if proc.returncode != 0:
        return None
    return [root / item.decode("utf-8", errors="surrogateescape") for item in proc.stdout.split(b"\0") if item]


def tree_files(root: Path) -> list[Path]:
    result: list[Path] = []
    for current, dirs, files in os.walk(root):
        dirs[:] = sorted(d for d in dirs if d not in SKIP_DIRS)
        result.extend(Path(current) / name for name in sorted(files))
    return result


def candidates(root: Path) -> list[Path]:
    files = git_files(root)
    if files is None:
        files = tree_files(root)
    return sorted({p for p in files if p.is_file()}, key=lambda p: p.as_posix().lower())


def load_allowlist(path: str | None) -> list[dict[str, Any]]:
    if not path:
        return []
    data = json.loads(Path(path).read_text(encoding="utf-8"))
    if not isinstance(data, list):
        raise ValueError("la allowlist debe ser una lista JSON")
    return data


def is_allowlisted(finding: dict[str, Any], rules: Iterable[dict[str, Any]]) -> bool:
    for rule in rules:
        if rule.get("detector") not in (None, finding["detector"]):
            continue
        if rule.get("path") not in (None, finding["path"]):
            continue
        if rule.get("line") not in (None, finding["line"]):
            continue
        return True
    return False


def finding(detector: str, rel: str, line: int | None, matched: str, evidence: str) -> dict[str, Any]:
    key = f"{detector}\0{rel}\0{line}\0{matched.casefold()}"
    return {
        "id": "RD-" + hashlib.sha256(key.encode("utf-8")).hexdigest()[:12],
        "detector": detector,
        "channel": "path" if line is None else "content",
        "path": rel,
        "line": line,
        "matched": matched,
        "evidence": evidence.strip()[:300],
        "evidence_hash": hashlib.sha256(evidence.encode("utf-8", errors="replace")).hexdigest(),
        "allowlisted": False,
    }


def is_manifest(rel: str) -> bool:
    name = Path(rel).name.lower()
    return name in MANIFEST_NAMES or name.endswith((".lock", ".lock.json"))


def scan(root: Path, target_os: str | None, max_bytes: int, allowlist: list[dict[str, Any]], ignored_paths: set[Path] | None = None) -> dict[str, Any]:
    findings: list[dict[str, Any]] = []
    skipped: list[dict[str, str]] = []
    ignored_paths = ignored_paths or set()
    files = [path for path in candidates(root) if path.resolve() not in ignored_paths]

    for path in files:
        try:
            rel = path.relative_to(root).as_posix()
        except ValueError:
            continue
        parts = set(Path(rel).parts)
        if Path(rel).name.lower() in PATH_NAMES or parts.intersection(PATH_SEGMENTS):
            findings.append(finding("platform-path", rel, None, Path(rel).name, rel))

        try:
            size = path.stat().st_size
            if size > max_bytes:
                skipped.append({"path": rel, "reason": f"size>{max_bytes}"})
                continue
            raw = path.read_bytes()
        except OSError as exc:
            skipped.append({"path": rel, "reason": f"read-error:{exc.__class__.__name__}"})
            continue
        if b"\0" in raw:
            skipped.append({"path": rel, "reason": "binary"})
            continue
        try:
            text = raw.decode("utf-8")
        except UnicodeDecodeError:
            skipped.append({"path": rel, "reason": "non-utf8"})
            continue

        for number, line_text in enumerate(text.splitlines(), 1):
            seen: set[tuple[str, str]] = set()
            for detector, pattern in TEXT_PATTERNS:
                for match in pattern.finditer(line_text):
                    token = match.group(0)
                    key = (detector, token.lower())
                    if key in seen:
                        continue
                    seen.add(key)
                    findings.append(finding(detector, rel, number, token, line_text))
            if target_os and is_manifest(rel):
                for match in PLATFORM_RE.finditer(line_text):
                    source_os = OS_ALIASES[match.group(1).lower()]
                    if source_os != target_os:
                        findings.append(finding("native-platform-pin", rel, number, match.group(0), line_text))

    unique: dict[tuple[str, str, int | None, str], dict[str, Any]] = {}
    for item in findings:
        key = (item["detector"], item["path"], item["line"], item["matched"].lower())
        unique[key] = item
    ordered = sorted(unique.values(), key=lambda x: (x["path"].lower(), x["line"] or 0, x["detector"], x["matched"].lower()))
    for item in ordered:
        item["allowlisted"] = is_allowlisted(item, allowlist)

    return {
        "schema_version": SCHEMA_VERSION,
        "root": str(root.resolve()),
        "target_os": target_os,
        "files_scanned": len(files) - len(skipped),
        "findings": ordered,
        "skipped": skipped,
        "excluded_directories": sorted(SKIP_DIRS),
    }


def as_markdown(report: dict[str, Any]) -> str:
    lines = [
        "# Inventario de candidatos Replit",
        "",
        f"- Schema: {report['schema_version']}",
        f"- Target OS: {report['target_os'] or 'no declarado'}",
        f"- Archivos inspeccionados: {report['files_scanned']}",
        f"- Hallazgos: {len(report['findings'])}",
        f"- Omitidos: {len(report['skipped'])}",
        "",
        "| ID | Detector | Ruta | Línea | Coincidencia | Allowlisted |",
        "|---|---|---|---:|---|---|",
    ]
    for item in report["findings"]:
        lines.append(f"| {item['id']} | {item['detector']} | `{item['path']}` | {item['line'] or '—'} | `{item['matched']}` | {str(item['allowlisted']).lower()} |")
    if report["skipped"]:
        lines += ["", "## Superficies omitidas", "", "| Ruta | Motivo |", "|---|---|"]
        lines += [f"| `{item['path']}` | {item['reason']} |" for item in report["skipped"]]
    return "\n".join(lines) + "\n"


def main() -> int:
    args = parse_args()
    root = Path(args.root).resolve()
    if not root.is_dir():
        print(f"error: raíz inexistente: {root}", file=sys.stderr)
        return 2
    try:
        allowlist = load_allowlist(args.allowlist)
        ignored = {Path(item).resolve() for item in args.ignore_file}
        if args.allowlist:
            ignored.add(Path(args.allowlist).resolve())
        report = scan(root, args.target_os, args.max_bytes, allowlist, ignored)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2
    content = json.dumps(report, ensure_ascii=False, indent=2) + "\n" if args.format == "json" else as_markdown(report)
    if args.output:
        Path(args.output).write_text(content, encoding="utf-8")
    else:
        sys.stdout.write(content)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
