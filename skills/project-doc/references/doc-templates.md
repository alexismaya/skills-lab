# Índices base de documento por audiencia

Puntos de partida para la propuesta de índice que la skill presenta al usuario ANTES de
generar el `.docx` (Regla cero). No son fijos: se **adaptan** según Q3 (alcance del corpus a
proyectar) y Q5 (deadline y alcance del entregable). Una sección sin fuente de corpus
verificable se marca como borrador (`[PENDIENTE — bloque: {nombre}, responsable: {skill o
rol}]`), nunca se rellena con inferencias.

Cada sección declara la **fuente de corpus esperada**: el bloque del que provienen las
entradas y, cuando aplica, el filtro de visibilidad necesario.

## Reglas comunes a todos los índices

1. **Portada siempre primera, cierre siempre al final.** Lo intermedio se prioriza según la
   audiencia y el alcance.
2. **Una afirmación por párrafo** en el cuerpo del documento — igual que en el corpus. La
   prosa que agrupa varias ideas mezcla fuentes y hace imposible revalidar cada una.
3. **Entradas `por revalidar` → marcadas.** Se incluyen o excluyen según la audiencia, pero
   nunca se presentan como vigentes sin haberlo verificado.
4. **Entradas `interna` en documentos externos → marcadas** `[SOLO USO INTERNO]` o excluidas
   según instrucción del usuario. El documento no decide la visibilidad; la declara.
5. **Sin fuente de corpus → borrador.** La sección existe en el índice marcada; entra en la
   lista de pendientes al cierre.

---

## 1. Manual de usuario

Audiencia: usuarios finales y operadores del sistema. Lenguaje no técnico, en términos del
usuario. Solo entradas con `visibilidad = externa`.

| # | Sección | Contenido | Fuente de corpus |
|---|---|---|---|
| 1 | Portada | Nombre del sistema, versión, fecha, logo si hay | Q4 (branding) + datos del usuario |
| 2 | Para qué sirve este sistema | El propósito en lenguaje de usuario, sin tecnicismos | `superficie` + `logica-negocio` (flujos de interfaz, `visibilidad = externa`) |
| 3 | Requisitos para usarlo | Accesos, permisos, prerrequisitos | `superficie` (guardas de autenticación/autorización, `visibilidad = externa`) |
| 4 | Caso de uso: [nombre del flujo 1] | Paso a paso desde la perspectiva del usuario; qué ve, qué hace, qué puede salir mal | `logica-negocio` (flujo 1, `visibilidad = externa`) |
| 5 | Caso de uso: [nombre del flujo 2..N] | Ídem por cada flujo principal — máx. 5 | `logica-negocio` (flujos, `visibilidad = externa`) |
| 6 | Referencia rápida | Resumen de acciones, atajos, estados visibles | `superficie` + `logica-negocio` (estados, `visibilidad = externa`) |
| 7 | Preguntas frecuentes | Dudas comunes, en las palabras del usuario | Bloque `operacion` si existe · o P-n para captura operativa |
| 8 | Contacto y soporte | A quién acudir, por qué canal, para qué tipo de problema | Declaración del usuario |

**Bloqueante:** sin `logica-negocio` de los flujos de interfaz, la sección de casos de uso
queda borrador. Un manual sin los casos de uso es solo una portada y requisitos.

---

## 2. Capacitación

Audiencia: equipo que va a operar o dar soporte al sistema. Nivel de detalle máximo —
incluye errores, comportamientos inesperados y procedimientos. Uso interno.

| # | Sección | Contenido | Fuente de corpus |
|---|---|---|---|
| 1 | Portada | Nombre del sistema, versión, fecha, audiencia explícita | Q4 (branding) + datos del usuario |
| 2 | Qué hace este sistema | Propósito y alcance funcional | `superficie` + `logica-negocio` (visión general) |
| 3 | Arquitectura funcional | Cómo está organizado el sistema visto desde quien lo opera — no la arquitectura interna | `superficie` (bloques funcionales, no rutas técnicas) |
| 4 | Flujo operativo: [nombre 1] | El flujo completo, incluyendo casos de error y qué hacer en cada uno | `logica-negocio` (flujo 1) + `zonas-oscuras` (comportamientos inesperados) |
| 5 | Flujo operativo: [nombre 2..N] | Ídem por cada flujo relevante para la operación | `logica-negocio` + `zonas-oscuras` |
| 6 | Integraciones: qué puede fallar | Cada integración externa, qué hace el sistema cuando falla, y cómo se detecta | `integraciones` |
| 7 | Runbook y procedimientos | Procedimientos ante fallos comunes, escalamiento, recuperación | Bloque `operacion` — **obligatorio**; si no existe, sección bloqueada |
| 8 | Referencia técnica de apoyo | Tablas de estados, códigos de error, campos relevantes | `logica-negocio` + `modelo-datos` |
| 9 | Glosario | Términos del sistema y del negocio que usa este documento | `logica-negocio` (nomenclatura del corpus) |

**Bloqueante:** sin el bloque `operacion` (captura operativa), la sección §7 queda bloqueada
y el material de capacitación es incompleto para quien dará soporte. El responsable es la
skill de captura operativa (entrevista) — no se improvisa un runbook desde el código.

---

## 3. Documentación de PM

Audiencia: gestión de producto, dirección, stakeholders internos que deciden prioridades.
Interesa el estado y los riesgos, no la mecánica. Uso interno.

| # | Sección | Contenido | Fuente de corpus |
|---|---|---|---|
| 1 | Portada | Nombre del proyecto, fecha, versión del corpus | Q4 (branding) + ancla del corpus |
| 2 | Estado actual del sistema | Qué está resuelto, qué está a medias, qué falta | `superficie` + `zonas-oscuras` (estado) |
| 3 | Capacidades actuales | Qué puede hacer el sistema hoy, en términos de negocio | `logica-negocio` (flujos principales, sin detalle técnico) |
| 4 | Deuda declarada y zonas oscuras | Código muerto, duplicidades, comportamientos no declarados | `zonas-oscuras` — **obligatorio** |
| 5 | Riesgos abiertos | Hallazgos de riesgo con severidad y estado | Bloque `riesgo` (`project-audit`) — **obligatorio**; si no existe, sección bloqueada |
| 6 | Coste operativo | Qué necesita atención operativa, con qué frecuencia | Bloque `operacion` — **obligatorio**; si no existe, sección bloqueada |
| 7 | Pendientes con responsable | Qué falta, quién lo produce, cuándo es urgente | Preguntas abiertas (P-n) del proyecto + bloques faltantes del corpus |
| 8 | Integraciones críticas | Qué sistemas externos depende el producto y cuál es el riesgo | `integraciones` |

**Nota:** esta es la proyección que más necesita los bloques que `documentation-master` no
produce sola (`riesgo` de `project-audit`, `operacion` de la captura operativa). Declararlos
bloqueados en Q2 es parte del valor de la skill — un PM que recibe esto sabe qué falta y
quién lo produce.

---

## 4. Handover técnico

Audiencia: desarrollador o equipo que recibe el sistema. Nivel técnico completo, incluyendo
trampas y zonas oscuras. Uso interno.

| # | Sección | Contenido | Fuente de corpus |
|---|---|---|---|
| 1 | Portada | Nombre del sistema, versión, fecha, quién entrega y a quién | Q4 (branding) + datos del usuario |
| 2 | Arquitectura y stack | Componentes, capas, tecnologías, decisiones relevantes | `superficie` + `logica-negocio` (arquitectura) |
| 3 | Modelo de datos | Entidades, relaciones, esquema declarado vs. esquema real | `modelo-datos` — **obligatorio** |
| 4 | Flujos y lógica de negocio | Los flujos críticos con su lógica completa, condiciones y efectos secundarios | `logica-negocio` — **obligatorio** |
| 5 | Reglas implícitas | `catch` mudos, valores por defecto, retornos tempranos, comportamientos no declarados | `logica-negocio` (reglas implícitas) + `zonas-oscuras` |
| 6 | Integraciones y contratos reales | APIs, colas, webhooks — con el comportamiento real ante fallo | `integraciones` — **obligatorio** |
| 7 | Zonas oscuras y trampas conocidas | Código muerto, duplicidades, contradicciones, `NO DETERMINADO` | `zonas-oscuras` — **obligatorio** |
| 8 | Setup y configuración | Variables de entorno, secretos referenciados (nunca valores), dependencias | `integraciones` + `superficie` |
| 9 | Pendientes y prioridad | Qué falta, con su P-n y su bloque de corpus si aplica | P-n del proyecto + borradores |
| 10 | Glosario técnico | Nombres de entidades, handlers, servicios tal como los usa el código | `logica-negocio` + `modelo-datos` (nomenclatura) |

**Nota:** esta es la proyección más fiel al corpus crudo. Las entradas con procedencia
`entrevista` se marcan explícitamente — quien recibe el sistema necesita saber qué está
demostrado en código y qué fue declarado por una persona.

---

## 5. Presentación a cliente

Audiencia: cliente externo, dirección, evaluadores. Nivel de detalle bajo, capacidades y
flujos de alto nivel. Solo entradas con `visibilidad = externa`.

| # | Sección | Contenido | Fuente de corpus |
|---|---|---|---|
| 1 | Portada | Nombre del proyecto o producto, fecha, logo si hay | Q4 (branding) + datos del usuario |
| 2 | El problema que resuelve | En lenguaje de negocio, sin jerga técnica | Declaración del usuario + `logica-negocio` (propósito, `visibilidad = externa`) |
| 3 | Capacidades principales | Qué puede hacer el sistema, en términos del cliente | `superficie` + `logica-negocio` (flujos principales, `visibilidad = externa`) |
| 4 | Cómo funciona (alto nivel) | Flujo de usuario o de negocio, sin arquitectura interna | `logica-negocio` (flujos de interfaz o de negocio, `visibilidad = externa`) |
| 5 | Estado y próximos pasos | Qué está entregado, qué viene | Declaración del usuario · P-n de producto si aplica |
| 6 | Cierre | Datos de contacto, próxima acción | Declaración del usuario |

**Nota:** es la proyección con menor dependencia del corpus — en muchos casos la fuente
principal es la declaración del usuario. Si el corpus tiene entradas relevantes con
`visibilidad = externa`, se usan; si no, la sección se genera desde el insumo del usuario
declarándolo como `entrevista`.

---

## 6. Aval de desempeño

Audiencia: evaluadores internos o externos que juzgan la contribución técnica de una persona
o equipo. Énfasis en evidencia, no en narrativa. Uso interno; exigencia de respaldo alta.

| # | Sección | Contenido | Fuente de corpus |
|---|---|---|---|
| 1 | Portada | Nombre del evaluado, periodo, fecha, evaluador | Datos del usuario |
| 2 | Ámbito del aval | Qué partes del sistema corresponden al evaluado, en qué periodo | Declaración del usuario + `trayectoria` (commits, PRs, incidentes) |
| 3 | Contribuciones con evidencia | Qué se implementó o decidió, con su evidencia de corpus | `logica-negocio` + `trayectoria` — **obligatorio** |
| 4 | Trayectoria de cambios | Evolución del sistema en el periodo: qué cambió, cuándo, a raíz de qué | Bloque `trayectoria` (`git-workflow`) — **obligatorio**; si no existe, sección bloqueada |
| 5 | Criterios cumplidos | Qué objetivos se declararon y qué evidencia los respalda | Declaración del usuario + evidencia de corpus |
| 6 | Limitaciones y pendientes | Qué quedó sin completar y por qué | P-n del proyecto + borradores |

**Bloqueante:** sin el bloque `trayectoria` (alimentado por `git-workflow`), esta proyección
queda bloqueada. No se reconstruye la historia leyendo el estado actual del corpus — eso
produce una descripción del presente, no un registro de lo que cambió y cuándo.
