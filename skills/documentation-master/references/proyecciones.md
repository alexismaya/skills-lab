# Proyecciones: qué exige cada audiencia

Una **proyección** es la lectura del corpus que hace un renderizador para una audiencia
concreta. Este documento define qué bloques necesita cada una, con qué detalle, qué omite, y
qué ocurre cuando un bloque falta.

`documentation-master` **no renderiza ninguna**: define el contrato y reporta la cobertura.
Quien produce el archivo es `project-doc` (`.docx`), `project-deck` (`.pptx`) o la proyección
de desempeño.

Se lee dos veces: en **Q3** de la entrevista, para saber qué cobertura mínima exige lo que el
usuario piensa hacer con el corpus; y al **cierre**, para emitir el reporte.

## Por qué la audiencia se pregunta al principio

La audiencia no cambia el tono aquí —el tono es del renderizador—: cambia **qué hay que ir a
buscar**. Un manual de usuario necesita los flujos vistos desde la interfaz, que es un ángulo
de extracción distinto al de la lógica interna. Descubrirlo al final significa volver a
extraer.

Y cambia **de dónde** hay que sacarlo. Algunos bloques no se leen en el repo: `operacion` se
captura preguntando a quien opera el sistema —hay que agendar esa entrevista, y eso depende de
la disponibilidad de una persona—, y `riesgo`, `trayectoria` y `pruebas` los produce otra
skill. Saberlo en la entrevista convierte un fracaso al cierre en una decisión informada al
principio: el usuario sabe desde el día uno que su handover exige media jornada de quien
levanta el sistema, o que no habrá handover completo.

## Requisitos por proyección

Leyenda: **obligatorio** (sin él la proyección se declara bloqueada) · *deseable* (se produce
sin él, declarando el hueco) · — (no lo consume).

| Bloque | Manual de usuario | Capacitación | Documentación de PM | Presentación a cliente | Handover técnico | Aval de desempeño |
|---|---|---|---|---|---|---|
| `superficie` | **obl.** | **obl.** | *des.* | *des.* | **obl.** | *des.* |
| `logica-negocio` | **obl.** | **obl.** | *des.* | — | **obl.** | **obl.** |
| `modelo-datos` | — | *des.* | — | — | **obl.** | *des.* |
| `integraciones` | *des.* | **obl.** | *des.* | *des.* | **obl.** | *des.* |
| `zonas-oscuras` | — | *des.* | **obl.** | — | **obl.** | *des.* |
| `operacion` | *des.* | **obl.** | **obl.** | — | **obl.** | — |
| `riesgo` | — | — | **obl.** | — | *des.* | — |
| `trayectoria` | — | — | *des.* | *des.* | — | **obl.** |
| `pruebas` | — | *des.* | *des.* | — | **obl.** | *des.* |

### Manual de usuario

- **Detalle:** los flujos **desde la interfaz**, no desde el handler. La entrada de corpus
  útil aquí es la que dice qué ve y qué puede hacer quien opera el sistema, y bajo qué
  condición el sistema se lo impide.
- **Exige `visibilidad = externa`.** Un manual sale de la organización.
- **Omite:** riesgo, trayectoria, modelo de datos, y cualquier entrada `interna`.
- **Procedencia:** admite `entrevista` con naturalidad — cómo se opera algo suele saberlo una
  persona antes que el código.
- **Si falta `logica-negocio` de los flujos de interfaz:** bloqueada. Sin las condiciones de
  rechazo, el manual describe el camino feliz y falla justo donde el usuario necesita ayuda.

### Capacitación

- **Detalle:** el más alto de todas las proyecciones, porque tiene que cubrir el error: qué
  falla, cómo se ve cuando falla, y qué hacer entonces.
- **Depende críticamente del bloque `operacion`**, que no se extrae del código: se captura en
  entrevista dirigida (SKILL.md §Captura operativa). Si nadie puede responderla, la proyección
  se declara **bloqueada** y se nombra al responsable por su rol —no se improvisa un runbook a
  partir del código, que es exactamente lo que el código no dice—.
- **Omite:** riesgo (es material de otra conversación).
- **Las `zonas-oscuras` son deseables aquí**, aunque suene contraintuitivo: quien se capacita
  se va a topar con el comportamiento raro, y es mejor que llegue advertido.
- **`pruebas` es deseable, no obligatorio:** aporta la traza de verificación que convierte un
  procedimiento en algo comprobable. Su ausencia no bloquea la capacitación; la vuelve
  narrativa.

### Documentación de PM

- **Detalle:** medio. Interesa el **estado** del sistema, no su mecánica: qué está resuelto,
  qué está a medias, qué se ignora silenciosamente y qué riesgo hay abierto.
- **`zonas-oscuras` y `riesgo` son obligatorios** — son la mitad de la proyección. Una
  documentación de gestión que solo cuenta lo que funciona no sirve para gestionar.
- **`operacion` obligatorio:** el coste de operar es lo que un PM necesita para planear.
- **Visibilidad:** interna.

### Presentación a cliente

- **Detalle:** el más bajo. Capacidades y flujos de alto nivel.
- **Exige `visibilidad = externa`** y no consume `zonas-oscuras` ni `riesgo`: esa es una
  decisión de la audiencia, no una omisión del corpus, y conviene decirlo así en el reporte
  para que nadie la confunda con un hueco.
- Rara vez se bloquea. Si se bloquea, es porque falta `superficie`, y entonces falta todo.

### Handover técnico

- **Detalle:** máximo en mecánica. Es la proyección que más se parece al corpus crudo.
- **Todo lo estructural es obligatorio**, `zonas-oscuras` incluido: entregar un sistema sin
  su lista de trampas es entregar la mitad.
- **`operacion` es obligatorio aquí, no deseable.** Quien recibe un sistema tiene que poder
  levantarlo, saber qué ambientes existen y qué accesos necesita pedir. Un handover que
  explica la arquitectura pero no la puesta en marcha describe el sistema sin entregarlo: el
  receptor sabe cómo funciona y sigue sin poder tocarlo el primer día. Es el bloque que más
  se subestima porque el corpus se ve completo sin él —todo lo estructural tiene evidencia—,
  y la cobertura reporta verde sobre el hueco que decide si la transferencia sirve.
- **`pruebas` es obligatorio.** Sin al menos una traza de verificación de extremo a extremo,
  quien recibe no puede confirmar que lo que levantó funciona, y cualquier cambio que haga
  después parte de una base que nunca validó.
- **Procedencia:** exige `codigo` para lo estructural. Lo de `entrevista` se marca como tal
  para que quien reciba sepa qué está verificado y qué está dicho. `operacion` es
  legítimamente `entrevista` casi siempre (R4): que un dato venga de una persona no lo
  degrada, siempre que se sepa de quién y cuándo.

### Aval de desempeño

- **Detalle:** medio, pero con exigencia de respaldo alta.
- **`trayectoria` obligatorio** (procedencia `historial`, alimentado por `git-workflow`): sin
  el registro de qué cambió, cuándo y a raíz de qué, no hay desempeño que avalar — hay una
  descripción del sistema.
- **Procedencia:** es la proyección más estricta. Una afirmación de procedencia `entrevista`
  puede acompañar, pero no sostener sola una afirmación de desempeño; el renderizador debe
  poder distinguirlas, y por eso la marca es obligatoria en el corpus.
- **Si falta `trayectoria`:** bloqueada, y el responsable es `git-workflow`.

## Reporte de cobertura

Tabla **Cobertura por proyección** en el hub Corpus, emitida en la consolidación y
reemitida en cada re-ejecución:

| Propiedad | Contenido |
|---|---|
| `proyeccion` | Cuál de las de arriba |
| `estado` | `completa` / `incompleta` / `bloqueada` / `desactualizada` |
| `bloques_faltantes` | Cuáles, y si son obligatorios o deseables |
| `responsable` | Qué skill produce cada bloque faltante |
| `ancla` | Con qué ancla se emitió esta cobertura |
| `notas` | Qué se excluyó por decisión del usuario (Q5), para no confundirlo con un hueco |

Los cuatro estados, que no son grados de lo mismo:

- **completa** — todos los bloques obligatorios tienen entradas `vigentes`.
- **incompleta** — falta algún *deseable*. Se puede producir; el renderizador declara el hueco.
- **bloqueada** — falta un **obligatorio**. No se produce. Se nombra el bloque y su skill
  responsable.
- **desactualizada** — se emitió bajo un ancla anterior a cambios del corpus. Existe, pero
  refleja un estado pasado (`incremental.md` §6).

## Bloques que esta skill no extrae del código

Declararlos, no suplirlos. Esta tabla es lo que se responde en Q3 cuando el usuario nombra
una audiencia cuyo bloque no está:

| Bloque faltante | Quién lo produce | Qué NO se hace en su lugar |
|---|---|---|
| `operacion` | Esta skill, en entrevista dirigida (SKILL.md §Captura operativa), con quien opera el sistema | Deducir el runbook del código: el código no dice a quién se escala ni qué falla seguido |
| `pruebas` | `qa-discovery` (mapa de superficie de prueba) y `qa-generator` (suites) | Escribir tests, o declarar cubierto un flujo porque existe un archivo de prueba con su nombre |
| `riesgo` | `project-audit` | Emitir juicios de calidad desde esta skill; aquí se describe, no se evalúa |
| `trayectoria` | `git-workflow` | Reconstruir la historia leyendo el estado actual |
| `superficie` (si no hay onboarding) | `project-onboarding`, o inventario mínimo declarado parcial (R3) | Levantarlo completo por cuenta propia y presentarlo como equivalente |

`operacion` es el único que esta skill puede llenar por sí sola, y solo porque no lo deduce:
lo pregunta. Los demás requieren un artefacto que produce otra skill.

## Regla de cierre

El reporte de cobertura se entrega **siempre**, incluso cuando todo está completo, y **antes**
de que nadie pida un entregable. Que una proyección esté bloqueada es información que el
usuario necesita para planear, no una excusa que se da cuando ya pidió el documento.

**Excepción — camino corto.** Cuando el SKILL.md §Camino corto está activo (alcance puntual,
sin proyecciones previstas), el reporte de cobertura se omite: no hay proyecciones declaradas
que reportar. Si durante la ejecución aparece una proyección prevista, el camino corto deja
de aplicar y el reporte vuelve a ser obligatorio.
