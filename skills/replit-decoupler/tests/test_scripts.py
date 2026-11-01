from __future__ import annotations

import json
import re
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCANNER = ROOT / "scripts" / "scan_replit.py"
VALIDATOR = ROOT / "scripts" / "validate_batch.py"
FIXTURES = ROOT / "evals" / "fixtures"


class ScannerTests(unittest.TestCase):
    def run_scanner(self, fixture: Path, expected: dict, fmt: str = "json") -> subprocess.CompletedProcess[str]:
        command = [sys.executable, str(SCANNER), str(fixture), "--format", fmt,
                   "--ignore-file", str(fixture / "expected-findings.json")]
        if expected.get("target_os"):
            command += ["--target-os", expected["target_os"]]
        if expected.get("allowlist"):
            command += ["--allowlist", str(fixture / expected["allowlist"])]
        return subprocess.run(command, text=True, capture_output=True, check=False)

    def test_all_fixture_oracles_match_exactly(self) -> None:
        fixture_dirs = sorted(path.parent for path in FIXTURES.glob("*/expected-findings.json"))
        self.assertGreaterEqual(len(fixture_dirs), 8)
        for fixture in fixture_dirs:
            with self.subTest(fixture=fixture.name):
                expected = json.loads((fixture / "expected-findings.json").read_text(encoding="utf-8"))
                proc = self.run_scanner(fixture, expected)
                self.assertEqual(proc.returncode, 0, proc.stderr)
                report = json.loads(proc.stdout)
                actual_rows = [
                    {key: item[key] for key in ("detector", "path", "line", "allowlisted")}
                    for item in report["findings"]
                ]
                self.assertEqual(actual_rows, expected["findings"])
                self.assertEqual(report["skipped"], [])
                for candidate in expected.get("rejected_candidates", []):
                    self.assertFalse(
                        any(candidate.casefold() in item["matched"].casefold() for item in report["findings"]),
                        f"candidato rechazado detectado: {candidate}",
                    )

    def test_finding_id_is_case_normalized(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            source = root / "package.json"
            ids = []
            for token in ("@replit/example", "@REPLIT/example"):
                source.write_text(json.dumps({"dependencies": {token: "1.0.0"}}), encoding="utf-8")
                proc = subprocess.run([sys.executable, str(SCANNER), str(root)], text=True, capture_output=True)
                self.assertEqual(proc.returncode, 0, proc.stderr)
                report = json.loads(proc.stdout)
                ids.append(next(item["id"] for item in report["findings"] if item["detector"] == "replit-package"))
            self.assertEqual(ids[0], ids[1])

    def test_native_platform_pin_requires_target_os(self) -> None:
        for name in ("native-linux-to-windows", "native-windows-to-linux"):
            fixture = FIXTURES / name
            with self.subTest(fixture=name):
                proc = subprocess.run([
                    sys.executable, str(SCANNER), str(fixture),
                    "--ignore-file", str(fixture / "expected-findings.json"),
                ], text=True, capture_output=True)
                self.assertEqual(proc.returncode, 0, proc.stderr)
                report = json.loads(proc.stdout)
                self.assertFalse(any(item["detector"] == "native-platform-pin" for item in report["findings"]))

    def test_markdown_contains_every_json_finding_id(self) -> None:
        fixture = FIXTURES / "frontend-tooling"
        expected = json.loads((fixture / "expected-findings.json").read_text(encoding="utf-8"))
        json_proc = self.run_scanner(fixture, expected)
        md_proc = self.run_scanner(fixture, expected, "markdown")
        self.assertEqual(md_proc.returncode, 0, md_proc.stderr)
        for item in json.loads(json_proc.stdout)["findings"]:
            self.assertIn(item["id"], md_proc.stdout)

    def test_binary_is_declared_skipped(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            (root / ".replit").write_text("run='python app.py'", encoding="utf-8")
            (root / "blob.bin").write_bytes(b"\x00\x01replit")
            proc = subprocess.run([sys.executable, str(SCANNER), str(root)], text=True, capture_output=True)
            self.assertEqual(proc.returncode, 0, proc.stderr)
            report = json.loads(proc.stdout)
            self.assertIn({"path": "blob.bin", "reason": "binary"}, report["skipped"])
            self.assertTrue(any(item["detector"] == "platform-path" for item in report["findings"]))


class BatchValidatorTests(unittest.TestCase):
    def test_valid_batch_returns_hash(self) -> None:
        proc = subprocess.run([sys.executable, str(VALIDATOR), str(FIXTURES / "batches" / "valid.json")], text=True, capture_output=True)
        self.assertEqual(proc.returncode, 0, proc.stdout)
        self.assertRegex(proc.stdout.strip(), r"^VALID [0-9a-f]{64}$")

    def test_invalid_batch_fails_with_multiple_reasons(self) -> None:
        proc = subprocess.run([sys.executable, str(VALIDATOR), str(FIXTURES / "batches" / "invalid.json")], text=True, capture_output=True)
        self.assertEqual(proc.returncode, 1)
        self.assertIn("bajo coste solo admite clase A", proc.stdout)
        self.assertIn("open_questions debe ser []", proc.stdout)
        self.assertIn("smoke.positive_signal", proc.stdout)

    def test_expected_hash_detects_changed_batch(self) -> None:
        proc = subprocess.run([
            sys.executable, str(VALIDATOR), str(FIXTURES / "batches" / "valid.json"),
            "--expect-hash", "0" * 64,
        ], text=True, capture_output=True)
        self.assertEqual(proc.returncode, 1)
        self.assertIn("hash distinto", proc.stdout)


if __name__ == "__main__":
    unittest.main()
