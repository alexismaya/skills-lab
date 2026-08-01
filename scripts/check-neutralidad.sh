#!/usr/bin/env bash
# Verifica que no entre material identificable al repo.
#
# Superficies cubiertas: contenido de archivos, nombres de archivo, mensajes de
# commit y nombre de rama. El mensaje de commit es la superficie que no revisa
# ninguna lectura de diff, y es por donde se ha colado material en el pasado.
#
# Este archivo NO contiene terminos sensibles: la lista versionada
# (scripts/neutralidad-permitidos.txt) es de lo PERMITIDO, no de lo prohibido.
# Una lista de prohibidos versionada republicaria exactamente lo que se oculta.
#
# Capa opcional: si existe .neutralidad-local (ignorado por git) o la variable
# NEUTRALIDAD_LOCAL apunta a un archivo, sus lineas se tratan como prohibidas.
#
# Uso:
#   ./scripts/check-neutralidad.sh --staged           # lo que esta en el index
#   ./scripts/check-neutralidad.sh --msg <archivo>    # un mensaje de commit
#   ./scripts/check-neutralidad.sh --range <a>..<b>   # un rango de commits
#   ./scripts/check-neutralidad.sh --all              # auditoria del arbol
set -uo pipefail

# Imprescindible: sin locale UTF-8, grep interpreta las clases de caracteres
# byte a byte y una palabra como "Acción" se captura como si fuera CamelCase
# (el primer byte de "ó" cae dentro de la clase de mayusculas acentuadas).
# En un repo escrito en español eso llena el allowlist de vocabulario comun y
# deja la capa 4 sin capacidad de discriminar.
export LC_ALL=C.UTF-8

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PERMITIDOS="$ROOT/scripts/neutralidad-permitidos.txt"
LOCAL="${NEUTRALIDAD_LOCAL:-$ROOT/.neutralidad-local}"
MODO="${1:---staged}"
FALLOS=0

# Textos de terceros incluidos verbatim: no son contenido de autor y no pueden
# filtrar material identificable, porque son byte a byte un documento publico
# conocido. Se excluyen de la inspeccion en vez de permitir sus terminos uno a
# uno: el vocabulario juridico en mayusculas de una licencia son decenas de
# tokens que, admitidos para siempre en el allowlist, dejarian a la capa 4 sin
# capacidad de discriminar — el mismo modo de fallo contra el que se fijo el
# locale mas arriba. Si se anade otro texto de terceros, va aqui, no al
# allowlist.
EXCLUIR=(':(exclude)LICENSE')

rojo()  { printf '\033[31m%s\033[0m\n' "$*" >&2; }
verde() { printf '\033[32m%s\033[0m\n' "$*"; }

[ -f "$PERMITIDOS" ] || { rojo "falta $PERMITIDOS"; exit 2; }

# Extrae una categoria del allowlist ("host", "forma", "token").
permitidos() { grep "^$1:" "$PERMITIDOS" 2>/dev/null | cut -d: -f2- | grep -v '^$' || true; }

# --- recolectar el texto a inspeccionar -------------------------------------
anadidas() { grep '^+' | grep -v '^+++' | sed 's/^+//'; }

case "$MODO" in
  --staged)
    TEXTO="$(git diff --cached -U0 -- . "${EXCLUIR[@]}" | anadidas)"
    NOMBRES="$(git diff --cached --name-only --diff-filter=ACR -- . "${EXCLUIR[@]}")" ;;
  --msg)
    [ -n "${2:-}" ] || { rojo "uso: --msg <archivo>"; exit 2; }
    TEXTO="$(cat "$2")"; NOMBRES="" ;;
  --range)
    [ -n "${2:-}" ] || { rojo "uso: --range <a>..<b>"; exit 2; }
    TEXTO="$(git log "$2" --pretty='%B%n%an%n%ae' 2>/dev/null; git diff "$2" -U0 -- . "${EXCLUIR[@]}" 2>/dev/null | anadidas)"
    NOMBRES="$(git diff "$2" --name-only --diff-filter=ACR -- . "${EXCLUIR[@]}" 2>/dev/null)" ;;
  --all)
    TEXTO="$(git ls-files --cached --others --exclude-standard -z -- . "${EXCLUIR[@]}" | xargs -0 cat 2>/dev/null)"
    NOMBRES="$(git ls-files --cached --others --exclude-standard -- . "${EXCLUIR[@]}")" ;;
  *)
    echo "uso: check-neutralidad.sh [--staged|--msg <f>|--range <a>..<b>|--all]" >&2; exit 2 ;;
esac

BLOQUE="$TEXTO
$NOMBRES"
[ -n "$(printf '%s' "$BLOQUE" | tr -d '[:space:]')" ] || { verde "neutralidad OK ($MODO, sin contenido)"; exit 0; }

reporta() { rojo "$1"; printf '  %s\n' $2 | sort -u >&2; FALLOS=1; }

# --- capa 1: deterministas ---------------------------------------------------
# Un correo se admite si coincide con una entrada completa (contiene @) o si su
# dominio coincide con una entrada de dominio, o es subdominio suyo.
CORREO_RE="$(permitidos correo | sed 's/\./\\./g' \
  | awk '{ if (index($0,"@")) print "^" $0 "$"; else print "@([a-z0-9-]+\\.)*" $0 "$" }' | paste -sd'|' -)"
CORREOS="$(printf '%s' "$BLOQUE" \
  | grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' \
  | { [ -n "$CORREO_RE" ] && grep -viE "${CORREO_RE}" || cat; } || true)"
[ -n "$CORREOS" ] && reporta "correo no permitido:" "$CORREOS"

# Un host se admite si coincide con uno permitido o es subdominio suyo:
# api.example.com debe pasar con example.com en la lista.
HOST_RE="$(permitidos host | sed 's/\./\\./g' | paste -sd'|' -)"
HOSTS="$(printf '%s' "$BLOQUE" \
  | grep -oE '\b[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9-]+)*\.(com|mx|net|org|io|dev|es|co|ai|app|cloud)\b' \
  | { [ -n "$HOST_RE" ] && grep -vE "(^|\.)(${HOST_RE})\$" || cat; } || true)"
[ -n "$HOSTS" ] && reporta "host no permitido:" "$HOSTS"

# --- capa 2: formas con aspecto de nombre propio -----------------------------
# proyecto/experimento · repos con sufijo de rol · servicios con doble segmento
FORMAS="$(printf '%s' "$BLOQUE" | grep -oEi \
  '\b[a-z][a-z0-9]+-[a-z][a-z0-9]+/(exp|run|v)[0-9]+\b|\bapi-[a-z0-9]+-[a-z0-9]+\b|\b[a-z0-9]+-(front|admin|back|portal)\b' \
  | grep -vxiFf <(permitidos forma) || true)"
[ -n "$FORMAS" ] && reporta "forma con aspecto de nombre propio:" "$FORMAS"

# --- capa 3: lista local de prohibidos, si existe -----------------------------
if [ -f "$LOCAL" ]; then
  PATRONES="$(grep -v '^#' "$LOCAL" 2>/dev/null | grep -v '^$' || true)"
  if [ -n "$PATRONES" ]; then
    HIT="$(printf '%s' "$BLOQUE" | grep -ioFf <(printf '%s\n' "$PATRONES") || true)"
    [ -n "$HIT" ] && reporta "termino de la lista local de prohibidos:" "$HIT"
  fi
fi

# --- capa 4: nombres propios desconocidos ------------------------------------
# Bloquea. Un aviso que salta en cada commit se ignora y deja de ser una guarda.
# El regex incluye mayusculas acentuadas: sin ellas, ANALISIS produce el token
# basura "LISIS" y el ruido se dispara en un repo escrito en español.
DESC="$(printf '%s' "$BLOQUE" \
  | grep -oE '\b[A-ZÁÉÍÓÚÑÜ][a-záéíóúñü]+[A-ZÁÉÍÓÚÑÜ][A-Za-záéíóúñüÁÉÍÓÚÑÜ]*\b|\b[A-ZÁÉÍÓÚÑÜ]{3,}\b' \
  | grep -vxFf <(permitidos token) || true)"
[ -n "$DESC" ] && reporta "token no reconocido (nombre propio potencial):" "$DESC"

# --- veredicto ---------------------------------------------------------------
if [ "$FALLOS" -ne 0 ]; then
  rojo ""
  rojo "Verificacion de neutralidad FALLIDA ($MODO)."
  rojo ""
  rojo "Si el hallazgo es legitimo, anade el termino a"
  rojo "  scripts/neutralidad-permitidos.txt"
  rojo "con su categoria (host: / forma: / token:) y justifica el porque en el commit."
  rojo "Cada excepcion queda asi registrada como decision, no como aviso ignorado."
  rojo ""
  rojo "Regenerar el allowlist desde el arbol actual (solo si el arbol esta limpio):"
  rojo "  ./scripts/seed-permitidos.sh"
  exit 1
fi
verde "neutralidad OK ($MODO)"
