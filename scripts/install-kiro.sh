#!/usr/bin/env bash
# Instala la suite en Kiro copiando cada carpeta e inyectando
# shared/interop-notion.md en su references/ (igual que install-claude.sh, con
# otro destino: Kiro tambien lee las carpetas directamente).
#
# Kiro descubre skills como carpetas con SKILL.md en:
#   - personal:     ~/.kiro/skills/<nombre>/
#   - por proyecto: <raiz-del-proyecto>/.kiro/skills/<nombre>/
#
# La lista se deriva de skills/: toda carpeta con SKILL.md se instala. Ver la
# nota de install-claude.sh sobre por que no hay lista fija.
#
# Este script existe porque su ausencia tenia un costo medible: mientras las
# copias de Claude se refrescaban con su instalador, las de Kiro se quedaron
# meses atras: skills paradas en el commit inicial, un archivo de referencia
# entero que nunca llego, y el contrato desactualizado en todas. Una
# instalacion que se hace a mano se deja de hacer.
#
# La copia de interop-notion.md dentro de cada skill es un artefacto: la fuente
# unica es shared/interop-notion.md.
#
# Uso:
#   ./scripts/install-kiro.sh                   # instala en ~/.kiro/skills
#   ./scripts/install-kiro.sh /ruta/proyecto/.kiro/skills
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SHARED="$ROOT/shared/interop-notion.md"
DEST="${1:-$HOME/.kiro/skills}"

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
echo "$n skills instaladas en Kiro."
