---
name: git-workflow
description: "Gobierna el uso de Git por un agente mientras trabaja dentro de un repo: buenas prácticas, protección del historial y coordinación con Notion, sin tomar decisiones unilaterales. Usar esta skill SIEMPRE que, teniendo un repo de contexto, surja cualquier acción potencial de git: hay cambios en staging o sin commitear, se menciona 'commit', 'branch'/'rama', 'PR'/'pull request', 'merge', 'rebase', 'push', 'tag', '.gitignore' o 'historial', o el usuario pide orientación sobre cómo organizar su trabajo en git (cuándo commitear, cómo nombrar ramas, cuándo abrir un PR, cómo resolver un conflicto). NO usar para preguntas teóricas sobre git cuando no hay un repositorio de contexto sobre el que actuar."
---

# Git Workflow (uso de Git por el agente)

Disciplina para que un agente de código use Git dentro del repo del usuario de forma segura y colaborativa. Principio rector: **el agente propone y explica; el usuario decide y confirma. Nada que reescriba o mueva historial ocurre sin validación explícita.**

Esta skill es un solo artefacto de contenido, no un sistema por fases: gobierna el comportamiento de git en cualquier repo. No trae proyectos reales embebidos: el aprendizaje acumulado vive en la página "Lecciones SDD" del usuario, no aquí. Cuando el repo forma parte de la suite SDD harness, se coordina con las demás skills a través de Notion — ver `references/interop-notion.md`.

## Regla cero (gobierna todo lo demás)

**Nunca ejecutar una acción git sin que el usuario la valide explícitamente.**

El ciclo es siempre el mismo: **proponer → explicar por qué → esperar confirmación → ejecutar.** No hay `git add`, `commit`, `branch`, `push`, `merge`, `rebase` ni borrado de ramas sin un "adelante" del usuario para esa acción concreta.

Toda duda o ambigüedad (qué entra en un commit, si una rama es compartida, si un archivo es sensible) se registra como **pregunta abierta numerada (P-n)** en la página de Notion del proyecto si existe, y no se avanza en la acción dependiente hasta resolverla — o hasta que el usuario decida conscientemente omitir el registro. Si no hay Notion, la duda se plantea igual en la conversación antes de actuar.

## Arranque en un repo (primera vez)

Al activarse sobre un repo donde no se ha usado antes, **detectar del contexto disponible antes de preguntar**. Lo que el repo ya dice no se pregunta, se confirma:

- ¿Tiene `.git`? ¿Cuál es el `remote` (`git remote -v`)?
- ¿Qué modelo de branching es observable? (ramas existentes, PRs abiertos/cerrados, forma del historial: ¿una sola línea, o ramas de larga vida como `develop`?).
- ¿Hay convención de commits observable? (mensajes existentes en el log, `.commitlintrc`, `CONTRIBUTING.md`, `.gitmessage`).
- ¿Qué granularidad de commit se observa en el historial? (tamaño y alcance típicos: ¿commits de un propósito, o lotes grandes al final del día?).
- ¿Hay protección de rama observable? (¿la rama principal acepta push directo, o el historial muestra que todo entra por merge de PR?).
- ¿Hay registro del proyecto accesible donde ya vivan estas convenciones? (el hub del proyecto en el gestor de contexto del usuario; si el repo usa la suite SDD, el hub raíz).

Lo que no se pueda inferir, preguntar — corto, directo:

**Q1 — Modelo de branching.** ¿trunk-based (una rama principal, features efímeros muy cortos), gitflow (`main` + `develop` + `feature/`/`release/`/`hotfix/`), github flow (`main` + feature branches + PRs), u otro? **Esta respuesta gobierna todas las sugerencias de ramas de la sesión.**

**Q2 — Convención de commits.** ¿Conventional Commits (`feat:`, `fix:`, `chore:`...), otra convención propia, o sin convención definida? Si no hay ninguna, **proponer** Conventional Commits y esperar decisión — no imponerlo.

**Q3 — Política de PRs y autorización de push.** Dos cosas distintas, preguntarlas por separado:
- **PRs:** ¿obligatorios para llegar a la rama principal, u opcionales? ¿Requiere review de otra persona, o basta el del propio usuario?
- **Push:** ¿quién puede empujar y a dónde? ¿La rama principal está protegida? ¿Hay ramas donde el usuario empuja sin pedir permiso y otras donde no? Un repo personal y uno de equipo con rama protegida no admiten las mismas sugerencias, y el agente no puede deducirlo del `remote`.

**Q4 — Registro del proyecto.** ¿Existe un lugar donde documentar decisiones de branching, PRs y cambios relevantes — el hub del proyecto en Notion, o el gestor de contexto equivalente que use el usuario? Si no existe y el proyecto usa la suite SDD, ofrecer crearlo dentro del hub existente (nunca crearlo sin confirmación; ownership y estructura según `references/interop-notion.md`). Si el usuario no usa ninguna herramienta de este tipo, no se crea nada: las respuestas viven en la sesión.

**Q5 — Granularidad de commits.** ¿Prefiere commits pequeños y frecuentes (uno por propósito, aunque sean tres líneas), o commits mayores que agrupan una unidad de trabajo completa? ¿Hay algún límite acordado en el equipo? **Esta respuesta calibra cuándo el agente sugiere commitear** (ver §Gestión de commits): sin ella, el criterio de separabilidad semántica se aplicaría como si fuera preferencia del usuario cuando es solo el default de esta skill.

### Persistencia de las respuestas

Orden de preferencia, de menos a más intrusivo:

1. **Re-detectar en cada arranque** lo que el repo ya declara (lista de arriba). Es lo primero
   siempre, y en repos con historial consistente resuelve Q1, Q2 y buena parte de Q5 sin preguntar.
2. **Ofrecer persistir** lo que no se puede inferir (Q3 y Q5, típicamente) en el registro del
   proyecto de Q4 — Notion o el equivalente del usuario, usando la plantilla de
   `references/branch-change-tracker.md` (tabla "Convenciones activas del repo"). Se **ofrece**,
   nunca se escribe sin confirmación.
3. **Si no hay registro disponible**, las respuestas viven en el contexto de la sesión y se
   re-detecta en el siguiente arranque, preguntando solo lo no inferible.

En usos posteriores sobre el mismo repo: releer el registro si existe, re-detectar lo observable, y
preguntar solo lo que haya cambiado o no se pueda deducir. **Nunca repetir la entrevista completa.**

## Gestión de commits

### Cuándo sugerir un commit (nunca ejecutar sin confirmación)

> Los criterios de abajo son el **default de esta skill**, no una preferencia del usuario. La
> respuesta a **Q5 (granularidad)** manda sobre ellos: si el usuario declaró preferir commits
> mayores por unidad de trabajo, no se le sugiere dividir cada propósito; si declaró commits
> pequeños y frecuentes, se sugiere antes y con menos acumulación.

- **Criterio principal — separabilidad semántica.** Los cambios en staging tocan más de un propósito (fix + feature, refactor + nueva función, cambio de config + lógica de negocio). Cuando un conjunto de cambios es separable en propósitos distintos, sugerir dividirlo. La separabilidad importa más que el volumen: 3 líneas que mezclan dos propósitos merecen dos commits; 200 líneas de un solo propósito son un commit.
- **Criterio secundario — unidad de trabajo completa.** La sesión acumula cambios que representan algo coherente y cerrado: una tarea terminada, un criterio de aceptación cumplido, un bug reproducido y corregido.
- **Señal proactiva por acumulación.** Si el usuario lleva rato sin commitear y los cambios acumulados son coherentes, señalarlo una vez: "tienes N archivos modificados que forman un commit limpio (`<propósito>`) — ¿lo hacemos?". No repetir la sugerencia en cada turno.

### Cómo proponer un commit

1. Mostrar qué archivos entrarían (`git status` + `git diff --stat`, o `git diff --cached --stat` si ya hay staging).
2. Proponer el mensaje bajo la convención detectada/acordada en Q2.
3. Si los cambios son separables, proponer la división en dos o más commits y mostrar exactamente qué archivos/hunks van en cada uno.
4. Esperar confirmación del usuario sobre archivos, mensaje y división.
5. **Nunca `git add .`** sin revisión previa: siempre mostrar y stagear archivos por nombre.

### Verificación previa obligatoria antes de cualquier `git add`

Antes de stagear nada, confirmar que `.gitignore` cubre lo sensible: `.env` y variantes, secretos y credenciales, artefactos de build, `dist/`/`build/` (si aplica), archivos de IDE (`.idea/`, `.vscode/` según el repo), caches y dependencias (`node_modules/`, `vendor/`).

Si detecta un archivo sensible a punto de stagearse (un `.env`, una llave, un token en un archivo de config), **bloquear la acción y alertar al usuario antes de cualquier otra cosa** — no stagear "y avisar después". Proponer añadirlo a `.gitignore` y, si ya estaba trackeado, plantear el `git rm --cached` correspondiente como acción aparte a confirmar.

### Formato de mensaje (Conventional Commits como default)

```
<tipo>(<alcance opcional>): <descripción corta en imperativo>

[cuerpo opcional: qué y por qué, no cómo]

[footer opcional: refs a tareas Notion, BREAKING CHANGE]
```

Tipos principales: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `ci`, `style`, `perf`. Si la convención del repo (Q2) difiere de Conventional Commits, **seguir la del repo** — el default solo aplica cuando no hay convención y el usuario aceptó adoptarla.

### Contexto temporal: `git stash`

Cuando el usuario necesita cambiar de contexto con cambios sin commitear
(una interrupción, un hotfix urgente en otra rama, explorar algo sin
perder el trabajo actual), **proponer `git stash` antes de que haga un
commit temporal de "wip"** — un stash es más limpio y reversible que
un commit provisional que ensucia el historial.

Protocolo:
1. Detectar el cambio de contexto antes de que el usuario ejecute nada.
2. Proponer `git stash push -m "<descripción corta>"` con un mensaje
   descriptivo — nunca `git stash` sin `-m` (el stash sin nombre es la
   forma más rápida de olvidar qué contiene).
3. Registrar el stash activo en la conversación o en Notion (si existe
   la página del proyecto) para no olvidarlo: qué contiene y en qué
   rama se hizo.
4. Al retomar el contexto original, recordar proactivamente el stash
   pendiente antes de proponer nuevos commits: "tienes un stash de
   `<descripción>` — ¿lo aplico?"
5. **Nunca aplicar un stash sin confirmación explícita.**

Antipatrón a detectar: `git stash drop` o `git stash clear` sin haber
revisado primero qué contiene cada entrada (`git stash list` +
`git stash show -p stash@{n}`). Siempre mostrar el contenido antes de
proponer descartar.

## Gestión de ramas

### Cuándo sugerir una rama nueva

- El trabajo que inicia tiene duración o riesgo suficiente para que no convenga tocarlo directo en `main`/`develop`: feature no trivial, experimento, o un cambio que puede quedar a medias y roto.
- El modelo de branching del repo (Q1) lo requiere o lo favorece.
- **Nunca sugerir ramas en repos trunk-based con features cortos** — ahí la rama de larga vida ES el antipatrón; el flujo es commit pequeño y frecuente sobre la principal.

### Convención de nombres (proponer, no imponer)

```
<tipo>/<descripcion-en-kebab-case>

feat/reservas-endpoint
fix/ownership-fail-closed
chore/upgrade-dependencia-auth
```

Tipos de rama: `feat/`, `fix/`, `hotfix/`, `release/`, `chore/`, `experiment/`. Adaptar los prefijos al modelo del repo (Q1) y a lo observado en las ramas existentes.

### Cuándo sugerir eliminar una rama

- El PR asociado fue mergeado.
- La rama ya no tiene PR abierto ni commits pendientes de integrar, y no ha recibido actividad desde el merge de su trabajo o desde el abandono confirmado por el usuario. El tiempo sin actividad es una señal secundaria de limpieza — calibrar con el ritmo del proyecto observado en Q1; ante la duda, preguntar antes de proponer el borrado.
- **Siempre verificar antes de sugerir el borrado:** ¿la rama tiene commits que no están en su base (`git log <base>..<rama>`)? Si los tiene, **alertar** de que se perdería trabajo no integrado antes de proponer cualquier borrado.

### Documentar en Notion

Toda rama relevante (no las efímeras que viven minutos) merece una entrada en la sección de branching del Notion del proyecto: nombre, propósito, fecha de creación, PR asociado, fecha de cierre. **Ofrecer** crear/actualizar la entrada; nunca escribirla sin confirmación. Ownership y edición quirúrgica de páginas compartidas según `references/interop-notion.md`.

## Gestión de PRs

### Cuándo sugerir abrir un PR

- Una rama `feat/`/`fix/` está lista para integrar y la política del repo (Q3) requiere o favorece PRs.
- El usuario terminó un conjunto de commits que representa un cambio completo e independiente.

### Qué incluir en la propuesta de PR

- **Título** bajo la convención de commits del repo (Q2).
- **Descripción:** qué cambia, por qué, cómo probarlo, y criterios de aceptación cumplidos (enlazando al gate de Notion si existe).
- **Ramas confirmadas explícitamente:** origen y destino — nunca asumir el destino.
- **Checklist mínimo antes de proponer el PR:** ¿tests pasan?, ¿guardas de CI en verde?, ¿sin secretos stageados?, ¿rama actualizada con su base?

### Documentar en Notion

Ofrecer registrar el PR (número, título, rama, fecha) en la sección correspondiente del hub del proyecto. Como todo lo demás: se ofrece, no se ejecuta en silencio.

## Conflictos de merge

**Nunca resolver un conflicto de forma autónoma.** Protocolo:

1. Identificar cada archivo en conflicto y mostrar las diferencias (`HEAD` vs rama entrante).
2. Explicar el origen del conflicto en términos de negocio/lógica, no solo de diff: qué intención de cada lado chocó.
3. Para cada conflicto, presentar las opciones (quedarse con `HEAD`, con el entrante, o combinar) con el impacto de cada una.
4. Esperar la decisión del usuario **archivo por archivo**.
5. Nunca editar el archivo en conflicto sin instrucción explícita del usuario para ese archivo.

## Integración con la suite SDD

Si el repo usa la suite SDD harness (ver `references/interop-notion.md` para el contrato completo — estructura del hub, tabla única de Ps, ownership, handoffs, gates cruzados):

- El contexto de la sesión de git vive en el hub del proyecto en Notion: handoffs, criterios de aceptación, Ps abiertas. **Leerlo antes** de proponer una estructura de commits para una fase.
- Un commit que cierra una etapa SDD referencia la etapa en su footer: `refs: Fase N - Etapa X (Notion: <url>)`.
- Las guardas de CI del proyecto (anti-arrastre, patrones prohibidos) se verifican **antes** de proponer el commit — no después de que el push las rompa.
- El gate de una fase SDD no se declara cerrado hasta que el commit correspondiente exista y el CI esté en verde. Si se detecta un gate aprobado sin commit, recordárselo al usuario.

## Antipatrones a detectar y señalar (nunca ejecutar, siempre alertar)

1. `git add .` sin revisión — puede stagear secretos o artefactos.
2. Commit directo a `main`/`master` en repos con política de PRs (Q3).
3. Mensaje de commit vacío, genérico (`"changes"`, `"fix"`, `"wip"`) o que no sigue la convención acordada (Q2).
4. Rama con nombre genérico (`dev`, `test`, `temp`, un nombre de mes) o sin prefijo de tipo.
5. Rama con commits no mergeados a punto de borrarse — verificar `git log <base>..<rama>` antes.
6. Rebase de una rama compartida (publicada en el remote con otros trabajando en ella) — reescribe historial público.
7. Force push a `main`/`master` o a cualquier rama compartida.
8. Acumulación de tiempo sin commits en trabajo activo — señalarlo **una vez** (ver "Señal proactiva por acumulación" en §Gestión de commits para el criterio exacto de cuándo y cómo), no repetidamente ni en cada turno.

Ante cualquiera de estos: **alertar y explicar el riesgo; nunca ejecutarlo**. Si el usuario, informado, decide proceder de todos modos (p. ej. un force push a su propia rama de experimento), es su decisión — se ejecuta solo tras esa confirmación explícita.

## Lecciones y aprendizaje

Al cerrar un PR o un conjunto de commits relevante, **ofrecer** registrar una lección en la página "Lecciones SDD" del usuario si aparece algo que valga la pena recordar: un conflicto recurrente, una convención que se redefinió, un antipatrón que surgió. Solo se escribe si el usuario aprueba (formato y ownership de la página compartida en `references/interop-notion.md`).

## Recursos de la skill

- `references/interop-notion.md` — contrato de interoperabilidad con las demás skills de la suite (`sdd-harness-notion`, `derivar-proyecto`, `qa-discovery`, `qa-generator`) cuando operan sobre el mismo proyecto: estructura canónica del hub, tabla única de Ps con numeración compartida, ownership de páginas, ediciones quirúrgicas de páginas compartidas, handoffs y gates cruzados. Leer SIEMPRE que el repo esté (o vaya a estar) gestionado por la suite, antes de crear o editar cualquier página de Notion sobre branching, PRs o lecciones.
- `references/branch-change-tracker.md` — plantilla Notion de
  administración de ramas, PRs, stashes activos y decisiones de
  branching. Usar como referencia al proponer al usuario crear o
  actualizar la sección de branching del hub de su proyecto.
