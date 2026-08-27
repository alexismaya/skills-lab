---
name: project-doc
description: "Generación de un documento Word (.docx) a partir del corpus de documentation-master como entregable puntual (snapshot para una audiencia concreta, no se sincroniza automáticamente con el proyecto). Una entrevista de arranque detecta la AUDIENCIA —manual de usuario, capacitación, documentación de PM, handover técnico, presentación a cliente o aval de desempeño— y adapta la estructura, el vocabulario, el nivel de detalle y qué bloques del corpus incluir. Consume el corpus ya producido por documentation-master en Notion; si no existe corpus, remite a documentation-master primero. Usar esta skill SIEMPRE que el usuario quiera: generar un documento Word del proyecto, un 'informe', 'manual', 'docx', 'Word', 'documentación para el cliente', 'documentación de PM', 'handover técnico', 'material de capacitación', 'aval de desempeño', o 'documento de entrega'; también ante menciones de 'exportar el corpus', 'proyectar la documentación', 'generar el .docx' o 'redactar el documento'. NO usar para documentar en Notion (eso es project-onboarding o documentation-master), para generar el PPTX (eso es project-deck), para levantar o actualizar el corpus (eso es documentation-master), ni para evaluar calidad (eso es project-audit). Si el usuario quiere documentar Y generar el .docx, recomendar correr documentation-master primero."
---

# Proyección del corpus a documento Word (.docx)

Disciplina para renderizar el corpus de `documentation-master` como un **documento Word
entregable y puntual**: se produce para una audiencia concreta y no se mantiene sincronizado
automáticamente con el proyecto. Si el corpus cambia, se reinvoca la skill.

Principio rector: **la audiencia define la estructura, no al revés.** Un manual de usuario y
un handover técnico consumen el mismo corpus, pero producen documentos radicalmente
distintos en estructura, vocabulario y qué se incluye. Intentar generar uno solo "con opciones"
produce un documento que no sirve bien a nadie.

La separación con `documentation-master` es deliberada y no es burocracia: un documento
producido sin corpus no se puede revalidar, ni versionar, ni saber qué parte suya dejó de ser
cierta cuando el código cambie. Por eso esta skill **no produce corpus**; solo lo proyecta.
Si el corpus no existe, la respuesta correcta es decirlo, explicar el reparto y remitir a
`documentation-master`.

## Regla cero (gobierna todo lo demás)

**Nada se genera sin aprobación de la propuesta de estructura.**

1. La skill presenta el **índice propuesto** —con la fuente del corpus declarada por cada
   sección— y espera confirmación antes de generar el `.docx`. El usuario puede añadir,
   quitar o reordenar.
2. Sección sin fuente verificable en el corpus → **sección marcada como borrador** (`[PENDIENTE — {qué falta y qué skill lo produce}]`), nunca inventada ni inferida.
3. Sin secciones de relleno. Un hueco declarado es honesto; una sección con datos inventados
   es un pasivo que se firmará como cierto.

## Cuándo NO es esta skill

| Lo que el usuario quiere | Skill correcta |
|---|---|
| Levantar o actualizar la lógica del proyecto en Notion | `documentation-master` |
| Panorama del repo: árbol, stack, diagramas, onboarding | `project-onboarding` |
| Presentación de slides / PPTX | `project-deck` |
| Evaluar calidad o riesgo del proyecto | `project-audit` |
| Construir o remediar algo en el proyecto | `sdd-harness-notion` |

Si el usuario pide el `.docx` sin haber corrido `documentation-master`, no se improvisa:
se explica la razón (un documento sin corpus no se puede revalidar), se ofrece correr
`documentation-master` primero, y se dice qué audiencias quedarán disponibles una vez
que el corpus esté completo.

## Arranque: detectar antes de preguntar

Al activarse, revisar el contexto disponible —conversación, memoria, Notion accesible— y
**confirmar** lo que ya se sabe. Solo entonces hacer las preguntas que no se puedan inferir,
en un solo bloque si la interfaz lo permite.

### Q1 — ¿Existe corpus de `documentation-master`?

Es la pregunta bloqueante. Pedir la URL del hub **Corpus** en Notion. Si no existe:

- Explicar que sin corpus esta skill no puede generar nada verificable.
- Ofrecer dos caminos: (a) correr `documentation-master` primero y volver, o (b) si el
  usuario ya tiene documentación en otro formato, aceptarla como insumo con procedencia
  `entrevista` declarada explícitamente en cada sección del documento producido.

Si existe corpus, leerlo antes de proponer nada: la cobertura real determina qué audiencias
son posibles y cuáles quedan bloqueadas.

### Q2 — Audiencia (define la estructura del documento)

Seis audiencias posibles; cada una fija estructura, vocabulario, nivel de detalle y qué
bloques del corpus son obligatorios vs. omitibles. Ver §Audiencias y sus requisitos.

Si la audiencia no es clara, dos preguntas de desempate:
1. **¿Quién va a leer este documento?**
2. **¿Qué acción o decisión esperas que tome al leerlo?**

### Q3 — Alcance del corpus a proyectar

¿Se proyecta el corpus completo o solo un subconjunto (un módulo, un flujo, un periodo de
tiempo)? Determina qué filtros aplicar sobre el corpus antes de armar la propuesta.

### Q4 — Formato y branding

- ¿Hay plantilla `.docx` corporativa o de proyecto? → pedir que se adjunte.
- ¿Numeración de páginas, tabla de contenidos, encabezados y pies de página?
- ¿Logo o nombre del cliente para la portada?

Si no hay branding definido, usar la configuración por defecto de la skill `docx` del entorno.

### Q5 — Deadline y alcance del entregable

- ¿Es el documento completo o un MVP con los bloques más urgentes?
- ¿Hay fecha límite? Define si se marcan secciones como borrador o si se espera el corpus
  completo.

Con las respuestas, producir la **propuesta de índice** (ver §Flujo de generación) y
presentarla antes de escribir nada.

## Audiencias y sus requisitos

Cada audiencia tiene bloques de corpus obligatorios. Un bloque obligatorio faltante
**bloquea la sección** — no se omite en silencio ni se rellena con inferencias.

Los bloques del corpus y quién los produce cuando faltan están en
`references/proyecciones-doc.md`. Resumen operativo:

| Audiencia | Bloques obligatorios | Vocabulario | Visibilidad |
|---|---|---|---|
| Manual de usuario | `superficie`, `logica-negocio` (flujos de interfaz) | No técnico, en términos del usuario | Solo `externa` |
| Capacitación | `superficie`, `logica-negocio`, `integraciones`, `operacion` | Mixto: técnico donde el operador lo necesita | Interna |
| Documentación de PM | `zonas-oscuras`, `riesgo`, `operacion` | Gestión, no implementación | Interna |
| Handover técnico | `superficie` (a profundidad de contrato), `logica-negocio`, `modelo-datos`, `integraciones`, `zonas-oscuras`, `operacion`, `pruebas` | Técnico completo | Interna |
| Presentación a cliente | `superficie` (alto nivel) | Negocio, sin código ni jerga interna | Solo `externa` |
| Aval de desempeño | `logica-negocio`, `trayectoria` | Evidencia, no narrativa | Interna |

**Nota sobre `visibilidad`:** toda sección que use entradas de corpus con `visibilidad = interna`
lleva una marca visible en el documento: `[SOLO USO INTERNO]`. El renderizador no decide qué
publicar; marca para que quien distribuya tome la decisión informada.

## Estructura del documento por audiencia

Los índices completos con contenido esperado y fuente de corpus por sección viven en
`references/doc-templates.md`. Leerlo al armar la propuesta de índice. Resumen de los
puntos de partida:

- **Manual de usuario:** portada · para qué sirve · requisitos · casos de uso paso a paso
  (por flujo de interfaz) · referencia rápida · preguntas frecuentes.
- **Capacitación:** portada · introducción al sistema · arquitectura funcional (no interna) ·
  flujos operativos · casos de error y cómo actuar · procedimientos y runbook · referencia
  de integraciones.
- **Documentación de PM:** portada · estado del sistema · capacidades actuales · zonas
  oscuras y deuda declarada · riesgos abiertos · coste operativo · pendientes con responsable.
- **Handover técnico:** portada · arquitectura y stack · modelo de datos · flujos y lógica de
  negocio · integraciones y contratos · zonas oscuras y trampas conocidas · setup y
  configuración · **guía de incorporación** (puesta en marcha · ambientes · accesos ·
  verificación de extremo a extremo · ejemplos de invocación · estado y alcance vigente ·
  backlog priorizado · criterios de liberación y responsables · checklist de recepción) ·
  glosario. La guía de incorporación es la mitad que decide si el receptor puede trabajar el
  primer día; sin `operacion` en el corpus, se emite bloqueada, no se omite.
- **Presentación a cliente:** portada · propuesta de valor · capacidades principales · flujos
  de usuario (alto nivel) · estado y próximos pasos.
- **Aval de desempeño:** portada · ámbito del aval · contribuciones con evidencia · trayectoria
  de cambios · criterios cumplidos.

## Generación del `.docx`

### Paso obligatorio antes de cualquier código

**Consultar la skill `docx` del entorno** según tu runtime (ver tabla de equivalencias en
`references/interop-notion.md`): en Claude/Claude Code, leer `/mnt/skills/public/docx/SKILL.md`;
en Kiro, invocar la skill `docx` según el mecanismo de Kiro. Si la skill no está disponible,
notificar al usuario antes de continuar. Las restricciones de la skill `docx` tienen
precedencia sobre cualquier preferencia de esta skill.

### Mapeo corpus → documento

Por cada sección del índice aprobado:

1. **Filtrar el corpus** por bloque, estado (`vigente`) y visibilidad adecuada a la audiencia.
2. **Ordenar** las entradas para la narrativa de esa sección (no necesariamente en el orden
   del corpus — el orden narrativo es responsabilidad de esta skill).
3. **Adaptar el vocabulario** al de la audiencia. Una afirmación de corpus dice `handler
   rechaza la solicitud cuando...`; para un manual de usuario se traduce a `el sistema muestra
   un error cuando...`. La afirmación no se inventa: se parafrasea declarando que proviene del
   corpus.
4. **Secciones con entradas `NO DETERMINADO`:** incluirlas o no según la audiencia (un manual
   de usuario no necesita los huecos del corpus; un handover técnico sí). Cuando se incluyen,
   se presentan como limitaciones conocidas, no como fallos del documento.
5. **Entradas con procedencia `entrevista`:** se marcan como "confirmado por [rol], [fecha]"
   para que el lector sepa qué está verificado en código y qué fue declarado por una persona.

### Secciones borrador

Toda sección cuyo bloque de corpus falta o está bloqueado lleva, sin excepción:

1. **Marcador visible:** `[PENDIENTE — bloque: {nombre}, responsable: {skill o rol}]`.
2. **Descripción de qué falta** y qué skill o persona lo puede producir.

Al terminar, el usuario recibe la **lista de secciones borrador** con instrucciones de qué
completar. Una sección borrador nunca se rellena con inferencias para "que se vea terminado".

### Flujo de generación

1. **Leer** el corpus en Notion; calcular la cobertura real para la audiencia elegida.
2. **Proponer** el índice con fuente de corpus por sección (real vs. borrador).
3. **Esperar aprobación** — el usuario puede añadir, quitar o reordenar secciones.
4. **Consultar** la skill `docx` del entorno según tu runtime.
5. **Generar** el `.docx` con el contenido aprobado, aplicando branding (Q4).
6. **Entregar** el archivo + lista de secciones borrador + instrucciones si las hay.

## Relación con `documentation-master`

Esta skill es consumidora, no productora. Lo que implica en la práctica:

- **No escribe entradas de corpus.** Si durante la generación se detecta que una afirmación
  del corpus está mal formada o es sospechosa, se reporta como defecto del corpus y se
  continúa, pero no se corrige en la tabla. Corregir el corpus es de `documentation-master`.
- **No actualiza el corpus.** Si el usuario pide añadir algo que no está, la respuesta es
  registrarlo como P-n para `documentation-master` y marcarlo como borrador en el documento.
- **No revalida el corpus.** Si hay entradas `por revalidar`, se las trata como lo que son:
  información posiblemente desactualizada. Se incluyen marcadas, o se omiten si la audiencia
  lo requiere, pero no se decide su vigencia — esa decisión es de `documentation-master`.
- **Cobertura por proyección.** Al emitir el documento, declarar qué secciones quedaron
  como borrador y por qué, para que `documentation-master` sepa qué bloques faltan.

## Notion

Esta skill **no crea páginas en Notion**. Su entregable es el `.docx`, punto.

Lo que sí hace, de forma quirúrgica y solo si el proyecto ya usa la suite:

- Registrar en la tabla de **Cobertura por proyección** del hub Corpus el resultado de esta
  proyección: audiencia, estado (`completa` / `incompleta` / `bloqueada`), bloques faltantes,
  ancla y fecha. Esto mantiene al corpus informado de qué proyecciones se produjeron y con
  qué base.
- Añadir una P-n por cada bloque faltante que bloqueó una sección, si no existe ya.

Ambas operaciones se **proponen** antes de ejecutar (Regla cero). Si el usuario prefiere no
tocar Notion, el resultado es el mismo `.docx` con el mismo reporte de borradores — solo sin
la actualización en Notion.

## Fuera de alcance

- **Producir o actualizar el corpus** — es `documentation-master`.
- **Documentar en Notion** — es `project-onboarding` o `documentation-master`.
- **Generar presentaciones** — es `project-deck`.
- **Evaluar calidad o riesgo** — es `project-audit`.
- **Mantener el documento sincronizado** — es un snapshot puntual; para reflejar cambios
  en el corpus se reinvoca.
- **Decidir la vigencia de entradas `por revalidar`** — es `documentation-master`.

## Antipatrones

1. **Rellenar borradores** — escribir algo plausible en lugar del bloque faltante. El documento
   se firma como cierto ante una audiencia; un dato inventado en un handover técnico o en un
   aval de desempeño es un pasivo real.
2. **Ignorar la visibilidad** — incluir entradas `interna` en un manual de usuario o en una
   presentación a cliente sin marcarlas. Publica sin que nadie decida que quería publicar.
3. **Reescribir el corpus al redactar** — la paráfrasis adapta vocabulario, no cambia el
   hecho. Si la afirmación del corpus parece incorrecta, se reporta como defecto; no se
   "mejora" al escribirla en el documento.
4. **Omitir entradas `NO DETERMINADO` en un handover técnico** — es exactamente la
   información que quien recibe necesita: las trampas y los huecos conocidos.
5. **Asumir vigencia de entradas `por revalidar`** — si no se revalidaron, no se sabe si
   son ciertas. Tratarlas como vigentes produce un documento que afirma cosas que el corpus
   ya declaró dudosas.

## Recursos de la skill

- `references/doc-templates.md` — los seis índices base con contenido esperado y fuente de
  corpus por sección. Leer al armar la propuesta de índice.
- `references/proyecciones-doc.md` — qué bloques exige cada audiencia, con qué nivel de
  detalle, qué omite, y qué ocurre si un bloque falta. Leer en Q2 y al emitir la lista de
  borradores.
- `references/interop-notion.md` — contrato de interoperabilidad de la suite (inyectado al
  empacar): estructura canónica del hub, tabla única de Ps, ownership de páginas, y
  equivalencias de herramienta por runtime. Leer antes de tocar Notion y antes de invocar
  la skill `docx` del entorno.
