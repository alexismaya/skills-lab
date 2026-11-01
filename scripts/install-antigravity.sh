#!/usr/bin/env bash
# Instala la suite en la CLI de Antigravity (agy) copiando cada carpeta e
# inyectando shared/interop-notion.md en su references/ (igual que
# install-claude.sh e install-kiro.sh, con otro destino: Antigravity tambien lee
# las carpetas directamente).
#
# Antigravity descubre skills como carpetas con SKILL.md en:
#   - global (maquina): ~/.gemini/config/skills/<nombre>/
#   - por proyecto:     <raiz-del-repo>/.agents/skills/<nombre>/
#     (tambien acepta .agent/, _agents/, _agent/)
#
# Precedencia, de mayor a menor: workspace .agents/ > entradas declaradas en
# skills.json del workspace > global ~/.gemini/config/ > skills builtin >
# entradas declaradas en el skills.json global. Instalar en el destino global
# deja la suite disponible en todos los proyectos de la maquina, y un proyecto
# puede seguir sobrescribiendo una skill concreta con su propia copia en
# .agents/skills/.
#
# NO instalar en ~/.gemini/antigravity-cli/builtin/skills/: ese arbol lo maneja
# la CLI, esta sellado por checksum y se reescribe en cada actualizacion. Lo que
# se ponga ahi desaparece sin aviso.
#
# La lista se deriva de skills/: toda carpeta con SKILL.md se instala. Ver la
# nota de install-claude.sh sobre por que no hay lista fija.
#
# La copia de interop-notion.md dentro de cada skill es un artefacto: la fuente
# unica es shared/interop-notion.md.
#
# Uso:
#   ./scripts/install-antigravity.sh                    # instala global
#   ./scripts/install-antigravity.sh /ruta/proyecto/.agents/skills
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SHARED="$ROOT/shared/interop-notion.md"
DEST="${1:-$HOME/.gemini/config/skills}"

[ -f "$SHARED" ] || { echo "No se encontro el contrato compartido: $SHARED" >&2; exit 1; }

case "$DEST" in
  */antigravity-cli/builtin*)
    echo "Destino invalido: $DEST" >&2
    echo "El arbol builtin de la CLI esta sellado por checksum y se reescribe al actualizar." >&2
    echo "Usa el destino global (~/.gemini/config/skills) o el de un proyecto (.agents/skills)." >&2
    exit 1
    ;;
esac

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
echo "$n skills instaladas en Antigravity."
echo "Reinicia agy para que las descubra; /help lista los comandos de la sesion."
