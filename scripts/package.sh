#!/usr/bin/env bash
# Empaqueta cada skill de skills/ en dist/<nombre>.skill,
# inyectando shared/interop-notion.md en references/ de cada una.
# La copia dentro de cada skill es un artefacto de build: la fuente
# única del contrato es shared/interop-notion.md.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/dist"
for dir in "$ROOT"/skills/*/; do
  name="$(basename "$dir")"
  if [ ! -f "$dir/SKILL.md" ]; then
    echo "skip: $name (sin SKILL.md)"
    continue
  fi
  stage="$(mktemp -d)"
  cp -r "$dir" "$stage/$name"
  mkdir -p "$stage/$name/references"
  cp "$ROOT/shared/interop-notion.md" "$stage/$name/references/interop-notion.md"
  out="$ROOT/dist/$name.skill"
  rm -f "$out"
  (cd "$stage/$name" && zip -rq "$out" .)
  rm -rf "$stage"
  echo "ok:   dist/$name.skill"
done
