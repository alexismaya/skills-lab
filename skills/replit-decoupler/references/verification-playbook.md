# Playbook de verificación y cierre

## Línea base antes de cambiar

Capturar por comando:

- ambiente (OS/CPU/runtime/gestor);
- comando literal y directorio;
- código de salida;
- salida/predicado relevante;
- duración si importa;
- fallo preexistente con evidencia y superficie afectada.

No declarar `preexistente` un fallo observado solo después. Sin baseline fechada es `no determinado`.

## Oráculo de cierre

Redactar `closure-oracle.md` antes de ejecutar la verificación.

### 1. Reconciliación

Cada ID inicial termina `removed | replaced | allowlisted | blocked`. Para `complete`: cero C/G
abiertas y cada F con propietario/motivo/revisión.

### 2. Instalación limpia

- checkout/workspace limpio, sin dependencias/caché anterior;
- comando detectado, no supuesto;
- código esperado 0;
- warnings solo si están allowlisted con motivo;
- segunda instalación no cambia manifest/lockfile.

### 3. Regresión

Ejecutar los mismos comandos y ambiente de baseline. Cada diferencia:

`new | preexisting | environment-blocked`, con evidencia. Un diff que no toca la superficie ayuda
a sostener causalidad, pero no sustituye reproducir el fallo en baseline.

### 4. Smoke positivo

Declarar:

- comando y directorio;
- ventana mínima de observación adecuada al proyecto;
- proceso que debe seguir vivo;
- señal de salud o flujo observable y predicado esperado;
- teardown.

Un log “listening”, un puerto abierto sin respuesta o ausencia de error no bastan solos.

### 5. Portabilidad externa

Si el alcance promete otro ambiente además de local, el cierre requiere smoke allí. Un smoke local
no certifica producción ni otro proveedor.

## Repetición del inventario

Repetir exactamente los canales iniciales y reconciliar por ID. Un detector nuevo encontrado al
cierre activa el protocolo de hallazgo tardío; no se añade como nota menor.

## Estados de cierre

| Estado | Uso |
|---|---|
| `complete` | todas las obligaciones cumplidas; libera consumidores completos |
| `partial-risk-accepted` | usuario acepta pendientes explícitos; solo trabajo independiente nombrado |
| `blocked` | falta evidencia, C/G o migración; consumidores dependientes no inician |

Un parcial sin lista de trabajo independiente se interpreta como bloqueado.

## Evidencia por criterio

Por cada criterio:

- artefacto/comando;
- salida esperada;
- salida real;
- comparación;
- veredicto;
- enlace/ruta de evidencia.

Aplicar la prueba: *si el mecanismo estuviera inerte, ¿fallaría?* Si no, corregir el criterio antes
de ejecutar el gate.

## Handoff a SDD/QA

El handoff lleva baseline, oráculos, Ps/gates, clases, archivos protegidos, decisiones de paridad,
allowlist y `closure_state`. SDD no reinterpreta `partial-risk-accepted` como completo. QA recibe
las superficies críticas y contrafactuales, pero decide su estrategia en `qa-discovery`.
