# Patrones de stack — artefacto → tipo de prueba

Referencia agnóstica de stack: **el mapa de qué tipo de prueba corresponde a cada clase de
artefacto no depende del lenguaje**. Lo que cambia por stack son las rutas donde viven los
artefactos y el nombre de la herramienta.

Leer cuando el repo tenga estructura no convencional, o cuando no quede claro qué tipo de test
aplica a un artefacto concreto.

---

## 1. Detectar el stack antes de aplicar convenciones

Ningún paso del discovery asume un stack. El orden es siempre: **detectar → confirmar con el
usuario → aplicar las convenciones de ese stack**.

Señales de detección, en orden de fiabilidad:

| Señal | Qué revela |
|---|---|
| Manifiesto de dependencias en la raíz | Lenguaje, framework y versiones. Es la fuente primaria |
| Archivo de lock | Versiones reales resueltas (más fiable que el manifiesto) |
| Config del runner de tests | Qué framework de pruebas ya existe y qué suites define |
| Config de CI | Qué se ejecuta de verdad en el pipeline |
| Estructura de directorios de primer nivel | Convención del framework (si sigue una) |
| Config de contenedores | Servicios de apoyo: base de datos, cachés, colas |

**Si la detección es ambigua o el stack no aparece en este documento, preguntar al usuario y
registrar la respuesta.** No inferir convenciones de un framework que no se verificó.

---

## 2. Mapa: artefacto → tipo de prueba (agnóstico)

Los nombres de artefacto son conceptuales. Traducirlos al vocabulario del stack detectado.

| Artefacto | Tipo de test | Notas |
|---|---|---|
| Entidad/modelo con lógica propia (cálculos, derivados) | Unitario | Sin base de datos; probar la lógica con valores en memoria |
| Entidad/modelo con relaciones | Integración | Necesita el fixture/factory de la entidad relacionada |
| Validador de entrada / esquema de request | Unitario | Instanciar el validador aislado |
| Controlador / handler de endpoint | Integración | Recorrido completo con autenticación real del framework |
| Servicio de dominio sin E/S | Unitario | Inyectar dependencias como dobles |
| Servicio que llama a un tercero | Integración con doble | **Siempre** interceptar la llamada externa |
| Job / tarea encolada | Integración | Verificar despacho y ejecución **por separado** |
| Evento / suscriptor | Integración | Verificar que el evento se emite, y aparte que el suscriptor actúa |
| Comando de CLI | Integración | Ejecutar el comando y aseverar código de salida y efecto |
| Política / regla de autorización | Unitario | Probar cada capacidad **y su negación** |
| Middleware / interceptor | Integración | Petición real que atraviese la cadena |
| Componente de UI presentacional | Unitario | Props de entrada → render de salida; sin efectos |
| Componente de UI con estado | Unitario | Simular la interacción del usuario, no el estado interno |
| Hook / composable / lógica de UI reutilizable | Unitario | Probar en aislamiento |
| Función pura de transformación | Unitario | Entrada/salida; sin dependencias |
| Cliente HTTP propio | Unitario | Doble en la capa de red |
| Flujo crítico de negocio completo | E2E | Pocas pruebas; happy path + 1–2 casos de error |
| API multi-tenant | Integración | Probar el cambio de tenant **explícitamente** |
| Contrato entre dos servicios | Contrato / integración | Validar el esquema de request y de response |

Regla transversal: **si el artefacto necesita red, disco o base de datos para ejercitarse, no es
unitario.** Es el único criterio que no cambia entre stacks.

---

## 3. Convenciones por stack

Los stacks siguientes son **ejemplos de cómo se rellena esta sección**, no una lista de stacks
soportados. Si el proyecto usa otro, se documenta el suyo con el mismo formato y se registra como
lección.

```markdown
### {stack detectado}
- **Runner de tests:** {herramienta} · **Config:** {archivo}
- **Ubicación de tests:** {ruta unitarios} · {ruta integración} · {ruta e2e}
- **Aislamiento de base de datos entre tests:** {mecanismo}
- **Doble de servicios externos:** {mecanismo}
- **Datos de prueba:** {mecanismo de factories/fixtures}
- **Config de entorno de test:** {archivo}
```

### Ejemplo A — stack con framework backend por convención + SPA

- **Runner:** uno para backend, otro para frontend · configs separados
- **Ubicación:** `tests/Unit/`, `tests/Feature/`, `e2e/`
- **Aislamiento de BD:** trait/utilidad del framework que revierte la transacción por test
- **Doble de externos:** interceptor HTTP del framework
- **Datos de prueba:** factories con estados semánticos
- **Config de entorno de test:** archivo de entorno dedicado, **nunca el de desarrollo**

### Ejemplo B — stack sin convención de directorios impuesta

- **Runner:** uno solo, con marcadores para separar suites
- **Ubicación:** tests junto al módulo que prueban
- **Aislamiento de BD:** contenedor efímero levantado por la suite
- **Doble de externos:** biblioteca de intercepción a nivel de transporte
- **Datos de prueba:** constructores de objetos de prueba
- **Config de entorno de test:** variables inyectadas por el runner

---

## 4. Patrones que cruzan cualquier stack

### Multi-tenancy

Si el proyecto aísla datos por tenant:

- Los tests de integración **deben** fijar el tenant activo antes de cada prueba.
- Crear una clase base de test que lo haga una sola vez.
- Probar **explícitamente** que un tenant no accede a datos de otro. Es el test que nadie escribe
  y el fallo que nadie detecta hasta que ya pasó.

```
// Forma del caso, en pseudocódigo — traducir al stack
test "un actor del tenant A no puede leer un recurso del tenant B":
    recurso  = crear_recurso(tenant: B)
    respuesta = como(tenant: A).obtener("/recursos/{recurso.id}")
    esperar respuesta.estado en (403, 404)   // nunca 200
```

### Servicios externos

Interceptar **siempre**, en la capa más baja posible (transporte HTTP), no sustituyendo el
servicio propio que se quiere probar. Guardar las respuestas de ejemplo como fixtures
versionados, de modo que se puedan actualizar cuando el contrato del tercero cambie.

### Trabajos asíncronos

Dos pruebas distintas, nunca una sola:

1. **Que se despacha** — la operación encola el trabajo (sin ejecutarlo).
2. **Que hace lo suyo** — el trabajo, ejecutado en aislamiento, produce el efecto esperado.

Mezclarlas produce un test que pasa aunque la cola no esté configurada.

### Formularios y validación en cliente

- **Unitario:** validación de campos, formateo, mensajes de error.
- **E2E:** el recorrido completo hasta la respuesta del servidor.

No probar en E2E lo que se puede probar unitario: cuesta un orden de magnitud más y falla por
razones de infraestructura.

---

## 5. Estructura de tests — forma, no ruta

Lo que importa no es la ruta sino la separación:

```
{raíz de tests}
├── {unitarios}        ← sin E/S; por capa o por módulo
├── {integración}      ← con BD y dobles de externos
├── {fixtures}         ← respuestas de ejemplo de terceros, versionadas
└── {e2e}
    ├── {flujos}       ← un archivo por flujo de negocio
    └── {objetos de página}  ← selectores centralizados, nunca repetidos por test
```

La única regla estructural firme: **los selectores de E2E viven en un solo lugar.** Repetidos por
archivo, un cambio de UI rompe N tests en vez de uno.
