# Tácticas de refutación

> Los ejemplos usan un dominio ilustrativo (reserva de espacios y recursos compartidos).
> Es un universo sintético: ilustra la **forma** de lo que se ataca, no un sistema real ni un
> sector recomendado. La sintaxis de los fragmentos también es ilustrativa.

Cómo se ataca un artefacto de plan, tipo por tipo. Se lee antes de la primera refutación de cada
sesión. El orden de este documento no es el orden de ataque: ese lo fija el escepticismo
asimétrico (§ del SKILL.md) — primero lo caro de revertir.

---

## 0. Las tres lecturas

Un artefacto se recorre tres veces, y cada pasada busca algo distinto. Hacerlas a la vez es cómo
se termina con un contra-reporte que solo objeta lo que estaba escrito y nada de lo que faltaba.

1. **Lo que afirma** — cada afirmación contra su respaldo. Ataca `premisa-no-verificada`,
   `ancla-ausente`, `inferencia-encadenada`.
2. **Lo que omite** — qué debería estar y no está. Ataca `p-ausente`, `guarda-ausente-u-huerfana`,
   `frontera-ambigua`. **Es la pasada que más encuentra y la que más se salta**, porque exige
   saber qué esperar en lugar de reaccionar a lo escrito.
3. **Lo que se verifica a sí mismo** — los criterios de aceptación y sus evidencias. Ataca
   `criterio-que-no-discrimina` y `alternativa-de-paja`.

---

## 1. `premisa-no-verificada`

Una afirmación técnica que llegó de un handoff, del análisis previo o del propio plan, y que
todos dan por buena porque nadie la contradice. **Cuanto más obediente el ejecutor, más
literalmente la ejecuta.**

| Forma | Pregunta que la destapa |
|---|---|
| "Sin X esto se rompe" | ¿Alguien lo probó, o se dedujo? ¿Qué pasa exactamente si se quita? |
| "Basta con sustituir Y" | ¿Qué más apunta a Y? ¿La sustitución es de una línea o de un contrato? |
| "El mecanismo Z ya está cubierto" | ¿Cubierto por qué artefacto concreto, en qué `archivo:línea`? |
| Una cifra de rendimiento sin fuente ("responde en {n} ms") | ¿Medida cuándo, con qué carga, en qué entorno? |
| "El sistema de al lado ya valida esto" | ¿Se leyó ese sistema, o se asumió por su nombre? |

**Cómo se ataca:** se abre la fuente primaria y se lee. No se discute la premisa: se contrasta.
Si el código dice otra cosa, la ficha lleva `archivo:línea` de la contra-evidencia. Si no hay
manera de contrastarla con lo que hay en el paquete, la refutación no es "es falsa" sino
**"no es verificable con lo declarado"**, y lo que gatea es la verificación.

**Falso positivo:** una premisa que el artefacto ya marcó como `[inferido]` o como hipótesis a
confirmar. Está declarada; no es refutable por estar declarada.

---

## 2. `alternativa-de-paja`

La ficha de decisión lista alternativas porque el formato las exige, no porque se consideraran.

| Forma | Pregunta que la destapa |
|---|---|
| Alternativas descartadas con una línea genérica ("demasiado complejo", "no escala") | ¿Complejo comparado con qué? ¿No escala a qué número? |
| La alternativa descartada es una versión obviamente peor de la elegida | ¿Cuál era la opción **buena** que competía de verdad? |
| Todas las alternativas se descartan por el mismo motivo | ¿Ese motivo es un criterio, o el nombre de la conclusión ya tomada? |
| La opción elegida aparece primero y las otras la justifican | ¿Se evaluaron, o se redactaron después de decidir? |
| Falta la alternativa "no construir esto" | Si esta pieza no existiera, ¿qué se rompe exactamente? |

**Cómo se ataca:** se nombra la alternativa que falta. Nombrarla **no es proponerla** — la ficha
dice "esta opción no aparece considerada y compite con la elegida en el mismo criterio", no
"hay que usar esta". La diferencia entre refutar y contraproponer está justo aquí, y es el
antipatrón 4 del revisor.

**Falso positivo:** una decisión impuesta por una restricción no negociable declarada. Si el
stack viene dado, la ficha de alternativas es ceremonia y el artefacto ya debería decirlo — si
lo dice, no es refutable.

---

## 3. `ancla-ausente`

Toda decisión de infraestructura se argumenta contra el volumen y horizonte declarados. Sin ese
número, es una preferencia disfrazada de criterio.

| Forma | Pregunta que la destapa |
|---|---|
| Una pieza de infraestructura justificada por "escalabilidad" a secas | ¿A qué número? ¿Quién lo declaró? |
| Un número que aparece por primera vez en la justificación | ¿Está en las anclas cuantitativas, o se acaba de inventar aquí? |
| Se justifica por mantenibilidad **y** por volumen a la vez | El anclaje obliga a declarar cuál de las dos; ambas a la vez es no elegir ninguna |
| La sección "lo que NO se construye" está vacía o falta | A cualquier volumen hay mecanismos que no hacen falta. Una lista vacía significa que nadie los nombró, y una fase posterior los reintroducirá |
| Falta "qué la invalidaría" | ¿Con qué condición concreta habría que revisar esta decisión? |

**Cómo se ataca:** se busca el número en las anclas cuantitativas del artefacto y se compara con
el que usa la justificación. Cuando el artefacto no tiene anclas, la refutación es una sola,
sobre la sección faltante — no una por decisión (criterio de parada).

**Falso positivo:** una decisión que el artefacto declara explícitamente como tomada por costo de
cambio o por capacidad del equipo, con esa etiqueta puesta. Está anclada a otra cosa, y lo dice.

---

## 4. `criterio-que-no-discrimina`

El criterio pasa en verde aunque el mecanismo esté inerte. Es el más caro de la lista porque
produce un **gate aprobado sobre una función que no funciona**, y deja esa creencia escrita para
que las fases siguientes la hereden.

**La pregunta, literal:** *si el mecanismo estuviera roto, ¿este criterio fallaría?*

| Señal | Qué significa realmente |
|---|---|
| "El log muestra que X ocurre" | Se cumple emitiendo el log, aunque X no tenga efecto |
| "El componente está registrado / configurado" | Prueba que existe, no que participa |
| "La suite pasa en verde" | Prueba que nada empeoró, no que esto funciona |
| "No hay errores en consola" | El silencio se lee como cobertura |
| "El endpoint responde 200" | Prueba que responde, no que hizo lo que debía |
| "Se creó el archivo / la tabla / la cola" | Prueba la creación, no el uso |
| Un conteo que solo puede subir | ¿Con qué valor exacto se compara? Sin salida esperada, no discrimina |

**Cómo se ataca:** por cada criterio, se construye el **escenario del mecanismo inerte** — la
versión más barata del sistema que aprobaría ese criterio sin hacer el trabajo. Si esa versión
existe y es plausible, hay ficha, y la cita es el criterio tal cual está redactado.

**Falso positivo:** un criterio que declara salida esperada literal y un valor concreto contra el
que comparar. Ese discrimina por construcción.

---

## 5. `frontera-ambigua`

Dos etapas que pueden interpretar distinto quién crea qué. Es el hueco donde el ejecutor decide
por criterio propio — y cuanto más barato el ejecutor, más silenciosamente lo rellena.

| Forma | Pregunta que la destapa |
|---|---|
| La etapa A "prepara" y la B "materializa" | ¿A qué apunta exactamente lo que deja A? ¿Qué queda para B, con nombre? |
| Un artefacto aparece en las tareas de dos etapas | ¿Cuál lo crea y cuál lo consume? |
| Un artefacto no aparece en ninguna y se usa en una tercera | ¿Quién lo produce? Suele ser una `p-ausente` disfrazada |
| "Dejar listo para" / "sentar las bases de" | ¿Listo verificado cómo? "Sentar las bases" no tiene criterio de cumplimiento |
| Etapas paralelizables que tocan los mismos archivos | ¿Se pueden ejecutar en cualquier orden, de verdad? |

**Cómo se ataca:** se toma el grafo de dependencias del artefacto y se recorre cada artefacto
producido preguntando quién lo crea y quién lo consume. Un artefacto con dos creadores o con
ninguno es la ficha.

**Falso positivo:** una frontera que el artefacto describe con precisión —"A deja el punto de
entrada apuntando a la implementación provisional; B la sustituye"—, aunque suene informal. Lo
que se ataca es la ambigüedad, no el estilo.

---

## 6. `p-ausente`

Donde debía haber una pregunta abierta hay una decisión sin dueño. Es la refutación de mayor
retorno del catálogo, porque una P que nadie abrió no bloquea nada.

| Forma | Pregunta que la destapa |
|---|---|
| Un dato del que depende una decisión y que nadie declaró | ¿Quién dijo esto, y cuándo? |
| Una decisión que "se confirmará durante la implementación" | ¿Qué etapa se detiene si resulta que no? |
| Un valor concreto (umbral, plazo, tope) sin fuente | ¿Sale del código, de una medición, o de la costumbre del sector? |
| Un comportamiento de un sistema externo dado por sabido | ¿Se leyó su contrato, o se asumió por su nombre? |
| Una P declarada sin `gatea` | Una P que no dice qué detiene es una nota que nadie revisa |
| Un `NO DETERMINADO` sin motivo | El motivo es lo que lo vuelve accionable |

**Cómo se ataca:** se recorre el artefacto marcando toda afirmación que no sea trazable a código,
a medición, o a algo que el usuario declaró literalmente. Cada marca sobreviviente es candidata.
Se suben a ficha solo las que gatean algo.

**Falso positivo:** una decisión que el artefacto declara como tomada por el usuario, con la cita.
Ahí hay dueño.

---

## 7. `guarda-ausente-u-huerfana`

Dos caras del mismo descuido: una regla crítica que nadie va a verificar automáticamente, y una
verificación que sigue verde vigilando algo que ya no está en el camino.

**La pregunta para la huérfana, literal:** *¿qué guardas apuntaban a esto?* — se hace en toda
fase que reemplace o jubile un artefacto.

| Forma | Pregunta que la destapa |
|---|---|
| Una regla de la línea base sin verificación que la respalde | ¿Qué comando falla si alguien la incumple? |
| Una guarda que se describe pero no se ejecuta en CI | ¿Rompe el build, o es disciplina esperada? |
| Una fase que sustituye un componente | ¿Qué guardas apuntaban al viejo? ¿Se migran o se quedan verdes sobre un artefacto muerto? |
| Una guarda con excepciones sin justificar | ¿Cada excepción está documentada, o es un supresor silencioso? |
| Una regla que se promete "como remediación posterior" | ¿Qué etapa la implementa, y qué la gatea? |

**Cómo se ataca:** se cruza la lista de reglas críticas declaradas contra la lista de
verificaciones automáticas del plan. Toda regla sin verificación es media ficha; toda
verificación que apunta a algo que otra etapa reemplaza es la otra media.

**Falso positivo:** una regla que el artefacto declara explícitamente como no automatizable, con
el motivo y con el control humano que la sustituye.

---

## 8. `inferencia-encadenada`

Una sección construida sobre inferencias apiladas: cada paso es razonable y el conjunto no está
anclado a nada. **Una sección entera sin una sola afirmación trazable a lo declarado es la
señal**, y no se detecta leyendo frase a frase — solo mirando la sección completa.

| Forma | Pregunta que la destapa |
|---|---|
| Una sección sin ninguna marca `[declarado]` (o sin ningún `archivo:línea`) | ¿De dónde sale algo de esto? |
| Una conclusión que depende de tres suposiciones encadenadas | Si la primera es falsa, ¿qué queda en pie? |
| Vocabulario de dominio que el usuario nunca usó | ¿Quién nombró así esto? |
| Una arquitectura completa y coherente para un problema descrito en dos líneas | ¿Cuánto de esta forma vino del problema y cuánto de lo que suele hacerse? |

**Cómo se ataca:** se toma la sección, se listan sus afirmaciones ancladas, y si la lista queda
vacía o casi, la ficha es sobre **la sección**, no sobre sus frases. Es una ficha, no quince.

**Falso positivo:** una sección explícitamente propositiva, marcada como tal, que el artefacto
presenta para confirmación en el gate. Está pidiendo justo lo que la refutación pediría.

---

## Leer un plan al revés

Señales que no son refutaciones por sí mismas, pero que dicen dónde mirar.

| Señal | Qué significa realmente |
|---|---|
| El plan no tiene ninguna P abierta | O el dominio es trivial, o las dudas se resolvieron en silencio |
| Todas las etapas son del mismo tamaño | La granularidad se decidió por estética, no por el trabajo |
| "Fuera de alcance" está vacío o es genérico | Lo no listado como excluido volverá a entrar en una fase tardía |
| Cada criterio de aceptación cabe en una línea | Probablemente ninguno nombra su evidencia |
| El plan usa el vocabulario del revisor y no el del usuario | El artefacto se escribió desde la plantilla, no desde el problema |
| Muchas etapas, ninguna decisión extraída | Granularidad teatral: las mismas ambigüedades, repartidas en más chats |
| El handoff de una etapa cabe en dos líneas | La siguiente etapa va a releer el repo entero, o a inventar |
| Una fase sin ningún smoke intermedio | La verificación está toda al final, donde el fallo cuesta más |

---

## Frases-test

Ya calibradas en la suite; se usan literalmente porque son cortas y no admiten interpretación.

- *"Si el mecanismo estuviera roto, ¿este criterio fallaría?"*
- *"¿Qué guardas apuntaban a esto?"*
- *"Una decisión sin alternativas rechazadas no es una decisión, es una preferencia."*
- *"Un nombre no es evidencia."* — `validarDisponibilidad` puede no validar nada.
- *"¿Otra persona puede verificar esto abriendo lo que cito, sin repetir mi análisis?"*
- *"Se pregunta o se marca. Nunca se infiere."*
- *"Una premisa heredada es una hipótesis fechada, no un hecho."*

---

## Cuándo callarse

Tres situaciones en las que la objeción correcta es no escribir ficha:

1. **El artefacto ya lo declaró abierto.** Una P registrada, un `NO DETERMINADO` con motivo, una
   sección marcada como propositiva. El autor fue honesto ahí.
2. **La objeción no gatea nada.** Corregirla no cambia ninguna decisión ni detiene ningún
   trabajo. Va a notas menores, o no va.
3. **La objeción es sobre cómo está escrito.** Orden de secciones, vocabulario, formato. El
   artefacto es del autor; el contra-reporte no es una revisión de estilo.
