#!/usr/bin/env bash
# Instala las skills de Claude en Claude Code copiando cada carpeta e
# inyectando shared/interop-notion.md en su references/ (igual que package.sh,
# pero sin empaquetar en .skill: Claude Code lee las carpetas directamente).
#
# Claude Code descubre skills como carpetas con SKILL.md en:
#   - personal:     ~/.claude/skills/<nombre>/
#   - por proyecto: <raiz-del-proyecto>/.claude/skills/<nombre>/
# Solo instala las skills para Claude; las de Kiro (qa-discovery, qa-generator)
# corren en su propio runtime y se omiten. La copia de interop-notion.md dentro
# de cada skill es un artefacto: la fuente unica es shared/interop-notion.md.
#
# Uso:
#   ./scripts/install-claude.sh                 # instala en ~/.claude/skills
#   ./scripts/install-claude.sh /ruta/proyecto/.claude/skills
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SHARED="$ROOT/shared/interop-notion.md"
DEST="${1:-$HOME/.claude/skills}"

# Skills para Claude (las de Kiro corren en su propio runtime y se omiten).
CLAUDE_SKILLS=(
  derivar-proyecto
  sdd-harness-notion
  project-onboarding
  documentation-master
  project-deck
  project-doc
  project-audit
  git-workflow
)

[ -f "$SHARED" ] || { echo "No se encontro el contrato compartido: $SHARED" >&2; exit 1; }

mkdir -p "$DEST"
echo "Destino: $DEST"
echo

for s in "${CLAUDE_SKILLS[@]}"; do
  from="$ROOT/skills/$s"
  if [ ! -f "$from/SKILL.md" ]; then
    echo "omitir: $s (sin SKILL.md)"
    continue
  fi
  to="$DEST/$s"
  rm -rf "$to"
  cp -r "$from" "$to"
  mkdir -p "$to/references"
  cp "$SHARED" "$to/references/interop-notion.md"
  echo "ok:     $s"
done

echo
echo "Listo. En Claude Code corre /skills para verificar la lista."
