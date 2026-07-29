---
name: project-onboarding
description: "Documentación de un proyecto de software en Notion, a nivel técnico y de usuario, como snapshot único: extrae información del repo, de los insumos que el usuario provea y de una entrevista guiada, y produce documentación estructurada (visión, arquitectura, flujos, modelo de datos, integraciones, setup, glosario) con diagramas Mermaid. Orienta al usuario sobre qué insumos aportar y cómo; lo que no tenga fuente verificable se marca como pendiente, nunca se inventa. Usar esta skill SIEMPRE que el usuario quiera: documentar un proyecto o sistema, hacer onboarding de un nuevo integrante al equipo, generar una base de conocimiento del sistema, explicar 'cómo funciona' un proyecto completo, levantar la arquitectura de un proyecto en Notion, o preparar la documentación que alimentará una presentación (project-deck). También ante menciones de 'documentar', 'onboarding', 'arquitectura del proyecto', 'explicar el sistema', 'base de conocimiento' o 'diagramas del proyecto'. NO usar para documentar una función o módulo aislado (eso lo hace el agente de código directamente) ni para generar el PPTX (eso es project-deck)."
---

# Onboarding y documentación de proyecto (snapshot en Notion)

Disciplina para documentar un proyecto completo en Notion —a nivel técnico y de usuario— combinando lo que se extrae del repo, los insumos que el usuario aporta y una entrevista guiada. El resultado es una página de documentación estructurada con diagramas Mermaid, pensada para onboarding de nuevos integrantes, stakeholders técnicos o administradores.

Principio rector: **la documentación es un snapshot, no un sistema vivo.** Se genera una vez por invocación reflejando el estado del proyecto en ese momento; no se mantiene automáticamente. Si el proyecto evoluciona, se invoca de nuevo —completa o parcialmente—. Por eso cada sección declara de qué fuente salió: un snapshot sin trazabilidad de fuentes envejece sin que nadie sepa qué sigue siendo cierto.

Esta skill **orienta al usuario para que provea los insumos**; no asume que puede leer el repo por su cuenta. Pregunta qué está disponible y cómo acceder. Lo que no tenga fuente de verdad se marca explícitamente como pendiente en Notion. Es una skill compañera de `project-deck` (que genera el PPTX): el handoff entre ambas es la página de Notion del proyecto.

## Regla cero (gobierna todo lo demás)

**No asumir nada. Nada se escribe en Notion sin confirmación del usuario.**

1. Toda sección que no pueda sustentarse en una fuente verificable se marca como **pendiente** (`⚠️ PENDIENTE`) con la descripción de qué falta — nunca se rellena con suposiciones. Una documentación con un hueco declarado es útil; una con datos inventados es un pasivo.
2. Cada hueco genera además una **pregunta abierta numerada (P-n)** en la tabla única del proyecto (ver `references/interop-notion.md`). La numeración de Ps es del proyecto, no de la skill: continúa la secuencia existente, nunca la reinicia.
3. Antes de crear o editar cualquier página, presentar al usuario la **propuesta de estructura y los diagramas** y esperar su aprobación explícita. La propuesta es conversación; la escritura en Notion empieza después del "adelante".
4. No avanzar con secciones huérfanas de fuente: si una sección no tiene insumo, se registra su P y se marca pendiente, pero no se redacta a ciegas.

## Arranque: detectar antes de preguntar

Al activarse, revisar primero el contexto ya disponible (conversación, memoria, archivos adjuntos, Notion accesible): lo que ya se sabe se **confirma**, no se pregunta. Solo entonces hacer las preguntas que no se puedan inferir. Preguntas cortas, en un solo bloque si la interfaz lo permite.

**Q1 — Propósito y audiencia de la documentación.** ¿Para quién es principalmente: nuevos desarrolladores del equipo, stakeholders técnicos, o administradores/usuarios finales? La respuesta calibra el balance entre detalle técnico y narrativa. (La audiencia del PPTX se define aparte en `project-deck`; aquí se documenta para Notion.)

**Q2 — Insumos disponibles.** Recorrer por categoría (ver §Insumos y su acceso): ¿qué existe y cómo se puede acceder? Para cada categoría disponible, pedir que se adjunte o comparta ANTES de continuar con la sección que depende de ella. Para cada categoría ausente, registrar una P y marcar pendiente la sección correspondiente.

**Q3 — Notion destino.** ¿Existe un hub del proyecto (pedir URL) o se crea desde cero? Si existe, leerlo ANTES de proponer estructura — adaptarse a su nomenclatura y páginas, nunca sobreescribir lo que ya hay.

**Q4 — Alcance del snapshot.** ¿Documentación completa (las 7 secciones) o alcance parcial (p. ej. solo arquitectura técnica, o solo flujos de usuario)? Calibra qué secciones se generan en esta invocación. Lo no incluido en el alcance no se marca como pendiente — simplemente queda fuera de este snapshot.

**Q5 — ¿El proyecto usa la suite SDD?** Si sí, la documentación se integra bajo el hub existente como página "Documentación" (si no existe) o se enriquece si ya existe. Nunca duplicar información que ya vive en handoffs, análisis o reportes de cierre — referenciarla. Leer `references/interop-notion.md` para respetar ownership de páginas.

Con las respuestas, generar la **propuesta**: qué secciones se producirán, qué diagramas, qué Ps ya se detectan por insumos ausentes, y dónde vivirá la documentación en Notion. Presentarla, iterar, y solo entonces escribir.

## Insumos y cómo el usuario los provee

La skill no asume acceso a nada. Por cada categoría pregunta qué existe y orienta sobre cómo compartirlo. Por cada categoría no disponible, registra una **P-n** y marca pendiente la sección que dependía de ella.

- **Repo / código fuente:** estructura de directorios, stack detectado (`composer.json`, `package.json`, u equivalente), rutas principales, migraciones. Cómo proveer: adjuntar el árbol de directorios, los manifiestos de dependencias, y las rutas/migraciones relevantes.
- **Documentación existente:** README, ADRs, wiki, colección Postman, DDL, spec. Si el proyecto usa la suite SDD: el hub de Notion con sus análisis, handoffs y reportes de cierre (compartir URL).
- **Insumos de negocio:** propósito del proyecto, usuarios objetivo, flujos principales — en palabras del usuario, no del código. Cómo proveer: descripción en prosa; la skill puede proponer un borrador para que el usuario lo corrija.
- **Notion del proyecto:** ¿existe hub? ¿URL? ¿qué secciones ya tiene? ¿dónde debe vivir la documentación nueva?

## Estructura de la documentación en Notion

La skill propone esta estructura y la crea SOLO tras aprobación. Si el hub ya tiene páginas propias, adaptarse a ellas en lugar de imponer el esqueleto.

```
{Proyecto} (hub raíz, ya existente o nuevo)
└── Documentación (página nueva o enriquecida)
    ├── Visión general
    ├── Arquitectura técnica
    ├── Flujos principales
    ├── Modelo de datos
    ├── Integraciones externas
    ├── Guía de inicio (setup)
    └── Glosario
```

Cada sección declara su **fuente**; si la fuente falta, aplica el comportamiento pendiente (marcador `⚠️ PENDIENTE` + P-n).

### 1. Visión general

- Propósito del proyecto en 2-3 párrafos. Fuente: Q1 + insumos de negocio.
- Usuarios objetivo y casos de uso principales. Fuente: insumos de negocio.
- Stack tecnológico. Fuente: `composer.json`, `package.json`, u equivalente.
- Estado actual. Fuente: último reporte de cierre de la suite SDD si existe, o declaración del usuario.
- Sin fuente → marcar pendiente + P-n.

### 2. Arquitectura técnica

- Diagrama de arquitectura de alto nivel (Mermaid `graph TD` o `C4Context`).
- Repositorios del ecosistema y sus relaciones, si es multi-repo.
- Componentes principales: capas, servicios, jobs, middleware clave.
- Decisiones de diseño relevantes. Fuente: ADRs, análisis SDD, o declaración del usuario. Las no documentadas se marcan como pendiente.

### 3. Flujos principales

Un diagrama de secuencia Mermaid (`sequenceDiagram`) por flujo crítico. **Máximo 5** en el snapshot; priorizar con el usuario cuáles. Fuente: colección Postman, spec, handoffs SDD, o descripción del usuario. Flujo sin fuente verificable → bloque Mermaid con `%% PENDIENTE: verificar con {fuente} %%` como primera línea + P-n.

### 4. Modelo de datos

- Diagrama ER Mermaid (`erDiagram`) de las entidades principales.
- Fuente primaria: DDL o migraciones. Sin DDL → diagrama marcado como pendiente con las entidades que se puedan inferir del código, y P-n.
- Tablas compartidas vs propias del producto, si aplica ecosistema multi-repo.

### 5. Integraciones externas

Tabla en Notion con columnas: integración · tipo (REST/SOAP/evento) · dirección (entrante/saliente) · autenticación · entorno (UAT/prod) · estado. Fuente: colección Postman, `config/services`, `.env.example`. Lo no documentado en fuentes → fila marcada pendiente + P-n. Nunca inferir credenciales ni endpoints no verificados.

### 6. Guía de inicio (setup)

Pasos para levantar el proyecto localmente: prerrequisitos, variables de entorno necesarias (fuente: `.env.example` — **nunca valores reales**, solo nombres de variables), comandos de instalación y arranque, cómo correr los tests. Fuente primaria: README existente — referenciarlo, no duplicarlo si ya existe y está actualizado. Sin README ni `.env.example` → pendiente + P-n.

### 7. Glosario

Términos del dominio de negocio que un nuevo integrante necesita conocer. Fuente: el usuario los declara. La skill puede **sugerir** términos detectados en el código que parezcan específicos del dominio, presentándolos para que el usuario los confirme o descarte — no darlos por definidos.

## Diagramas: reglas de los bloques Mermaid

Los diagramas se entregan de dos formas complementarias, y **nunca se renderizan como imágenes** dentro de esta skill (Notion renderiza el bloque Mermaid nativamente; `project-deck` incrusta el código en el PPTX):

1. Como **bloque de código con lenguaje `mermaid`** en la sección correspondiente de Notion.
2. Como **código Mermaid listo para incrustar en el PPTX**, guardado también en un bloque/página `references/diagrams-export.md` de la documentación de Notion, para que `project-deck` lo consuma sin re-parsear la página completa.

Reglas de cada diagrama:

- **Título como comentario Mermaid** en la primera línea útil: `%% Título del diagrama %%`.
- **Diagrama pendiente de verificación:** primera línea `%% PENDIENTE: fuente requerida: {qué} %%`, y el contenido refleja solo lo inferible, nunca lo inventado.
- Todo diagrama se **propone al usuario antes de insertarse**.
- Plantillas reutilizables por tipo en `references/mermaid-templates.md` (arquitectura, secuencia, ER, C4). Leerlas al redactar cualquier diagrama.

## Secciones pendientes y Ps

Toda sección que no pudo completarse por falta de insumo genera dos artefactos, siempre juntos:

1. En Notion: el bloque con el marcador visual **`⚠️ PENDIENTE`** + descripción de qué falta y de qué fuente debería salir.
2. En la tabla única de Ps del proyecto: una entrada `P-n · tema · origen: project-onboarding · gatea: actualización de esta sección · estado: abierta`.

Cuando el usuario provea el insumo faltante, se actualiza la sección (edición quirúrgica) y se cierra la P con su resolución — sin reescribir el resto de la página.

## Integración con la suite SDD

- **Leer `references/interop-notion.md` antes de crear o editar cualquier página.** Define ownership, ediciones quirúrgicas y la tabla única de Ps. No duplicar aquí su contenido — es la fuente única.
- Si el hub ya tiene hubs de fase con handoffs y reportes de cierre: **referenciarlos** desde las secciones relevantes de la documentación, no copiar su contenido. Un dato duplicado es un dato que envejecerá desincronizado.
- **Ownership:** la página "Documentación" es propiedad de `project-onboarding`; los hubs de fase son propiedad de `sdd-harness-notion`. Ninguna skill edita las páginas de la otra. La documentación se integra como página hermana de las fases, bajo el hub raíz — no reemplaza ni sobreescribe páginas existentes.
- Si el proyecto no usa la suite SDD, la documentación puede ser la primera página del hub; se sigue respetando la tabla única de Ps por si otra skill de la suite se incorpora después.

## Operación con Notion

Al **crear**: proponer estructura y diagramas, esperar aprobación, luego crear la página "Documentación" y sus secciones. Al **enriquecer** una página existente o corregir una sección pendiente: edición quirúrgica (`update_content` con reemplazos puntuales) — nunca reescribir la página completa (destruye historial, bloques y anclas de otras skills). Al **leer** un hub existente (Q3/Q5): hacerlo antes de proponer, para adaptarse a lo que ya vive ahí.

Si las páginas las genera otro agente con su propia integración, pueden nacer inaccesibles para el conector — pedir al usuario compartirlas o moverlas a una sección conectada. Nunca aceptar tokens de integración pegados en el chat.

## Fuera de alcance

- Generar el PPTX — es `project-deck`.
- Renderizar imágenes de los diagramas — Notion lo hace con el bloque Mermaid.
- Documentar funciones o módulos aislados — es tarea directa del agente de código.
- Actualización continua o versionado automático — la documentación es un snapshot; para reflejar cambios se reinvoca la skill.
- Cambios a otras skills o al contrato compartido `interop-notion.md`.

## Recursos de la skill

- `references/interop-notion.md` — contrato de interoperabilidad de la suite (inyectado por `package.sh`): estructura canónica del hub, tabla única de Ps con numeración compartida, ownership de páginas, handoffs como interfaz. Leer SIEMPRE antes de crear o editar páginas de un proyecto que involucre (o vaya a involucrar) más de una skill de la suite.
- `references/mermaid-templates.md` — plantillas Mermaid reutilizables para los tipos de diagrama del ecosistema: arquitectura (`graph TD`), secuencia (`sequenceDiagram`), ER (`erDiagram`) y C4 (`C4Context`), con comentarios sobre cuándo usar cada una y las reglas de título/pendiente/exportación. Leer al redactar cualquier diagrama.
