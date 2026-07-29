---
name: derivar-proyecto
description: "Creación de un proyecto nuevo a partir de uno existente: heredar estructura, patrones de diseño, stack, infraestructura o base de datos compartida SIN arrastrar código muerto, nombres, marca/logos, configuraciones ni deuda del proyecto anterior. Guía al usuario con una entrevista para delimitar qué se adapta y cómo, clasifica el 100% del proyecto origen (heredable / no heredable / muerto), y administra el proceso en Notion bajo metodología SDD harness engineering. Usar esta skill SIEMPRE que el usuario quiera: crear un proyecto/repo/API/app nueva 'basada en', 'a partir de', 'con la estructura de' o 'igual que' otro existente; clonar o copiar un proyecto como plantilla; scaffoldear desde un repo anterior; agregar un producto nuevo a un ecosistema de repos similares; o cualquier mención de 'plantilla', 'derivar', 'heredar estructura', 'no arrastrar código muerto' o 'mismo patrón que el proyecto X'."
---

# Derivación de proyectos (nuevo desde existente)

Disciplina para crear un proyecto nuevo tomando otro como base, donde **todo lo que cruza del origen al nuevo lo hace por decisión explícita, con acción declarada y verificación de que nada más se coló**. Complementa a la skill `sdd-harness-notion`: esta skill gobierna el descubrimiento y las reglas de derivación; la ejecución por fases/etapas/gates sigue la metodología SDD harness (si esa skill está instalada, usar sus plantillas de hub/etapa/reporte; si no, las de `references/plantillas-derivacion.md` incluyen versiones mínimas).

Principio rector: **un proyecto derivado no hereda por defecto — excluye por defecto.** La pregunta nunca es "¿qué quitamos de la copia?" sino "¿qué justifica cruzar?".

## Regla cero (compartida con SDD harness)

No asumir nada; nunca ejecutar sin propuesta aprobada. Toda duda se registra como **P-n en Notion** y el trabajo dependiente no avanza hasta que el usuario la responda — o hasta que el modelo encuentre la respuesta en el contexto y **el usuario la confirme**. La propuesta de derivación (qué se hereda, cómo, en qué etapas) se presenta y aprueba ANTES de crear páginas o escribir código.

## Entrevista de derivación (obligatoria antes de proponer nada)

Revisar primero el contexto disponible (conversación, memoria, Notion, repos accesibles): lo ya sabido se confirma, no se pregunta.

**Q1 — Qué se pretende heredar (por categoría, no en bloque).** Recorrer con el usuario:
estructura de directorios y organización de capas · patrones de diseño (middleware, servicios, jobs, manejo de errores) · stack y dependencias · autenticación/autorización · infraestructura (docker, CI/CD) · componentes transversales (logging, multi-tenant, resolvers) · BD compartida o esquema · flujos de negocio análogos.
Cada categoría marcada entra a la matriz de herencia con acción por decidir; lo no marcado queda excluido por defecto.

**Q2 — Qué NO debe cruzar (lista de exclusión explícita).** Preguntar y registrar aunque parezca obvio:
nombres del proyecto/producto anterior (namespaces, slugs, strings) · marca: logos, colores, textos, correos, dominios · credenciales y `.env` reales · lógica de dominio del producto viejo · catálogos/datos específicos · historial git · documentación y colecciones del producto anterior.
Esta lista se convierte después en **guardas anti-arrastre** (greps que fallan el build).

**Q3 — Confiabilidad del origen.** ¿El proyecto base tiene deuda conocida, hallazgos de seguridad, código de terceros productos mezclado, o antigüedad que lo desactualice? La respuesta calibra la profundidad de la auditoría: una base confiable se clasifica; una base con deuda se clasifica Y se audita con lente de hallazgos. Regla: **los defectos del origen no se heredan — el nuevo nace corregido, y el hallazgo se reporta al dueño del origen como asunto aparte** (nunca se corrige silenciosamente solo en la copia).

**Q4 — Recursos vivos compartidos.** ¿El nuevo convivirá con el viejo sobre BD, colas, buckets, gateways o servicios comunes? Si sí: identificar dueño de cada recurso compartido, convención de nombrado/prefijos observada (contra la fuente real: DDL, consola — no contra el código), verificación de colisiones, y la regla de que **lo compartido se consume, no se migra/recrea** desde el proyecto nuevo.

**Q5 — ¿Cuántas derivaciones previas existen?** Si el origen ya fue plantilla de N proyectos, proponer al usuario evaluar la **extracción de lo común a un paquete/librería interna** en lugar de la copia N+1 — el costo de mantener N copias del mismo código transversal crece con cada parche que deba replicarse. La decisión es del usuario; si elige copiar, se registra como decisión consciente (y candidata a la página de Lecciones).

**Q6 — Estado en Notion y ejecutor.** ¿Existe ya espacio del proyecto o se crea? ¿Quién ejecuta (agente, usuario) y con qué contexto? — igual que en SDD harness; calibra la atomización en etapas.

Con las respuestas, producir la **propuesta de derivación**: matriz de herencia inicial, Ps detectadas, fases/etapas tentativas, y estructura de Notion. Iterar hasta aprobación.

## La matriz de herencia (artefacto central)

Vive en Notion como tabla y es el contrato de la derivación. Una fila por elemento del origen (directorio, componente, dependencia, config, tabla):

| Elemento (ruta) | Clasificación | Acción | Justificación | Estado |
|---|---|---|---|---|

- **Clasificación:** `heredable` / `no heredable` (lógica del producto viejo) / `muerto` (residuo a no arrastrar y a reportar al dueño del origen).
- **Acción** (solo heredables): `copia directa` / `parametrización` (qué variables) / `renombrado` (qué namespace/slug) / `reimplementación` (el concepto cruza, el código no).
- La fase de análisis debe clasificar el **100%** del primer y segundo nivel del origen — un elemento sin fila es una fuga en potencia.
- Toda desviación posterior contra la matriz se reporta, nunca se ejecuta en silencio.

## Fases de la derivación (SDD harness aplicado)

**Fase 1 — Análisis de derivación (cero código).** Prompt en `references/plantillas-derivacion.md`. Produce: matriz de herencia completa con evidencia (rutas explícitas; esquema verificado contra DDL real si Q4 aplica), barrido de identidad (dónde vive el nombre/marca del origen: namespaces, configs, textos, assets, correos, dominios), inventario de dependencias con veredicto por cada una (se justifica o se excluye), línea base de seguridad del origen (qué patrones NO deben cruzar), y Ps numeradas. Gate: el usuario aprueba la matriz.

**Fase 2 — Scaffold con exclusiones vinculantes.** Se materializa SOLO lo que la matriz marca heredable, con su acción. Obligatorio:
- `.env` real, secretos e historial git **jamás** cruzan; `.env.example` se regenera con placeholders.
- **Guardas anti-arrastre en CI** derivadas de Q2: grep que falla ante el nombre del proyecto viejo, sus slugs, dominios, correos y cualquier patrón prohibido de la línea base. La limpieza se demuestra, no se declara.
- Elementos `muerto` detectados: excluidos aquí + reportados al dueño del origen (asunto aparte, no tarea de este proyecto).
Gate: reporte con evidencia — corrida de las guardas en cero, diff de dependencias justificado, mapa de lo materializado contra la matriz.

**Fases 3..N — Implementación del dominio nuevo.** Ya es territorio de `sdd-harness-notion` (etapas, smokes, handoffs, gates). Las guardas anti-arrastre siguen activas en todas las fases: el arrastre no solo ocurre al copiar — también cuando una fase tardía "toma prestado" del origen.

## Antipatrones de derivación (detectar al proponer o auditar)

1. **Copiar y podar** — clonar todo y "luego borrar lo que sobre": garantiza arrastre. El flujo correcto materializa desde la matriz.
2. **Herencia sin acción** — "heredable" sin decir si es copia/parametrización/renombrado deja la decisión al ejecutor.
3. **Corrección silenciosa** — arreglar en la copia un defecto del origen sin reportarlo: el origen sigue enfermo y la divergencia se vuelve invisible.
4. **Migrar lo compartido** — el proyecto nuevo recreando tablas/recursos que ya existen porque copió las migraciones del origen.
5. **Identidad residual** — nombres, logos, correos o textos del producto viejo sobreviviendo en rincones (plantillas de email, metadatos, docker-compose, títulos). El barrido de identidad de la Fase 1 + la guarda de CI existen por esto.
6. **La copia N+1 irreflexiva** — derivar por sexta vez sin haber puesto sobre la mesa la extracción a paquete común (Q5).

## Notion y aprendizaje

Misma operación que SDD harness: hub del proyecto → hub de fase → subpáginas de etapa; la **matriz de herencia** como página/tabla propia enlazada desde el hub; Ps con su gate; ediciones quirúrgicas, nunca reescritura de páginas. Al cierre de cada gate, ofrecer registrar lecciones en la página **"Lecciones SDD"** del usuario (compartida con la otra skill) — en particular: qué elemento se clasificó mal, qué identidad residual se escapó, qué pregunta faltó en la entrevista.

## Recursos de la skill

- `references/plantillas-derivacion.md` — entrevista completa con ramificaciones, matriz de herencia, prompt de Fase 1 (análisis de derivación), checklist de barrido de identidad, checklist de recursos compartidos, guardas anti-arrastre de ejemplo, y versiones mínimas de hub/etapa por si `sdd-harness-notion` no está instalada. Leer al redactar cualquiera de estos artefactos.
- `references/interop-notion.md` — contrato de interoperabilidad con las demás skills de la suite (`sdd-harness-notion`, `qa-discovery`, `qa-generator` u otras) sobre el mismo proyecto: estructura canónica del hub (la matriz de herencia es una página propia enlazada desde el hub raíz), tabla única de Ps compartida, ownership de páginas, handoffs como interfaz, gates cruzados. Leer SIEMPRE que el proyecto involucre (o vaya a involucrar) más de una skill de la suite.
