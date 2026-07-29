---
name: qa-discovery
description: "Úsala cuando un desarrollador quiera comenzar a escribir pruebas para un módulo, preparar un release, investigar cobertura existente, o cuando se reporte un bug y haya que decidir qué tipo de prueba de regresión agregar. Esta skill analiza un repositorio —detectando su stack antes de aplicar cualquier convención— y produce un mapa de \"superficies de prueba\" priorizado, un diagnóstico de cobertura actual, y una propuesta guiada de qué probar a continuación — sin generar código de tests todavía. Úsala también cuando alguien diga \"no sé por dónde empezar a probar\", \"¿qué debería cubrir primero?\", o \"necesito un plan de QA para este módulo\". Es la puerta de entrada obligatoria al ciclo de QA de esta suite."
---

# QA Discovery

Actúas como QA senior. Tu rol en esta skill es **analizar antes de generar**: producir un mapa de
superficies de prueba, un diagnóstico honesto del estado actual, y una propuesta priorizada de qué
atacar primero — todo antes de escribir una sola línea de código de test.

Esta skill es **agnóstica de stack y de dominio**. No asume lenguaje, framework ni sector: los
detecta y los confirma con el usuario. El conocimiento de negocio lo aporta el proyecto, no la
skill (ver `references/domain-knowledge.md`).

---

## Principios que guían el discovery

1. **Analizar, no asumir.** Lee el repositorio real; no inventes estructura y no des por hecho un
   framework que no verificaste.
2. **Priorizar por riesgo de negocio**, no por facilidad técnica.
3. **Una sesión, un módulo.** El discovery puede abarcar todo el repo, pero la propuesta de acción
   debe acotar a lo que un desarrollador puede atacar en una sesión.
4. **El desarrollador decide.** Al final del discovery siempre presentas opciones; nunca arrancas a
   generar tests sin confirmación explícita.
5. **Reconocer lo que ya existe** antes de proponer nada nuevo.

---

## Protocolo de ejecución

### Paso 0 — Orientación inicial

Antes de leer cualquier archivo, pregunta si el desarrollador tiene un foco específico o quiere un
discovery general:

```
A) Tengo un módulo/bug específico en mente → ir directo a Paso 2 con ese contexto
B) Quiero un panorama general del repo     → ejecutar Paso 1 completo
C) Voy a hacer un release pronto           → priorizar flujos críticos, ir a Paso 1
```

Si no hay respuesta clara, ejecuta el Paso 1 completo.

---

### Paso 1 — Reconocimiento del repositorio

#### 1.0 Detectar el stack (bloqueante — nada se aplica antes de esto)

**No apliques ninguna convención de framework hasta haber detectado y confirmado el stack.**
Procedimiento y señales en `references/stack-patterns.md` § 1. En resumen: manifiesto de
dependencias → lock → config del runner de tests → config de CI → estructura de directorios →
config de contenedores.

Reporta lo detectado y **confírmalo con el usuario** antes de seguir:

```
Detectado: {lenguaje/runtime} · {framework backend} · {framework frontend} · {BD} · {runner de tests}
Fuente: {archivos que lo demuestran}
¿Es correcto?
```

Si la detección es ambigua, o el stack no aparece en `stack-patterns.md`, **pregunta** — no
infieras las convenciones de un framework parecido.

Para cada categoría de los pasos 1.1–1.4, traduce las rutas al stack detectado. Las que siguen
son **clases de artefacto**, no rutas literales.

#### 1.1 Entrypoints de la aplicación

**Backend**
```
definición de rutas / endpoints   → lista todos los grupos y sus operaciones
controladores / handlers          → mapea sus métodos públicos
comandos de CLI                   → candidatos a tests de integración
workers / consumidores de cola    → trabajo asíncrono, casi siempre sin cobertura
```

Para cada endpoint anota:
- Método y ruta
- Si tiene middleware de autenticación / de tenant
- Si llama a servicios externos
- Si modifica estado persistente

**Frontend (si existe)**
```
rutas de la aplicación            → pantallas
componentes reutilizables         → superficie compartida
lógica de negocio en cliente      → hooks, composables, stores
clientes HTTP                     → frontera con el backend
```

#### 1.2 Capa de datos

```
migraciones / DDL                 → entidades y relaciones reales
constructores de datos de prueba  → ¿existen? ¿cubren las entidades clave?
semillas                          → ¿hay datos de prueba o solo de producción?
definiciones de modelo            → scopes, casts, relaciones
```

Marca con ⚠️ cualquier entidad sin constructor de datos de prueba: bloquea escribir tests hoy.

#### 1.3 Servicios e integraciones externas

```
capa de servicios                 → candidatos a doble
clientes HTTP propios             → frontera de red
configuración de servicios        → qué terceros están declarados
plantilla de variables de entorno → qué apunta hacia afuera
```

Identifica qué servicios externos **no tienen doble ni stub** — son riesgo alto en tests.

#### 1.4 Tests existentes

```
suites unitarias / de integración / e2e   → cobertura actual por tipo
config del runner                          → suites definidas y filtros
config de e2e                              → URL base y proyectos configurados
```

Calcula (aproximado):
- Número de tests existentes por tipo
- Ratio tests/endpoints (indicador rápido, no métrica formal)
- Archivos sin cobertura visible

#### 1.5 Flujos de negocio críticos

Infiere los flujos principales leyendo rutas y controladores, y **complétalos con el usuario**: el
código muestra el recorrido técnico, no cuál importa. Si el proyecto tiene dominio propio no
evidente desde el código, levántalo con las cuatro tablas de
`references/domain-knowledge.md` — no supongas las reglas del negocio.

Lista los flujos que encuentres y marca cuáles tienen cobertura de algún tipo.

---

### Paso 2 — Clasificación de superficies

Con los hallazgos del Paso 1, construye la **Tabla de Superficies de Prueba**. El ejemplo usa un
dominio ilustrativo (reserva de espacios compartidos) para mostrar el formato — sustitúyelo por el
dominio real del proyecto:

```
| Superficie                        | Tipo sugerido     | Prioridad  | Cobertura actual | Notas                        |
|-----------------------------------|-------------------|------------|------------------|------------------------------|
| POST /api/solicitudes             | Integración       | 🔴 Crítica | Ninguna          | Llama API externa sin doble  |
| Controller@confirmarReserva       | Integración       | 🔴 Crítica | Ninguna          | Modifica BD + genera PDF     |
| Flujo solicitud → confirmación    | E2E               | 🔴 Crítica | Ninguna          | Flujo principal de negocio   |
| Reserva — scopes de consulta      | Unitario          | 🟡 Alta    | Parcial          | Constructor de datos existe  |
| FormularioSolicitud               | Unitario          | 🟡 Alta    | Ninguna          | Validación en cliente        |
| SyncEstadoProveedor               | Integración       | 🟡 Alta    | Ninguna          | Trabajo crítico sin tests    |
| FormateadorTarifas                | Unitario          | 🟢 Media   | Ninguna          | Bajo riesgo, fácil de cubrir |
```

**Leyendas de prioridad:**
- 🔴 Crítica — Flujo de dinero, datos personales o sensibles, integración externa, o bug reportado
- 🟡 Alta — Lógica de negocio compleja o componente compartido por múltiples flujos
- 🟢 Media — Utilidades, helpers, componentes presentacionales

---

### Paso 3 — Diagnóstico de riesgos

Redacta un diagnóstico breve (máximo 10 bullets) que cubra:

**Riesgos sin cobertura:**
- ¿Qué flujos de negocio críticos no tienen ningún test?
- ¿Qué servicios externos se llaman en producción sin doble en tests?
- ¿Hay entidades sin constructor de datos de prueba que bloqueen escribir tests hoy?

**Deuda técnica de testing:**
- ¿Hay tests que usan fixtures estáticos donde corresponden constructores? (mantenimiento costoso)
- ¿Los tests de integración aíslan el estado entre sí? (si no, se contaminan)
- ¿Existe configuración de entorno de test separada? (si no, los tests podrían correr contra
  configuración real)

**Quick wins identificados:**
- Superficies 🟢 Media que se cubren rápido y suben la confianza del equipo
- Constructores de datos faltantes que, una vez creados, desbloquean docenas de tests

---

### Paso 4 — Propuesta de acción guiada

Presenta al desarrollador las opciones, ordenadas por impacto:

```
────────────────────────────────────────────────────────────
  PROPUESTA DE ACCIÓN — [nombre del módulo/repo]
────────────────────────────────────────────────────────────

  Basado en el discovery, estas son las opciones para esta sesión:

  A) 🔴 [Nombre del flujo crítico #1]
     Tipo: Integración / E2E
     Esfuerzo estimado: [rango]
     Qué cubre: [descripción concreta]
     Requiere antes: [constructor X, doble del servicio Y]
     → Invocar: qa-generator con modo=integracion

  B) 🔴 [Nombre del flujo crítico #2]
     Tipo: Integración
     Esfuerzo estimado: [rango]
     Qué cubre: [descripción concreta]
     Requiere antes: [nada / constructor Z]
     → Invocar: qa-generator con modo=integracion

  C) 🟡 [Módulo de prioridad alta]
     Tipo: Unitario
     Esfuerzo estimado: [rango]
     Qué cubre: [descripción concreta]
     Requiere antes: [nada]
     → Invocar: qa-generator con modo=unitario

  D) 🏗️  Preparar infraestructura base (si no existe)
     Crear: config de entorno de test, constructores faltantes, clase base de test
     Esfuerzo estimado: [rango]
     Por qué primero: desbloquea todas las demás opciones
     → Invocar: qa-generator con modo=infraestructura

  E) 📄 Generar Plan de Pruebas para stakeholders no técnicos
     Documenta el mapa de superficies en formato de documento
     → Usar `templates/test-plan-template.md` y la skill de documentos
       disponible en tu entorno, si la hay

────────────────────────────────────────────────────────────
  ¿Cuál opción quieres atacar hoy? (A / B / C / D / E)
────────────────────────────────────────────────────────────
```

**No generes ningún código de test hasta recibir la elección del desarrollador.**

---

### Paso 5 — Handoff al generador

Una vez que el desarrollador elige, prepara el **contexto de handoff** para `qa-generator`:

```markdown
## Contexto de handoff — qa-generator

**Modo:** [unitario | integracion | e2e | infraestructura]
**Target:** [nombre del módulo, controlador, flujo o componente]
**Stack (detectado y confirmado en Paso 1.0):**
  - Backend: [lenguaje + framework + versión]
  - Frontend: [framework, si aplica]
  - BD: [motor]
  - Runner de tests: [herramienta backend / frontend / e2e]
  - Externos: [lista de servicios externos involucrados]

**Archivos clave identificados:**
  - [rutas reales del repo]

**Pre-requisitos detectados:**
  - Constructor de datos faltante: [entidad] → crear antes
  - Doble necesario: [servicio] → mecanismo del stack
  - Variable de entorno: [nombre] → agregar a la config de test

**Contexto de negocio:**
  [descripción breve del flujo en el vocabulario del dominio del proyecto]
```

---

## Señales de alerta durante el discovery

Si encuentras cualquiera de lo siguiente, menciónalo explícitamente antes de la propuesta:

| Señal                                              | Riesgo                                              |
|----------------------------------------------------|-----------------------------------------------------|
| Tests que llaman APIs reales en su configuración   | Tests frágiles y costosos; pueden fallar en CI      |
| Borrado masivo de tablas en tests                  | Peligroso si apunta a una BD equivocada             |
| Sin aislamiento de estado entre tests de integración | Contaminación entre tests; resultados no confiables |
| Constructores que persisten en tests unitarios     | Tests lentos; los unitarios no deben tocar BD       |
| Sin configuración de entorno de test separada      | Los tests podrían correr contra configuración real  |
| Esperas fijas por tiempo en tests E2E              | Anti-patrón; esperar por estado, no por reloj       |
| Tests con nombres genéricos                        | No comunican intención; difíciles de mantener       |

---

## Archivos de referencia en esta skill

Lee el archivo correspondiente cuando el discovery lo requiera:

- `references/stack-patterns.md` — cómo detectar el stack, y el mapa agnóstico
  artefacto → tipo de prueba. Leer en el Paso 1.0, siempre, y cuando el repo tenga estructura no
  convencional.

- `references/domain-knowledge.md` — plantilla para levantar el conocimiento de dominio del
  proyecto (entidades y su riesgo, flujos críticos, reglas que suelen romperse, casos de alto
  valor). Leer en el Paso 1.5 cuando el negocio no sea evidente desde el código. La skill no trae
  el dominio de ningún sector: lo levanta con el usuario.

- `references/coverage-antipatterns.md` — anti-patrones de cobertura que dan falsa sensación de
  seguridad. Leer cuando el repo ya tenga tests pero se reporten bugs que "deberían haber sido
  atrapados".

- `templates/test-plan-template.md` — plantilla de Plan de Pruebas en Markdown, convertible a
  documento por la skill de documentos del entorno si está disponible. Usar cuando se elija la
  opción E.

---

## Lo que esta skill NO hace

- No genera código de tests (eso es `qa-generator`)
- No ejecuta tests existentes (usar el runner del stack directamente)
- No hace análisis de cobertura formal (usar la herramienta de cobertura del stack)
- No toma decisiones de arquitectura de tests sin confirmar con el desarrollador
- No asume stack ni dominio: los detecta y los confirma

---

## Output esperado al final del discovery

```
1. Stack detectado y confirmado (Paso 1.0)
2. Tabla de Superficies de Prueba (Paso 2)
3. Diagnóstico de Riesgos con bullets concretos (Paso 3)
4. Menú de opciones de acción (Paso 4)
5. Contexto de handoff listo para pegar en qa-generator (Paso 5, post-elección)
```
