# Re-análisis incremental

Cómo se actualiza un corpus existente sin rehacerlo y sin dar por vigente nada que no se
revalidó. Se lee cuando Q6 de la entrevista es "re-ejecución".

## 1. El ancla

Cada ejecución registra la **referencia del código que analizó**. Sin eso, un corpus no se
puede actualizar: solo se puede tirar y rehacer.

Tabla **Anclas de ejecución** (una fila por ejecución):

| Propiedad | Contenido |
|---|---|
| `id` | `A-n` correlativo |
| `fecha` | Cuándo se ejecutó |
| `referencia` | Commit, tag, o hash del conjunto de archivos analizados |
| `repos` | Qué repos cubrió, con su referencia cada uno si son varios |
| `etapas` | Qué etapas del plan se ejecutaron bajo esta ancla |
| `alcance` | Qué quedó fuera por decisión (Q5), para no confundirlo después con un hueco |

**Sin control de versiones accesible**, el ancla es el hash del contenido de los archivos
analizados. Es más frágil (no distingue un cambio de formato de uno real) pero permite
detectar que algo cambió, que es lo único que el mecanismo necesita.

**Multi-repo:** una referencia por repo. Un corpus multi-repo con un solo ancla no puede
decir cuál de los lados cambió, y la etapa de integración es justo la que más lo necesita.

## 2. Caducidad de evidencias

Al arrancar una re-ejecución, antes de proponer nada:

1. Obtener los archivos modificados entre el `ancla` de cada entrada y el estado actual.
2. Marcar `por revalidar` **toda** entrada cuyo `respaldo` cite alguno de esos archivos.
3. Reportar el total y su distribución por bloque y por etapa.

**No se juzga si el cambio fue sustantivo.** Decidirlo requiere leer el cambio, y leerlo es
exactamente lo que hace la revalidación. "Parece cosmético" es la frase que precede a un
corpus que afirma cosas falsas con evidencia que ya no dice eso.

Casos que el cálculo debe distinguir, porque cada uno significa algo distinto:

| Situación | Efecto |
|---|---|
| El archivo cambió | Entrada → `por revalidar` |
| El archivo se movió o renombró | Entrada → `por revalidar`, motivo `ruta inexistente`. La línea citada ya no significa nada aunque el código sea idéntico |
| El archivo se eliminó | Entrada → `por revalidar`, **candidata a `obsoleto`**. No se marca obsoleta sin confirmar: la lógica pudo mudarse de sitio, y entonces el hecho sigue siendo cierto con otro respaldo |
| Hay archivos nuevos que ninguna entrada cita | **Hueco de cobertura**: superficie que el corpus no describe. Se propone la etapa que la cubriría |

Ese último caso es el que un chequeo ingenuo omite: fijarse solo en lo que caducó deja fuera
lo que nunca se documentó.

## 3. Re-ejecución selectiva

Con el cálculo anterior, la skill **propone** —no ejecuta (R2)— re-correr solo las etapas
afectadas, y la propuesta se justifica con datos, no con criterio:

```
Propuesta de re-ejecución (ancla previa A-3 → estado actual)

Etapa 2 · lógica de negocio · flujo de confirmación
  7 entradas por revalidar
  archivos modificados que las respaldan: 3
  perfil sugerido: frontier

Etapa 4 · integraciones
  2 entradas por revalidar
  archivos modificados que las respaldan: 1
  perfil sugerido: frontier

Sin cambios: etapas 1, 3 y 5 (0 entradas afectadas)

Hueco detectado: 2 archivos nuevos bajo el módulo de incidencias
  que ninguna entrada cita → etapa nueva propuesta
```

El usuario aprueba, ajusta o amplía. Si decide no re-correr una etapa afectada, sus entradas
**se quedan en `por revalidar`** — no vuelven a `vigente` por decisión de nadie. Un corpus
que declara qué no revalidó es utilizable; uno que asume vigencia no.

## 4. Qué hace una revalidación

Para cada entrada `por revalidar`, se relee la evidencia y hay exactamente tres desenlaces:

- **El hecho sigue siendo cierto** → se actualiza el `ancla` y, si la línea se movió, el
  `respaldo`. **No se crea una entrada nueva**: el `id` identifica al hecho, no a la lectura.
- **El hecho cambió** → la entrada pasa a `obsoleto` anotando el ancla en la que dejó de ser
  cierta, y la entrada nueva la referencia con `sustituye_a`. El par es el registro de que el
  sistema cambió; sin él, el corpus cuenta el presente como si siempre hubiera sido así.
- **El hecho ya no es determinable** → entrada `NO DETERMINADO` con su motivo, sustituyendo a
  la anterior. Perder capacidad de determinar algo también es información.

Lo que nunca se hace: **borrar la entrada y capturarla de nuevo**. Se pierden el `id`, el
historial y la trazabilidad de las proyecciones que la citaban.

## 5. Entradas de entrevista

**No caducan por cambio de código**: nadie invalida lo que dijo una persona modificando un
archivo. Pero se marcan **para revisión** —no `por revalidar` automáticamente— cuando el
bloque que describen cambió sustancialmente, y "sustancialmente" se define de forma
operativa para que no sea una impresión:

> Una entrada `entrevista` se marca para revisión cuando alguna entrada de procedencia
> `codigo` **de la misma entidad o flujo** pasó a `obsoleto` en esta re-ejecución.

Es decir: el código donde vivía lo que esa persona describía cambió de verdad, no solo se
tocó. Revisarla significa volver a preguntar, con la pregunta ya acotada: "esto lo confirmaste
en tal fecha; el flujo cambió aquí — ¿sigue siendo así?".

## 6. Efecto sobre las proyecciones

La tabla de **Cobertura por proyección** registra con qué ancla se emitió cada cobertura.
Cuando el corpus cambia:

1. Toda proyección emitida bajo un ancla anterior a las entradas modificadas queda
   **desactualizada**, y se reporta así, nombrando qué entradas la afectaron.
2. La skill **no regenera nada**: no produce archivos y no invoca renderizadores. Informa
   para que el usuario decida si vale la pena regenerar con `project-doc`, `project-deck` o
   la proyección de desempeño.
3. Si el cambio dejó **incompleta** una proyección que antes estaba completa (una entrada que
   la alimentaba quedó obsoleta sin sustituta), eso se declara como **bloqueo**, no como
   desactualización. La diferencia importa: una está vieja, la otra ya no se puede producir.

## 7. Antipatrones del incremental

1. **Dar por vigente lo no revalidado** porque el cambio "parece menor". Todo el mecanismo
   existe contra este impulso.
2. **Revalidar por lote sin leer** — marcar treinta entradas como vigentes tras mirar el
   resumen del cambio. Si no se abrió la línea, no se revalidó.
3. **Borrar y recapturar** — pierde `id`, historial y la trazabilidad de las proyecciones.
4. **Ignorar los archivos nuevos** — el corpus queda con evidencia fresca y cobertura vieja,
   que es la combinación más engañosa: parece actualizado.
5. **Re-correr todo por comodidad** — desperdicia el anclaje y, peor, vuelve a exponer a
   invención entradas que ya estaban verificadas y aprobadas en su gate.
