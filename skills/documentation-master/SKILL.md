---
name: documentation-master
description: "Extrae por etapas la lógica real de un proyecto existente con evidencia file:línea y la consolida en Notion como corpus persistente y versionado, listo para proyectarse a manuales, capacitación, documentación de PM, presentaciones o entregables. Usar SIEMPRE que se pida entender qué hace realmente un sistema, levantar la lógica de negocio de un repo o de un flujo, documentar a fondo un proyecto heredado, saber qué parte de lo ya documentado dejó de ser cierta tras nuevos commits, o preparar la base de conocimiento antes de generar cualquier documento; también ante menciones de 'sin inventar', 'levantamiento funcional', 'qué hace exactamente este código', 'ingeniería inversa del negocio', 'actualizar el corpus' o 'documentar el proyecto a fondo'. Aplica igual cuando el alcance es un solo módulo, handler o función, siempre que lo que se pida sea certeza con evidencia verificable —poder señalar la línea— y no una explicación rápida. NO usar para un panorama rápido del repo (eso es project-onboarding), evaluar calidad contra pilares (project-audit), ni para generar el PPTX o el DOCX (project-deck / project-doc): esta skill no produce ningún archivo de salida, solo el corpus del que esos entregables se proyectan."
---

# Levantamiento de lógica real (corpus en Notion)

Disciplina para analizar por etapas un proyecto de software existente, extraer la lógica
que **realmente** ejecuta —no la que debería ejecutar— con evidencia verificable, y
consolidarla en Notion como un **corpus estructurado y versionado** que funciona como
contexto persistente del proyecto.

Principio rector: **el entregable no es un documento, es el corpus.** Un documento sirve a
una audiencia y envejece con ella; el corpus sirve a todas y declara qué parte de sí mismo
dejó de ser cierta. De ahí la segunda mitad del principio: **una afirmación sin respaldo no
entra al corpus** — ni siquiera cuando es plausible, ni siquiera cuando el modelo la dedujo
bien.

La separación entre **extraer** y **redactar** es deliberada. Un mismo sistema se cuenta
distinto a un usuario final, a un equipo de capacitación, a un PM y a un cliente. Si la
extracción cargara con el tono y el índice de cada audiencia, cada audiencia nueva obligaría
a tocar la lógica de extracción. Aquí se extrae una vez y se proyecta muchas.

## Lo que produce y lo que no

**Produce:** entradas atómicas de corpus en Notion, cada una con procedencia y respaldo; el
ancla de código con la que se capturaron; las preguntas abiertas que bloquean; y el reporte
de **cobertura por proyección** — qué audiencias puede alimentar completas y cuáles tienen
bloques faltantes, nombrando quién debería producirlos.

**No produce, por diseño:** ningún archivo (`.docx`, `.pptx`, o un `.md` de entregable), ni
prosa redactada, ni índices, ni tono por audiencia, ni plantillas o carpetas de entregables.
Si el usuario pide un documento, ver §Handoff a renderizadores: primero corpus, después
proyección.

## Cuándo NO es esta skill

El nombre es amplio y compite por activación. Antes de arrancar, descartar estos casos:

| Lo que el usuario quiere | Skill correcta |
|---|---|
| Panorama del repo: qué hay, cómo se ve, árbol, stack, diagramas | `project-onboarding` |
| Evaluar calidad o riesgo contra los 4 pilares | `project-audit` |
| El documento o la presentación ya renderizados | `project-doc` (`.docx`) / `project-deck` (`.pptx`) |
| Escribir o ejecutar pruebas del sistema | `qa-discovery` (qué probar) / `qa-generator` (las suites) |
| Construir, implementar o remediar algo | `sdd-harness-notion` |
| Partir de un proyecto para crear otro | `derivar-proyecto` |
| Anotar el código en el código: docstring, comentario, README de un módulo | el agente de código, directamente |

El conocimiento operativo —cómo se levanta, qué ambientes hay, a quién se escala— **sí es de
esta skill**, pero por una vía distinta: se pregunta, no se extrae (§Captura operativa). La
frontera no es de tema, es de método.

La frontera práctica con `project-onboarding`: **onboarding responde *qué hay y cómo se
ve*; esta skill responde *qué hace exactamente y bajo qué condiciones*.** Si la pregunta se
contesta mirando el árbol de directorios, es onboarding. Si exige seguir una decisión hasta
su rama menos obvia, es esta.

La otra frontera, la que se confunde por tamaño y no por profundidad: **un alcance de un solo
archivo sigue siendo esta skill si lo que se pide es certeza con evidencia** —poder señalar la
línea—; es del agente de código si lo que se pide es una explicación rápida o un comentario en
el archivo. El tamaño decide el camino (§Camino corto), no la skill.

**Derivar es un acto concreto, no una disculpa.** Se nombra la skill que corresponde, se dice
qué produce y qué necesita de entrada, y ahí termina: esta skill no invoca a la otra ni hace
"una versión provisional" de su trabajo mientras tanto.

## Regla cero (gobierna todo lo demás)

**No asumir nada. Nada se escribe en Notion sin propuesta aprobada.** Toda duda se registra
como **P-n en la tabla única del proyecto** y **bloquea el avance** del trabajo que depende
de ella. Si el modelo deduce la respuesta del contexto, la presenta como deducción y espera
confirmación antes de escribirla: una deducción confirmada es procedencia `entrevista`; una
deducción no confirmada no es nada.

## Las cuatro reglas no negociables

### R1 — Cero invención

Toda afirmación sobre el comportamiento lleva evidencia `ruta/archivo.ext:línea`. Lo que no
se pueda demostrar así se escribe literalmente **`NO DETERMINADO`** con su motivo —código
muerto, dependencia externa, configuración fuera del repo, lógica en base de datos—, nunca
con la suposición plausible. La *intención* solo se describe si tiene fuente: un comentario,
documentación del repo, o confirmación del usuario.

El modo de fallo a vigilar no es inventar de la nada, es **completar el patrón**
(§Antipatrones).

### R2 — Nada se ejecuta sin aprobación

Se propone el plan de etapas y se espera aprobación explícita. Cada etapa cierra con un
**gate revisable** antes de pasar a la siguiente. Un gate no es un aviso de progreso: es el
punto donde el usuario puede corregir una lectura errada antes de que contamine las etapas
que la usan como base.

### R3 — Frontera con `project-onboarding`

Si ya existe entrada de `project-onboarding`, **no se reconstruye el inventario**: se
consume, se **valida su vigencia** contra el estado actual del repo, y las desviaciones se
**reportan sin reescribir** la página de onboarding — es ownership ajeno. La desviación se
registra como entrada de corpus y como P-n; corregir la página de onboarding es decisión del
usuario, ejecutada por su skill.

Si no existe, ofrecer dos caminos y dejar elegir: correr `project-onboarding` antes, o
levantar aquí un **inventario mínimo declarado como parcial** (suficiente para anclar el
análisis, explícitamente no equivalente a un onboarding).

### R4 — Procedencia explícita

El corpus mezcla conocimiento de orígenes distintos, y esa mezcla es su valor. Por eso
**toda entrada declara su procedencia**, sin excepción:

| Procedencia | Requisito de respaldo |
|---|---|
| `codigo` | Evidencia `archivo:línea` + el ancla de código con la que se capturó |
| `entrevista` | Quién lo afirmó y cuándo |
| `auditoria` | Hallazgo de origen en `project-audit` |
| `historial` | Referencia de commit, PR o incidente |

Consecuencia que se equivoca con facilidad: **un dato de runbook obtenido en entrevista no es
`NO DETERMINADO`** — es procedencia `entrevista` con su respaldo. Confundirlos hace que el
corpus parezca más débil de lo que es. El error simétrico —anotar como hecho de código algo
que dijo el usuario— lo hace parecer más fuerte. Los renderizadores deciden cómo tratar cada
procedencia (un manual de usuario puede aceptar `entrevista`; un aval de desempeño quizá
no); esta skill solo garantiza que esté marcada.

## Entrevista de arranque (bloqueante)

Revisar primero el contexto disponible —conversación, memoria, Notion accesible, repos— y
**confirmar** lo que ya se sabe en vez de preguntarlo. Ningún análisis inicia sin cerrar la
entrevista: cada respuesta cambia el plan de etapas, no solo su presentación. Si el alcance
parece puntual, ver §Camino corto antes de formular las seis: se encoge el proceso, nunca la
disciplina.

**Q1 — Alcance.** ¿Un repo, un ecosistema multi-repo, o un flujo crítico que cruza varios
repos? **No hay default.** Es la pregunta que determina la forma del plan (§Plan de etapas),
y asumirla mal produce un análisis que no sirve para lo que se pidió.

**Q2 — Qué existe ya.** ¿Hay entrada de `project-onboarding`? ¿De `project-audit`? ¿Existe
página del proyecto en Notion (pedir URL) o se crea? Si existe, leerla antes de proponer
nada. Verificar que el hub raíz viva en una sección compartida con las integraciones que van
a operar (ver contrato de interoperabilidad).

**Q3 — Proyecciones previstas.** ¿Para qué audiencias se va a usar este corpus? Determina la
**cobertura mínima**, no el tono: si se prevé un manual de usuario, el corpus necesita los
flujos vistos desde la interfaz; si se prevé capacitación o **handover técnico**, necesita el
bloque `operacion`, que no se extrae del código y exige una entrevista con quien opera el
sistema (§Captura operativa) — se agenda desde el arranque o se declara faltante desde el
arranque, nunca se descubre al final. Los bloques que dependen de otra skill (`riesgo`,
`trayectoria`, `pruebas`) se declaran faltantes aquí con su responsable. Ver
`references/proyecciones.md`.

**Q4 — Profundidad.** Tres niveles, no dos: **mapa de superficie** (qué puntos de entrada
existen y quién los atiende), **contrato de invocación** (además, qué recibe cada uno, qué
devuelve y con qué errores falla) o **lógica decisión a decisión** de los flujos críticos. El
tercero es varios órdenes de magnitud más caro; conviene que el usuario elija sabiéndolo, y
que se aplique solo a los flujos que lo ameriten. **El segundo no es opcional si Q3 previó
handover técnico o capacitación**: quien recibe un sistema necesita poder invocarlo, y una
firma sin su contrato no alcanza para eso (`references/extraccion.md` §2).

**Q5 — Qué queda explícitamente fuera de alcance.** Lo excluido se declara en el corpus como
exclusión, no como hueco: un lector futuro debe poder distinguir "no se analizó por decisión"
de "no se pudo determinar".

**Q6 — ¿Análisis nuevo o re-ejecución?** Si hay corpus previo, el trabajo es incremental y
cambia por completo (ver `references/incremental.md`).

Con las respuestas, producir la **propuesta**: forma del plan, etapas con su bloque y su
perfil de ejecutor, estructura a crear en Notion, Ps ya detectadas, y cobertura esperada por
proyección. Iterar hasta aprobación (R2).

## Plan de etapas — derivado del alcance, no fijo

No existe una lista de etapas por defecto. El plan se **deriva** de Q1:

- **Un repo** → etapas secuenciales por bloque sobre el mismo árbol.
- **Multi-repo** → una pasada de extracción por repo, más una **etapa final de integración**
  que reconcilia los contratos *reales* entre repos y reporta las incompatibilidades
  **observadas**, no las teóricamente posibles. Que dos repos declaren el mismo campo no
  significa que lo llenen igual; eso se demuestra con evidencia de ambos lados o se marca
  `NO DETERMINADO`.
- **Flujo transversal** → etapas por tramo, siguiendo la traza de ejecución y cruzando repos
  donde el flujo los cruce. **Lo que el flujo no toca queda fuera aunque viva en el repo**:
  el alcance es la traza, no el árbol.

Cada etapa, sea cual sea la forma, produce lo mismo: **hallazgos + evidencia + preguntas
abiertas + gate**.

### Camino corto

Para alcance puntual —uno o pocos archivos, un módulo aislado, sin proyecciones previstas—
el proceso completo cuesta el doble y no compra ni una afirmación más. En ese caso:
entrevista reducida a **alcance y destino**, sin plan de etapas, sin gates intermedios, sin
reporte de cobertura; se escribe directo al corpus.

Lo que **no** se relaja nunca, porque es lo que separa a esta skill de una lectura atenta:
evidencia `archivo:línea`, **procedencia declarada** (R4) y `NO DETERMINADO` con su motivo en
lugar de la suposición plausible. La regla cero y §Lo que esta skill NO hace siguen rigiendo
igual: las dudas se registran como P-n y no se produce ningún archivo.

**No aplica** si el alcance es multi-repo, si hay proyecciones previstas, o si el resultado
va a alimentar un entregable. Ante la duda, camino largo.

Y el camino corto se **propone**: la skill lo ofrece con su motivo y espera confirmación,
nunca lo asume. Un atajo tomado por cuenta propia no es calibración del esfuerzo — es una
puerta trasera a los gates.

### Atomización y perfil de ejecutor

Cada etapa se escribe en Notion para poder ejecutarse en un **chat independiente**: su página
lleva el contexto vinculante que un chat nuevo necesita (alcance del tramo, archivos y ancla,
qué cuenta como evidencia, dónde escribir el resultado, qué no tocar). Un handoff pobre
obliga a releer el repo entero y anula la atomización.

Cada etapa declara además el **perfil de ejecutor** que requiere —frontier, intermedio o de
bajo coste— para que el trabajo caro se gaste donde hay juicio y no donde hay transcripción.
Los criterios por bloque están en `references/extraccion.md`.

Si una etapa no cabe en un contexto acotado, **se divide; no se degrada**. Bajar la
profundidad para que quepa produce un corpus que parece completo y no lo está — el modo de
fallo más caro de esta skill, porque no deja rastro.

## Bloques de extracción

| Bloque | Qué extrae |
|---|---|
| Superficie | Rutas, endpoints, comandos, jobs, eventos: firma real y handler que los atiende; a profundidad de contrato (Q4), además qué recibe, qué devuelve y con qué errores falla |
| Modelo de datos | Entidades, relaciones, migraciones vigentes vs. huérfanas; esquema declarado vs. esquema realmente usado |
| Lógica de negocio | Secuencia real de decisiones, validaciones, efectos secundarios, estados; y las **reglas implícitas**: retornos tempranos, `catch` mudos, valores por defecto silenciosos |
| Integraciones | APIs consumidas y expuestas, colas, webhooks, credenciales **referenciadas** — nombres de variable, nunca valores |
| Zonas oscuras | Código muerto, duplicidad, `NO DETERMINADO`, y contradicciones entre lo documentado y lo implementado |
| Consolidación | Normalización de todo lo anterior al esquema del corpus |

Estos seis se extraen del código. El corpus tiene además bloques que **no se extraen**:
`operacion` se pregunta (§Captura operativa), y `riesgo`, `trayectoria` y `pruebas` los
aportan otras skills. Existen en el vocabulario para poder declararse vacíos — un bloque que
no existe no se puede reportar como faltante.

Las reglas implícitas son el bloque que justifica la skill: un `catch` vacío es una regla de
negocio —"este fallo se ignora"— que ningún documento del proyecto declara y que la
extracción sí puede demostrar. Técnicas, criterios de evidencia y qué buscar en cada bloque:
`references/extraccion.md`.

## Captura operativa (bloque `operacion`)

Hay una clase de conocimiento que decide si una transferencia sirve y que **no está en el
código**: cómo se levanta el proyecto desde cero, qué ambientes existen y a qué apunta cada
uno, qué accesos hay que pedir y a quién, qué se verifica antes de liberar, quién responde
cuando algo falla. El código no lo dice y nunca lo va a decir.

La reacción natural es declararlo faltante y derivarlo. Es media respuesta: **R4 ya resuelve
el problema.** Un dato operativo obtenido en entrevista no es una suposición ni un
`NO DETERMINADO`; es una entrada de procedencia `entrevista` con su respaldo —quién lo
afirmó y cuándo—, tan legítima como una de `codigo` y distinguible de ella para siempre. Lo
que está prohibido es **deducir** el runbook leyendo el repo, no **registrarlo** cuando
alguien lo declara.

De ahí la regla que gobierna este bloque, y que es la única que lo separa de la invención:

> **Se pregunta o se marca. Nunca se infiere.** Un archivo de configuración por ambiente
> demuestra que el ambiente está previsto, no que exista, ni a qué apunta, ni quién tiene
> acceso. Eso se pregunta. Si nadie lo sabe, es `NO DETERMINADO` con su motivo —y esa
> respuesta también es un hallazgo: un sistema cuyo procedimiento de puesta en marcha nadie
> puede enunciar tiene un solo dueño real, y conviene que quede escrito.

**Cuándo se activa.** Solo si Q3 previó una proyección que exige `operacion` —capacitación,
documentación de PM o handover técnico—. No se corre "por si acaso": es tiempo de una persona
que sabe operar el sistema, y se le pide con una agenda concreta.

**Cómo se ejecuta.** Como una etapa más del plan, con su gate: se propone, se agenda, se
registra por temas y cada respuesta entra al corpus como entrada atómica con su respaldo. No
se convierte en prosa, no se convierte en un runbook redactado — eso es del renderizador. El
guion por temas, qué se pregunta en cada uno, qué nunca se anota (ningún valor de credencial,
ninguna ruta que solo sirva para alcanzar un sistema desde fuera) y cómo se cierra un tema que
nadie puede responder: `references/operacion.md`.

## El corpus

El corpus es una tabla propia de esta skill en Notion, **relacionada** con las entidades que
ya existan del proyecto. Campos mínimos de toda entrada:

| Campo | Para qué |
|---|---|
| `id` | Identificador estable que sobrevive a las re-ejecuciones |
| `bloque` | A qué bloque pertenece (§Bloques, o un bloque aportado por otra skill) |
| `afirmacion` | El hecho, en una frase, sin adjetivos ni intención |
| `procedencia` | `codigo` / `entrevista` / `auditoria` / `historial` (R4) |
| `respaldo` | La evidencia que exige esa procedencia |
| `ancla` | La referencia de código con la que se capturó |
| `estado` | `vigente` / `por revalidar` / `obsoleto` / `nuevo` |
| `entidad` | Relación con el repo, módulo o flujo al que pertenece |
| `visibilidad` | Apto para audiencias externas, o solo interno |

Dos reglas gobiernan la escritura de cada entrada, y ambas existen para que el corpus sea
legible por quien no lo produjo:

1. **El corpus no contiene prosa redactada**, solo afirmaciones atómicas. Una afirmación que
   necesita un párrafo son varias afirmaciones. La prosa es del renderizador.
2. **Una afirmación nunca se borra**: se marca `obsoleto` con el ancla en la que dejó de ser
   cierta. Borrar destruye la única evidencia de que el sistema cambió.

Y una tercera que gobierna la tabla entera: **el corpus es autodescriptivo.** Su cabecera
declara las reglas que lo rigen —vocabulario de procedencia, formato del ancla, estados
posibles y qué significa cada marca— para que un agente que lo lea **sin cargar esta skill**
herede la disciplina. Un corpus que solo se entiende con la skill puesta está mal construido.

El esquema completo —tipos, vocabularios, ejemplos de entrada bien y mal formada, y qué debe
poder hacer un renderizador sin saber cómo se produjo el corpus— vive en
`references/corpus.md`. **Leerlo antes de escribir la primera entrada.** La interfaz mínima
que las demás skills de la suite pueden asumir está en el contrato compartido
`references/interop-notion.md`.

## Notion

El corpus vive bajo el hub del proyecto, en tabla propia de esta skill, **relacionada de
forma unidireccional** con las entidades de otras skills: se apunta hacia ellas sin crear
propiedades recíprocas en sus tablas. Extender por relación, no por mutación — una columna
añadida a una tabla ajena es una modificación de un artefacto que no se posee.

Las preguntas abiertas viven en la **tabla única de Ps del proyecto**, con su numeración
compartida; nunca en el chat. Una duda que solo existe en la conversación desaparece cuando
la conversación termina, y esta skill está diseñada para ejecutarse en varias.

El corpus debe leerse como **contexto persistente**: una sesión nueva, en cualquier chat,
tiene que poder retomar el proyecto leyendo el corpus **sin releer el código**. Esa es la
prueba práctica de si una entrada está bien escrita. Estructura de páginas, ownership,
relaciones y operación: `references/notion.md`.

## Re-análisis incremental

Un corpus sin anclaje no se puede actualizar: solo se puede rehacer. Por eso cada análisis
registra la **referencia de código analizada** (commit, tag, o hash de los archivos tocados),
y toda entrada la conserva.

- **Las evidencias caducan.** Si el archivo cambió desde la captura, la entrada pasa
  automáticamente a `por revalidar`. Nunca se asume vigente porque "el cambio parece
  cosmético".
- **La re-ejecución es selectiva.** La skill calcula qué etapas toca el cambio y propone
  re-correr solo esas, justificando la selección con los archivos modificados. El usuario
  aprueba (R2).
- **Las entradas de procedencia `entrevista` no caducan por cambio de código**, pero se
  marcan para revisión si el bloque que describen cambió sustancialmente.
- Al cambiar el corpus, la skill **reporta qué proyecciones quedaron desactualizadas** para
  que el renderizador correspondiente regenere. No regenera nada por su cuenta.

Mecánica completa: `references/incremental.md`.

## Handoff a renderizadores

Al cerrar, la skill entrega: **corpus consolidado**, **cobertura por proyección**, **lista de
bloques faltantes con su responsable**, y **preguntas abiertas pendientes**.

**Cómo se declara bloqueada una proyección.** Con cuatro datos, siempre los mismos: la
proyección, el estado `bloqueada`, el bloque o bloques que faltan, y **qué la desbloquea**.
Una proyección bloqueada no es un fracaso del análisis; es el resultado correcto cuando el
conocimiento que esa audiencia necesita no vive en el código. Y se declara **en el arranque**
(Q3) en cuanto se sabe, no al final: descubrir en el cierre que la capacitación nunca fue
posible desperdicia el análisis entero.

**Cómo se nombra al responsable de un bloque faltante.** Con un dueño concreto: la skill que
produce ese bloque (`trayectoria` → `git-workflow`; `riesgo` → `project-audit`; `pruebas` →
`qa-discovery` / `qa-generator`). `operacion` es la excepción: su dueño no es una skill, es
**la persona que opera el sistema**, nombrada por su rol, y esta skill le hace la entrevista
(§Captura operativa). Si una skill responsable **no existe o no está disponible** en el
entorno, el responsable vuelve a ser la persona que tiene el conocimiento, nombrada por su
rol. "Falta el bloque
operativo" sin dueño no es un pendiente: es una queja, y nadie la recoge.

**Por qué no se genera el archivo aunque lo pidan.** No es una negativa de proceso: es que un
documento producido sin corpus no se puede revalidar, ni versionar, ni saber qué parte suya
dejó de ser cierta cuando el código cambie — que es exactamente lo que esta skill existe para
evitar. La respuesta correcta es explicar el reparto, ofrecer producir el corpus y decir qué
falta para renderizar. **La insistencia no cambia el reparto**: si el usuario repite la
petición, la skill sostiene la derivación y ofrece lo que sí puede entregar; no redacta "un
borrador mientras tanto" ni deja la prosa del documento en el chat, que es la misma mezcla por
la puerta de atrás.

- `project-deck` (`.pptx`) y `project-doc` (`.docx`) consumen el corpus. Esta skill **no los
  invoca por su cuenta**: entrega y declara qué está completo.
- La **proyección de desempeño** consume el mismo corpus apoyada en el bloque de trayectoria
  (cambios, decisiones, incidentes resueltos) que alimenta `git-workflow`. Esta skill no lo
  produce: lo requiere, y lo declara faltante si no está.

Qué bloques exige cada audiencia y qué pasa cuando falta uno: `references/proyecciones.md`.

## Composición con otras skills

- **`project-onboarding`** — aporta el bloque de superficie. Se consume y se valida, no se
  reescribe (R3).
- **`project-audit`** — aporta el bloque de riesgo y calidad, con procedencia `auditoria`.
  Auditoría juzga; esta skill describe. Un hallazgo de auditoría entra al corpus como lo que
  es: una evaluación con su origen declarado, no un hecho del sistema.
- **`git-workflow`** — aporta el bloque de trayectoria (procedencia `historial`).
- **`qa-discovery` / `qa-generator`** — aportan el bloque `pruebas`: qué superficies están
  cubiertas y con qué suites. Sin ellas el bloque se declara faltante; esta skill no escribe
  tests ni da por cubierto un flujo porque exista un archivo de prueba con su nombre.
- **`project-deck`** y **`project-doc`** — renderizadores; consumidores del corpus.
- **`sdd-harness-notion`** — si el análisis revela trabajo a construir o remediar, el handoff
  va ahí; esta skill no implementa.
- **`derivar-proyecto`** — si el destino es rehacer, el corpus alimenta su matriz de
  herencia; la clasificación `heredable / no heredable / muerto` es de esa skill.

La comunicación es siempre por **artefactos de Notion**, nunca leyendo los archivos de otra
skill.

## Antipatrones

1. **Completar el patrón** — escribir la regla que "obviamente" está, por analogía con las
   que sí se leyeron. Es la forma más común de invención y la más difícil de detectar después.
2. **Narrar intención** — "este módulo se encarga de garantizar que…". El código no dice
   *garantiza*; dice qué hace cuando se cumple una condición. La intención necesita fuente.
3. **`NO DETERMINADO` como cajón de sastre** — usarlo para lo que sí se sabe por entrevista.
   Confunde ausencia de conocimiento con ausencia de código legible (R4).
4. **Corpus con prosa** — se lee mejor una vez, para una audiencia, y bloquea las demás.
5. **Degradar una etapa para que quepa** — bajar la profundidad en vez de dividir produce un
   corpus que parece completo.
6. **Avanzar con Ps abiertas** — si la respuesta llega tarde, invalida todo lo que se apoyó
   en ella.
7. **Reescribir páginas ajenas** — la desviación se reporta; la corrección es de su dueño.
8. **Tomar el camino corto por cuenta propia** — o tomarlo con una proyección prevista
   encima. El atajo se propone y se confirma; si hay destino de entregable, no hay atajo.
9. **Responder la entrevista operativa desde el repo** — reconstruir la puesta en marcha
   leyendo el gestor de dependencias y los archivos de configuración. Produce un
   procedimiento verosímil que nadie ha ejecutado nunca, con procedencia falsificada: parece
   `entrevista` y es deducción. Es la forma que toma el antipatrón 1 en el bloque `operacion`,
   y la más difícil de detectar porque el resultado suele ser casi correcto.

## Lo que esta skill NO hace

- No genera archivos de salida de ningún formato.
- No redacta prosa, índices, ni adapta tono por audiencia.
- No modifica el código analizado ni lo remedia.
- No reescribe las páginas de otras skills ni añade columnas a sus tablas.
- No captura conocimiento que no está en el código sin declararlo como `entrevista`.
- No invoca a los renderizadores ni regenera entregables por su cuenta.

## Recursos de la skill

No hace falta leerlos todos para empezar. El mínimo para extraer y escribir bien es
`corpus.md` + `extraccion.md`; los demás se leen cuando su momento llega. Cargarlos todos por
adelantado gasta el contexto que hace falta para leer el código, que es donde está el trabajo.

- `references/corpus.md` — esquema completo del corpus: campos, tipos, vocabularios de
  procedencia y estado, reglas de escritura, entradas de ejemplo bien y mal formadas, y el
  contrato de lectura para renderizadores. Leer **antes de escribir la primera entrada**.
- `references/extraccion.md` — los seis bloques en detalle: qué buscar, con qué técnica,
  qué cuenta como evidencia suficiente, cómo detectar reglas implícitas, y el perfil de
  ejecutor por bloque. Leer al planear las etapas y al ejecutar cada una.
- `references/notion.md` — estructura de páginas y tablas, relaciones unidireccionales,
  ownership, operación de las Ps y de los gates. Leer antes de crear o editar cualquier página.
- `references/incremental.md` — anclaje, caducidad de evidencias, cálculo de la re-ejecución
  selectiva y efecto sobre las proyecciones. Leer cuando Q6 sea "re-ejecución".
- `references/operacion.md` — guion de la entrevista operativa: temas, qué se pregunta en
  cada uno, cómo se registra cada respuesta como entrada de corpus, qué no se anota nunca, y
  cómo se cierra un tema sin respuesta. Leer cuando Q3 previó una proyección que exige
  `operacion`.
- `references/proyecciones.md` — qué bloques exige cada audiencia, con qué detalle, qué omite
  y qué ocurre si un bloque falta. Leer en Q3 y al emitir la cobertura de cierre.
- `references/interop-notion.md` — contrato de interoperabilidad de la suite (inyectado al
  empacar): estructura canónica del hub, tabla única de Ps, ownership de páginas, interfaz
  mínima del corpus que las demás skills pueden asumir, handoffs y gates cruzados. Leer
  SIEMPRE antes de tocar Notion.
