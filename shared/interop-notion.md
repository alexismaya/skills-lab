# Convención de interoperabilidad Notion — suite SDD

Contrato compartido entre skills que operan sobre el mismo proyecto:
`sdd-harness-notion` y `derivar-proyecto` (Claude), `qa-discovery` y
`qa-generator` (Kiro), y cualquier skill futura. Cada skill conserva su
especialidad; este documento define lo que comparten para no pisarse.

## Estructura canónica del proyecto en Notion

```
{Proyecto} (hub raíz)
├── Preguntas abiertas (P)     ← tabla ÚNICA del proyecto
├── Documentación               ← opcional (Q3 de la entrevista)
├── Matriz de herencia          ← solo proyectos derivados (derivar-proyecto)
├── Auditoría                   ← solo proyectos auditados (project-audit)
├── QA                          ← hub de calidad (qa-discovery / qa-generator)
├── Lecciones SDD               ← o enlace a la página global del usuario
└── Fase 1..N                   ← hub de fase → subpáginas de etapa (SDD harness)
```

Si el proyecto ya tiene estructura propia (entrevista Q2 = "Notion existente"),
esta convención se adapta a ella: se agregan las páginas que falten, no se
reorganiza lo que existe.

## Reglas compartidas

1. **Numeración única de Ps.** Los P-x son del PROYECTO, no de la skill: la
   numeración continúa entre fases y skills, nunca se reinicia. La tabla vive
   en una sola página; los hubs de fase y el hub QA la referencian o filtran,
   no la duplican. Columnas mínimas: id · tema · origen (skill/fase) · gatea
   (etapa o suite) · estado · resolución (cómo se resolvió y quién confirmó).

2. **Ownership de páginas.** Cada skill crea y edita solo sus páginas:
   derivar-proyecto la matriz; SDD harness los hubs de fase y etapas; las QA
   el hub QA y sus suites. Los artefactos compartidos (tabla P, estado global
   del hub raíz, Lecciones) se editan de forma quirúrgica (`update_content`
   con reemplazos puntuales) — reescribir una página compartida está
   prohibido para todas las skills.

3. **Handoffs como interfaz entre skills.** El "Resumen de salida" de cada
   etapa es el contrato de lectura para las demás: qa-discovery arma su plan
   leyendo hubs, criterios de aceptación y handoffs — no releyendo el repo
   completo. Ergo: un handoff pobre rompe a la skill de al lado; el checklist
   de cierre de toda etapa exige handoff escrito.

4. **QA como fase del ciclo, no como apéndice.** `qa-discovery` consume el
   hub del proyecto (contrato/spec, endpoints, criterios, matriz si existe)
   y produce el plan QA sobre la taxonomía L1–L6, con sus propias Ps en la
   tabla única. `qa-generator` materializa las suites por modo (unitario /
   integracion / e2e / infraestructura) como etapas SDD normales: contexto
   vinculante, smoke, checklist, handoff y evidencia. Los criterios de
   aceptación de las fases de implementación alimentan directamente los
   casos — un criterio sin caso QA que lo cubra se reporta como hueco.

5. **Gates cruzados.** Ninguna suite se genera sobre una fase cuyo gate no
   está aprobado (se generaría contra código que aún puede cambiar). Y el
   gate final de un proyecto no cierra sin el veredicto QA correspondiente.
   Las guardas del proyecto (anti-arrastre, patrones prohibidos) también
   aplican al código de tests: los tests son código del proyecto.

6. **Lecciones compartidas.** Una sola página "Lecciones SDD" por usuario (o
   por proyecto, a su elección): toda skill la lee al arrancar y ofrece
   escribir al cerrar un gate. Las lecciones de una skill benefician a las
   otras (una clasificación errada en la matriz es lección para QA:
   superficie que nadie probó).

7. **Evidencia uniforme.** Mismo formato de reporte de cierre para todas las
   skills: mapa de lo hecho, estado de Ps, evidencia por criterio (artefactos,
   no checkboxes), desviaciones justificadas, pendientes con responsable. Un
   gate se revisa igual sin importar qué skill produjo el entregable.

## Nota operativa (integraciones distintas)

Las skills de Kiro escriben con su propia integración de Notion; las de
Claude con el conector del usuario. Para que ambas vean las mismas páginas,
el hub raíz del proyecto debe vivir en una sección compartida con AMBAS
integraciones desde su creación — verificarlo es parte del arranque de
cualquier skill de la suite. Nunca intercambiar tokens de integración por
chat para "resolver" un problema de acceso: se comparte la página, no el
secreto.

## Equivalencias por runtime

Las skills de esta suite pueden ejecutarse desde Kiro o desde
Claude/Claude Code. Las referencias a herramientas específicas
en los cuerpos de las skills deben interpretarse según esta tabla.
La implementación concreta depende del runtime activo; la disciplina
(proponer → aprobar → ejecutar, Regla cero, ownership de páginas)
es idéntica en ambos.

### Integración de Notion

| Runtime | Cómo se resuelve |
|---|---|
| Claude / Claude Code | Conector de Notion del usuario (`notion-fetch`, `notion-update-page`, `notion-create-pages`, etc.) |
| Kiro | `mcp_notion_api_*` (herramientas MCP de Notion disponibles en el contexto de Kiro) |

En ambos casos aplican las mismas reglas de ownership y edición
quirúrgica definidas en §Ownership de páginas.

### Invocación de skills del entorno (pptx, docx, playwright, etc.)

| Runtime | Cómo se invoca una skill del entorno |
|---|---|
| Claude / Claude Code | Leyendo la SKILL.md en `/mnt/skills/public/<nombre>/SKILL.md` antes de generar |
| Kiro | Invocando la skill por nombre según el mecanismo de Kiro para el entorno activo |

Cuando una skill de esta suite diga "leer `/mnt/skills/public/pptx/SKILL.md`"
o "usar la `pptx` skill del entorno", interpretarlo según la fila de tu
runtime. Si la skill del entorno referenciada no está disponible en el
runtime activo, notificar al usuario antes de continuar.
