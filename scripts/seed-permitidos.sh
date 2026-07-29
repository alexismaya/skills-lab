#!/usr/bin/env bash
# Regenera la seccion "token:" de scripts/neutralidad-permitidos.txt a partir
# del arbol actual.
#
# ATENCION: sembrar desde el arbol da por bueno TODO lo que ya hay dentro. Solo
# es seguro si el arbol esta verificado limpio. Ante la duda, revisa a mano el
# diff del allowlist antes de commitearlo — es la lista de lo que el repo
# considera aceptable para siempre.
#
# Las secciones host: y forma: NO se regeneran: se mantienen a mano porque son
# las que deciden que dominios y que nombres de repo se consideran de ejemplo.
set -euo pipefail

# Mismo motivo que en check-neutralidad.sh: sin locale UTF-8 las clases de
# caracteres se evaluan byte a byte y el allowlist se llena de vocabulario comun.
export LC_ALL=C.UTF-8

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$ROOT/scripts/neutralidad-permitidos.txt"
TMP="$(mktemp)"

cd "$ROOT"

# Conserva cabecera + secciones host:/forma: tal cual; regenera token:
awk '/^# --- token/{exit} {print}' "$DEST" > "$TMP"

{
  echo "# --- token: nombres propios y siglas admitidos ---------------------------"
  echo "# Regenerado por scripts/seed-permitidos.sh el $(date +%Y-%m-%d)."
  echo "# Anadir a mano un token equivale a declararlo neutro de forma permanente."
  git ls-files --cached --others --exclude-standard -z | xargs -0 cat 2>/dev/null \
    | grep -oE '\b[A-ZÁÉÍÓÚÑÜ][a-záéíóúñü]+[A-ZÁÉÍÓÚÑÜ][A-Za-záéíóúñüÁÉÍÓÚÑÜ]*\b|\b[A-ZÁÉÍÓÚÑÜ]{3,}\b' \
    | sort -u | sed 's/^/token:/'
} >> "$TMP"

mv "$TMP" "$DEST"
echo "allowlist regenerado: $DEST"
echo -n "tokens: "; grep -c '^token:' "$DEST"
echo
echo "Revisa el diff antes de commitear:  git diff -- scripts/neutralidad-permitidos.txt"
