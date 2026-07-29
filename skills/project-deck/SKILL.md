---
name: project-deck
description: "Generación de una presentación (PPTX) de un proyecto de software como entregable puntual (snapshot para una presentación concreta, no se sincroniza con el proyecto). Una entrevista de arranque detecta la AUDIENCIA —técnica, cliente/stakeholder o manual de usuario— y adapta todo el deck: estructura de slides, profundidad, vocabulario y qué diagramas incluir. Consume la documentación que el usuario provea, idealmente la ya generada por project-onboarding en Notion (bloque diagrams-export), o insumos adjuntos directamente. Renderiza los diagramas Mermaid como imágenes usando la skill pptx del entorno. Usar esta skill SIEMPRE que el usuario quiera: generar una presentación del proyecto, un 'deck', un 'PPTX', 'diapositivas' o 'slides'; 'presentar el sistema', hacer un 'pitch del proyecto', 'slides para el cliente', 'slides técnicos' o un 'manual de usuario en presentación'. NO reemplaza a project-onboarding: si el usuario quiere documentar Y presentar, recomendar correr primero project-onboarding (que produce la documentación en Notion) y luego esta skill (que produce el PPTX). NO usar para documentar en Notion (eso es project-onboarding) ni para mantener el deck actualizado en el tiempo."
---

# Presentación de proyecto (PPTX, snapshot puntual)

Disciplina para generar una presentación de un proyecto de software como **entregable puntual**: se produce para una presentación concreta y no se mantiene sincronizado con el proyecto. Si el proyecto cambia, se reinvoca la skill.

Principio rector: **el deck se genera para una audiencia específica, y la audiencia define TODO.** No hay "modos" separados: una sola entrevista detecta a quién va dirigida la presentación y de ahí se deriva la estructura de slides, la profundidad, el vocabulario y qué diagramas incluir. Un deck técnico y uno para cliente no son el mismo contenido con distinto formato — son presentaciones distintas.

Esta skill **orienta al usuario para que provea los insumos**; no asume acceso autónomo al repo ni a Notion. Su compañera es `project-onboarding`: si esa skill ya corrió, el deck se alimenta de la documentación que dejó en Notion (en especial el bloque `diagrams-export`); si no, el usuario adjunta los insumos directamente. Esta skill **no** documenta en Notion ni reemplaza a `project-onboarding` — si el usuario quiere documentar y presentar, recomendar correr `project-onboarding` primero.

## Regla cero (gobierna todo lo demás)

**Nada se genera sin aprobación de la propuesta de estructura.**

1. La skill presenta el **índice de slides propuesto** —con la fuente declarada por cada slide— y espera confirmación explícita antes de generar el PPTX. El usuario puede añadir, quitar o reordenar. La propuesta es conversación; la generación empieza después del "adelante".
2. Información sin fuente verificable → **slide marcado como borrador**, nunca inventado. Un slide con un hueco declarado es honesto; uno con datos inventados es un pasivo que se presentará como cierto frente a una audiencia.
3. Sin slides de relleno: cada slide tiene contenido real o no existe. Los slides "pendiente de verificar" se marcan visualmente como borradores y se listan al final — nunca se presentan como completos.

## Arranque: detectar antes de preguntar

Al activarse, revisar primero el contexto ya disponible (conversación, memoria, archivos adjuntos, Notion accesible): lo que ya se sabe se **confirma**, no se pregunta. Solo entonces hacer las preguntas que no se puedan inferir, cortas y en un solo bloque si la interfaz lo permite.

### Q1 — Audiencia (define TODO el deck)

Es la pregunta que gobierna toda la generación. Tres opciones; cada una fija estructura, vocabulario y tipos de diagrama:

- **Técnica** — desarrolladores, arquitectos, equipo de ingeniería. Contenido: stack, arquitectura, flujos de datos, decisiones técnicas, endpoints, modelo de datos. Vocabulario técnico, sin traducir a negocio. Diagramas: arquitectura (`graph TD` / `C4Context`) y secuencia (`sequenceDiagram`).
- **Cliente / stakeholder** — dirección, cliente externo, product owner. Contenido: propuesta de valor, capacidades del sistema, flujos de usuario, métricas o resultados, roadmap si aplica. Sin código, sin jerga interna. Diagramas: flujo de usuario (no secuencia técnica).
- **Manual de usuario** — usuarios finales, operadores. Contenido: guía paso a paso, pantallazos o wireframes, casos de uso operativos, FAQ. Lenguaje no técnico. Sin arquitectura interna.

Si la audiencia no es clara, ayudar al usuario a elegir con dos preguntas de desempate:

1. **¿Quién va a ver esta presentación?**
2. **¿Qué acción esperas que tome al verla?**

La combinación de ambas resuelve casi todos los casos: quien decide un presupuesto no es la misma audiencia que quien va a operar el sistema, aunque ambos sean "no desarrolladores".

### Q2 — Insumos disponibles

Por cada categoría, preguntar qué existe y cómo acceder. Por cada sección del deck sin insumo, registrar el slide como **borrador** y ofrecer al usuario completarlo manualmente después.

- ¿Existe documentación en Notion generada por `project-onboarding`? → pedir la **URL de la página de Documentación**. Es la fuente preferida.
- ¿Se adjuntan insumos directamente? → README, spec, capturas, DDL, colección Postman, descripción en prosa.
- ¿Hay material visual existente? → logos, paleta de colores, plantilla PPTX corporativa (se cruza con Q4).

### Q3 — Contexto de la presentación

Calibra la profundidad y el número de slides:

- **¿Cuánto dura?** Una charla de 5 minutos y una de 40 no llevan el mismo número de slides ni la misma profundidad.
- **¿Es para demo en vivo, lectura autónoma, o ambas?** La lectura autónoma necesita slides más autoexplicativos; la demo en vivo puede apoyarse en la narración.
- **¿Hay deadline?** Define si se genera el deck completo o un MVP rápido con lo esencial y el resto como borradores.

### Q4 — Branding

- **¿Existe una plantilla PPTX corporativa o de proyecto?** → pedir que se adjunte.
- **¿Paleta de colores o fuentes definidas?**
- **¿Logo del proyecto o empresa para la portada?**

Si no hay branding definido, usar la paleta y tipografía por defecto de la `pptx` skill del entorno — no inventar una identidad de marca.

Con las respuestas, generar la **propuesta de índice** (ver §Flujo de generación) y presentarla antes de escribir nada.

## Estructura de slides por audiencia

La skill propone el índice ANTES de generar, adaptando el índice base de `references/slide-templates.md` según Q3 (duración → cuántos slides y cuánta profundidad) y Q2 (insumos disponibles → qué va como slide real y qué como borrador). Los índices completos, con contenido y fuente por slide, viven en `references/slide-templates.md`; leerlo al armar la propuesta. Resumen de los tres puntos de partida:

- **Técnica:** portada · contexto y problema · arquitectura de alto nivel (diagrama) · stack · flujos principales (secuencia, máx. 3) · modelo de datos (ER simplificado) · integraciones externas · decisiones de diseño · estado y pendientes · Q&A.
- **Cliente / stakeholder:** portada · problema (en lenguaje de negocio) · solución y propuesta de valor · capacidades principales · flujo del usuario (diagrama de flujo) · resultados/métricas (si existen) · estado actual · próximos pasos/roadmap · Q&A.
- **Manual de usuario:** portada (nombre, versión, fecha) · ¿para qué sirve? (3 puntos) · requisitos para usarlo · casos de uso paso a paso (una acción por slide con captura/wireframe, máx. 5) · preguntas frecuentes · contacto/soporte.

## Generación del PPTX

### Paso obligatorio antes de cualquier código

**Consultar la `pptx` skill del entorno** según tu runtime (ver tabla de equivalencias en `references/interop-notion.md`): en Claude/Claude Code, leer `/mnt/skills/public/pptx/SKILL.md`; en Kiro, invocar la skill `pptx` según el mecanismo de Kiro. Si la skill no está disponible en tu runtime, notificar al usuario antes de continuar. Define las restricciones del entorno: librerías disponibles, rutas de salida, límites de renderizado y formato. **Las restricciones de la `pptx` skill tienen precedencia sobre cualquier preferencia de esta skill.** Si algo aquí choca con lo que dice esa skill, manda esa skill.

### Diagramas en el PPTX

- **Fuente preferida:** el código Mermaid del bloque `diagrams-export` de Notion, generado por `project-onboarding`. Consumirlo directamente sin re-parsear toda la página de documentación.
- **Si no hay Notion:** generar el Mermaid desde los insumos adjuntos (mismos tipos y reglas que usa `project-onboarding`: título como comentario, pendiente marcado, nunca inventar).
- **Renderizado:** convertir cada diagrama Mermaid a imagen según el mecanismo disponible en la `pptx` skill, e insertarlo como imagen en el slide. Si el entorno **no** soporta renderizado de Mermaid directamente, insertar el código Mermaid como bloque de texto en el slide y **notificar al usuario** que debe reemplazarlo por la imagen renderizada manualmente (el diagrama sin renderizar cuenta como pendiente del slide).

### Slides borrador

Todo slide cuyo contenido no pudo verificarse con una fuente lleva, sin excepción:

1. **Marca visual diferenciada:** fondo o borde de alerta según la paleta activa (o la de la `pptx` skill si no hay branding).
2. **Texto al pie del slide:** `[BORRADOR — pendiente: {qué falta}]`, con la descripción concreta de qué información y de qué fuente debería salir.

Al terminar la generación, el usuario recibe una **lista de todos los slides borrador** con instrucciones de qué completar en cada uno. Un borrador nunca se presenta como completo ni se rellena con suposiciones para "que se vea terminado".

### Flujo de generación

1. **Proponer** el índice de slides con la fuente declarada por cada slide (real vs borrador).
2. **Esperar aprobación** del usuario — puede añadir, quitar o reordenar slides.
3. **Consultar** la `pptx` skill del entorno según tu runtime (ver `references/interop-notion.md`).
4. **Generar** el PPTX con el contenido aprobado, aplicando branding (Q4) y renderizando diagramas.
5. **Entregar** el archivo + la lista de slides borrador + instrucciones de completado manual si los hay.

## Integración con project-onboarding

Si el proyecto ya tiene la página de Documentación en Notion (`project-onboarding` corrió antes):

- **Leer solo las secciones relevantes para la audiencia elegida (Q1).** Un deck técnico consume arquitectura, modelo de datos y flujos; uno de cliente consume visión, capacidades y flujos de usuario. No arrastrar todo.
- **Consumir el bloque `diagrams-export`** para los diagramas, en vez de regenerarlos.
- **No duplicar en Notion** nada que ya esté ahí — el deck es el entregable, no una nueva página de Notion. Esta skill no escribe documentación en Notion.
- **Registrar la generación del deck** (solo ofrecer, nunca escribir sin confirmación):
  - Si el proyecto usa `git-workflow`: como entrada breve en el **Registro de decisiones de branching** de `branch-change-tracker` (qué deck se generó, para qué audiencia y presentación).
  - Si el proyecto usa `sdd-harness-notion`: como nota breve en el hub del proyecto.
  - Respetar el ownership y las ediciones quirúrgicas del contrato compartido (`references/interop-notion.md`): nunca reescribir una página compartida.

Si no hay Notion, la skill opera solo con los insumos adjuntos; no crea estructura en Notion para "compensar".

## Fuera de alcance

- **Generar la documentación en Notion** — es `project-onboarding`. Esta skill consume documentación, no la produce.
- **Actualización continua del deck** — es un snapshot puntual; para reflejar cambios se reinvoca.
- **Cambios a otras skills o al contrato compartido `interop-notion.md`.**
- **Renderizado de diagramas si la `pptx` skill del entorno no lo soporta** — en ese caso se notifica al usuario y se entregan los bloques Mermaid como texto para reemplazo manual.

## Recursos de la skill

- `references/interop-notion.md` — contrato de interoperabilidad de la suite (inyectado por `package.sh`): estructura canónica del hub, tabla única de Ps, ownership de páginas, ediciones quirúrgicas sobre páginas compartidas. Leer antes de ofrecer registrar el deck en Notion de un proyecto que use otra skill de la suite.
- `references/slide-templates.md` — los tres índices base completos (técnica / cliente / manual de usuario), con nota de contenido y fuente esperada por cada slide. Leer al armar la propuesta de índice para el usuario.
