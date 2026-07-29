# Plantillas SDD Harness — listas para llenar

Convención: `{placeholder}` se sustituye; los bloques entre `<!-- opcional -->` se eliminan si no aplican. El idioma de las plantillas sigue al del proyecto del usuario. Las plantillas son punto de partida: la estructura ya existente en el Notion del usuario y su página de Lecciones tienen prioridad.

---

## 0. Página de Lecciones SDD

```markdown
# Lecciones SDD

> La metodología aprende de los proyectos. Una entrada por lección,
> aprobada por el usuario al cierre de un gate. Al arrancar cualquier
> proyecto, esta página se lee y sus reglas derivadas se aplican como
> extensión de la metodología — siempre como propuesta a confirmar,
> nunca como suposición.

| Fecha | Proyecto | Qué pasó | Regla derivada |
|---|---|---|---|
| {fecha} | {proyecto} | {hecho concreto, 1-2 líneas} | {regla accionable para futuros proyectos} |
```

---

## 1. Prompt de Fase de Análisis

```markdown
# Prompt — Fase de Análisis: {objetivo} (`{repo/proyecto}`)

## Contexto
{Qué se va a construir y sobre qué base.}

**Esta es una fase de ANÁLISIS exclusivamente. NO se debe generar código,
NO se debe crear el repositorio, NO se deben escribir migraciones.** El
entregable es un reporte que revisaré y aprobaré antes de autorizar
cualquier fase de implementación.

## Insumos disponibles
1. {repo plantilla / código base}
2. {contrato: colección Postman, spec, requerimientos}
3. {DDL / esquema de datos — si aplica}
4. {hallazgos o líneas base previas — si aplica}

## Objetivo del análisis
Producir un reporte único en markdown (`analisis-{slug}.md`) con estas secciones:

### Sección 1 — Auditoría estructural de {plantilla}
Clasificar el 100% de los directorios de primer y segundo nivel en:
**heredable** (copia directa / parametrización / renombrado), **no heredable**
(lógica específica de otro producto) y **código muerto** (no arrastrar).
Rutas explícitas para cada elemento.

### Sección 2 — Contrato ({fuente de verdad})
Inventario completo de {endpoints/operaciones}: método, URL, auth, payloads
campo por campo (obligatorios vs opcionales, catálogos referenciados),
estructura de errores. Lo que no esté en la fuente se marca como pregunta
abierta — no se inventa ni se asume.

### Sección 3 — Datos (contra el DDL adjunto)
El DDL es la fuente de verdad; nada se infiere del código. Tablas
compartidas a consumir (con repo dueño), convención de nombrado observada,
propuesta de tablas propias (esquema conceptual, sin DDL nuevo),
verificación de colisiones, inconsistencias detectadas (solo reporte).

### Sección 4 — Línea base de seguridad
Checklist por hallazgo: regla · verificación en plantilla con evidencia
`archivo:línea` · obligación para el nuevo código. Veredicto explícito:
"plantilla lista para scaffold" o lista numerada de correcciones requeridas.

## Criterios de aceptación
1. Reporte único con todas las secciones.
2. Sección 1 clasifica el 100% con rutas explícitas.
3. Sección 2 cubre todo lo presente en la fuente, sin omitir ni inventar.
4. Toda incertidumbre en una subsección **Preguntas abiertas** (P-1..P-n)
   al final — no se resuelve con suposiciones.
5. Toda afirmación de esquema verificada contra el DDL; toda afirmación de
   código con referencia archivo:línea.
6. Sección 4 concluye con veredicto explícito.
7. **No se genera ningún archivo de código, migración ni configuración.**

## Fuera de alcance (no hacer)
- Scaffold, código, migraciones, modificaciones a repos existentes.
- {integraciones posteriores, QA formal, ...}

## Entregable
`analisis-{slug}.md` — lo revisaré y, tras correcciones si las hay,
autorizaré la Fase 2 (scaffold).
```

---

## 1b. Prompt de Fase de Análisis — proyecto desde cero

> Variante B de § Fase de Análisis. Se usa cuando Q1 = *nuevo desde cero* y el proyecto
> **no** nace de otro existente (si nace de otro, es `derivar-proyecto`).
>
> **Por qué esta plantilla es más larga que la de la variante A.** En un proyecto con base
> existente el rigor lo aporta la fuente: hay código que clasificar y un DDL contra el que
> verificar, y la realidad acota lo que el ejecutor puede afirmar. Aquí no hay nada que leer
> salvo lo que diga el usuario, así que **el rigor tiene que aportarlo la estructura del
> entregable**. De ahí las marcas de trazabilidad, las alternativas obligatorias y la
> condición de invalidación: son lo único que separa un análisis de una invención elegante.

```markdown
# Prompt — Fase de Análisis (proyecto desde cero): {objetivo} (`{proyecto}`)

## Contexto
{Qué se quiere construir, en las palabras del usuario.}

**Esta es una fase de ANÁLISIS exclusivamente. NO se genera código, NO se crea el
repositorio, NO se escriben migraciones, NO se instala nada.** El entregable es un
reporte de decisiones que revisaré y ratificaré antes de autorizar el scaffold.

**No hay base que auditar.** La única fuente de este análisis es lo que yo he
declarado. Por eso rige la regla de trazabilidad de abajo: sin ella, este reporte
sería una arquitectura inventada con aspecto de análisis.

## Regla de trazabilidad (no negociable)
Cada afirmación del reporte lleva **una** de estas marcas:

- `[declarado]` — lo dije yo. Cita mis palabras, no una paráfrasis que te convenga.
- `[inferido]` — lo derivaste de algo declarado. Preséntalo para confirmación:
  no es vinculante hasta que yo lo ratifique en el gate.
- `[P-n]` — no se sabe y hace falta. Va a la tabla de preguntas abiertas con lo
  que bloquea.

Si una sección no tiene ninguna marca `[declarado]`, está construida sobre
inferencias encadenadas: dilo explícitamente al principio de esa sección.

**Prohibido rellenar huecos con lo habitual del sector.** "Normalmente se usa X"
no es una fuente. Si no lo declaré y lo necesitas, es una P.

## Insumos
1. {descripción del problema en prosa, notas, bocetos — lo que haya}
2. {restricciones conocidas: stack impuesto, infraestructura, compliance}
3. {volumen y horizonte declarados en la entrevista (Q6)}
4. {sistemas existentes con los que hay que integrarse — si aplica}

## Objetivo
Producir `analisis-{slug}.md` con estas secciones:

### S1 — Problema y alcance
Qué se construye, para quién, y qué problema resuelve — en lenguaje de negocio.
Y explícitamente: **qué NO se construye** en esta primera versión.
Todo con su marca. Un alcance sin la mitad negativa no acota nada.

### S2 — Anclas cuantitativas
| Magnitud | Al arrancar | Horizonte declarado | Marca |
|---|---|---|---|
| {usuarios / registros / peticiones / elementos de catálogo} | {n} | {n} | {[declarado] o [P-n]} |

Horizonte temporal: {cuánto se espera que viva sin rehacerse}.
**Este es el número contra el que se argumenta toda la sección S4.** Si falta,
S4 no puede cerrarse: se registra como P y se detiene ahí.

### S3 — Restricciones no negociables
Lo que NO se puede elegir, declarado antes de elegir nada:
- Stack impuesto por el equipo, la empresa o el cliente
- Infraestructura que ya existe y hay que usar
- Requisitos de compliance
- Sistemas con los que hay que integrarse, y quién es su dueño
- **Capacidad real del equipo que lo va a mantener** — una arquitectura que el
  equipo no puede sostener es una mala arquitectura por buena que sea

### S4 — Decisiones de arquitectura
Una ficha por decisión. **Una decisión sin alternativas rechazadas no es una
decisión, es una preferencia.**

#### D{n} — {qué se decide}
- **Opción elegida:** {cuál}
- **Alternativas consideradas:** {al menos dos, con por qué se descartaron}
- **Justificación contra S2:** {por qué esta opción para **ese** volumen concreto}.
  Si el volumen no la justifica: declarar que se elige por **mantenibilidad**
  o por **costo de cambio**, y decir cuál de las dos. No valen ambas a la vez.
- **Qué la invalidaría:** {la condición concreta que obligaría a revisarla —
  un umbral de volumen, un requisito nuevo, una integración}
- **Marca:** {[declarado] / [inferido] / gateada por [P-n]}

Cubrir como mínimo: forma del sistema · stack y por qué · persistencia ·
autenticación y autorización · fronteras entre componentes · despliegue.

### S5 — Lo que NO se construye
Lista nominada de los mecanismos que a este volumen **no hacen falta**, cada uno
con el umbral que los volvería necesarios:

| Mecanismo descartado | Por qué no hace falta hoy | Qué lo haría necesario |
|---|---|---|

Esta sección es el complemento de la regla transversal 4 (default fail-safe): esa
solo sabe decir *no construyas*. Escribir aquí lo descartado impide que una fase
posterior lo reintroduzca "por si acaso" sin discutirlo.

### S6 — Convenciones desde el día uno
- Estructura de directorios y organización de capas
- Nomenclatura (archivos, símbolos, rutas, tablas)
- **Decisión** de convención de commits y modelo de branching
  → solo la decisión. El mecanismo lo gobierna `git-workflow`, que la lee del
  registro del proyecto. No duplicar aquí su protocolo.
- Qué guardas automáticas se instalarán en el scaffold para sostener todo lo anterior

### S7 — Línea base de seguridad (prospectiva)
| Regla | Obligación para el código nuevo | Cómo se verifica sola |
|---|---|---|

Veredicto explícito: qué es obligatorio desde el primer commit y qué se difiere,
con la fase que lo recoge.

### S8 — Preguntas abiertas
| P | Tema | Qué bloquea | Marca de origen |
|---|---|---|---|

## Criterios de aceptación
1. Reporte único con las ocho secciones.
2. **Toda afirmación lleva marca** `[declarado]` / `[inferido]` / `[P-n]`.
   Una sola sin marca invalida el reporte.
3. Cada ficha de S4 lista al menos dos alternativas rechazadas con su motivo.
4. Cada ficha de S4 se argumenta contra el número de S2, o declara explícitamente
   que se elige por mantenibilidad o por costo de cambio.
5. Cada ficha de S4 declara qué la invalidaría.
6. S5 no está vacía. Un proyecto donde "todo hace falta" no se analizó.
7. S1 incluye la mitad negativa del alcance.
8. Cero código, repo, migraciones o configuración generados.

## Fuera de alcance (no hacer)
- Scaffold, código, migraciones, instalación de dependencias.
- Elegir por mí: las decisiones de S4 se presentan, se ratifican en el gate.
- Rellenar con lo habitual del sector lo que no declaré.

## Entregable
`analisis-{slug}.md` → lo reviso → ratifico o corrijo las decisiones de S4 →
gate → Fase 2 (scaffold).
```

---

## 2. Prompt de Fase de Implementación (scaffold o dominio)

```markdown
# Prompt — Fase {N}: {nombre} de `{repo}`

## Contexto
Fase de **IMPLEMENTACIÓN** autorizada tras {gate anterior}. {Qué construye
esta fase y sobre qué esqueletos/entregables previos.} {Lo que es de fases
posteriores} queda **fuera de alcance**.

Los documentos {análisis + addendums} son **vinculantes**. Ante cualquier
conflicto entre este prompt y esos documentos, detenerse y reportar — no
resolver por criterio propio.

## Decisiones cerradas vigentes
- **P-{x} resuelta:** {decisión definitiva y su consecuencia}. {Prohibición
  explícita de reabrirla o construir "por si acaso".}

## Insumos
1..n. {documentos vinculantes, repos, spec, DDL}

## Tareas
### T1 — {nombre}
{Acciones concretas. Las exclusiones obligatorias se listan DENTRO de la
tarea que las ejerce, marcadas como no negociables.}

### T{n} — Tests y guardas (la seguridad se demuestra, no se declara)
1. Tests de los mecanismos críticos de la fase.
2. **Guardas estáticas en CI** (falla el build ante): {patrones prohibidos
   con su regex}.
3. CI ejecutando todo lo anterior.

## Criterios de aceptación
1. {Compila/levanta/migra} — con evidencia adjunta.
2. Grep del repo: cero coincidencias de patrones prohibidos (adjuntar corrida).
3. Suite en verde ({qué demuestran los tests clave}).
4. {Verificables específicos: route:list, conteos, diffs}.
n. Reporte de cierre: mapa de lo hecho contra el análisis; toda desviación
   reportada y justificada, no silenciosa.

## Fuera de alcance (no hacer)
- {lista explícita}

## Entregable
{Repo/feature} + reporte de cierre (`fase{N}-cierre.md`) con las evidencias
de los criterios {x, y, z}. Revisaré reporte y diff antes de autorizar la
Fase {N+1}.
```

---

## 3. Hub de fase en Notion

```markdown
# Fase {N} — {nombre} de `{repo}`

> Hub de la fase. Cada etapa es una subpágina autocontenida: se inicia en
> un chat nuevo adjuntando **solo la URL de esa etapa** para ahorrar
> tokens/contexto. El agente NO necesita leer el prompt completo, solo su
> etapa + las secciones citadas del análisis.

## Cómo iniciar una etapa en un chat nuevo
> Inicia la **Etapa {n}** de la Fase {N} de `{repo}`. Lee esta página y
> ejecuta sus tareas: `<URL de la subpágina>`

## Contexto
{2-4 líneas: qué fase, sobre qué se construye.}

## Decisiones vinculantes (aplican a todas las etapas)
- {documentos vinculantes} — ante conflicto: **detenerse y reportar**.
- **P-{x} (cerrada):** {decisión}. Prohibido {reabrirla}.
- {reglas de seguridad activas: H-x}
- {reglas de logging/datos}

## Preguntas abiertas que GATEAN etapas (resolver ANTES de ejecutar)
Regla: si la P sigue abierta al iniciar la etapa, **detenerse y reportar**
en el punto exacto; no asumir.
| Pregunta | Tema | Gatea |
|---|---|---|
| P-{x} | {tema} | E{n} |

## Insumos
1..n. {lista}

## Orden de etapas
| # | Etapa | Tareas | Depende de | Gate (P-x) | Perfil requerido |
|---|---|---|---|---|---|
| 1 | {nombre} | T1 | {previa} | {P-x o —} | {puntero / intermedio / bajo coste} |

Ruta secuencial recomendada: E1 → ... E{a} y E{b} paralelizables tras E{c}.

> **Perfil requerido:** capacidad mínima del ejecutor de la etapa (Q4). Marcar
> `puntero`/`intermedio` (no bajo coste) toda etapa de diseño/arquitectura,
> refactor transversal, resolución de ambigüedad, interpretación de spec
> incompleta, o gateada por una P abierta (§ Escalamiento por perfil en el
> SKILL.md). Solo se marca `bajo coste` si todas sus tareas se pueden escribir
> como tareas de inferencia cero → usar la plantilla de subpágina modo granular.

## Estado global
- [ ] Etapa 1 — {nombre}
- [ ] Etapa n — ...

## Etapas (subpáginas)
{una subpágina por etapa}

## Criterios de aceptación globales (Fase {N})
1..n. {los del prompt de fase}

## Fuera de alcance (Fase {N})
- {lista}

## Entregable
{entregable + qué revisa el humano}
```

---

## 4. Subpágina de etapa

```markdown
# Etapa {n} — {nombre} (T{x})

## Contexto vinculante de la etapa
{REPETIR aquí las decisiones globales que aplican a ESTA etapa — no asumir
que el agente leyó el hub:}
- {P-x cerradas relevantes}
- {reglas H-x que esta etapa puede violar si no las conoce}
- {fronteras exactas: "el modelo de esta etapa apunta a {tabla existente};
  los modelos {otros} NO se crean aquí — son de la Etapa {m}"}
- Ante duda: detenerse y reportar — no decidir.

## Depende de
Etapa(s) {m} cerrada(s). Leer su "Resumen de salida (handoff)".

## Tareas
- [ ] {tarea atómica 1}
- [ ] {tarea atómica n}

## Criterios de aceptación de la etapa
- {verificables}
- **Smoke ejecutable en esta etapa:** {test mínimo del mecanismo crítico
  introducido aquí}. No sustituye la suite de la Etapa {final}; evita
  descubrir a varios contextos de distancia un fallo introducido aquí.

## Fuera de alcance de la etapa
- {qué es de otras etapas, nombrándolas}

## Checklist de cierre
- [ ] {ítems}
- [ ] Smoke en verde: {qué demuestra}
- [ ] Resumen de salida escrito (abajo)

## Resumen de salida (handoff)
{Al cerrar: qué se produjo (archivos/clases clave), decisiones tomadas,
y qué necesita saber la siguiente etapa. 5-15 líneas.}
```

---

## 4b. Subpágina de etapa — modo granular (perfil bajo coste)

> Derivada de la plantilla 4. Se usa cuando la etapa se marcó **perfil
> requerido = bajo coste** en el hub. Principio: *la calidad no se le pide al
> ejecutor — se le construye aquí*. El ejecutor **transcribe, no diseña**: cada
> tarea es de inferencia cero y toda verificación es una comparación mecánica
> contra una salida esperada literal. Si algo exige criterio, la etapa está mal
> escrita para este perfil — subir de perfil o descomponer.

```markdown
# Etapa {n} — {nombre} (T{x}) · perfil: bajo coste

## Contexto vinculante de la etapa (ampliado)
{Para bajo coste se repiten LITERALMENTE TODAS las exclusiones y decisiones
aplicables — no un resumen. La redundancia es el costo de aislar contexto en
un ejecutor que no infiere:}
- {P-x cerradas relevantes, con la decisión textual}
- {TODAS las reglas H-x que esta etapa podría violar, transcritas}
- {fronteras exactas: "esta etapa toca SOLO {archivos listados}; NO se crea
  ni modifica {otros}, son de la Etapa {m}"}
- **Archivos que esta etapa puede tocar (lista cerrada):** {rutas exactas}.
  Tocar cualquier archivo fuera de esta lista = detenerse y reportar.
- **Decisiones permitidas al ejecutor: CERO.** Todo lo que parezca requerir
  una decisión ya está resuelto abajo o es una P — no se decide aquí.
- Ante cualquier cosa no descrita: **detenerse y reportar — no corregir, no
  adaptar, no completar el hueco.**

## Depende de
Etapa(s) {m} cerrada(s). Estado exacto que se hereda: {qué dejó lista la
etapa previa según su handoff — el ejecutor NO lo re-verifica ni lo rehace}.

## Tareas (inferencia cero)
Cada tarea especifica: ubicación exacta · forma del cambio · verificación
literal · criterio de detención.

### T{x} — {nombre}
- [ ] **Ubicación:** `{ruta/archivo}` → {ancla: `def {func}` / clase `{X}` /
  fragmento literal a localizar `{texto}`}.
- [ ] **Forma esperada del cambio** (transcribir, no diseñar):
  ```
  {firma / contrato / pseudodiff exacto a reproducir}
  ```
- [ ] **Verificación:** ejecutar
  ```
  {comando literal copiable}
  ```
  **Salida esperada:** `{valor exacto o patrón de la salida}`.
- [ ] **Detención:** si lo encontrado en la ubicación NO coincide con lo
  descrito, o el comando no da la salida esperada → **detenerse y reportar el
  punto exacto. No corregir, no adaptar.**

## Smoke de etapa (OBLIGATORIO)
Comando literal + salida esperada — red intermedia, no sustituye la suite final:
```
{comando de smoke}
```
**Salida esperada:** `{patrón/valor}`. Si no coincide: detenerse y reportar.

## Fuera de alcance de la etapa
- {qué es de otras etapas, nombrándolas — lista cerrada}

## Checklist de cierre (cada checkbox referencia su evidencia)
- [ ] T{x} aplicada — evidencia: salida de `{comando de verificación}` = `{esperada}`
- [ ] Smoke en verde — evidencia: salida de `{comando de smoke}` = `{esperada}`
- [ ] Ningún archivo fuera de la lista cerrada fue tocado — evidencia: `git diff --stat`
- [ ] Resumen de salida escrito (abajo)

## Resumen de salida (handoff)
{Estado EXACTO que hereda la siguiente etapa: qué archivos/símbolos quedaron
en qué estado, qué comando lo comprueba, y qué NO se hizo (queda para E{m}).
Sin este estado explícito la siguiente etapa vuelve a inferir. 5-15 líneas.}
```

---

## 5. Reporte de cierre de fase

```markdown
# Reporte de Cierre — Fase {N}: {nombre}

**Fecha:** {fecha}
**Estado:** {✅ Completo / ⚠️ Completo con desviaciones}

## 1. Mapa de lo construido
{endpoint ↔ operación / tarea ↔ resultado, en tabla}

## 2. Estado final de preguntas gate (Ps)
| P | Tema | Estado | Decisión adoptada / a qué fase se difiere |

## 3..k. Evidencia por criterio de aceptación
{una sección por criterio: qué se verificó, CON el artefacto — salida de
tests, grep, route:list, conteos. Cada evidencia nombra el test/comando.}

## Divergencias vs fase anterior
{dependencias, estructura, decisiones — cada una justificada. "Ninguna"
si aplica.}

## Pendientes documentados (fuera de esta fase)
| Pendiente | Referencia | Impacto | Responsable |

## Entregable
{resumen + "Listo para revisión → {siguiente gate}"}
```

---

## 6. Hallazgo de seguridad (H-x)

```markdown
## H{n} — {título}

**Severidad propuesta:** {Crítica/Alta/Media}
**Componente:** {repo/tabla/flujo}
**Estado:** {Activo / Latente} ({qué falta confirmar})

### Evidencia
- {archivo:línea — qué hace y por qué es riesgo}

### Descripción e impacto
{qué está expuesto, por qué vías, y la ventana de exposición}

### Remediación — dos frentes
**Frente 1 — Código (detener la causa):** {pasos}
**Frente 2 — Datos históricos (limpiar lo ya escrito):** {logs, filas,
respaldos — incluir la decisión sobre respaldos como decisión explícita,
no como omisión}

### Criterios de cierre
- {verificables: grep en CI, conteos antes/después, evidencia de purga}

### Preguntas de dimensionamiento
- {lo que hay que responder antes de estimar el frente 2}
```
