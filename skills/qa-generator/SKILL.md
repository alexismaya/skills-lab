---
name: qa-generator
description: "Materializa en código de prueba concreto el \"Contexto de handoff\" que produce qa-discovery. Úsala SIEMPRE que un desarrollador ya haya corrido qa-discovery y elegido una opción (A–E), o cuando pida \"genera las pruebas de X\", \"escribe los tests unitarios / de integración / e2e\", \"prepara la base de testing\", o \"materializa el handoff\" de un módulo ya analizado. Opera en cuatro modos alineados a qa-discovery — unitario, integracion, e2e, infraestructura — y NUNCA genera un test sin un handoff trazable a una superficie del mapa de discovery. Usa el runner de pruebas del stack declarado en el handoff, sin imponer ninguno. Si no existe handoff de discovery, detente y remite a qa-discovery primero. Es el segundo eslabón obligatorio del ciclo de QA de esta suite."
---

# QA Generator

Segundo eslabón del ciclo de QA de esta suite, companion de `qa-discovery`. Discovery **decide qué
probar** y emite un mapa de superficies + un bloque de handoff. Generator **materializa el cómo**
(código de prueba concreto), sin re-decidir el alcance y sin salirse del mapa.

Regla rectora: **map-before-generate.** Todo test nace de una superficie del mapa de discovery y
traza de vuelta a ella. No hay tests huérfanos.

Esta skill es **agnóstica de stack**: el lenguaje, el framework y el runner de pruebas vienen
declarados en el handoff (Paso 1.0 del discovery). No impone herramienta; aplica las convenciones
del stack declarado.

---

## Precondición: el handoff de discovery

La entrada de esta skill es el **"Contexto de handoff — qa-generator"** que qa-discovery produce en
su Paso 5:

```
Modo:      unitario | integracion | e2e | infraestructura
Target:    módulo / controlador / flujo / componente
Stack:     lenguaje, framework, BD, runner de pruebas, externos
Archivos clave identificados: [rutas]
Pre-requisitos detectados:    constructor de datos faltante / doble / variable de entorno
Contexto de negocio:          descripción del flujo en el vocabulario del proyecto
```

- **Si el handoff existe:** procede con el protocolo.
- **Si NO existe:** detente. No improvises el alcance ni el modo. Remite a `qa-discovery` para
  producir el mapa y el handoff, y explica por qué (generar sin discovery da cobertura sin criterio
  de riesgo ni trazabilidad).
- **Si el handoff no declara stack:** detente y pídelo. Generar contra un stack supuesto produce
  código que no corre.
- **Si el Target no aparece en la Tabla de Superficies de discovery:** no lo generes. Márcalo como
  gap y sugiere volver a discovery para incorporarlo con su prioridad de riesgo.

---

## Protocolo (6 pasos)

1. **Parsear el handoff.** Extrae `Modo`, `Target`, `Stack`, `Archivos clave`, `Pre-requisitos`,
   `Contexto de negocio`.
2. **Confirmar el modo.** Usa el `Modo` del handoff. Si viniera vacío, derívalo del tipo de
   superficie; si es ambiguo, pregunta una sola vez con opciones.
3. **Resolver pre-requisitos.** Si el handoff lista pre-requisitos (constructor de datos faltante,
   doble, config de entorno de test) y el modo NO es `infraestructura`:
   - Si son triviales y locales al test, créalos en línea.
   - Si son cimientos compartidos (base de testing, constructores de las entidades clave),
     **detente y recomienda correr `modo=infraestructura` primero** (opción D de discovery). No
     generes sobre una base inexistente.
4. **Cargar la referencia del modo.** Lee `references/<modo>.md` y sigue sus patrones, traduciendo
   al stack declarado. No mezcles modos en un mismo archivo.
5. **Generar con trazabilidad.** Produce el código y una entrada en `templates/trazabilidad.md` que
   liga cada test a la **superficie** de discovery (por su nombre en la Tabla, no por un ID
   inventado).
6. **Reportar.** Resume: superficies cubiertas, archivos creados, pre-requisitos resueltos o
   pendientes, y qué quedó bloqueado.

---

## Modos (alineados a qa-discovery)

| Modo | Cubre | Herramienta | Referencia |
|---|---|---|---|
| `unitario` | Reglas de negocio, validaciones, edge cases, componentes | Runner unitario del stack | `references/unitario.md` |
| `integracion` | Endpoints + BD, contratos entre servicios, efectos de infraestructura observables | Runner de integración del stack | `references/integracion.md` |
| `e2e` | Flujos de navegador end-to-end por rol/tenant | Herramienta de e2e del entorno (ver § Delegación de e2e) | `references/e2e.md` |
| `infraestructura` | **Base de testing**: config de entorno de test, clase base, constructores de datos, semillas | Andamiaje de pruebas | `references/infraestructura.md` |

`infraestructura` es distinto de la observabilidad de efectos externos: prepara los cimientos que
desbloquean los otros modos (opción D de discovery). Las aserciones sobre almacenamiento y logs
viven en `integracion`.

---

## Delegación de e2e

El modo `e2e` **no produce el archivo de test final**: produce **specs de escenario** (contrato en
`references/e2e.md`) y las delega a la herramienta o skill de e2e disponible en el entorno del
usuario — igual que el resto de la suite trata las herramientas del entorno (ver la tabla de
equivalencias por runtime en `references/interop-notion.md`).

- Si el entorno ofrece una skill o CLI de e2e, entrégale las specs en el formato que consuma.
- Si no ofrece ninguna, **notifícalo al usuario** y materializa las specs con el runner de e2e que
  el handoff declare, siguiendo la guía mínima de `references/e2e.md`. El modo sigue siendo
  ejecutable; lo que cambia es quién escribe el archivo final.

Nunca des por hecho que una herramienta externa existe.

---

## Trazabilidad (superficie → test)

Discovery nombra superficies de forma descriptiva (p. ej. `POST /api/solicitudes`,
`Controller@confirmarReserva`), sin IDs persistentes. Traza por ese nombre:

- **Nombre del test: descriptivo** (nunca `test_1`), del comportamiento, no de la implementación.
- **Traza explícita** a la superficie con un comentario y/o agrupación. El ejemplo usa una sintaxis
  concreta a modo ilustrativo; tradúcelo al stack declarado:

```php
// discovery: POST /api/solicitudes  (Tabla de Superficies)
it('rechaza reservar un espacio no habilitado para el tenant', function () { /* ... */ })
    ->group('solicitudes');
```

- Registra la fila en `templates/trazabilidad.md`: superficie → archivo → modo → estado. Esto hace
  visible la deuda: superficies de riesgo alto aún sin materializar.

---

## Lo que qa-generator NUNCA emite (anti-patrones de discovery)

- Tests que llaman **APIs reales**; usa el interceptor de red del stack o dobles.
- Tests de integración **sin aislamiento de estado** entre sí (contaminación).
- **Constructores que persisten en tests unitarios** (tocan BD, son lentos); en unitario, construir
  en memoria.
- **Esperas por reloj en e2e**; esperar por estado.
- Tests apuntando a BD o servicios reales por falta de config de entorno de test.
- Nombres genéricos (`test_1`, `it_works`) o que verifican cinco cosas a la vez.
- Fixtures estáticos donde corresponden **constructores de datos**.

---

## Doble eje (solo si el módulo forma parte de un ecosistema de repos)

Cuando el módulo no se despliega aislado sino como parte de un ecosistema de servicios que se
consumen entre sí, cada test declara su modo de ejecución:

- **Standalone:** dependencias sustituidas por dobles generados desde el **contrato versionado**
  (especificación de API) — servidor de simulación local.
- **Ecosistema:** contrato real contra la dependencia desplegada, versión fijada.
- **Drift de contrato:** si standalone pasa contra el doble pero ecosistema falla el mismo
  contrato, es doble desactualizado (clase de fallo distinta), no bug de negocio.

Si el módulo se prueba solo, ignora este eje.

---

## Salida esperada

- Archivos de test en la ubicación convencional del stack declarado.
- Manifiesto de trazabilidad actualizado.
- Resumen: superficies cubiertas, pre-requisitos resueltos/pendientes, bloqueos.

---

## Archivos de referencia

Lee la referencia del modo activo antes de generar:
- `references/unitario.md` — aislamiento sin E/S; reglas, validaciones, edge cases, componentes.
- `references/integracion.md` — endpoints con BD y aislamiento de estado, contract tests, efectos
  de infraestructura observables, máquinas de estado.
- `references/e2e.md` — contrato de spec de escenario, delegación a la herramienta del entorno,
  flujos críticos, esperas por estado.
- `references/infraestructura.md` — base de testing: config de entorno de test, clase base,
  constructores de datos y semillas faltantes.
- `references/interop-notion.md` — contrato compartido de la suite. Aquí se consulta por su
  **tabla de equivalencias por runtime**: cómo se resuelve una herramienta del entorno según el
  runtime activo. Leer antes de delegar el modo `e2e`.

Plantilla:
- `templates/trazabilidad.md` — manifiesto superficie → test → modo → estado.
