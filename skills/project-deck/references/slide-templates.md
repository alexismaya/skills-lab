# Índices base de slides por audiencia

Puntos de partida para la propuesta de índice que la skill presenta al usuario ANTES de generar el PPTX (Regla cero). No son fijos: se **adaptan** según Q3 (duración → cuántos slides y cuánta profundidad) y Q2 (insumos disponibles → qué va como slide real y qué como borrador). Un slide sin fuente verificable se marca como borrador (`[BORRADOR — pendiente: {qué falta}]` + marca visual), nunca se rellena con suposiciones.

Cada slide declara la **fuente esperada**. Cuando la fuente proviene de la documentación de `project-onboarding` en Notion, se indica la sección de origen; los diagramas se toman del bloque `diagrams-export`. Si no hay Notion, la fuente es el insumo adjunto equivalente.

## Reglas comunes a los tres índices

1. **Portada siempre primero, Q&A o contacto siempre al final.** Lo intermedio se prioriza según duración.
2. **Un slide por idea.** Si un slide acumula dos diagramas o dos temas, se parte en dos.
3. **Diagramas como imagen** (renderizados desde Mermaid vía la `pptx` skill). Si el entorno no soporta el render, va el código Mermaid como texto + aviso al usuario.
4. **Recorte por duración (Q3):** para charlas cortas, conservar portada, problema, propuesta/arquitectura, un flujo y cierre; el resto pasa a apéndice o se omite. Nunca inflar con relleno para "llenar tiempo".
5. **Sin fuente → borrador.** El slide existe en el índice marcado como borrador y entra en la lista final de pendientes.

---

## 1. Audiencia técnica

Desarrolladores, arquitectos, equipo de ingeniería. Vocabulario técnico. Diagramas de arquitectura y secuencia.

| # | Slide | Contenido | Fuente esperada |
|---|---|---|---|
| 1 | Portada | Nombre del proyecto, fecha, autor, logo si hay | Q4 (branding) + datos del usuario |
| 2 | Contexto y problema | Qué problema técnico resuelve el sistema y en qué contexto opera | Notion: Visión general · o insumos de negocio |
| 3 | Arquitectura de alto nivel | Diagrama de componentes/capas y sus conexiones | Notion: `diagrams-export` (`graph TD` / `C4Context`) · o generado de insumos |
| 4 | Stack tecnológico | Lenguajes, frameworks, servicios, infraestructura | Notion: Visión general (stack) · o manifiestos (`package.json`, `composer.json`) |
| 5 | Flujos principales | Un diagrama de secuencia por flujo crítico — **máx. 3** | Notion: `diagrams-export` (`sequenceDiagram`) · o Postman/spec/usuario |
| 6 | Modelo de datos | Diagrama ER simplificado de las entidades principales | Notion: `diagrams-export` (`erDiagram`) · o DDL/migraciones |
| 7 | Integraciones externas | Servicios externos, dirección, autenticación, entorno | Notion: Integraciones externas · o `config/services`, `.env.example` (nunca valores reales) |
| 8 | Decisiones de diseño | Decisiones técnicas relevantes y su justificación | Notion: Arquitectura técnica · ADRs · o declaración del usuario |
| 9 | Estado actual y pendientes | Qué está hecho, qué falta, deuda conocida | Notion: estado actual · último reporte de cierre SDD · o usuario |
| 10 | Preguntas / Q&A | Cierre para preguntas | — |

---

## 2. Audiencia cliente / stakeholder

Dirección, cliente externo, product owner. Lenguaje de negocio, sin código. Diagramas de flujo de usuario.

| # | Slide | Contenido | Fuente esperada |
|---|---|---|---|
| 1 | Portada | Nombre del proyecto, fecha, autor, logo si hay | Q4 (branding) + datos del usuario |
| 2 | El problema que resuelve | El problema en lenguaje de negocio, sin jerga técnica | Notion: Visión general · o insumos de negocio |
| 3 | Solución y propuesta de valor | Qué ofrece el sistema y por qué importa | Insumos de negocio · declaración del usuario |
| 4 | Capacidades principales | Las capacidades clave, una por slide o en lista visual | Notion: Visión general / Flujos · o insumos de negocio |
| 5 | Flujo del usuario | Diagrama de flujo del usuario (no secuencia técnica) | Notion: `diagrams-export` (flujo de usuario) · o descripción del usuario |
| 6 | Resultados / métricas | Métricas o resultados, **solo si existen** | Datos que aporte el usuario (sin métrica verificable → omitir o borrador) |
| 7 | Estado actual | En qué punto está el proyecto, en lenguaje de negocio | Notion: estado actual · o usuario |
| 8 | Próximos pasos / roadmap | Qué sigue, si aplica | Usuario · roadmap del proyecto |
| 9 | Preguntas / Q&A | Cierre para preguntas | — |

---

## 3. Manual de usuario

Usuarios finales, operadores. Lenguaje no técnico. Sin arquitectura interna. Casos de uso paso a paso con captura o wireframe.

| # | Slide | Contenido | Fuente esperada |
|---|---|---|---|
| 1 | Portada | Nombre del sistema, versión, fecha | Q4 (branding) + datos del usuario |
| 2 | ¿Para qué sirve este sistema? | El propósito en 3 puntos, sin tecnicismos | Notion: Visión general · o insumos de negocio |
| 3 | Requisitos para usarlo | Accesos, prerrequisitos, permisos necesarios | Notion: Guía de inicio · o declaración del usuario |
| 4 | Caso de uso 1: paso a paso | Una acción por slide, con captura o wireframe | Capturas/wireframes adjuntos · descripción del usuario |
| 5 | Caso de uso 2: paso a paso | Ídem, siguiente flujo operativo | Capturas/wireframes adjuntos · descripción del usuario |
| 6 | (Repetir por flujo principal) | Un caso de uso por flujo — **máx. 5 casos** | Capturas/wireframes adjuntos · descripción del usuario |
| 7 | Preguntas frecuentes | Dudas comunes de operación y sus respuestas | Usuario · soporte del proyecto |
| 8 | Contacto / soporte | A quién acudir y por qué canal | Usuario |

Nota: sin capturas ni wireframes, cada caso de uso queda como slide **borrador** con la descripción del paso y el marcador de pendiente (falta el material visual). Se ofrece al usuario adjuntarlo o completarlo después.
