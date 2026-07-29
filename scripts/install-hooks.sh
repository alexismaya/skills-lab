#!/usr/bin/env bash
# Activa los hooks de neutralidad. Una vez por clon.
#
# Usa core.hooksPath para que los hooks vivan versionados en scripts/hooks/ y
# viajen con el repo: sin esto, cada clon nace sin proteccion.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
chmod +x "$ROOT"/scripts/hooks/* "$ROOT"/scripts/check-neutralidad.sh "$ROOT"/scripts/seed-permitidos.sh 2>/dev/null || true
git -C "$ROOT" config core.hooksPath scripts/hooks

echo "hooks activos (core.hooksPath=scripts/hooks):"
echo "  pre-commit  → contenido + nombres de archivo"
echo "  commit-msg  → mensaje de commit"
echo "  pre-push    → rango completo + nombre de rama"
echo
echo "Auditoria completa del arbol:  ./scripts/check-neutralidad.sh --all"
echo
echo "Recuerda: un hook es una red, no una cerradura. --no-verify lo salta, y"
echo "las ediciones hechas desde la web de la plataforma no pasan por el."
