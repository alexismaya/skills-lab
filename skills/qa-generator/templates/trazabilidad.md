# Manifiesto de trazabilidad — `<módulo/repo>`

Liga cada test generado a la **superficie** de la Tabla de Superficies de qa-discovery que lo
justifica. Sin fila aquí, el test no debería existir.

## Cómo llenarlo

- **Superficie:** nombre exacto como aparece en la Tabla de Superficies de discovery (p. ej.
  `POST /api/solicitudes`, `Controller@confirmarReserva`). No inventes IDs.
- **Prioridad:** la que discovery asignó (🔴 crítica / 🟡 alta / 🟢 media).
- **Modo:** unitario | integracion | e2e | infraestructura.
- **Ejecución:** standalone | ecosistema | n/a (solo si el módulo forma parte de un ecosistema de
  repos).
- **Archivo:** ruta del test generado (o de la spec, en e2e).
- **Estado:** generado | pendiente | bloqueado (indica el bloqueo, p. ej. "falta config de entorno
  de test → correr modo=infraestructura").

## Matriz

> Las filas de ejemplo usan un dominio ilustrativo y rutas de un stack concreto. Sustitúyelas por
> las superficies y rutas reales del proyecto.

| Superficie | Prioridad | Modo | Ejecución | Archivo | Estado |
|---|---|---|---|---|---|
| POST /api/solicitudes | 🔴 | integracion | standalone | tests/Feature/Solicitud/NoHabilitadoTest.php | generado |
| Controller@confirmarReserva | 🔴 | integracion | n/a | tests/Feature/Confirmacion/DocumentoTest.php | generado |
| Flujo solicitud → confirmación (E2E) | 🔴 | e2e | standalone | e2e/specs/sol-confirmacion-01.yaml | pendiente (delegado a la herramienta de e2e) |
| CalculadoraTarifa | 🟡 | unitario | n/a | tests/Unit/CalculadoraTarifaTest.php | generado |
| Base de testing (config de entorno, clase base) | — | infraestructura | n/a | tests/TestCase.php, config de entorno de test | generado |
| … | | | | | |

## Gaps de alto riesgo sin materializar

Superficies 🔴/🟡 del mapa de discovery que aún no tienen test. Es la deuda de cobertura visible.

- …
