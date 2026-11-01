#!/usr/bin/env python3
"""Valida que un lote de perfil bajo coste sea de inferencia cero."""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path
from typing import Any

PLANNER_PROFILES = {"intermedio", "puntero", "humano"}
TASK_FIELDS = {"id", "finding_class", "location", "anchor", "change", "verification", "smoke", "stop_condition", "handoff"}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("batch", help="archivo JSON del lote")
    parser.add_argument("--expect-hash", help="falla si el hash no coincide")
    return parser.parse_args()


def nonempty(value: Any) -> bool:
    return isinstance(value, str) and bool(value.strip())


def validate(data: Any) -> list[str]:
    errors: list[str] = []
    if not isinstance(data, dict):
        return ["la raíz debe ser un objeto JSON"]

    for field in ("schema_version", "batch_id", "profile", "contract_version", "approved", "planner", "allowed_files", "protected_files", "open_questions", "tasks"):
        if field not in data:
            errors.append(f"falta campo raíz: {field}")

    if data.get("profile") != "bajo-coste":
        errors.append("profile debe ser 'bajo-coste'")
    if data.get("approved") is not True:
        errors.append("approved debe ser true")
    if not nonempty(data.get("contract_version")):
        errors.append("contract_version debe ser no vacío")
    if not isinstance(data.get("allowed_files"), list) or not data.get("allowed_files"):
        errors.append("allowed_files debe ser lista no vacía")
    if not isinstance(data.get("protected_files"), list):
        errors.append("protected_files debe ser lista")
    if data.get("open_questions") != []:
        errors.append("open_questions debe ser [] para perfil bajo coste")

    planner = data.get("planner")
    if not isinstance(planner, dict):
        errors.append("planner debe ser objeto")
    else:
        if planner.get("profile") not in PLANNER_PROFILES:
            errors.append("planner.profile debe certificar intermedio/puntero/humano")
        for field in ("name", "date"):
            if not nonempty(planner.get(field)):
                errors.append(f"planner.{field} debe ser no vacío")

    tasks = data.get("tasks")
    if not isinstance(tasks, list) or not tasks:
        errors.append("tasks debe ser lista no vacía")
        return errors

    allowed = set(data.get("allowed_files") or [])
    protected = set(data.get("protected_files") or [])
    overlap = allowed.intersection(protected)
    if overlap:
        errors.append("archivos simultáneamente permitidos/protegidos: " + ", ".join(sorted(overlap)))

    for index, task in enumerate(tasks, 1):
        prefix = f"tasks[{index}]"
        if not isinstance(task, dict):
            errors.append(f"{prefix} debe ser objeto")
            continue
        missing = TASK_FIELDS.difference(task)
        for field in sorted(missing):
            errors.append(f"{prefix}: falta {field}")
        if task.get("finding_class") != "A":
            errors.append(f"{prefix}: bajo coste solo admite clase A aprobada")
        if task.get("location") not in allowed:
            errors.append(f"{prefix}: location fuera de allowed_files")
        for field in ("id", "location", "anchor", "change", "stop_condition", "handoff"):
            if not nonempty(task.get(field)):
                errors.append(f"{prefix}.{field} debe ser no vacío")
        for block_name in ("verification", "smoke"):
            block = task.get(block_name)
            if not isinstance(block, dict):
                errors.append(f"{prefix}.{block_name} debe ser objeto")
                continue
            for field in ("command", "expected"):
                if not nonempty(block.get(field)):
                    errors.append(f"{prefix}.{block_name}.{field} debe ser no vacío")
            if block_name == "smoke" and not nonempty(block.get("positive_signal")):
                errors.append(f"{prefix}.smoke.positive_signal debe ser no vacío")
    return errors


def digest(data: Any) -> str:
    canonical = json.dumps(data, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
    return hashlib.sha256(canonical.encode("utf-8")).hexdigest()


def main() -> int:
    args = parse_args()
    try:
        data = json.loads(Path(args.batch).read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"INVALID\n- no se pudo leer JSON: {exc}")
        return 2
    errors = validate(data)
    batch_hash = digest(data)
    if args.expect_hash and args.expect_hash != batch_hash:
        errors.append(f"hash distinto: esperado {args.expect_hash}, real {batch_hash}")
    if errors:
        print("INVALID")
        for error in errors:
            print(f"- {error}")
        return 1
    print(f"VALID {batch_hash}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
