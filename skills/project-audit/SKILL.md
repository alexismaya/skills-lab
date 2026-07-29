---
name: project-audit
description: "Auditoría de un proyecto de software EXISTENTE para detectar debilidades, deuda técnica y áreas de mejora, evaluándolo contra 4 pilares: seguridad, escalabilidad, rendimiento y mantenibilidad. Cada hallazgo se sustenta con evidencia file:line, severidad e impacto; el propósito final es servir de insumo para rehacer el proyecto con la mejor arquitectura posible. Usar esta skill SIEMPRE que el usuario quiera: 'auditar' o hacer una 'auditoría' de un proyecto/repo/API/app; saber 'qué tan mal está' algo, 'dónde está la deuda técnica', 'qué debilidades' o 'riesgos' tiene; evaluar seguridad, escalabilidad, rendimiento o mantenibilidad de una base existente; o preparar el diagnóstico previo para 'rehacer esto bien' / 'rehacer con mejor arquitectura'. NO usar para: crear un proyecto nuevo a partir de otro (esa es derivar-proyecto), planear o generar tests (qa-discovery / qa-generator), implementar features o arreglar un bug, ni optimizar/mejorar/endurecer directamente un componente aunque se mencione un pilar (p. ej. 'optimiza el rendimiento de este endpoint' o 'endurece la seguridad de este login' → eso es implementación, sdd-harness-notion) — esta skill solo diagnostica, no modifica código."
---

# Auditoría de proyectos (4 pilares)

Disciplina para auditar un proyecto de software existente y producir un diagnóstico
honesto de sus debilidades, deuda técnica y áreas de mejora, evaluado contra cuatro
pilares — **seguridad, escalabilidad, rendimiento y mantenibilidad** — donde **cada
hallazgo cruza al reporte solo con evidencia `file:line` verificable, severidad e
impacto declarados**. El propósito final no es el reporte en sí, sino alimentar la
decisión de **rehacer el proyecto con la mejor arquitectura posible**: la auditoría
es el insumo de la clasificación `heredable / no heredable / muerto` de `derivar-proyecto`.

Principio rector: **un hallazgo sin evidencia no es un hallazgo.** La pregunta nunca es
"¿qué creo que está mal?" sino "¿qué puedo demostrar contra el código, y con qué impacto?".

Esta skill **audita, no remedia**: no toca el código del proyecto auditado en ninguna fase.

## Regla cero (compartida con la suite SDD)

No asumir nada; nunca ejecutar sin propuesta aprobada. Toda duda se registra como **P-n
en Notion** y el trabajo dependiente no avanza hasta que el usuario la responda — o hasta
que el modelo encuentre la respuesta en el contexto y **el usuario la confirme**. Cada fase
se propone y se aprueba ANTES de ejecutarse: el usuario aprueba el alcance del reconocimiento
antes de leer, y el entregable de cada fase antes de pasar a la siguiente.

## Entrevista de arranque (obligatoria antes de auditar nada)

Revisar primero el contexto disponible (conversación, memoria, Notion, repos accesibles):
lo ya sabido se confirma, no se pregunta. Ningún análisis inicia sin completar la entrevista.

**Q1 — Qué se audita y dónde está el código.** Proyecto, repositorio o ruta accesible,
rama o commit de referencia. Sin acceso verificable al código no hay auditoría: todo
hallazgo exige `file:line`, y sin fuente no hay evidencia.

**Q2 — Estado en Notion.** ¿Existe ya página/hub del proyecto en Notion o se crea desde
cero? Si existe, la skill se adapta a esa estructura (agrega lo que falte, no reorganiza).
Verificar que el hub raíz viva en una sección compartida con ambas integraciones (ver
contrato de interoperabilidad).

**Q3 — Alcance de la auditoría.** ¿Integral (los 4 pilares) o enfocada en un subconjunto
(p. ej. solo seguridad y rendimiento)? El alcance define qué análisis de la Fase 1 se
ejecutan; lo excluido se declara explícitamente como "fuera de alcance de esta auditoría".

**Q4 — Destino del diagnóstico.** ¿El objetivo es **rehacer** el proyecto (el reporte
compone con `derivar-proyecto` y su matriz de herencia) o **remediar** sobre el existente
(el reporte se convierte en plan de remediación por etapas vía `sdd-harness-notion`)? La
respuesta define el formato del handoff de la Fase 3. Si el usuario no lo sabe aún, se
registra como P-n y la Fase 3 no se cierra hasta resolverlo.

**Q5 — Restricciones conocidas.** Stack obligatorio, infraestructura o base de datos
compartida con otros sistemas, requisitos de compliance (normativa sectorial aplicable, o
cualquier régimen que cubra datos personales, medios de pago o historiales sensibles), o
límites que la arquitectura objetivo deba respetar. Calibran la severidad de los hallazgos
y las opciones de la propuesta arquitectónica.

Con las respuestas, producir la **propuesta de auditoría**: alcance por pilar, estructura
de Notion a crear, Ps detectadas y fases tentativas. Iterar hasta aprobación.

## Los cuatro pilares (criterios de evaluación)

Cada pilar se evalúa con criterios concretos y verificables contra el código real. La lista
es agnóstica de stack: se aplican los que apliquen al proyecto, y los inaplicables se
declaran como tal (no se inventa un hallazgo para llenar una casilla). La rúbrica de
severidad por pilar vive en `references/rubrica-severidad.md`.

### 1. Seguridad
- **Manejo de secretos** — secretos hardcodeados, `.env` real versionado, credenciales en
  el historial git, tokens en logs o en código cliente.
- **Validación de entrada** — endpoints/handlers que consumen entrada sin validar; vectores
  de inyección (SQL/command/XSS) por concatenación en lugar de consultas parametrizadas o
  escape.
- **Autenticación / autorización** — rutas sensibles sin middleware de auth; checks de
  autorización ausentes o inconsistentes; IDOR (acceso a recursos por id sin verificar
  pertenencia); escalada de privilegios.
- **Dependencias con CVEs** — dependencias con vulnerabilidades conocidas según el lockfile;
  versiones sin soporte; ausencia de mecanismo de actualización.
- **Exposición** — CORS permisivo, endpoints internos expuestos, mensajes de error que
  filtran stack traces o datos, PII en logs.

### 2. Escalabilidad
- **Cuellos arquitectónicos** — estado en memoria del proceso que impide escalar
  horizontalmente (sesiones locales, cachés en proceso, singletons con estado); punto único
  de contención.
- **Acoplamiento** — módulos que no pueden desplegarse o escalar de forma independiente;
  dependencias circulares; "god objects"/servicios que concentran responsabilidades.
- **Capacidad de crecer** — ¿los servicios son stateless? ¿los jobs son idempotentes y
  reintentables? ¿hay límites de conexión a BD o pools mal dimensionados que topan bajo carga?
- **Límites de diseño** — paginación ausente en colecciones que crecen; cargas ilimitadas
  en memoria; procesamiento síncrono de trabajo que debería ser asíncrono/encolado.

### 3. Rendimiento
- **Queries ineficientes** — N+1, `SELECT *` innecesarios, queries dentro de loops, ausencia
  de índices en columnas usadas para filtrar/ordenar/unir.
- **Uso de memoria** — cargar colecciones completas cuando bastaría streaming/cursor; fugas
  por referencias retenidas; buffers sin límite.
- **Latencia** — llamadas externas síncronas en el camino crítico; ausencia de timeouts y
  circuit breakers; trabajo pesado en el hilo de request.
- **Caché** — ausencia de caché donde el patrón de acceso lo justifica; cálculos o llamadas
  repetidos que podrían memoizarse; invalidación de caché inexistente o incorrecta.

### 4. Mantenibilidad
- **Deuda técnica** — `TODO`/`FIXME`/`HACK` sin ticket; workarounds documentados; parches
  sobre parches.
- **Código muerto** — rutas, funciones, archivos o dependencias sin referencias vivas.
- **Complejidad** — funciones/clases desproporcionadamente largas, anidamiento profundo,
  duplicación, complejidad ciclomática alta.
- **Tests** — ausencia o escasez de tests; ratio pobre frente a superficie crítica; sin CI
  que los ejecute. (Para un plan de pruebas detallado, el handoff apunta a `qa-discovery`;
  aquí solo se reporta el hueco como deuda.)
- **Documentación** — README/setup/arquitectura ausentes o desactualizados; conocimiento
  solo en la cabeza del autor.
- **Consistencia de patrones** — mezcla de estilos/paradigmas, convenciones incoherentes,
  múltiples formas de hacer lo mismo.

## Regla de evidencia (no negociable)

- Todo hallazgo lleva **evidencia `file:line` verificable** contra el código auditado.
- Un hallazgo sin evidencia `file:line` se **descarta** o se marca explícitamente como
  **`hipótesis a validar`**, indicando qué haría falta para confirmarlo. Nunca se presenta
  una hipótesis como hecho.
- Cada hallazgo declara **pilar**, **severidad** (crítica / alta / media / baja según la
  rúbrica) e **impacto** concreto (qué se rompe, para quién, bajo qué condición).
- La evidencia es un artefacto (la ruta y la línea que lo demuestran), no un checkbox.

## Fases de la auditoría (con gate por fase)

Cada fase produce un entregable en Notion y no avanza sin gate de aprobación del usuario.

**Fase 0 — Reconocimiento (solo lectura).** Inventario del proyecto: stack y versiones,
estructura de directorios y capas, dependencias (con su lockfile), puntos de entrada
(rutas, comandos, jobs, workers), infraestructura declarada (docker, CI/CD), y presencia
de tests. Cero juicios todavía: se registra lo que hay, no lo que está mal.
- **Entregable:** página **Snapshot de reconocimiento** en el hub de Auditoría.
- **Gate:** el usuario confirma que el inventario refleja el proyecto antes de auditar.

**Fase 1 — Auditoría por pilar (cero modificaciones de código).** Un análisis por cada
pilar dentro del alcance (Q3). Cada hallazgo con `file:line`, pilar, severidad e impacto;
los no verificables como `hipótesis a validar`. Solo análisis: no se toca ni una línea del
proyecto auditado.
- **Entregable:** página **Auditoría por pilar** (una sección por pilar) alimentando la
  matriz de hallazgos.
- **Gate:** el usuario revisa los hallazgos por pilar antes de la síntesis.

**Fase 2 — Síntesis y propuesta.** Matriz de hallazgos consolidada (ordenada por
severidad/impacto) y **trade-offs entre pilares explícitos** (p. ej. una caché que mejora
rendimiento pero añade superficie de invalidación/consistencia). La segunda mitad tiene dos
variantes según Q4, espejo de la Fase 3:
- **Destino "rehacer" →** **propuesta de arquitectura objetivo** con justificación pilar por
  pilar de cómo la nueva forma resuelve o mitiga los hallazgos.
- **Destino "remediar" →** **estado objetivo dentro de la arquitectura actual**: qué debe
  quedar corregido y con qué prioridad, sin proponer una rearquitectura completa — se
  respeta la forma existente y se enfoca en cerrar los hallazgos.
- **Entregable:** página **Síntesis + propuesta** con la matriz consolidada y la variante
  que corresponda.
- **Gate:** el usuario aprueba la propuesta antes del handoff.

**Fase 3 — Handoff.** Según Q4:
- **Rehacer →** reporte con **clasificación por componente en la taxonomía `heredable /
  no heredable / muerto`**, directamente consumible por `derivar-proyecto` para poblar su
  matriz de herencia. La taxonomía es la de `derivar-proyecto` (fuente de verdad); esta
  skill la emite como handoff, no la redefine.
- **Remediar →** plan de remediación por etapas priorizadas (por severidad e impacto),
  entregable a `sdd-harness-notion` como fases/etapas con criterios de aceptación.
- **Entregable:** página **Reporte de handoff** en el hub de Auditoría.
- **Gate:** el usuario confirma el destino y la completitud del reporte.

## Composición con otras skills

- **`derivar-proyecto`** — es el consumidor natural del handoff "rehacer": su entrevista Q3
  (confiabilidad del origen) se satisface con esta auditoría, y su matriz de herencia se
  puebla con la clasificación de la Fase 3. Un componente marcado `muerto` aquí es residuo
  a no arrastrar allá.
- **`sdd-harness-notion`** — consumidor del handoff "remediar": las etapas priorizadas se
  ejecutan como fases con gates.
- **`qa-discovery`** — cuando un hallazgo de mantenibilidad es "ausencia de tests", el
  handoff señala la superficie a `qa-discovery`; esta skill no planea ni genera tests.
- La comunicación es por **artefactos de Notion** (handoffs, tabla de Ps, gates), nunca
  leyendo los archivos de otra skill.

## Antipatrones de auditoría (evitar al auditar)

1. **Hallazgo sin evidencia** — afirmar un problema sin `file:line`; si no se puede
   demostrar, es hipótesis, no hallazgo.
2. **Severidad inflada** — marcar todo "crítico" vacía la palabra; la severidad se calibra
   contra la rúbrica y el impacto real en el contexto del proyecto.
3. **Auditar y arreglar** — tocar el código "de paso"; esta skill diagnostica, la remediación
   es de otra skill y otra fase.
4. **Pilares en silos** — reportar hallazgos sin exponer los trade-offs entre pilares
   (la Fase 2 existe para esto).
5. **Reporte no accionable** — un handoff que `derivar-proyecto` o `sdd-harness-notion` no
   puede consumir directamente rompe la composición; el formato de salida es parte del
   entregable, no un extra.
6. **Sesgo de stack** — asumir problemas de un framework que no se verificaron en este
   código; los criterios se aplican contra la evidencia real, no contra prejuicios.

## Notion y aprendizaje

Misma operación que el resto de la suite: hub del proyecto → hub **Auditoría** → páginas de
la skill (Snapshot, Auditoría por pilar, Síntesis + propuesta, Reporte de handoff); Ps con
su gate en la tabla única del proyecto; ediciones quirúrgicas, nunca reescritura de páginas
compartidas. Al cierre de cada gate, ofrecer registrar lecciones en la página **"Lecciones
SDD"** del usuario — en particular: qué hallazgo resultó ser hipótesis sin fundamento, qué
severidad se calibró mal, qué pregunta de la entrevista faltó.

## Lo que esta skill NO hace

- No modifica el código del proyecto auditado (no remedia, no refactoriza, no "arregla de paso").
- No crea el proyecto nuevo ni puebla la matriz de herencia (eso es `derivar-proyecto`).
- No planea ni genera tests (eso es `qa-discovery` / `qa-generator`).
- No implementa features ni corrige bugs (eso es `sdd-harness-notion`).
- No inventa hallazgos para llenar un pilar ni presenta hipótesis como hechos.

## Recursos de la skill

- `references/rubrica-severidad.md` — rúbrica de severidad (crítica / alta / media / baja)
  con criterios por pilar y definición de impacto, para calibrar los hallazgos de forma
  consistente y no arbitraria. Leer al asignar severidad en la Fase 1.
- `references/plantillas-auditoria.md` — plantillas de los entregables: snapshot de
  reconocimiento, ficha de hallazgo (`file:line`, pilar, severidad, impacto, flag de
  hipótesis), matriz de hallazgos consolidada, plantilla de trade-offs entre pilares, y el
  reporte de handoff con la tabla de clasificación `heredable / no heredable / muerto`
  consumible por `derivar-proyecto`. Leer al redactar cualquiera de estos artefactos.
- `references/interop-notion.md` — contrato de interoperabilidad con las demás skills de la
  suite sobre el mismo proyecto: estructura canónica del hub (el hub **Auditoría** es una
  página propia enlazada desde el hub raíz), tabla única de Ps compartida, ownership de
  páginas, handoffs como interfaz, gates cruzados, equivalencias por runtime. Leer SIEMPRE
  que el proyecto involucre (o vaya a involucrar) más de una skill de la suite.
