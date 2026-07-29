# Plantilla: Administración de ramas y cambios (Notion)

Plantilla para la sección de branching del hub de proyecto en Notion.
El agente la usa como referencia al proponer crear o actualizar entradas.
Toda escritura requiere confirmación del usuario; ediciones quirúrgicas
sobre páginas compartidas (ver `interop-notion.md`).

---

## Tabla de ramas

Una fila por rama relevante (excluir las efímeras de minutos).

| Rama | Tipo | Propósito | Base | Fecha creación | PR | Estado | Fecha cierre |
|---|---|---|---|---|---|---|---|
| `feat/nombre` | feat | {qué resuelve} | `main` | YYYY-MM-DD | #{n} | abierta / mergeada / abandonada | YYYY-MM-DD |

**Tipos:** feat · fix · hotfix · release · chore · experiment
**Estados:** abierta · en revisión · mergeada · abandonada

---

## Tabla de PRs

| # PR | Título | Rama origen → destino | Fecha apertura | Fecha cierre | Estado | Gate SDD |
|---|---|---|---|---|---|---|
| #{n} | `feat: descripción` | `feat/X` → `main` | YYYY-MM-DD | YYYY-MM-DD | abierto / mergeado / cerrado sin merge | Fase N - Etapa X |

La columna **Gate SDD** vincula el PR al gate de la metodología que lo
origina (si el proyecto usa la suite SDD harness). Un PR que cierra una
etapa lleva la referencia: `Fase N - Etapa X (Notion: <url>)`.

---

## Registro de stashes activos

Limpiar esta tabla cuando el stash se aplique o descarte.

| Stash | Rama donde se hizo | Descripción (`-m`) | Fecha | Estado |
|---|---|---|---|---|
| `stash@{0}` | `feat/nombre` | {qué contiene} | YYYY-MM-DD | pendiente / aplicado / descartado |

---

## Registro de decisiones de branching

Entradas cortas para decisiones no obvias: por qué se eligió un modelo
de branching, por qué se borró una rama con trabajo sin mergear, por qué
se hizo un force push justificado.

| Fecha | Decisión | Motivo | Quién confirmó |
|---|---|---|---|
| YYYY-MM-DD | {qué se decidió} | {por qué} | {usuario / agente propuso, usuario confirmó} |

---

## Convenciones activas del repo

Rellenar en el arranque (Q1–Q3 de la skill). Actualizar si cambian.

| Parámetro | Valor |
|---|---|
| Modelo de branching | trunk-based / gitflow / github flow / otro |
| Convención de commits | Conventional Commits / propia: {descripción} / ninguna |
| Política de PRs | obligatorio / opcional / push directo |
| Rama principal | `main` / `master` / otra |
| Ramas de larga vida | {lista, o "solo main"} |
