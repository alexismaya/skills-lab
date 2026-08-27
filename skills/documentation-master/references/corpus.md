# Contrato del corpus

> Los ejemplos usan un dominio ilustrativo (reserva de espacios y recursos compartidos).
> Es un universo sintético: ilustra la **forma** de cada entrada, no un sistema real ni un
> sector recomendado. La sintaxis de los fragmentos también es ilustrativa.

Este documento define **qué es una entrada de corpus**. Es el contrato que permite que un
renderizador consuma el corpus **sin saber cómo se produjo**, y que una sesión nueva retome
el proyecto sin releer el código.

La **interfaz mínima** que las demás skills de la suite pueden asumir (existencia de la
tabla, ownership, vocabulario de procedencia, campos legibles) vive en el contrato compartido
`interop-notion.md`. Aquí está el esquema completo, que es propiedad de `documentation-master`
y puede crecer sin enmendar el contrato de la suite.

## Índice

1. Campos de una entrada
2. Vocabularios cerrados
3. Cómo se escribe una `afirmacion`
4. `respaldo` por procedencia
5. `ancla` y caducidad
6. `NO DETERMINADO` como entrada de primera clase
7. Ciclo de vida de una entrada
8. Ejemplos: bien formada vs. mal formada
9. Contrato de lectura para renderizadores
10. Cabecera autodescriptiva

---

## 1. Campos de una entrada

| Campo | Obligatorio | Tipo | Notas |
|---|---|---|---|
| `id` | sí | texto | `C-n` correlativo del **proyecto**. Estable: sobrevive a re-ejecuciones y **nunca se reutiliza**, ni siquiera si la entrada quedó obsoleta |
| `bloque` | sí | selección | Vocabulario §2 |
| `afirmacion` | sí | texto | Una frase, un hecho. Reglas en §3 |
| `procedencia` | sí | selección | Vocabulario §2 |
| `respaldo` | sí | texto | Formato según procedencia, §4 |
| `ancla` | sí si `procedencia = codigo` | texto | §5 |
| `estado` | sí | selección | Vocabulario §2 |
| `entidad` | sí | relación | Repo, módulo o flujo al que pertenece. Relación **unidireccional** hacia las entidades del proyecto |
| `visibilidad` | sí | selección | `externa` / `interna`. §9 |
| `etapa` | sí | texto | Qué etapa del plan la produjo. Permite la re-ejecución selectiva |
| `p_relacionada` | no | texto | `P-n` si la entrada depende de una pregunta abierta |
| `sustituye_a` | no | texto | `id` de la entrada que esta deja obsoleta |

Los cuatro últimos no son adorno: `etapa` es lo que hace calculable la re-ejecución,
`p_relacionada` es lo que impide dar por firme algo que depende de una duda, y
`sustituye_a` es lo que convierte una tabla de hechos en un historial.

## 2. Vocabularios cerrados

**`bloque`** — `superficie` · `modelo-datos` · `logica-negocio` · `integraciones` ·
`zonas-oscuras` · `operacion` (capturado en entrevista dirigida, no extraído del código) ·
`pruebas` (aportado por `qa-discovery` / `qa-generator`) · `riesgo` (aportado por
`project-audit`) · `trayectoria` (aportado por `git-workflow`).

Los tres aportados por otras skills existen en el vocabulario aunque esta skill no los
produzca: el corpus tiene que poder declararlos **vacíos** para que la cobertura por
proyección sea honesta. Un bloque que no existe en el vocabulario no se puede reportar como
faltante.

`operacion` es el caso aparte, y conviene no confundirlo con los otros tres: **esta skill sí
lo llena, pero preguntando, nunca leyendo el código.** Sus entradas son de procedencia
`entrevista` con su respaldo (quién y cuándo); no llevan `ancla` porque no hay línea que
citar, y no caducan cuando el código cambia (`incremental.md`). Las de `pruebas`, en cambio,
son de procedencia `codigo` como cualquier otra: un archivo de prueba es evidencia
`archivo:línea` de pleno derecho.

**`procedencia`** — `codigo` · `entrevista` · `auditoria` · `historial`.

**`estado`** — `nuevo` (capturada en la ejecución en curso, aún sin gate) · `vigente`
(pasó su gate y su ancla sigue siendo válida) · `por revalidar` (el archivo evidenciado
cambió desde la captura) · `obsoleto` (se demostró que dejó de ser cierta).

**`visibilidad`** — `externa` (puede aparecer en un entregable que sale de la organización)
· `interna` (no sale: rutas de infraestructura, nombres de variables de credenciales,
hallazgos de riesgo, cualquier cosa cuyo valor para un atacante supere su valor para el
lector). Ante la duda, `interna`: el renderizador puede pedir permiso para subir una entrada
de nivel, pero no puede deshacer una publicación.

## 3. Cómo se escribe una `afirmacion`

**Una frase, un hecho, sin adjetivos ni intención.** La prueba de atomicidad: si al
convertirla en enunciado se puede marcar *verdadera* una mitad y *falsa* la otra, son dos
entradas.

Reglas prácticas:

- **Presente indicativo y sujeto concreto.** "El handler rechaza la solicitud cuando…", no
  "las solicitudes deberían rechazarse si…".
- **La condición va dentro de la afirmación.** Un hecho sin su condición es falso la mitad
  de las veces. "Aplica un recargo" es inútil; "aplica un recargo cuando la hora de inicio
  cae fuera del horario configurado del espacio" es una afirmación.
- **Sin cuantificadores que el código no declare.** "Siempre", "nunca" y "todos" solo se
  escriben si hay evidencia de que no hay otra rama. Si no se revisaron todas las rutas de
  entrada, el cuantificador correcto es el caso observado.
- **Nombres del sistema, no sinónimos.** Si el código llama `Solicitud` a la entidad, la
  afirmación dice `Solicitud`. Traducir a "pedido" o "petición" rompe la búsqueda y
  desincroniza el corpus del código.
- **Sin números de negocio inferidos.** El valor concreto se cita del código con su
  `archivo:línea` o no se escribe. Un umbral recordado de otra lectura es invención.

## 4. `respaldo` por procedencia

| Procedencia | Formato del respaldo | Ejemplo de forma |
|---|---|---|
| `codigo` | Una o varias referencias `ruta/archivo.ext:línea`; si el hecho se demuestra en dos puntos (declaración y uso), van los dos | `src/reservas/CalculadoraTarifa.ext:88` |
| `entrevista` | Quién lo afirmó y cuándo, en ese orden | `confirmado por la responsable del producto, 2026-08-20` |
| `auditoria` | Identificador del hallazgo en `project-audit` + su severidad | `hallazgo A-12, severidad alta` |
| `historial` | Referencia de commit, PR o incidente, con su fecha | `commit 4f2ab19, 2026-06-03` |

Una referencia `archivo:línea` sin línea no es respaldo suficiente para `logica-negocio`:
apuntar al archivo entero significa que nadie va a poder verificar la afirmación sin repetir
el trabajo. Para `superficie` puede bastar el archivo cuando la entrada describe el archivo
como unidad (p. ej. una definición de rutas), y en ese caso se dice explícitamente.

## 5. `ancla` y caducidad

El `ancla` es la **referencia del código en el momento de la captura**: commit, tag, o hash
del conjunto de archivos analizados cuando no hay control de versiones accesible. Sin ancla
no hay incremental posible — solo se puede rehacer.

Regla: **si el archivo referenciado en `respaldo` cambió entre el `ancla` y el estado
actual, la entrada pasa a `por revalidar` automáticamente.** No se juzga si el cambio fue
sustantivo: esa decisión requiere leer, y leer es precisamente lo que la revalidación hace.
Mecánica en `incremental.md`.

## 6. `NO DETERMINADO` como entrada de primera clase

Lo que no se pudo determinar **es una entrada del corpus**, no un hueco silencioso. Se
escribe con `afirmacion` que empieza literalmente por `NO DETERMINADO:` y declara **qué** no
se pudo determinar y **por qué**, con uno de estos motivos:

- `codigo-muerto` — la ruta existe pero no hay referencias vivas que la alcancen.
- `dependencia-externa` — el comportamiento lo decide un servicio de un tercero.
- `configuracion-fuera-del-repo` — depende de un valor que vive en el entorno, no en el árbol.
- `logica-en-base-de-datos` — la decisión ocurre en un trigger, una vista o un procedimiento
  almacenado al que no se tiene acceso desde el repo.

El `respaldo` de una entrada `NO DETERMINADO` es **el punto donde se corta el rastro**: el
`archivo:línea` de la última instrucción legible. Eso convierte el hueco en una pista
accionable: quien tenga acceso a lo que falta sabe exactamente por dónde entrar.

Y la consecuencia de R4, que se equivoca a menudo: **un dato que el usuario aportó en
entrevista no es `NO DETERMINADO`.** Es una entrada normal con procedencia `entrevista`. El
código no lo demuestra, pero alguien responde por él.

## 7. Ciclo de vida de una entrada

```
nuevo ──(gate aprobado)──> vigente ──(cambió el archivo)──> por revalidar
                              │                                  │
                              │                    (revalidación) │
                              │                    ┌─────────────┘
                              │                    ▼
                              └──(se demuestra que dejó de ser cierta)──> obsoleto
```

- **Una afirmación nunca se borra.** Se marca `obsoleto`, se anota el ancla en la que dejó
  de ser cierta, y la entrada nueva la referencia con `sustituye_a`. El par
  obsoleta→sustituta es la única evidencia de que el sistema cambió; borrar la vieja destruye
  esa información y deja al corpus contando el presente como si siempre hubiera sido así.
- **Una revalidación que confirma el hecho actualiza el `ancla`, no crea una entrada nueva.**
  El `id` es del hecho, no de la lectura.
- **Una entrada con `p_relacionada` abierta no puede estar `vigente`.** Si algo depende de
  una duda sin resolver, su estado honesto es `nuevo` o `por revalidar`.

## 8. Ejemplos: bien formada vs. mal formada

**Ejemplo 1 — intención vs. comportamiento**

| | |
|---|---|
| ❌ | `El servicio de proveedor garantiza que el estado del espacio siempre esté sincronizado.` |
| ✅ | `SyncEstadoProveedor actualiza el estado del Espacio solo cuando la respuesta del proveedor trae el identificador externo; si viene vacío, conserva el estado anterior.` |

Lo malo no es el optimismo: es que "garantiza" y "siempre" no son observables en el código.
La versión buena dice qué pasa en cada rama, que es lo que se puede demostrar.

**Ejemplo 2 — atomicidad**

| | |
|---|---|
| ❌ | `La confirmación valida el cupo, calcula la tarifa y notifica al solicitante.` |
| ✅ | Tres entradas: una por validación, una por cálculo, una por notificación — cada una con su `archivo:línea` |

La versión mala no se puede marcar obsoleta a medias. Cuando la notificación cambie, habrá
que decidir si toda la entrada dejó de ser cierta, y la respuesta será "más o menos".

**Ejemplo 3 — regla implícita**

| | |
|---|---|
| ❌ | (no registrar nada, porque el bloque `catch` está vacío) |
| ✅ | `ConfirmarReservaJob ignora los fallos del cliente del proveedor: el bloque catch no registra ni re-lanza, y la Reserva queda confirmada aunque la sincronización falle.` |

Un `catch` vacío es una regla de negocio no declarada. Es exactamente el tipo de hecho que
ningún documento del proyecto contiene y que la extracción sí puede demostrar.

**Ejemplo 4 — procedencia confundida**

| | |
|---|---|
| ❌ | `NO DETERMINADO: no se pudo determinar qué hace el equipo cuando la sincronización falla.` |
| ✅ | `Ante un fallo de sincronización, la operación se reintenta manualmente desde el panel de administración.` · procedencia `entrevista` · respaldo `confirmado por el responsable de operación, 2026-08-20` |

Marcar como indeterminado algo que alguien ya respondió hace que el corpus parezca más
débil de lo que es, y provoca que la siguiente ejecución vuelva a gastar en averiguarlo.

## 9. Contrato de lectura para renderizadores

Un renderizador (`project-doc`, `project-deck`, la proyección de desempeño) puede asumir
esto y solo esto:

**Garantías del corpus**

1. Toda entrada tiene `procedencia` y un `respaldo` con el formato de §4.
2. Ninguna entrada de procedencia `codigo` afirma comportamiento sin `archivo:línea`, salvo
   las `NO DETERMINADO`, que declaran su motivo.
3. `afirmacion` es atómica y sin prosa: se puede citar, agrupar y reordenar sin reescribirla.
4. `estado` refleja la vigencia respecto del `ancla`, no la confianza en el hecho.
5. Los `id` son estables entre ejecuciones, así que una proyección puede referenciarlos.
6. `visibilidad = interna` significa **no publicar**, no "publicar con cuidado".

**Lo que el corpus NO garantiza, y el renderizador debe resolver por su cuenta**

- **Orden narrativo.** Las entradas no vienen en el orden en que se cuentan a un lector.
- **Completitud.** El reporte de cobertura (`proyecciones.md`) dice qué falta; el corpus por
  sí solo no lo advierte.
- **Tono, agrupación por audiencia, títulos, índices.** Todo eso es del renderizador.
- **Tratamiento de `NO DETERMINADO`.** El corpus lo marca; cómo se muestra —nota al pie,
  advertencia, omisión— lo decide cada proyección.

**Regla de degradación:** si un renderizador encuentra una entrada que viola el contrato
(sin respaldo, con prosa, con procedencia vacía), no la corrige ni la interpreta: la reporta
como defecto del corpus y sigue. Corregir el corpus es de esta skill, no de quien lo lee.

## 10. Cabecera autodescriptiva

El corpus **declara en su propia cabecera las reglas que lo gobiernan**. La página `Corpus`
abre con un bloque fijo que enuncia, en corto:

- los valores posibles de `procedencia` y qué respaldo exige cada uno (§4);
- el formato del `ancla` y qué implica que una entrada la cite (§5);
- los estados posibles y qué transición produce cada uno (§2, §7);
- qué significa cada marca: `NO DETERMINADO` con sus motivos (§6), `visibilidad = interna`
  como **no publicar**, `obsoleto` como **dejó de ser cierta** y no como *borrada*.

El motivo es operativo, no ornamental: **el corpus se lee muchas más veces de las que se
escribe, y casi siempre desde una sesión que no cargó esta skill.** Quien abre la tabla para
retomar el proyecto tiene que poder heredar la disciplina de la tabla misma —qué puede dar
por demostrado, qué no puede publicar, qué tiene que revalidar antes de apoyarse en ello—.

De ahí la prueba: **un corpus que solo se entiende con la skill puesta está mal construido.**
Es un artefacto que funciona únicamente en presencia de su autor, y el corpus existe
precisamente para el caso contrario.

La cabecera se escribe **una vez, al crear el corpus**, y se actualiza solo cuando cambia el
esquema. No se repite por entrada ni por etapa, y no sustituye a este documento: enuncia las
reglas, no las justifica.
