# Plantillas de auditoría

Plantillas de los entregables de cada fase. Leer al redactar cualquiera de estos artefactos.
Todas viven en el hub **Auditoría** del proyecto en Notion (ver `references/interop-notion.md`).
Regla transversal: **sin `file:line` no hay hallazgo** — lo no verificable va a la sección de
hipótesis, no a la matriz.

> **Sobre los ejemplos.** Las rutas y nombres de las filas de ejemplo usan un dominio ilustrativo
> (reserva de espacios compartidos). Sustitúyelos por los del proyecto auditado.

---

## Fase 0 — Snapshot de reconocimiento

Inventario sin juicios: se registra lo que hay, no lo que está mal.

```markdown
# Snapshot de reconocimiento — {Proyecto}
Rama/commit auditado: {ref}          Fecha: {fecha}          Alcance (Q3): {pilares}

## Stack y versiones
- Lenguaje(s) / runtime / framework: ...
- Base de datos / almacenamiento: ...

## Estructura y capas
- Organización de directorios (nivel 1–2) y responsabilidad de cada uno.

## Dependencias
- Gestor y lockfile presente (sí/no) · nº de dependencias directas · notables.

## Puntos de entrada
- Rutas/endpoints · comandos/CLI · jobs/workers/crons · consumidores de colas.

## Infraestructura declarada
- Docker / compose · CI/CD · variables de entorno esperadas (nombres, no valores).

## Tests presentes
- Frameworks · ubicación · presencia de CI que los ejecute (sí/no).

## Observaciones de acceso
- Zonas del código no accesibles o ilegibles (impactan cobertura de la auditoría).
```

---

## Fase 1 — Ficha de hallazgo

Unidad atómica de la auditoría. Una ficha por hallazgo; alimenta la matriz consolidada.

```markdown
### [H-{n}] {título corto}
- **Pilar:** seguridad | escalabilidad | rendimiento | mantenibilidad
- **Evidencia:** `ruta/archivo.ext:línea` (una o varias) — {qué muestra exactamente}
- **Severidad:** crítica | alta | media | baja   (justificada contra rubrica-severidad.md)
- **Impacto:** qué se rompe · para quién · bajo qué condición
- **Descripción:** el problema en 1–3 líneas, sin remediar (la corrección es de otra skill).
```

### Hipótesis a validar (sección aparte, sin severidad)

```markdown
### [Hip-{n}] {título}
- **Pilar:** ...
- **Sospecha:** qué se cree que ocurre y por qué.
- **Falta para confirmar:** qué evidencia/acceso/ejecución haría falta para volverlo hallazgo.
```

---

## Fase 2 — Matriz de hallazgos consolidada

Tabla ordenada por severidad e impacto. Es el mapa que la propuesta y el handoff referencian.

```markdown
| ID   | Pilar          | Hallazgo (resumen)        | Evidencia (file:line)     | Severidad | Impacto (qué/quién/cuándo)        |
|------|----------------|---------------------------|---------------------------|-----------|-----------------------------------|
| H-1  | seguridad      | ...                       | `path:línea`              | crítica   | ...                               |
| H-2  | rendimiento    | ...                       | `path:línea`              | alta      | ...                               |
```

### Trade-offs entre pilares (explícitos)

```markdown
| Decisión de mejora | Pilar que favorece | Pilar en tensión | Naturaleza del trade-off        |
|--------------------|--------------------|------------------|---------------------------------|
| Introducir caché   | rendimiento        | mantenibilidad   | invalidación/consistencia añade complejidad |
| Desacoplar módulo  | escalabilidad      | rendimiento      | saltos de red vs. llamada local |
```

### Propuesta — variante según Q4

**Destino "rehacer" → Arquitectura objetivo**
```markdown
## Arquitectura objetivo
- Forma propuesta (componentes, límites, flujos).
- Justificación pilar por pilar: cómo resuelve/mitiga los H-n de cada pilar (citar IDs).
- Hallazgos que la nueva forma NO resuelve por sí sola (quedan como corrección explícita).
```

**Destino "remediar" → Estado objetivo dentro de la arquitectura actual**
```markdown
## Estado objetivo (sin rearquitectura)
- Qué debe quedar corregido, respetando la forma existente.
- Priorización de correcciones por severidad/impacto (citar IDs H-n).
- Límites: qué NO se toca de la arquitectura actual y por qué.
```

---

## Fase 3 — Reporte de handoff

Según Q4. El formato es parte del entregable: debe ser consumible directamente por la skill destino.

### Variante "rehacer" — consumible por `derivar-proyecto`

Clasificación **por componente** en la taxonomía de `derivar-proyecto` (fuente de verdad;
aquí se emite como handoff, no se redefine). Un componente `muerto` es residuo a no arrastrar.

```markdown
## Handoff de auditoría → derivar-proyecto — {Proyecto}
Alcance auditado (Q3): {pilares}     Base: {rama/commit}

| Componente (ruta)      | Clasificación | Correcciones al cruzar (H-n) | Justificación (por pilar)                        |
|------------------------|---------------|------------------------------|--------------------------------------------------|
| `src/tarifas/`         | heredable     | H-2, H-7                     | patrón sano; corregir N+1 (H-2) y validación (H-7) al derivar |
| `src/legacy-reservas/` | no heredable  | —                            | lógica del producto viejo + auth rota (H-1, H-4) |
| `src/utils/oldsync/`   | muerto        | —                            | sin referencias vivas (H-9); reportar al origen  |

Notas:
- Clasificación **estricta** en la taxonomía de derivar-proyecto: `heredable` / `no heredable`
  / `muerto`. No se redefine ni se añaden valores intermedios.
- "Correcciones al cruzar" es una **columna auxiliar** que derivar-proyecto puede leer o
  ignorar sin romper su matriz de herencia: lista los H-n que un componente `heredable` debe
  corregir al derivarse (el nuevo nace corregido; nunca corrección silenciosa). Vacía (`—`)
  para `no heredable` y `muerto`.
- Hipótesis abiertas relevantes para la clasificación: {Hip-n o "ninguna"}.
```

### Variante "remediar" — consumible por `sdd-harness-notion`

Plan de remediación por etapas priorizadas, con criterios de aceptación por etapa.

```markdown
## Handoff de auditoría → sdd-harness-notion — {Proyecto}

| Etapa | Hallazgos | Objetivo de la etapa            | Criterio de aceptación (verificable)     |
|-------|-----------|---------------------------------|------------------------------------------|
| E1    | H-1, H-4  | Cerrar brechas de auth/secretos | Auth en toda ruta sensible; sin secretos en repo (grep en cero) |
| E2    | H-2       | Eliminar N+1 del path crítico   | Query count acotado bajo carga de prueba |

Orden justificado por severidad/impacto (crítica → baja). Cada etapa es una fase SDD normal.
```

---

## Checklist de cierre (toda fase)

- [ ] Cada hallazgo tiene `file:line` verificable; lo no verificable está en Hipótesis.
- [ ] Cada severidad está justificada contra `rubrica-severidad.md`.
- [ ] El entregable vive en su página del hub Auditoría; Ps abiertas registradas en la tabla única.
- [ ] Handoff (Fase 3) en el formato de la skill destino según Q4.
- [ ] Ofrecido registrar lecciones al cerrar el gate.
