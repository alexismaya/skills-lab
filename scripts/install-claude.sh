#!/usr/bin/env bash
# Instala la suite en Claude Code copiando cada carpeta e inyectando
# shared/interop-notion.md en su references/ (igual que package.sh, pero sin
# empaquetar en .skill: Claude Code lee las carpetas directamente).
#
# Claude Code descubre skills como carpetas con SKILL.md en:
#   - personal:     ~/.claude/skills/<nombre>/
#   - por proyecto: <raiz-del-proyecto>/.claude/skills/<nombre>/
#
# La lista se deriva de skills/: toda carpeta con SKILL.md se instala. No hay
# lista fija que mantener, y es deliberado — una lista fija se desincroniza en
# silencio por dos lados: una skill nueva no llega a ningun runtime, y una skill
# ya instalada que quede fuera de la lista conserva el contrato viejo mientras
# las demas avanzan, dejando dos versiones del contrato conviviendo en el mismo
# runtime. Las dos fallas ocurrieron.
#
# Todas las skills son portables entre runtimes (ver la tabla de equivalencias
# en shared/interop-notion.md), asi que se instalan todas. La columna
# "Integracion prevista" de CLAUDE.md documenta para que runtime se diseno cada
# una, no cual puede ejecutarla.
#
# La copia de interop-notion.md dentro de cada skill es un artefacto: la fuente
# unica es shared/interop-notion.md.
#
# Uso:
#   ./scripts/install-claude.sh                 # instala en ~/.claude/skills
#   ./scripts/install-claude.sh /ruta/proyecto/.claude/skills
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SHARED="$ROOT/shared/interop-notion.md"
DEST="${1:-$HOME/.claude/skills}"

[ -f "$SHARED" ] || { echo "No se encontro el contrato compartido: $SHARED" >&2; exit 1; }

mkdir -p "$DEST"
echo "Destino: $DEST"
echo

n=0
for from in "$ROOT"/skills/*; do
  [ -d "$from" ] || continue
  s="$(basename "$from")"
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
  n=$((n + 1))
done

echo
echo "$n skills instaladas. En Claude Code corre /skills para verificar la lista."
