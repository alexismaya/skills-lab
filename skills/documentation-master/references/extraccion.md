# Bloques de extracción: qué buscar y qué cuenta como evidencia

> Los ejemplos usan un dominio ilustrativo (reserva de espacios y recursos compartidos).
> Es un universo sintético: ilustra la **forma** de lo que se busca, no un sistema real ni un
> stack recomendado. Los fragmentos de código son pseudocódigo; el patrón no depende del
> lenguaje.

## Índice

1. Criterio de evidencia suficiente
2. Bloque: superficie
3. Bloque: modelo de datos
4. Bloque: lógica de negocio
5. Reglas implícitas (catálogo)
6. Bloque: integraciones
7. Bloque: zonas oscuras
8. Bloque: consolidación
9. Perfil de ejecutor por bloque
10. Técnicas por forma de alcance
11. Cierre de etapa

---

## 1. Criterio de evidencia suficiente

Antes de escribir cualquier entrada, la pregunta es siempre la misma: **¿otra persona puede
verificar esto abriendo lo que cito, sin repetir mi análisis?**

- Suficiente: la línea donde la decisión ocurre. Si la decisión se reparte entre una
  declaración y su uso, ambas.
- Insuficiente: el archivo entero para un hecho de lógica; el nombre de una función como
  prueba de lo que hace; un test como prueba del comportamiento de producción (el test prueba
  lo que el test ejercita, y eso es otra afirmación).
- **Un nombre no es evidencia.** `validarDisponibilidad` puede no validar nada. Lo que se
  cita es el cuerpo.
- **Un comentario es evidencia de la intención declarada, no del comportamiento.** Si el
  comentario y el código se contradicen, eso son dos entradas: el comportamiento (bloque
  `logica-negocio`) y la contradicción (bloque `zonas-oscuras`).

## 2. Bloque: superficie

**Qué extrae.** Los puntos por los que se entra al sistema: rutas HTTP, comandos de consola,
jobs programados, consumidores de cola, manejadores de eventos, tareas de arranque.

**Qué se registra por cada uno.** Firma real (verbo y ruta, o nombre del comando/job),
handler que lo atiende con su `archivo:línea`, y si tiene o no guarda de autenticación o
autorización —**verificada en el código**, no supuesta por convención del framework—.

**Trampas frecuentes.**
- Rutas registradas dinámicamente (por convención de nombres, por escaneo de directorios):
  no aparecen en el archivo de rutas. Si no se puede enumerar la lista completa, se declara
  el método de registro y se marca el conjunto como parcial.
- Rutas que existen pero nadie invoca. Eso pertenece a `zonas-oscuras`, no a superficie.
- Middleware aplicado en un grupo padre: la guarda existe pero no está en la línea de la
  ruta. Se cita la línea del grupo.

**Si existe `project-onboarding`:** este bloque ya está levantado. **No se rehace** (R3): se
valida contra el estado actual y se registran únicamente las desviaciones, cada una como
entrada de corpus con su evidencia.

## 3. Bloque: modelo de datos

**Qué extrae.** Entidades, relaciones, y la distancia entre el **esquema declarado** y el
**esquema realmente usado**.

Esa distancia es el valor del bloque. Lo que hay que buscar:

- **Migraciones huérfanas** — columnas creadas por una migración que ninguna consulta lee ni
  escribe. Se demuestra con la migración y con la ausencia de referencias al nombre.
- **Campos que el código llena pero el esquema no restringe** — un campo textual libre que
  en la práctica solo toma tres valores porque solo tres lugares lo escriben.
- **Restricciones que viven en el código y no en la base** — unicidad garantizada por una
  consulta previa en vez de por un índice. Es una regla real, y frágil: se registra como
  afirmación con la línea que la implementa.
- **Relaciones implícitas** — dos tablas atadas por un identificador sin llave foránea. Muy
  frecuente cuando el identificador cruza sistemas (`ocupante_id` en un sistema, `id` en
  otro): la relación existe en el código, no en el esquema.

**Evidencia.** Migración o definición de esquema **más** el punto de uso. Solo la migración
demuestra qué se declaró; solo el uso demuestra qué se usa.

## 4. Bloque: lógica de negocio

Es el bloque caro y el que justifica la skill. Se aplica a los flujos que Q4 marcó como
profundos, no a todo el árbol.

**Método: seguir la decisión, no leer el archivo.** Se entra por el punto de superficie y se
avanza por la traza de ejecución, registrando en orden:

1. **Validaciones** — qué se rechaza, con qué condición, y qué responde el sistema al
   rechazar. Incluye el **orden**: una validación que corre después de un efecto secundario
   no protege de ese efecto.
2. **Decisiones** — cada bifurcación con su condición literal. Las ramas que no se toman
   también son información: "no existe rama para X" es una afirmación verificable.
3. **Efectos secundarios** — escrituras, envíos, encolamientos, llamadas externas — con su
   posición respecto del punto de no retorno del flujo.
4. **Estados** — qué transiciones existen, cuáles son alcanzables desde dónde, y cuáles están
   declaradas pero sin transición que las produzca.
5. **Cálculos** — la fórmula tal como está escrita, con sus condiciones. Si el cálculo no es
   proporcional (un total que no es el periodo multiplicado por la cantidad), eso es
   exactamente lo que hay que registrar, porque es lo que nadie recuerda bien.

**Regla de la rama no leída.** Si una condición depende de un valor que no se pudo resolver
(configuración de entorno, respuesta externa), la afirmación describe la rama observada y
declara la otra como `NO DETERMINADO` con su motivo. Nunca se resume como "según la
configuración, hace una cosa u otra": eso no informa a nadie.

## 5. Reglas implícitas (catálogo)

Reglas de negocio reales que ningún documento del proyecto declara. Buscarlas explícitamente
en cada flujo profundo:

| Patrón | Qué regla esconde |
|---|---|
| Retorno temprano sin registro | "En este caso no se hace nada, y nadie se entera" |
| `catch` vacío o que solo registra | "Este fallo se ignora y el flujo continúa como si hubiera funcionado" |
| Valor por defecto en la lectura de configuración | El comportamiento real cuando la variable no está definida — que suele ser el de producción de otro entorno |
| Coerción o comparación laxa de tipos | Entradas que se aceptan sin que nadie lo haya decidido |
| Cortocircuito en una condición compuesta | Una validación que no llega a ejecutarse cuando la anterior es falsa |
| Llamada externa sin tiempo de espera | "Este flujo se bloquea indefinidamente si el tercero no responde" |
| Guarda por entorno (`si es producción…`) | Dos comportamientos distintos del mismo código |
| Bandera de funcionalidad sin ruta de retirada | Una rama viva que nadie considera parte del sistema |
| Reintento sin idempotencia | Efectos duplicados bajo fallo parcial |

Ejemplo de forma —cómo se registra un `catch` mudo—:

```
// pseudocódigo ilustrativo
try {
    proveedorClient.sincronizar(reserva)
} catch (e) {
    // vacío
}
reserva.confirmar()
```

Entrada de corpus: *"`ConfirmarReservaJob` confirma la `Reserva` aunque la sincronización con
el proveedor falle: el bloque `catch` no registra ni re-lanza"*, bloque `logica-negocio`,
respaldo con las dos líneas (el `catch` y la confirmación posterior).

## 6. Bloque: integraciones

**Qué extrae.** APIs consumidas y expuestas, colas, webhooks, trabajos que hablan con
terceros, y cómo se comporta el sistema cuando el otro lado falla.

Por cada integración: dirección (entrante/saliente), protocolo, **dónde se configura el
destino**, qué se envía y qué se espera, y —lo más valioso— **qué pasa ante fallo**:
¿reintenta?, ¿con qué límite?, ¿deja el flujo a medias?, ¿hay compensación?

**Credenciales: se registra el nombre de la variable o del secreto referenciado, nunca su
valor.** Si un valor aparece hardcodeado en el código, eso no se transcribe al corpus: se
registra la afirmación de que existe un secreto en claro, con su `archivo:línea`,
`visibilidad = interna`, y se escala como P-n. El corpus documenta el problema sin
republicarlo.

**Contratos reales vs. declarados.** Una especificación de API describe lo que se prometió.
La evidencia de lo que ocurre está en el cliente y en el handler. Cuando difieren, la
afirmación describe el comportamiento e incluye la discrepancia como entrada de
`zonas-oscuras`.

## 7. Bloque: zonas oscuras

Cuatro cosas, y todas son entregables, no residuos:

- **Código muerto** — sin referencias vivas. Se demuestra con la ausencia de referencias al
  símbolo; la búsqueda usada se declara, porque una búsqueda incompleta produce un falso
  positivo (invocación dinámica, registro por convención, uso desde otro repo).
- **Duplicidad** — dos implementaciones del mismo cálculo o de la misma validación. Se citan
  ambas. Si divergen, la divergencia **es** el hallazgo: el sistema se comporta distinto
  según por dónde se entre.
- **`NO DETERMINADO`** — con su motivo y el punto donde se corta el rastro (`corpus.md` §6).
- **Contradicciones** entre documentación e implementación — el `README`, un comentario o una
  especificación afirmando algo que el código no hace. Se citan las dos fuentes.

## 8. Bloque: consolidación

Última etapa de cualquier plan. No extrae: normaliza.

- Verifica que **toda** entrada cumpla el contrato (`corpus.md`): procedencia, respaldo,
  ancla, atomicidad.
- **Deduplica** entradas que dos etapas capturaron desde ángulos distintos, conservando el
  `id` más antiguo y fusionando respaldos.
- Detecta **contradicciones internas** del corpus: dos entradas vigentes que no pueden ser
  ciertas a la vez. No se resuelven por criterio propio — se registran como P-n.
- Emite la **cobertura por proyección** (`proyecciones.md`) y la lista de bloques faltantes
  con su skill responsable.

## 9. Perfil de ejecutor por bloque

Cada etapa declara qué perfil requiere, para no gastar capacidad de juicio en transcripción
ni transcribir donde hace falta juicio.

| Bloque | Perfil | Por qué |
|---|---|---|
| Superficie | intermedio | Enumeración con criterio acotado; el riesgo es la exhaustividad, no la interpretación |
| Modelo de datos | intermedio | Salvo el contraste declarado vs. usado, que sube a frontier si el esquema es grande |
| Lógica de negocio | **frontier** | Seguir trazas, detectar reglas implícitas y resistir la tentación de completar el patrón |
| Integraciones | frontier | El comportamiento ante fallo casi nunca está declarado; hay que inferirlo de la estructura del código sin inventarlo |
| Zonas oscuras | frontier | Un falso positivo de código muerto es caro y creíble |
| Consolidación | bajo coste | Verificación mecánica contra un contrato explícito |
| Etapa de integración multi-repo | **frontier** | Reconciliar contratos reales entre repos es el trabajo con más superficie de error |

El perfil es una recomendación por defecto, no una barrera: si el usuario ejecuta todo con
el mismo ejecutor, la skill funciona igual. Lo que no debe pasar es lo contrario —asignar el
bloque de lógica de negocio a un ejecutor barato y presentar el resultado como equivalente.

## 10. Técnicas por forma de alcance

> **Alcance puntual — leer primero.** Si el alcance es uno o pocos archivos, un módulo
> aislado y sin proyecciones previstas, el SKILL.md §Camino corto define un proceso reducido:
> sin plan de etapas, sin gates intermedios, sin reporte de cobertura. En ese caso no aplica
> lo que sigue; regresar aquí solo si el camino corto no aplica o si el usuario lo descartó.

**Un repo.** Etapas secuenciales por bloque. La superficie se levanta primero porque ancla
todo lo demás: sin puntos de entrada, la lógica de negocio no tiene por dónde empezar.

**Flujo transversal.** Se parte del punto de entrada del flujo y se avanza por tramos. Cada
tramo cierra donde el control cambia de proceso (una llamada a otro servicio, un encolamiento,
un trabajo diferido). Ese corte natural es también el corte de etapa: el estado que cruza la
frontera es lo que se documenta en el handoff. **Lo que el flujo no toca queda fuera aunque
viva en el repo.**

**Multi-repo.** Una pasada por repo y una etapa final de integración que compara los
contratos **observados** en ambos lados. Qué buscar ahí:

- El mismo concepto con nombre distinto en cada repo, y el punto de traducción entre ambos.
- Un identificador que en un sistema es estable y en el otro se regenera con cierta operación.
- Campos que un lado envía y el otro ignora, o que el otro exige y el primero omite.
- Suposiciones de orden temporal: un repo que asume que el otro ya escribió.

Una incompatibilidad **observada** lleva evidencia de los dos lados. Una incompatibilidad
teórica ("podría pasar que…") no es un hallazgo: si acaso, es una P-n.

## 11. Cierre de etapa

Toda etapa cierra igual, sin importar su bloque:

1. **Hallazgos** — las entradas de corpus escritas, con su `id`.
2. **Evidencia** — cada entrada con su respaldo verificable y el `ancla` de la ejecución.
3. **Preguntas abiertas** — las P-n nuevas, cada una declarando **qué bloquea**.
4. **Cobertura declarada** — qué se cubrió del tramo y qué quedó fuera, distinguiendo lo
   excluido por decisión (Q5) de lo indeterminado (`NO DETERMINADO`).
5. **Handoff** — lo que la etapa siguiente necesita saber para arrancar en un chat nuevo.
6. **Gate** — el usuario revisa y aprueba. Hasta entonces las entradas quedan en `nuevo` y
   la etapa siguiente no arranca (R2).
