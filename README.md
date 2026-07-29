# skills-lab

Suite de skills para construcción de proyectos bajo metodología SDD harness
engineering, con Notion como gestor de tareas, contexto y documentación.

## Estructura

```
skills-lab/
├── shared/
│   └── interop-notion.md      # Contrato de interoperabilidad — FUENTE ÚNICA.
│                              # Nunca editarlo dentro de una skill: se inyecta
│                              # en cada una al empaquetar.
├── scripts/
│   └── package.sh             # Empaqueta skills/* → dist/*.skill
├── dist/                      # Artefactos generados (no versionados)
└── skills/
    ├── sdd-harness-notion/    # Metodología: fases, etapas, gates, Notion (Claude)
    ├── derivar-proyecto/      # Proyecto nuevo desde uno existente sin arrastre (Claude)
    ├── qa-discovery/          # Descubrimiento QA, taxonomía L1–L6 (Kiro)
    └── qa-generator/          # Suites por modo: unitario/integracion/e2e/infra (Kiro)
```

## Uso

```bash
./scripts/package.sh
```

Genera `dist/<skill>.skill` para cada carpeta de `skills/` que tenga
`SKILL.md`, inyectando el contrato compartido en sus `references/`. Los
`.skill` se instalan en Claude ("Save skill" / carga de skill). Las skills
de Kiro se consumen desde su carpeta según el mecanismo de Kiro; el
contrato les aplica igual (el script también se los inyecta).

## Reglas del repo

1. **`shared/interop-notion.md` se edita SOLO en `shared/`.** Un cambio al
   contrato es un cambio a toda la suite: revisarlo como tal. Las copias
   dentro de los `.skill` son artefactos de build.
2. **Cambios de comportamiento** de una skill → editar su `SKILL.md` o
   `references/` y anotar versión y motivo en `CHANGELOG.md`.
3. **Sin casos de proyectos reales embebidos** en las skills (evita sesgo):
   el aprendizaje acumulado vive en la página "Lecciones SDD" de Notion,
   no en el repo.
4. **Sin secretos:** nada de tokens, credenciales ni URLs privadas de
   Notion en el repo.

## Las skills

| Skill | Runtime | Rol en el ciclo |
|---|---|---|
| `derivar-proyecto` | Claude | Descubrimiento: qué se hereda de un proyecto base y qué no cruza (matriz de herencia, guardas anti-arrastre) |
| `sdd-harness-notion` | Claude | Construcción: fases con gates, etapas atomizadas en Notion, evidencia por criterio |
| `qa-discovery` | Kiro | Calidad (plan): descubrimiento de superficie y taxonomía L1–L6 |
| `qa-generator` | Kiro | Calidad (ejecución): generación de suites por modo |

Las cuatro comparten: tabla única de Ps por proyecto, página de Lecciones,
handoffs como interfaz, y gates cruzados — definido todo en
`shared/interop-notion.md`.
