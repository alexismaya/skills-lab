---
name: sdd-harness-notion
description: "Construcción de proyectos de software bajo la metodología SDD harness engineering (spec-driven development por fases con gates de revisión) usando Notion como gestor de tareas, contexto y documentación. Las tareas se atomizan en etapas ejecutables en chats independientes para optimizar tokens y contexto. Usar esta skill SIEMPRE que el usuario quiera: iniciar un proyecto o feature nuevo con metodología por fases, implementar un bug/feature de forma organizada, generar un plan de trabajo modularizado en Notion para agentes (Kiro, Claude Code u otro), crear prompts de análisis/scaffold/implementación con criterios de aceptación, modular un prompt grande en etapas, revisar un reporte de cierre de fase contra su gate, o cualquier mención de 'SDD', 'harness', 'fases', 'etapas', 'gate', 'análisis antes de implementación' o 'atomizar tareas en Notion'."
---

# SDD Harness Engineering con Notion

Metodología para construir proyectos de software mediante agentes de código, dividida en fases con gates de revisión humana, donde Notion actúa como gestor de tareas, contexto vinculante y documentación. Principio rector: **el análisis precede a la implementación, nada se asume, y la calidad se demuestra con evidencia — no se declara.**

Esta skill no trae proyectos de ejemplo embebidos, a propósito: cada proyecto define su propia forma a través de la **entrevista de arranque**, y la metodología acumula aprendizaje en la **página de Lecciones** del Notion del usuario — no en la skill.

## Regla cero (gobierna todo lo demás)

**No asumir nada. Nunca ejecutar sin propuesta aprobada.**

1. Toda duda, ambigüedad o decisión sin resolver se registra como **pregunta abierta numerada (P-1, P-2, ...)** en la página de Notion del proyecto, y el trabajo que depende de ella **no avanza** hasta resolverla.
2. Una P se resuelve solo de dos formas: (a) el usuario la responde, o (b) el modelo encuentra la respuesta en el contexto disponible (código, DDL, spec, documentos) — y **aun así la presenta al usuario para confirmación antes de darla por cerrada**. La evidencia encontrada se anota junto a la P.
3. Antes de crear páginas, escribir prompts o ejecutar cualquier cosa: presentar al usuario la **propuesta de fases/etapas/tareas** y esperar su aprobación explícita. La propuesta es conversación; la ejecución empieza después del "adelante".

## Arranque en un proyecto (entrevista obligatoria la primera vez)

Al activarse la skill sobre un proyecto donde no se ha usado antes, NO generar nada todavía. Entrevistar al usuario — preguntas cortas, de una en una o en un solo bloque de opciones si la interfaz lo permite. Antes de preguntar, revisar el contexto ya disponible (conversación, memoria, Notion accesible): lo que ya se sabe no se pregunta, se **confirma**.

**Q1 — Naturaleza del trabajo:** ¿Proyecto nuevo desde cero, o implementación sobre algo existente (feature, bug, refactor, remediación)?
- *Nuevo* → ciclo completo, y la Fase de Análisis usa la **variante desde cero** (§ Fase de Análisis): no hay base que auditar, así que el análisis produce **decisiones de forma** — arquitectura, stack, convenciones — en vez de hallazgos. Si el proyecto nace de otro existente, esto no aplica: es territorio de `derivar-proyecto`.
- *Implementación sobre existente* → el ciclo se adapta: el "análisis" puede ser una etapa corta de diagnóstico (reproducir el bug, delimitar el impacto del feature), pero **nunca se omite** — cambia de escala, no de existencia.

**Q2 — Estado en Notion:** ¿Ya existe una página/espacio de Notion con información de este proyecto, o se empieza a cargar desde cero?
- *Existe* → pedir la URL, leerla ANTES de proponer nada, y adaptarse a su estructura y nomenclatura en lugar de imponer las plantillas. Las plantillas complementan lo que falte (tabla de Ps, criterios, handoffs), no reemplazan lo que ya hay.
- *Desde cero* → proponer la estructura (hub raíz del proyecto → hubs de fase → subpáginas de etapa) y crearla solo tras aprobación.

**Q3 — Documentación general:** ¿El proyecto requiere una página de documentación general (visión, arquitectura, decisiones, glosario) además del plan de trabajo?
- *Sí* → incluir en la propuesta una página "Documentación" hermana de los hubs de fase, que se alimenta al cierre de cada fase (no al final del proyecto).
- *No* → el conocimiento vive en los hubs y handoffs; no crear páginas que nadie mantendrá.

**Q4 — Ejecutor, contexto y capacidad:** ¿Quién ejecuta las etapas (Kiro, Claude Code, otro agente, el propio usuario)? ¿Hay restricción de contexto que dicte el tamaño de los lotes? Y una segunda dimensión: **¿qué capacidad tiene el ejecutor?** — `puntero` (el modelo más capaz), `intermedio`, o `bajo coste` (modelo pequeño/barato).
- La restricción de contexto calibra el tamaño del lote: agentes con contexto corto → etapas más pequeñas y handoffs más ricos.
- La capacidad calibra **cuánta inteligencia debe absorber el plan**. Principio: *la calidad no se le pide al ejecutor — se le construye en el plan*. Toda ambigüedad que un modelo capaz resolvería con criterio, para un ejecutor de bajo coste es una P o una decisión pre-resuelta en la etapa. Cuanto más barato el ejecutor, más trabajo de la fase de planificación (hecha por un modelo capaz) y más mecánica la etapa.

Tabla de calibración por perfil (la granularidad es una calibración de esta Q4, **no una metodología paralela**: no se crea un ciclo de fases alterno):

| Variable | puntero | intermedio | bajo coste |
|---|---|---|---|
| Tareas T por etapa | hasta ~4 | 2–3 | 1–2 |
| Archivos tocados por tarea | según dominio | acotado | explícitamente listados, máximo definido en la propuesta |
| Decisiones permitidas al ejecutor | menores, reportadas | ninguna estructural | **cero** — toda decisión viene pre-resuelta en la etapa |
| Contexto vinculante en la subpágina | globales aplicables | globales + fronteras | **TODAS** las exclusiones aplicables, repetidas literalmente |
| Smoke de etapa | si hay mecanismo crítico | recomendado | **obligatorio**, con comando literal y salida esperada |

El perfil elegido se declara por etapa en la tabla de etapas del hub (columna **perfil requerido**, ver § Modularización) — una misma fase puede mezclar etapas de distinto perfil. Las etapas no aptas para bajo coste se identifican con la regla de escalamiento (§ Escalamiento por perfil).

**Q5 — Insumos disponibles:** ¿Qué fuentes de verdad existen? (repo base/plantilla, contrato/spec/colección, DDL o esquema de datos, hallazgos o líneas base previas, lecciones de proyectos anteriores). Todo insumo mencionado se lista; todo insumo faltante que la metodología esperaría se registra como P.

**Q6 — Volumen y horizonte:** ¿Cuál es el volumen real de operación — usuarios, registros, peticiones, elementos del catálogo — **al arrancar** y en el horizonte que el usuario declare? ¿Cuánto tiempo se espera que el sistema viva sin rehacerse?

- Aplica siempre, pero **su peso cambia**: para un bug es una línea ("no cambia la escala"); para un proyecto desde cero es el número contra el que se argumenta toda la arquitectura.
- **Regla de anclaje:** toda propuesta de infraestructura se argumenta **contra este número**. Si el volumen no la justifica, se argumenta por mantenibilidad o por costo de cambio — y se declara cuál de las dos. Una decisión de infraestructura sin ancla es una preferencia disfrazada de criterio.
- Es también el complemento de la regla transversal 4 (default fail-safe): esa solo sabe decir *no construyas*; el número permite además declarar **qué mecanismos NO hacen falta a esta escala**, por escrito, para que una fase posterior no los reintroduzca.
- Si el usuario no lo sabe, se registra como P y se acota con un rango declarado como suposición a confirmar — nunca se infiere en silencio.

Con las respuestas, generar la **propuesta**: fases con sus objetivos, etapas tentativas por fase, Ps iniciales detectadas, y estructura de Notion. Presentarla, iterar con el usuario, y solo entonces materializar en Notion.

En usos posteriores sobre el mismo proyecto, saltar la entrevista: leer el hub (estado global, Ps abiertas, último handoff) y continuar desde ahí.

## Ciclo de fases

Ninguna fase inicia sin que el gate de la anterior esté aprobado por el usuario.

```
Fase de ANÁLISIS/diagnóstico (solo lectura, cero código)
    → gate: revisión del reporte
Fase de SCAFFOLD/preparación + línea base (seguridad, guardas)
    → gate: reporte de cierre con evidencias
Fases de IMPLEMENTACIÓN por dominios
    → gate: reporte de cierre con evidencias
Fase de VERIFICACIÓN (UAT/QA contra entorno real)
    → gate: cierre → entrega
```

Reglas transversales:

1. **Los documentos de análisis son VINCULANTES.** Ante conflicto entre una tarea y el análisis: detenerse y reportar; el ejecutor nunca resuelve por criterio propio.
2. **Una premisa heredada es una hipótesis fechada, no un hecho.** Lo vinculante de un documento es su *decisión*, no cada afirmación técnica que lo acompaña. Toda afirmación que venga de un handoff, del texto de una etapa o del propio plan — "sin X esto se rompe", "basta con sustituir Y", "el mecanismo Z ya entra al loss" — se **verifica contra el código o una medición antes de construir sobre ella**, y si no se sostiene se reporta en vez de ejecutarla. Es el complemento de la regla 1: la 1 cubre el conflicto visible (la tarea contradice al análisis); esta cubre el silencioso, que es el que llega hasta producción — nadie contradice una premisa falsa que todos dan por buena, y cuanto más obediente el ejecutor, más literalmente la ejecuta. El costo de verificar es minutos; el de heredar una premisa falsa es una fase entera construida sobre ella.
3. **Las Ps gatean etapas específicas.** Cada P declara qué etapas bloquea; una P sin gate declarado es una suposición esperando a ocurrir. Si la P sigue abierta al iniciar la etapa gateada, el ejecutor se detiene en el punto exacto y reporta.
4. **Default fail-safe:** ante una decisión binaria sin resolver, el default es NO construir la infraestructura. Componentes "por si acaso" están prohibidos — un cambio aditivo posterior es más barato que una superficie muerta.
5. **Fuera de alcance explícito** en cada fase/etapa. Lo no listado como tarea tampoco se hace.
6. **Evidencia, no afirmación:** los criterios de aceptación exigen artefactos verificables (salida de comandos, tests, conteos, diffs), no checkboxes narrativos. Y la evidencia tiene que **discriminar**: ante cada criterio, preguntarse *si el mecanismo estuviera roto, ¿este criterio fallaría?* Si la respuesta es no, el criterio está mal escrito (ver antipatrón 10).
7. **Líneas base con guardas:** las reglas críticas del proyecto (seguridad, datos sensibles, patrones prohibidos) se implementan en el scaffold con verificaciones automáticas (CI/greps que rompen el build) — no como remediación posterior ni como disciplina esperada. Una guarda apunta a un artefacto concreto: **toda fase que reemplace o jubile ese artefacto revisa qué guardas lo apuntaban** y las migra, o quedan verdes protegiendo algo que ya nadie usa (ver antipatrón 11).

## Fase de Análisis

Producir un prompt que pida un reporte, nunca código (plantillas en `references/plantillas.md`). Hay **dos variantes**, según la respuesta a Q1. Comparten el principio —el análisis precede a la implementación y nada se asume— pero no el material: una lee una base existente, la otra no tiene nada que leer salvo lo que diga el usuario.

### Variante A — sobre una base existente

El análisis **observa**. Secciones típicas — adaptar a lo que el proyecto tenga, no forzar las que no apliquen:

- **Auditoría de la base:** clasificar el 100% en heredable / no-heredable / código muerto, con rutas explícitas.
- **Contrato/spec:** inventario completo de la fuente de verdad, sin inventar nada ausente — lo ausente es una P.
- **Datos** (si hay esquema compartido): verificado contra el DDL real, no inferido del código; convenciones observadas; colisiones; dueños de tablas compartidas.
- **Línea base** (seguridad u otra crítica del dominio): checklist *regla · estado en la base (✅/⚠️/🔴) con evidencia archivo:línea · obligación para el nuevo código*, y veredicto explícito.
- **Preguntas abiertas** numeradas al final.

Método del reporte: afirmaciones de código con `archivo:línea`; afirmaciones de esquema contra el DDL/migración que lo crea.

### Variante B — proyecto desde cero

El análisis **propone una forma**, porque no hay base que observar. Eso cambia el modo de fallo: aquí el riesgo no es leer mal el código, es **inventar una arquitectura verosímil y que el usuario la ratifique porque suena razonable**. Toda la disciplina de esta variante existe para impedirlo.

**Regla de trazabilidad (sustituye a `archivo:línea`).** Como la única fuente son las palabras del usuario, cada afirmación del reporte lleva una de estas tres marcas — sin excepción:

| Marca | Qué significa |
|---|---|
| `[declarado]` | El usuario lo dijo. Se cita lo que dijo, no una paráfrasis conveniente |
| `[inferido]` | El ejecutor lo derivó de algo declarado. **Se presenta para confirmación**; no es vinculante hasta que el usuario lo ratifique en el gate |
| `[P-n]` | No se sabe y hace falta. Bloquea lo que dependa de ello |

Una sección entera sin una sola marca `[declarado]` es una señal de alarma: significa que el reporte se construyó sobre inferencias encadenadas.

**Secciones** (detalle y plantilla literal en `references/plantillas.md` § 1b):

1. **Problema y alcance** — qué se construye, para quién, y qué **no** se construye.
2. **Anclas cuantitativas** — el volumen y horizonte de Q6. Es el número contra el que se argumenta lo demás.
3. **Restricciones no negociables** — stack impuesto, infraestructura existente, compliance, sistemas con los que hay que integrarse, capacidad real del equipo que lo va a mantener.
4. **Decisiones de arquitectura** — una ficha por decisión: qué se elige · **alternativas consideradas** · por qué esta contra el número de la sección 2 · **qué la invalidaría**.
5. **Lo que NO se construye** — los mecanismos que a este volumen no hacen falta, nombrados uno a uno.
6. **Convenciones desde el día uno** — estructura, nomenclatura, y la **decisión** de convención de commits y modelo de branching (solo la decisión: el mecanismo lo gobierna `git-workflow`, que la lee — no se duplica aquí).
7. **Línea base de seguridad**, prospectiva: qué reglas serán obligatorias para todo el código nuevo y con qué guarda automática se verifican en el scaffold.
8. **Preguntas abiertas** numeradas.

**Reglas de la variante:**

- **Una decisión sin alternativas rechazadas no es una decisión, es una preferencia.** Toda ficha de la sección 4 lista al menos dos opciones consideradas y por qué se descartaron.
- **El análisis propone; el gate decide.** Ninguna decisión de la sección 4 es vinculante hasta que el usuario la ratifica. Es la única fase donde el entregable es propositivo, y por eso el gate importa más que en ninguna otra.
- **Toda decisión de infraestructura se argumenta contra el número de la sección 2** (regla de anclaje, Q6). Sin ancla, se registra como P — no se resuelve por criterio del ejecutor.
- **Cero código, cero scaffold, cero migraciones.** Sigue siendo fase de análisis.

## Anatomía de un prompt de fase

En este orden (plantillas literales en `references/plantillas.md`):

1. **Contexto** — qué fase es y la declaración de alcance ("NO se hace X").
2. **Decisiones vinculantes** — documentos que gobiernan + Ps cerradas que no se reabren.
3. **Insumos** numerados.
4. **Tareas** (T1..Tn) con las exclusiones no-negociables dentro de la tarea que las ejerce.
5. **Criterios de aceptación** numerados, con la evidencia requerida nombrada.
6. **Fuera de alcance (no hacer).**
7. **Entregable** y qué revisará el usuario antes de la siguiente fase.

### Tarea de inferencia cero (perfil bajo coste)

Cuando el perfil del ejecutor (Q4) es **bajo coste**, cada tarea T se redacta como *tarea de inferencia cero*: el ejecutor **transcribe, no diseña**. La inteligencia ya la puso el modelo capaz al planificar. Toda tarea de inferencia cero especifica los cuatro componentes:

1. **Ubicación exacta:** ruta del archivo + ancla concreta (nombre de función, clase, o un fragmento literal a localizar). Nunca "en el módulo de auth" — sí "en `auth/tokens.py`, dentro de `def verify_token(...)`".
2. **Forma esperada del cambio:** firma, contrato, o pseudodiff que el ejecutor reproduce. Se le da la forma, no el problema — no hay decisión de diseño abierta.
3. **Verificación literal:** comando copiable + salida esperada (valor exacto o patrón de la salida). Es lo que el gate comparará (§ Revisión de gate), no la narrativa del ejecutor.
4. **Criterio de detención explícito:** *"si lo encontrado no coincide con lo descrito, detente y reporta — no corrijas, no adaptes, no completes el hueco."* Esto ejerce la Regla cero en el ejecutor barato: donde un modelo capaz improvisaría, el barato debe frenar.

Si una tarea no puede escribirse con estos cuatro componentes cerrados, la etapa **no es apta para bajo coste**: se etiqueta con perfil superior (§ Escalamiento por perfil) o se descompone hasta que sí lo sea.

## Modularización en Notion

Cuando una fase excede un solo chat (regla práctica: >~4 tareas T, o tareas que tocan muchos archivos, o el ejecutor declarado en Q4 tiene contexto corto), se modulariza:

```
Página proyecto (hub raíz)
├── Documentación (si Q3 = sí)
├── Lecciones (ver § Escalar con el uso)
└── Página de fase (hub)
    ├── Contexto + decisiones vinculantes GLOBALES
    ├── Tabla de Ps abiertas → qué etapa gatean
    ├── Tabla de etapas: #, nombre, tareas, depende de, gate (P-x), perfil requerido
    ├── Estado global (checkboxes con fecha de cierre)
    ├── Criterios de aceptación globales + fuera de alcance
    └── Subpáginas de etapa (una por lote ejecutable)
```

Cada **subpágina de etapa** es autocontenida — se ejecuta en un chat nuevo con solo su URL:

- **Contexto vinculante de la etapa:** REPITE las decisiones globales que le aplican. La redundancia es deliberada — es el costo de aislar contexto.
- **Tareas** con checkboxes.
- **Criterios de aceptación** + **smoke ejecutable:** toda etapa que implemente un mecanismo crítico incluye un test mínimo ejecutable EN esa etapa, marcado como red intermedia ("no sustituye la suite final") — evita descubrir a N contextos de distancia un fallo introducido aquí.
- **Checklist de cierre** + **Resumen de salida (handoff):** qué produjo, decisiones tomadas, qué necesita saber la siguiente etapa.

Reglas:

- **Grafo de dependencias explícito** — qué es paralelizable y qué no.
- **Precisión en las fronteras:** si la etapa A crea algo que la B materializa, A declara EXACTAMENTE a qué apunta hoy y qué queda para B. La ambigüedad en la frontera es donde el ejecutor decide por criterio propio.
- **Instrucción de arranque en el hub:** el texto literal para pegar en el chat nuevo.
- La propuesta de etapas SIEMPRE se presenta al usuario para análisis antes de crear las páginas (Regla cero).

### Escalamiento por perfil

La tabla de etapas del hub declara el **perfil requerido** por etapa (columna añadida al esquema de la tabla de etapas, que es ownership exclusivo de esta skill — no forma parte del contrato interop; ver `references/interop-notion.md`). No toda etapa admite un ejecutor de bajo coste. Se etiquetan para **ejecutor capaz** (`puntero`/`intermedio`) o para **el humano** las etapas que exigen inferencia real:

- **Diseño / arquitectura:** definir estructura, contratos nuevos, o trade-offs sin una forma ya resuelta.
- **Refactors transversales:** cambios que cruzan módulos y requieren mantener coherencia global en la cabeza.
- **Resolución de ambigüedad:** cualquier etapa cuyo trabajo consista en decidir entre opciones no zanjadas.
- **Interpretación de specs incompletas:** donde falta fuente de verdad y hay que inferir intención.
- **Etapas gateadas por Ps abiertas:** si el análisis previo de la etapa tiene una P sin resolver que la gatea, no baja a bajo coste hasta que la P se cierre — un ejecutor barato no debe decidir lo que la P dejó abierto.

Regla operativa: una etapa solo se marca `bajo coste` si todas sus tareas se pueden escribir como tareas de inferencia cero (§ Anatomía de un prompt de fase). Si no, se sube de perfil o se descompone.

**Efecto colateral positivo (QA):** como `qa-generator` materializa sus suites "como etapas SDD normales" (contrato interop, Regla 4), las etapas QA heredan la columna **perfil requerido** sin coordinación adicional — un caso de test mecánico (aserción con salida esperada literal) es naturalmente bajo coste; una etapa de diseño de estrategia de pruebas no lo es.

### Antipatrones (al crear o auditar un plan)

1. Etapa tardía reintroduce lo que una temprana excluyó — cada exclusión global debe repetirse en el contexto vinculante de toda etapa que pueda tocarla.
2. Verificación diferida sin red intermedia — todos los tests al final, cero smoke intermedio.
3. Frontera ambigua — dos etapas pueden interpretar distinto quién crea qué.
4. Handoff ausente — la etapa cierra sin resumen de salida.
5. P abierta sin gate — se resolverá por suposición silenciosa.
6. Checkbox sin evidencia — "compila y levanta" sin artefacto adjunto.
7. **Atomización sin porqué** — etapas tan pequeñas que el ejecutor pierde la intención y rellena huecos improvisando. El contexto vinculante ampliado (perfil bajo coste) existe precisamente para impedirlo: atomizar sin explicar el porqué de cada tarea deja el hueco que el ejecutor barato llenará adivinando.
8. **Granularidad teatral** — dividir en más etapas sin extraer las decisiones: las mismas ambigüedades, ahora repartidas en más chats. Más subpáginas no es más calidad si cada una sigue exigiendo criterio propio.
9. **Verificación delegada al barato** — pedirle al ejecutor de bajo coste que juzgue calidad ("verifica que quedó bien", "revisa que esté correcto") en lugar de ejecutar una comparación mecánica contra una salida esperada declarada. Juzgar es inferencia; el barato ejecuta comandos y compara, no dictamina.
10. **Criterio de aceptación que no discrimina** — el criterio pasa en verde aunque el mecanismo esté inerte. No es el antipatrón 6 (ahí *falta* el artefacto): acá **hay** evidencia y la evidencia no prueba lo que dice probar. Ejemplo real: *"el log muestra que la penalización sintáctica entra al loss"* — se cumple con solo sumar un número al escalar reportado, aunque el gradiente lo ignore por completo y el mecanismo no entrene nada. Es el más peligroso de la lista porque produce un **gate aprobado sobre una función que no funciona**, y deja esa creencia escrita en el reporte de cierre para que las fases siguientes la hereden (regla transversal 2). Test para detectarlo al redactar: *si el mecanismo estuviera roto, ¿este criterio fallaría?*
11. **Guarda huérfana** — una guarda de la regla transversal 7 sigue verde, pero el artefacto que vigilaba fue reemplazado por una fase posterior y ya no está en el camino crítico. Nadie lo nota porque los tests pasan: el silencio se lee como cobertura. Ejemplo real: guardas de round-trip construidas sobre el generador viejo que siguieron corriendo intactas después de que otra fase lo sustituyera por completo — protegiendo un artefacto muerto mientras lo que el sistema realmente emitía quedaba sin cubrir. Se detecta preguntando, en toda fase que reemplace algo: *¿qué guardas apuntaban a esto?*

## Revisión de gate

Al revisar un reporte de cierre:

1. Cada criterio contra su **evidencia adjunta** (no contra el ✅ del ejecutor). Sin evidencia = no cumplido, aunque probablemente sea cierto.
2. Estado de las **Ps**: resueltas con la decisión documentada y CÓMO se resolvió; abiertas con impacto y a qué fase se difieren.
3. **Desviaciones silenciosas:** dependencias, estructura, decisiones tomadas donde se pedía detenerse. Aceptables solo si están reportadas y justificadas.
4. Pendientes clasificados: bloquea el siguiente gate / bloquea entrega / posterior — con responsable, no solo "después".
5. Veredicto explícito: aprobado / aprobado con correcciones listadas / rechazado con el punto exacto.

**Verificación asimétrica (etapas de perfil bajo coste):** para estas etapas el gate compara **la salida real de cada comando contra la salida esperada declarada en la etapa** — nunca la narrativa del ejecutor sobre lo que hizo. El ejecutor barato no es una fuente de juicio: su reporte en prosa no es evidencia. Si un criterio de aceptación de la etapa **no declaró salida esperada**, el defecto es del **plan, no del ejecutor** — la etapa se redactó incompleta (una tarea que no era de inferencia cero pasó como si lo fuera). Ese hueco se corrige en el plan y se registra como **lección candidata** (§ Escalar con el uso): la próxima planificación no debe repetirlo.

## Escalar con el uso: página de Lecciones

La metodología aprende del usuario, no al revés. Mecanismo:

- En el hub raíz del proyecto (o en un espacio del usuario si prefiere lecciones globales) vive una página **"Lecciones SDD"**: entradas cortas *(fecha · proyecto · qué pasó · regla derivada)*.
- **Al cerrar cada gate**, ofrecer al usuario registrar lecciones: ¿qué P debió detectarse antes?, ¿qué antipatrón apareció?, ¿qué pregunta faltó en la entrevista de arranque? Solo se escribe lo que el usuario apruebe.
- **Al arrancar en un proyecto** (entrevista, Q5): buscar la página de Lecciones y leerla; sus reglas derivadas se tratan como extensiones de esta skill para ese usuario.
- Las lecciones nunca se convierten en suposiciones: si una lección sugiere una respuesta a una P del proyecto actual, se presenta como propuesta a confirmar, no como hecho.

## Operación con Notion

Usar la integración de Notion disponible en tu runtime (ver tabla de equivalencias en `references/interop-notion.md`): el conector del usuario en Claude, o `mcp_notion_api_*` en Kiro. Las reglas de ownership y edición quirúrgica son idénticas en ambos. Al **crear**: hub primero, subpáginas después, todo tras aprobación. Al **corregir**: la operación de actualización de página con `update_content` y reemplazos quirúrgicos — nunca reescribir la página completa (destruye checkboxes, fechas e historial). Al **leer** para un gate: hub + reporte de cierre suelen bastar; abrir subpáginas solo si la revisión lo exige.

Si las páginas las genera otro agente con su propia integración, pueden nacer inaccesibles para el conector — pedir al usuario compartirlas o moverlas a una sección conectada. **Nunca aceptar tokens de integración pegados en el chat**; si el usuario pega uno, indicarle que lo revoque y usar el conector.

## Recursos de la skill

- `references/plantillas.md` — plantillas literales: prompt de análisis (§ 1 sobre base existente, § 1b desde cero), prompt de implementación, hub de fase, subpágina de etapa, reporte de cierre, hallazgo (H-x), y formato de la página de Lecciones. Leer al redactar cualquiera de estos artefactos. Las plantillas son punto de partida — la estructura existente del Notion del usuario (Q2) y sus Lecciones tienen prioridad sobre ellas.
- `references/interop-notion.md` — contrato de interoperabilidad con las demás skills de la suite (`derivar-proyecto`, `qa-discovery`, `qa-generator` u otras) cuando operan sobre el mismo proyecto: estructura canónica del hub, tabla única de Ps con numeración compartida, ownership de páginas, handoffs como interfaz, gates cruzados con QA. Leer SIEMPRE que el proyecto involucre (o vaya a involucrar) más de una skill de la suite.
