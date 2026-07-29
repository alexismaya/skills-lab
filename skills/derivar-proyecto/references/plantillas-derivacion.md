# Plantillas de derivación — listas para llenar

Convención: `{placeholder}` se sustituye. El idioma sigue al del proyecto del usuario. Si `sdd-harness-notion` está instalada, sus plantillas de hub/etapa/reporte tienen prioridad; aquí solo se incluyen las específicas de derivación y versiones mínimas de respaldo.

---

## 1. Entrevista de derivación (guion)

Presentar por bloques; confirmar lo ya sabido por contexto en lugar de preguntarlo.

```
Q1 — ¿Qué pretendes heredar del proyecto {origen}? (marca las que apliquen)
  [ ] Estructura de directorios / organización de capas
  [ ] Patrones de diseño (middleware, servicios, jobs, manejo de errores)
  [ ] Stack y dependencias
  [ ] Autenticación / autorización
  [ ] Infraestructura (docker, CI/CD, despliegue)
  [ ] Componentes transversales (logging, multi-tenant, resolvers, config)
  [ ] BD compartida / esquema de datos
  [ ] Flujos de negocio análogos (el concepto, no el código)
  → Lo NO marcado queda excluido por defecto.

Q2 — ¿Qué NO debe cruzar bajo ninguna forma?
  Confirmar cada una aunque parezca obvia:
  [ ] Nombres del proyecto/producto viejo (namespaces, slugs, strings)
  [ ] Marca: logos, colores, textos, plantillas de email, dominios, correos
  [ ] Credenciales / .env reales / secretos
  [ ] Lógica de dominio del producto viejo
  [ ] Catálogos / datos específicos del producto viejo
  [ ] Historial git
  [ ] Docs y colecciones del producto viejo
  → Esta lista se convierte en guardas anti-arrastre (§6).

Q3 — ¿Qué tan confiable es el origen?
  ¿Deuda conocida? ¿Hallazgos de seguridad? ¿Código de otros productos
  mezclado? ¿Cuánto tiempo sin mantenimiento serio?
  → Base con deuda: la Fase 1 audita con lente de hallazgos, no solo clasifica.

Q4 — ¿Compartirán recursos vivos? (BD, colas, buckets, gateway, servicios)
  Por cada recurso: ¿quién es el dueño?, ¿qué convención de nombrado se
  observa EN el recurso real (DDL/consola, no el código)?, ¿riesgo de colisión?
  → Regla: lo compartido se consume, no se migra/recrea desde el nuevo.

Q5 — ¿Cuántos proyectos ya derivaron de este origen?
  Si N ≥ 2: poner sobre la mesa extraer lo común a un paquete/librería
  interna en vez de la copia N+1. Decisión del usuario; si copia, se
  registra como decisión consciente.

Q6 — ¿Notion existente o desde cero? ¿Quién ejecuta y con qué contexto?
  → Calibra estructura de páginas y tamaño de las etapas.
```

---

## 2. Matriz de herencia (tabla Notion)

```markdown
# Matriz de herencia — {nuevo} ⇐ {origen}

> Contrato de la derivación. Solo cruza lo que tiene fila con acción
> aprobada. Cobertura obligatoria: 100% del 1er y 2do nivel del origen.
> Toda desviación posterior se reporta contra esta matriz.

| Elemento (ruta) | Clasificación | Acción | Justificación | Estado |
|---|---|---|---|---|
| {app/Http/Middleware/X.php} | heredable | copia directa | {por qué} | pendiente |
| {app/Services/Y.php} | heredable | parametrización: {vars} | {por qué} | pendiente |
| {config/z.php} | heredable | renombrado: {viejo→nuevo} | {por qué} | pendiente |
| {app/Controllers/ProductoViejo*} | no heredable | — | lógica del producto {origen} | n/a |
| {app/Models/OtroProducto*} | muerto | excluir + reportar a dueño de {origen} | residuo cross-product | n/a |

Leyenda de clasificación: heredable · no heredable · muerto
Leyenda de acción: copia directa · parametrización (qué) · renombrado (qué) · reimplementación (cruza el concepto, no el código)
```

---

## 3. Prompt — Fase 1: Análisis de derivación

```markdown
# Prompt — Fase 1: Análisis de derivación `{nuevo}` ⇐ `{origen}`

## Contexto
Vamos a crear `{nuevo}` tomando `{origen}` como base. **Fase de ANÁLISIS
exclusivamente: cero código, cero repo, cero migraciones.** Entregable: un
reporte que revisaré antes de autorizar el scaffold.

Decisiones de la entrevista de derivación (vinculantes):
- Se hereda: {categorías Q1}
- No cruza: {lista Q2}
- Recursos compartidos: {Q4, con dueños}

## Insumos
1. Repo `{origen}`
2. {DDL/esquema del recurso compartido — si Q4 aplica}
3. {hallazgos/deuda conocida del origen — si Q3 aplica}

## Objetivo
Reporte único `analisis-derivacion-{slug}.md` con:

### S1 — Matriz de herencia (100% de cobertura)
Clasificar todo el 1er y 2do nivel de `{origen}` según la plantilla de
matriz: heredable (con acción: copia/parametrización/renombrado/
reimplementación), no heredable, o muerto. Rutas explícitas. El código
muerto o cross-product detectado se lista aparte con evidencia — no se
arrastra y se reportará al dueño del origen.

### S2 — Barrido de identidad
Inventario de TODOS los lugares donde vive el nombre/marca de `{origen}`:
namespaces, composer/package.json, configs, docker-compose, títulos,
plantillas de correo, assets (logos/íconos), textos de UI, dominios,
correos, metadatos. Cada uno con su destino: renombrar a {nuevo} / excluir.

### S3 — Dependencias
Lista completa de dependencias del origen con veredicto individual:
se hereda (justificación de uso en {nuevo}) o se excluye. Ninguna cruza
"porque estaba".

### S4 — Recursos compartidos (contra la fuente real)
{Si Q4 aplica:} qué se consume (sin migrar/recrear), dueño de cada
recurso, convención de nombrado observada en {DDL/consola}, verificación
de colisiones para los nombres nuevos propuestos, inconsistencias
detectadas (solo reporte).

### S5 — Línea base (lente de Q3)
Patrones del origen que NO deben cruzar (con evidencia archivo:línea):
{seguridad, logging, manejo de datos sensibles, etc.}. Formato: regla ·
estado en origen (✅/⚠️/🔴) · obligación para {nuevo}. Veredicto: "origen
listo como plantilla" o correcciones requeridas antes del scaffold.
Hallazgo activo en el origen = se reporta aparte, no se hereda ni se
corrige en silencio.

## Criterios de aceptación
1. Matriz con 100% de cobertura; cero elementos sin fila.
2. Toda afirmación con ruta explícita; esquema verificado contra la fuente
   real, no inferido del código.
3. Barrido de identidad exhaustivo (S2) — incluir assets y textos, no solo
   código.
4. Incertidumbres como Preguntas abiertas (P-1..P-n); nada resuelto por
   suposición.
5. S5 concluye con veredicto explícito.
6. Cero código/repo/migraciones generadas.

## Fuera de alcance
- Scaffold, código, modificaciones al origen, remediación de hallazgos
  del origen (se reportan, no se ejecutan).

## Entregable
`analisis-derivacion-{slug}.md` → revisión → gate → Fase 2 (scaffold).
```

---

## 4. Checklist — Barrido de identidad (para S2 y para la revisión de gate)

```
[ ] Namespaces y nombres de clase con el slug viejo
[ ] composer.json / package.json (name, description, autores)
[ ] Configs: app name, URLs, dominios, correos de notificación
[ ] docker-compose: nombres de contenedor, redes, volúmenes
[ ] Plantillas de correo / notificaciones (asunto, firma, logo embebido)
[ ] Assets: logos, íconos, favicons, imágenes de marca
[ ] Textos de UI y mensajes de error con el nombre del producto viejo
[ ] README, docs, comentarios de cabecera
[ ] Metadatos: títulos HTML, manifest, open graph
[ ] Colecciones/fixtures/seeds con datos del producto viejo
[ ] Nombres de colas, buckets, prefijos de caché, claves de storage
```

---

## 5. Checklist — Recursos compartidos

```
[ ] Cada recurso compartido tiene dueño identificado (persona/repo)
[ ] Convención de nombrado extraída del recurso REAL (DDL/consola)
[ ] Nombres nuevos verificados sin colisión contra el inventario real
[ ] El nuevo proyecto NO migra/recrea nada compartido (solo consume)
[ ] Prefijo propio del nuevo proyecto definido y sin colisión
[ ] Accesos/credenciales del nuevo emitidos aparte (no reutilizados)
```

---

## 6. Guardas anti-arrastre (CI del proyecto nuevo)

Derivar de Q2 + S5. Ejemplos de forma — adaptar patrones al proyecto:

```yaml
# security-and-identity-guards (falla el build ante cualquier coincidencia)
- grep -rn "{slug-viejo}\|{NombreViejo}\|{dominio-viejo}\|{correo-viejo}" app/ config/ resources/ docker* composer.json
  # excepciones documentadas: {ninguna | lista con justificación}
- grep -rn "{patrones prohibidos de S5: logging crudo, funciones peligrosas, decodes sin validar}" app/
- {verificación de que no existen migraciones sobre tablas compartidas}
```

Regla: las guardas se instalan en el scaffold (Fase 2) y permanecen activas en TODAS las fases — el arrastre también ocurre cuando una fase tardía "toma prestado" del origen.

---

## 7. Hub y etapa (versión mínima, solo si sdd-harness-notion no está instalada)

Hub: contexto + decisiones vinculantes (matriz aprobada, lista Q2, P-x) + tabla de etapas con dependencias y gates + estado global + criterios globales + fuera de alcance.
Etapa: contexto vinculante repetido (incluida la lista Q2 y las guardas) + tareas + criterios con smoke ejecutable + checklist de cierre + handoff.
Reporte de cierre: mapa contra la matriz + estado de Ps + evidencia por criterio (corrida de guardas incluida) + desviaciones justificadas + pendientes con responsable.
