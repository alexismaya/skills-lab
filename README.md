# skills-lab

Suite de skills de agente para construir software bajo metodología **SDD harness
engineering**: fases con gates de revisión humana, análisis antes de
implementación, y evidencia en vez de afirmación. Notion actúa como gestor de
tareas, contexto vinculante y documentación.

El contenido de las skills está **en español**. El núcleo son archivos Markdown; algunas
skills incluyen scripts deterministas y sus fixtures/pruebas, pero no hay código de
aplicación ni un stack impuesto a los proyectos del usuario.

> **Repo público, pensado para terceros.** Las skills no traen casos de
> proyectos reales ni conocimiento de ningún sector: son agnósticas de dominio y
> de stack, y cada una levanta con el usuario lo que necesita saber de *su*
> proyecto. Ver [`UNIVERSOS-SINTETICOS.md`](UNIVERSOS-SINTETICOS.md).

## Las skills

| Skill | Rol en el ciclo |
|---|---|
| [`derivar-proyecto`](skills/derivar-proyecto/) | **Descubrimiento** — proyecto nuevo a partir de uno existente: matriz de herencia, guardas anti-arrastre, barrido de identidad |
| [`project-audit`](skills/project-audit/) | **Diagnóstico** — auditoría contra 4 pilares (seguridad, escalabilidad, rendimiento, mantenibilidad) con evidencia `file:line` y severidad justificada |
| [`sdd-harness-notion`](skills/sdd-harness-notion/) | **Construcción** — fases con gates, etapas atomizadas en Notion, evidencia por criterio, calibración por capacidad del ejecutor |
| [`adversarial-review`](skills/adversarial-review/) | **Refutación** — contra-reporte independiente de un artefacto de plan antes de ejecutarlo: objeciones citadas, premortem acotado y veredicto; refuta y reporta, nunca corrige ni propone |
| [`replit-decoupler`](skills/replit-decoupler/) | **Portabilidad** — inventaría y elimina/sustituye acoplamientos de Replit con contrato de sustancia, paridad demostrada y smoke fuera de la plataforma |
| [`qa-discovery`](skills/qa-discovery/) | **Calidad (plan)** — detecta el stack, mapea superficies de prueba y las prioriza por riesgo de negocio |
| [`qa-generator`](skills/qa-generator/) | **Calidad (ejecución)** — materializa suites por modo: unitario, integración, e2e, infraestructura |
| [`project-onboarding`](skills/project-onboarding/) | **Documentación** — snapshot del proyecto en Notion con diagramas Mermaid; lo que no tiene fuente se marca pendiente, nunca se inventa |
| [`documentation-master`](skills/documentation-master/) | **Extracción** — levanta la lógica real en un corpus versionado en Notion: afirmaciones atómicas con procedencia y evidencia `file:línea`, o `NO DETERMINADO` con motivo. Lo operativo —puesta en marcha, ambientes, accesos— se captura en entrevista dirigida, nunca se deduce del repo; no genera archivos |
| [`project-deck`](skills/project-deck/) | **Presentación** — genera un PPTX adaptado a la audiencia (técnica / cliente / manual de usuario) |
| [`project-doc`](skills/project-doc/) | **Documento** — proyecta el corpus de `documentation-master` a un `.docx` adaptado a la audiencia (manual de usuario, capacitación, PM, handover técnico, cliente, aval de desempeño) |
| [`git-workflow`](skills/git-workflow/) | **Transversal** — gobierna el uso de Git por el agente en cualquier repo: propone y explica, nunca decide solo |

Las doce comparten **tabla única de preguntas abiertas** por proyecto, página de
Lecciones, **handoffs como interfaz** entre skills, y gates cruzados — definido
todo en [`shared/interop-notion.md`](shared/interop-notion.md).

Las skills son **portables entre runtimes** (Claude/Claude Code, Kiro y la CLI
de Antigravity); las equivalencias de herramienta por runtime están en el
contrato compartido.

## Estructura

```
skills-lab/
├── shared/
│   └── interop-notion.md        # Contrato de interoperabilidad — FUENTE ÚNICA.
│                                # Nunca editarlo dentro de una skill: se inyecta
│                                # en cada una al empaquetar.
├── skills/<nombre>/
│   ├── SKILL.md                 # Frontmatter (name + description-trigger) + cuerpo
│   ├── references/              # Material que la skill lee bajo demanda
│   ├── templates/               # Plantillas de entregables
│   ├── scripts/                 # Guardas deterministas opcionales
│   └── evals/                   # Fixtures y casos de evaluación opcionales
├── scripts/
│   ├── package.sh               # Empaqueta skills/* → dist/*.skill
│   ├── install-claude.sh|.ps1   # Instala la suite en Claude Code
│   ├── install-kiro.sh|.ps1     # Instala la suite en Kiro
│   ├── install-antigravity.sh|.ps1  # Instala la suite en la CLI de Antigravity
│   ├── check-neutralidad.sh     # Verifica que no entre material identificable
│   ├── seed-permitidos.sh       # Regenera el allowlist de la verificación
│   ├── install-hooks.sh         # Activa los hooks (una vez por clon)
│   └── hooks/                   # pre-commit · commit-msg · pre-push
├── UNIVERSOS-SINTETICOS.md      # Universo del que salen los ejemplos + prompts
└── dist/                        # Artefactos generados (no versionados)
```

## Uso

### Instalar las skills

```bash
./scripts/install-claude.sh                        # → ~/.claude/skills
./scripts/install-kiro.sh                          # → ~/.kiro/skills
./scripts/install-antigravity.sh                   # → ~/.gemini/config/skills
./scripts/install-claude.sh /ruta/.claude/skills   # → por proyecto
```

Cada instalador copia toda carpeta de `skills/` que tenga `SKILL.md` e inyecta
el contrato compartido en sus `references/`. Los tres runtimes leen las carpetas
directamente, y los tres reciben la suite completa: las skills son portables
entre runtimes, y la columna *Integración prevista* documenta para cuál se
diseñó cada una, no cuál puede ejecutarla.

En Antigravity el destino global es `~/.gemini/config/skills/`, que aplica a
todos los proyectos de la máquina; el equivalente por proyecto es
`<raíz>/.agents/skills/`, que tiene precedencia sobre el global y permite que un
repo sobrescriba una skill concreta. **No** se instala en
`~/.gemini/antigravity-cli/builtin/skills/`: ese árbol lo administra la CLI,
está sellado por checksum y se reescribe en cada actualización — lo que se
ponga ahí desaparece sin aviso. El instalador rechaza ese destino.

La lista **se deriva del árbol**, no está escrita en el script. Es deliberado:
una lista fija se desincroniza en silencio por dos lados — una skill nueva no
llega a ningún runtime, y una skill instalada que quede fuera de la lista
conserva el contrato viejo mientras las demás avanzan, dejando dos versiones
del contrato conviviendo en el mismo runtime.

Los `.ps1` equivalentes (`install-claude.ps1`, `install-kiro.ps1`,
`install-antigravity.ps1`) hacen lo mismo desde PowerShell.

### Empaquetar

```bash
./scripts/package.sh
```

Genera `dist/<skill>.skill` para cada carpeta de `skills/` que tenga `SKILL.md`,
inyectando el contrato compartido. Requiere `zip` en el `PATH` — no viene con
Git para Windows.

### Contribuir

```bash
./scripts/install-hooks.sh              # una vez por clon
./scripts/check-neutralidad.sh --all    # auditoría completa
```

## Reglas del repo

1. **`shared/interop-notion.md` se edita SOLO en `shared/`.** Un cambio al
   contrato es un cambio a toda la suite: revisarlo como tal. Las copias dentro
   de los `.skill` son artefactos de build.
2. **Cambios de comportamiento** de una skill → editar su `SKILL.md` o
   `references/` y anotar versión y motivo en `CHANGELOG.md`. El `description`
   del frontmatter es el **trigger**: editarlo cambia *cuándo* se activa la
   skill, no solo su documentación.
3. **Sin material de proyecto real, en ninguna superficie** — ni nombres de
   cliente, empresa, producto o sistema; ni reglas de negocio con sus valores;
   ni identificadores, endpoints o rutas de un sistema real. Aplica igual a
   `SKILL.md`, `references/`, `CHANGELOG.md`, **nombres de archivo y de rama, y
   mensajes de commit**. El aprendizaje de un caso real vive en la página
   "Lecciones SDD" del Notion del usuario, que es privada: en el repo queda la
   *forma* del hallazgo, nunca el dato.
4. **Los ejemplos salen del universo sintético** de `UNIVERSOS-SINTETICOS.md`:
   un archivo, un universo, declarado en su cabecera. Un stack puede aparecer
   como *ejemplo declarado*, nunca como requisito.
5. **Sin secretos:** nada de tokens, credenciales ni URLs privadas.
6. **La neutralidad se verifica antes de commitear**, no después. Los hooks lo
   hacen automáticamente; el workflow de CI es una **auditoría posterior al
   push**, no una barrera.

Detalle completo en [`CLAUDE.md`](CLAUDE.md).

## Licencia

[Apache License 2.0](LICENSE). Podés usar, adaptar y redistribuir las skills,
incluso comercialmente, conservando el aviso de copyright y declarando los
cambios significativos que hagas sobre los archivos.
