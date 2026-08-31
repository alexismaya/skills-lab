---
name: adversarial-review
description: "Revisión adversarial de un artefacto de plan antes de ejecutarlo: un contra-agente independiente intenta refutarlo y entrega un contra-reporte con objeciones citadas, sin corregir ni proponer. Se aplica a reportes de análisis, propuestas de fases/etapas, reportes de cierre de fase y handoffs entre skills. Usar esta skill SIEMPRE que el usuario quiera: una 'revisión adversarial', un 'contra-reporte', 'refutar', 'atacar' o 'tumbar' un plan, un 'red team' o 'abogado del diablo' sobre una propuesta, una 'segunda opinión' independiente sobre un análisis, un 'premortem', o saber 'qué puede salir mal con este plan', 'qué estoy dando por supuesto' o 'dónde me estoy engañando'; y SIEMPRE antes de aprobar un gate de análisis o de materializar en Notion una propuesta de fases/etapas. NO usar para: auditar código existente contra pilares de calidad (eso es project-audit), planear o generar pruebas (qa-discovery / qa-generator), revisar un diff o un PR, ni para corregir el artefacto revisado — esta skill refuta y reporta, nunca edita el artefacto ni propone la solución."
---

# Revisión adversarial (contra-reporte de un plan)

Segunda voz sobre un artefacto de plan **antes de que se ejecute**: alguien cuyo único trabajo es intentar tumbarlo. Principio rector: **un plan que nadie intentó tumbar no está aprobado — está sin examinar.**

La suite SDD ya es fuerte en *contención*: nada se afirma sin respaldo, y hay evidencia `archivo:línea`, procedencia, marcas de trazabilidad y criterios discriminantes para impedirlo. Lo que no tenía es *refutación*: un mecanismo que intente derribar lo que ya se afirmó. Esta skill es ese mecanismo, y existe contra un modo de fallo que el resto de la suite no puede cubrir solo — **un plan verosímil que el usuario ratifica porque suena razonable**.

## Regla de rol (gobierna todo lo demás)

**Refuta. No corrige, no propone, no edita.**

1. El revisor **no toca el artefacto revisado** ni ninguna página ajena. Una objeción sostenida es un **reporte de desviación**, igual que en el resto de la suite: la corrección es del dueño del artefacto (`references/interop-notion.md`, regla 2).
2. El revisor **no entrega la solución**. Decir *"esto no se sostiene, y esto haría falta para sostenerlo"* es su trabajo; decir *"hazlo así"* invade el rol del autor y, peor, introduce una alternativa que nadie sometió al mismo escrutinio.
3. **La objeción se cita.** Toda refutación arranca de una **cita literal** del artefacto con su ubicación. Sin cita no hay refutación: hay una impresión.

## Regla cero (compartida con la suite SDD)

**No asumir nada.** Toda objeción que el usuario acepta y que no se resuelve en el momento se registra como **P-n** en la tabla única del proyecto, con `origen: adversarial-review` y su **`gatea`** declarado — qué etapa o fase queda detenida. Una refutación aceptada sin `gatea` no bloquea nada y nadie la recoge: es una queja.

## Precondición: el paquete de revisión

La independencia del revisor no es una actitud, es una **regla de insumos**.

**Entra al paquete:**

1. El **artefacto a revisar**, completo y tal cual está.
2. Las **fuentes primarias** que el artefacto dice usar: el código con su ruta, el DDL o esquema, el contrato/spec, y **lo que el usuario declaró literalmente** (sus palabras, no la paráfrasis del autor).
3. El **punto de intervención** (A1–A4, § siguiente) y las decisiones ya cerradas que no están en discusión.

**No entra al paquete:**

- **La conversación en la que se produjo el artefacto.** Ni el razonamiento del autor, ni su justificación, ni el chat donde se negoció. Leer por qué el autor eligió algo antes de atacarlo es cómo se hereda el sesgo que esta revisión existe para romper.
- El contra-reporte de una revisión anterior del mismo artefacto, salvo que lo que se revise sea precisamente la corrección de una objeción concreta.

**Arranque:** el revisor se ejecuta en un **chat nuevo**, con el paquete y nada más (instrucción literal en `references/plantillas-adversarial.md`). Si el paquete llega con la conversación del autor incluida —porque el usuario lo pegó entero, o porque se revisa en la misma sesión que lo escribió—, **la revisión se hace igual y el contra-reporte se marca `contaminado`** en su cabecera. Es información honesta sobre cuánto vale ese veredicto, no un motivo para no revisar.

## Los cuatro puntos de intervención

| Punto | Artefacto | Pregunta rectora | Cuándo |
|---|---|---|---|
| **A1** | Reporte de la Fase de Análisis (variante A o B) | ¿Esta forma es la que el usuario declaró, o la que sonaba razonable? | **Obligatorio** antes del gate |
| **A2** | Propuesta de fases/etapas, **antes** de crear páginas | ¿Qué antipatrón ya está aquí y costará N subpáginas después? | **Obligatorio** antes de materializar |
| **A3** | Reporte de cierre de fase + sus evidencias | ¿Qué evidencia pasaría en verde con el mecanismo inerte? | Ofrecido en cada gate |
| **A4** | Resumen de salida (handoff) de una etapa | ¿Qué necesita la skill de al lado y no está aquí? | A demanda de quien lo consume |

**A1 y A2 son obligatorios porque son los dos puntos donde revertir todavía es barato.** Un error en A1 se corrige editando un reporte; el mismo error detectado tres fases después cuesta una arquitectura. Un error en A2 se corrige editando un mensaje; después son subpáginas creadas, ejecutadas y con handoffs colgando de ellas.

**A3 y A4 no son obligatorios, pero su omisión se declara por escrito en el gate.** Un contra-reporte ausente y no declarado se lee como uno aprobatorio.

**A4 no gasta un chat por etapa.** Corre en lote dentro del contra-agente de A3, sobre todos los handoffs de la fase; o lo invoca la skill que va a consumir el handoff (`qa-discovery`, `documentation-master`, `project-doc`) justo antes de consumirlo, que es cuando se sabe qué hacía falta.

## Taxonomía de refutación (R-n)

Ocho tipos. No son categorías inventadas: cada uno ataca un modo de fallo que la suite ya nombra y que hasta ahora solo se detectaba después de ocurrido.

| Tipo | Qué ataca |
|---|---|
| `premisa-no-verificada` | Una afirmación heredada de un handoff, del análisis o del propio plan, tratada como hecho y nunca contrastada contra el código o una medición |
| `alternativa-de-paja` | Una decisión que lista alternativas para cumplir el requisito de listarlas: opciones que nadie consideró en serio, descartadas con una línea genérica |
| `ancla-ausente` | Una decisión de infraestructura argumentada contra ningún número, o contra un número que el usuario nunca declaró |
| `criterio-que-no-discrimina` | Un criterio de aceptación que pasaría en verde con el mecanismo inerte — atacado **en el plan**, antes de que produzca un gate aprobado sobre una función que no funciona |
| `frontera-ambigua` | Dos etapas que pueden interpretar distinto quién crea qué: el hueco donde el ejecutor decidirá por criterio propio |
| `p-ausente` | Una duda que el plan resolvió en silencio: donde debía haber una P-n hay una decisión sin dueño |
| `guarda-ausente-u-huerfana` | Una regla crítica sin verificación automática que la respalde, o una guarda que apunta a un artefacto que esta fase va a jubilar |
| `inferencia-encadenada` | Una sección construida sobre inferencias apiladas, sin una sola afirmación anclada a lo que el usuario declaró o a lo que el código demuestra |

El método de ataque de cada tipo —qué buscar, con qué pregunta se destapa, y cuándo la señal es un falso positivo— está en `references/tacticas.md`. Leerlo antes de la primera refutación.

### Ficha de refutación

Una ficha por objeción, numeradas `R-1..R-n` dentro del contra-reporte. Formato literal en `references/plantillas-adversarial.md`; los cinco campos son obligatorios:

- **Tipo** — uno de los ocho. Si no encaja en ninguno, probablemente no es una refutación (ver antipatrones).
- **Cita** — el fragmento literal refutado, con su ubicación en el artefacto.
- **Por qué no se sostiene** — el argumento, no la sospecha. Si hay contra-evidencia en el código, va con `archivo:línea`.
- **Qué haría falta para sostenerlo** — la condición concreta que convertiría la objeción en resuelta. Es lo que permite cerrarla sin discutir.
- **Qué gatearía si se acepta** — la etapa, fase o entregable que queda detenido. **Es el único campo que mide el peso de la objeción:** no se inventa una severidad nueva, se declara qué bloquea, que es como la suite ya mide el bloqueo.

### Escepticismo asimétrico

**Dudar de todo por igual equivale a no dudar de nada.** El orden de ataque lo fija una sola pregunta: *¿cuánto cuesta revertir esto si está mal?* Primero lo caro e irreversible —decisiones de arquitectura, fronteras entre etapas, guardas de la línea base, cualquier cosa que las fases siguientes heredarán como cerrada—; al final lo barato de cambiar. Una objeción sobre algo que se corrige en cinco minutos y no bloquea nada no merece una ficha.

### Criterio de parada

El barrido termina cuando se cumple una de tres: se recorrieron los ocho tipos contra el artefacto completo; o las últimas objeciones encontradas ya no gatean nada; o el artefacto está tan incompleto que las refutaciones se acumulan sobre el mismo hueco — y entonces se reporta **ese** hueco, una vez, en lugar de sus quince síntomas.

## Premortem (uno por contra-reporte)

Un ejercicio prospectivo, obligatorio y acotado:

> *La fase terminó. El gate se aprobó. Tres meses después esto se rehízo. ¿Qué falló?*

**Máximo tres escenarios.** Cada uno se ancla a una línea concreta del artefacto —y entonces suele convertirse en una ficha R-n— o **se descarta explícitamente**, diciendo por qué no se sostiene. Es la única parte del contra-reporte que no exige cita previa, y por eso está limitada a tres: sin el tope, el premortem se vuelve el lugar por donde entra todo lo que no resistía la exigencia de cita.

## El contra-reporte

Plantilla literal por punto de intervención en `references/plantillas-adversarial.md`. Estructura invariante:

1. **Cabecera** — artefacto revisado, punto (A1–A4), fecha, y si el paquete estaba `contaminado`.
2. **Fichas R-n**, ordenadas por lo que gatean: lo que bloquea más, primero.
3. **Premortem** — hasta tres escenarios, anclados o descartados.
4. **Qué intenté tumbar y no pude** — obligatorio, incluso —sobre todo— cuando no hay objeciones.
5. **Veredicto explícito**, en uno de tres valores: `sin objeciones sostenidas` · `objeciones que corregir antes de ejecutar` · `objeciones que bloquean`.

**La sección 4 es la que hace verificable la revisión.** Un contra-reporte sin objeciones y sin esa sección es indistinguible de una revisión que nunca ocurrió; con ella, el usuario puede ver qué se atacó, con qué, y por qué el artefacto resistió. Si no hay hallazgos, se dice explícitamente — igual que un criterio cumplido se demuestra con su evidencia y no con un checkbox.

## Qué pasa con una refutación

Los tres desenlaces los ejecuta **el dueño del artefacto**, nunca el revisor:

| Desenlace | Cuándo | Qué queda escrito |
|---|---|---|
| **Se corrige el artefacto** | La objeción se sostiene y la corrección está al alcance | El artefacto corregido; la ficha R-n queda como registro de por qué cambió |
| **Se abre una P-n** | La objeción se sostiene y resolverla exige información que no se tiene | Fila en la tabla única: `origen: adversarial-review`, `gatea: {etapa}`, y la ficha R-n como respaldo |
| **Se anota como riesgo asumido** | El usuario decide seguir a pesar de la objeción | El riesgo declarado en el gate, con su motivo. **Nunca en silencio** |

**Una refutación rechazada se registra igual, con el motivo del rechazo.** Sirve para dos cosas: si el riesgo se materializa, la decisión y su razón están escritas; y si el patrón se repite, es candidata a la página **Lecciones SDD** — tanto la objeción que resultó certera como la que resultó ruido, porque calibrar al revisor importa igual que calibrar el plan.

## Antipatrones del revisor

Sin esta lista la skill produce ruido, y una skill que produce ruido se desactiva sola a la tercera vez.

1. **Refutación sin consecuencia** — la objeción es correcta y corregirla no cambia nada. Si el campo *qué gatearía* queda vacío, no era una ficha.
2. **Objeción de estilo** — reescribir el artefacto al gusto del revisor: reordenar secciones, cambiar vocabulario, preferir otra estructura. El artefacto es del autor.
3. **Refutación por catálogo** — recorrer los ocho tipos rellenando una ficha por cada uno. Un tipo que no aplica se declara inaplicable; **no se inventa una objeción para llenar una casilla**.
4. **Contrapropuesta** — entregar la solución en vez de la objeción. Además de invadir el rol del autor, introduce una alternativa que nadie sometió al mismo escrutinio y que el usuario adoptará por ser la última que leyó.
5. **Escepticismo simétrico** — atacar con la misma intensidad lo irreversible y lo trivial. Produce contra-reportes largos donde lo importante queda enterrado.
6. **Refutar la ejecución en vez del plan** — en A1 y A2 no hay ejecución que criticar todavía; señalar que "el código podría quedar mal" no es una objeción al plan. Lo que se ataca es lo que el artefacto **afirma** y lo que **omite**.
7. **Aprobación complaciente** — cerrar con "sin objeciones" sin declarar qué se atacó. Es el fallo más silencioso de todos: produce el sello de una revisión que no ocurrió.
8. **Refutar lo que ya está declarado como abierto** — objetar una P-n que el artefacto ya registró, o un `NO DETERMINADO` que ya declara su motivo. Ahí el autor no se equivocó: fue honesto. Lo refutable es la P que **falta**, no la que está.

## Lo que esta skill NO hace

- **No edita el artefacto revisado** ni ninguna página cuya dueña sea otra skill.
- **No propone la corrección**, ni "de paso" ni "para ahorrar tiempo".
- **No audita código** contra pilares de calidad — eso es `project-audit`, que trabaja sobre un sistema existente y produce hallazgos `H-n` con severidad. Aquí se revisa un **plan**, y el peso de una objeción se mide por lo que gatea, no por una severidad.
- **No diseña ni evalúa pruebas** — eso es `qa-discovery` / `qa-generator`.
- **No revisa diffs ni PRs de código.**
- **No decide.** El veredicto del contra-reporte es un insumo del gate; quien aprueba sigue siendo el usuario.

## Operación con Notion

Usar la integración de Notion disponible en tu runtime (tabla de equivalencias en `references/interop-notion.md`).

- **Escribe solo sus propias páginas:** el hub **Revisión adversarial** del proyecto y los contra-reportes que cuelgan de él, uno por artefacto revisado. El enlace desde el gate que lo motivó lo coloca el dueño de esa página, no el revisor.
- **Único artefacto compartido que toca:** la tabla única de Ps, para dar de alta las P-n derivadas de refutaciones aceptadas — con edición quirúrgica (`update_content` con reemplazos puntuales), nunca reescribiendo la página.
- Si el proyecto no tiene hub de Revisión adversarial, proponerlo y crearlo tras aprobación, como cualquier página nueva de la suite.

## Recursos de la skill

- `references/tacticas.md` — el método de ataque: qué buscar por cada uno de los ocho tipos R-n, la pregunta que destapa cada forma, cómo leer un plan al revés (señal → qué significa realmente), las frases-test ya calibradas en la suite, y cuándo una señal es un falso positivo. **Leer antes de la primera refutación de cada sesión.**
- `references/plantillas-adversarial.md` — plantillas literales: paquete de revisión e instrucción de arranque del chat nuevo, contra-reporte por punto (A1, A2, A3, barrido A4), ficha `R-{n}`, premortem, y el bloque de alta de P-n derivadas. Leer al redactar cualquiera de estos artefactos.
- `references/interop-notion.md` — contrato de interoperabilidad de la suite (inyectado al empacar): estructura canónica del hub, tabla única de Ps con numeración compartida, ownership de páginas, handoffs como interfaz, gates cruzados, y la regla 9 que define esta revisión como independiente y no correctiva. **Leer SIEMPRE antes de tocar Notion.**
