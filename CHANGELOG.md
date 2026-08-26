# Changelog

## 2026-08-23
- **`documentation-master`: tres ajustes derivados de la iteración 1 de evals** (la skill
  sigue sin publicar, así que esto es afinado de v1.0, no una versión nueva).
- **Camino corto.** Para alcance puntual —uno o pocos archivos, un módulo aislado, sin
  proyecciones previstas— la entrevista se reduce a alcance y destino, no hay plan de etapas,
  ni gates intermedios, ni reporte de cobertura: se escribe directo al corpus. Sustituye a la
  sección "calibrar el esfuerzo", que describía la intención sin decir qué se quita.
  Lo que **no** se relaja: evidencia, procedencia y la marca de lo indeterminable — encoger
  eso convierte a la skill en una lectura atenta con más pasos.
  Dos guardas, porque un atajo sin guardas es una puerta trasera a los gates: **no aplica**
  con multi-repo, con proyecciones previstas o si el resultado alimentará un entregable; y se
  **propone**, nunca se asume. Ante la duda, camino largo.
- **Corpus autodescriptivo.** La cabecera del corpus en Notion declara las reglas que lo
  gobiernan (procedencias y su respaldo, formato del ancla, estados, qué significa cada
  marca). El motivo es que el corpus se lee muchas más veces de las que se escribe, y casi
  siempre desde una sesión que no cargó la skill: quien abra la tabla tiene que heredar la
  disciplina de la tabla misma. La prueba es directa — **un corpus que solo se entiende con
  la skill puesta está mal construido**. Va en `corpus.md` §10 y en la operación de Notion;
  no toca la interfaz mínima de `interop-notion.md` §8, que sigue siendo la misma.
- **Presupuesto de prosa.** Un modelo competente ya lee código con rigor y ya evita inventar
  si se lo piden; extenderse en eso gasta contexto sin mover el resultado. R1 queda enunciada
  y corta, y la densidad se movió a donde la brecha es real: cuándo derivar a otra skill
  (incluida la frontera por tamaño, que se confunde con la frontera por profundidad), cómo se
  declara **bloqueada** una proyección, cómo se **nombra al responsable** de un bloque
  faltante, y por qué no se genera el archivo aunque insistan.
  Riesgo declarado, a vigilar en la iteración 2: acortar R1 puede hacer caer los casos
  `logica-en-BD` y `dato-de-entrevista`, hoy en 4/4 con margen estrecho. Si caen, la causa es
  este recorte, no el camino corto.
- **Descripción (trigger) actualizada a la v2 medida.** Gana dos cosas que la v1 no cubría y
  que el cuerpo de la skill sí implementa: la **re-ejecución incremental** —"saber qué parte
  de lo ya documentado dejó de ser cierta tras nuevos commits", más el literal "actualizar el
  corpus"— y el **alcance de un solo módulo, handler o función** cuando lo que se pide es
  certeza con evidencia y no una explicación rápida. Esa segunda frase dejó de ser una
  promesa suelta al entrar el camino corto: ahora la descripción anuncia un alcance que el
  cuerpo sabe atender sin imponer seis etapas.
  Los tres negativos que fallaban en la v1 eran positivos de re-ejecución y de alcance
  puntual, que es exactamente lo que la v2 añade. Puntaje sobre casos válidos: **v1 14/17 →
  v2 16/17**; el único fallo que queda es un positivo, no un sobre-disparo. La delimitación
  frente a `project-onboarding`, `project-audit`, `project-deck` y `project-doc` se conserva
  palabra por palabra.
- **Validez de las corridas de triggering (auditoría, sin cambio de texto).** Una corrida solo
  mide delimitación si las skills competidoras están instaladas en el entorno; sin rival
  cargado, un negativo aprueba por ausencia. En el entorno de la iteración 1 faltaban
  `project-audit` y `qa-discovery` (y `project-doc`, que ni existe todavía en la suite), así
  que **tres negativos quedaron descartados** y el número de sobre-disparo de esa corrida no
  se usa. Revisado también el resto de la suite: ninguna otra descripción se optimizó con esa
  herramienta —el instrumental es del 2026-08-22 y todas las demás llevan sin tocarse desde
  julio—, así que no hay texto ajustado contra una señal rota.

## 2026-08-22
- **Skill nueva: `documentation-master` v1.0.** Extrae por etapas la lógica real de un
  proyecto existente y la consolida en Notion como **corpus** —afirmaciones atómicas con
  procedencia y respaldo— pensado como contexto persistente entre sesiones y como insumo de
  los renderizadores. Su entregable no es un documento: es el corpus más el contrato que
  permite proyectarlo a varias audiencias.
  La decisión de diseño que la gobierna es **separar extracción de renderizado**. Con varias
  audiencias previstas (manual de usuario, capacitación, PM, cliente, aval de desempeño) y
  varios formatos, mezclarlas obligaría a tocar la lógica de extracción cada vez que aparece
  una audiencia nueva.
  Cuatro reglas no negociables: **cero invención** (evidencia `archivo:línea` o
  `NO DETERMINADO` con motivo; prohibido describir intención sin fuente), **nada sin
  aprobación** (gate por etapa), **frontera con `project-onboarding`** (su inventario se
  consume y se valida, nunca se reescribe: es ownership ajeno) y **procedencia explícita**.
  Esta última resuelve la confusión más cara del diseño: un dato de runbook obtenido en
  entrevista **no es** `NO DETERMINADO` — es procedencia `entrevista`. Confundirlos hace que
  el corpus parezca más débil de lo que es; el error simétrico lo hace parecer más fuerte.
  El plan de etapas **no está hardcodeado**: se deriva del alcance declarado (un repo /
  multi-repo / flujo transversal), y cada etapa declara su perfil de ejecutor para no gastar
  capacidad de juicio en transcripción. Cinco references: `corpus.md` (esquema y ciclo de
  vida), `extraccion.md` (bloques, catálogo de reglas implícitas, criterios de evidencia),
  `notion.md`, `incremental.md` (anclaje y caducidad) y `proyecciones.md` (qué exige cada
  audiencia).
- **`interop-notion.md`: enmienda — regla 8, interfaz mínima del corpus.** El contrato gana
  la página `Corpus` en la estructura canónica y la interfaz que las demás skills pueden dar
  por cierta al leerlo: procedencia obligatoria, campos legibles garantizados, y
  `visibilidad = interna` como *no publicar*, no como *publicar con cuidado*.
  Se optó por un reparto **híbrido** en vez de meter el esquema completo: interop fija el
  mínimo compartido —igual que ya hacía con la tabla P— y el esquema entero vive en
  `documentation-master/references/corpus.md`. Ampliarlo no enmienda el contrato; quitar o
  renombrar un campo de los listados, sí. Sin esa asimetría, cada campo nuevo sería una
  enmienda que afecta a toda la suite.
  Las relaciones del corpus hacia tablas ajenas son **unidireccionales**. El motivo es
  concreto: en Notion una relación bidireccional crea propiedad recíproca en la tabla
  destino, o sea que "extender por relación y no por mutación" solo se cumple literalmente
  en un sentido. El precio —desde la tabla ajena no se ve el vínculo inverso— es más barato
  que la alternativa de cada skill añadiendo columnas a las tablas de las demás.
- **`.gitignore`: `.claude/skills/`, `.agents/` y `skills-lock.json`.** El instalador de
  skills deja sus herramientas dentro del árbol. Versionarlas republicaría código de
  terceros en un repo público y además rompía `check-neutralidad.sh --all`, que acababa
  auditando vocabulario ajeno y produciendo un fallo que no era del contenido propio.
- `scripts/neutralidad-permitidos.txt`: `DETERMINADO` y `DOCX`. El primero es el marcador
  literal de la skill nueva; el segundo, un nombre de formato. Ambos son vocabulario del
  método, no nombres propios.

## 2026-08-01
- **Licencia declarada: Apache-2.0.** Hasta ahora el repo era publico pero no
  usable: sin `LICENSE` aplica copyright por defecto y un tercero no puede
  clonar, adaptar ni redistribuir las skills — solo verlas y forkearlas dentro
  de GitHub. Apache-2.0 cubre prosa y scripts con una sola licencia, exige
  conservar la atribucion y declarar los cambios significativos, y no obliga a
  nadie a consultar con su departamento legal.
- `check-neutralidad.sh` y `seed-permitidos.sh`: **exclusion de textos de
  terceros verbatim** (`EXCLUIR`, aplicada en `--staged`, `--range` y `--all`).
  El texto de la licencia disparaba 23 tokens y un host, todos vocabulario
  juridico. Admitirlos en el allowlist habria sido permanente y habria dejado a
  la capa 4 sin capacidad de discriminar — el mismo modo de fallo que motivo
  fijar el locale. La exclusion va en ambos scripts: sembrar el allowlist desde
  el arbol sin ella reintroduciria el vocabulario en la siguiente regeneracion.
- `.gitignore`: **`private/`**, taller no versionado para borradores de posts,
  diagramas y decks. Es la unica carpeta del arbol donde puede haber material
  identificable; `--exclude-standard` hace que la auditoria la ignore por
  diseno. Lo que sale de ahi hacia una superficie publica pasa antes por
  `check-neutralidad.sh --msg`, que ya acepta cualquier archivo y cubre asi una
  superficie que los hooks no alcanzan.
- `CLAUDE.md`: el bloque de comandos omitia `install-claude.sh`, que es el unico
  camino de instalacion y el que va a usar quien llegue de fuera; y la
  descripcion del repo afirmaba dos ejecutables cuando hay seis. La fila de
  `project-audit` (anadida el 2026-07-29) gana la restriccion que su propio
  `description` ya declaraba: diagnostica, no modifica el codigo auditado.

## 2026-07-29
- sdd-harness-notion v1.3: **variante de análisis para proyecto desde cero**. La rama
  "nuevo" de Q1 declaraba "Fase de Análisis primero" y no llevaba a nada distinto: la
  fase estaba escrita asumiendo que hay algo que auditar —una base, un contrato, un
  DDL— y con un proyecto de cero mordía poco. § Fase de Análisis se desdobla en
  **variante A** (sobre base existente, el análisis *observa*) y **variante B** (desde
  cero, el análisis *propone una forma*).
  El modo de fallo de B es distinto y la disciplina se diseñó contra él: el riesgo no es
  leer mal el código sino **inventar una arquitectura verosímil que el usuario ratifica
  porque suena razonable**. De ahí la **regla de trazabilidad** que sustituye a
  `archivo:línea` — toda afirmación marcada `[declarado]` / `[inferido]` / `[P-n]`, con
  lo inferido presentado para confirmación y prohibición explícita de rellenar huecos
  con "lo habitual del sector".
  Ocho secciones: problema y alcance con su mitad negativa · anclas cuantitativas ·
  restricciones no negociables (incluida la capacidad real del equipo que mantendrá el
  sistema) · decisiones de arquitectura · lo que NO se construye · convenciones ·
  línea base prospectiva · Ps. Reglas: **una decisión sin alternativas rechazadas es una
  preferencia**, y el análisis propone mientras el gate decide — es la única fase cuyo
  entregable es propositivo.
  Nueva plantilla `references/plantillas.md` § 1b, deliberadamente más extensa que la de
  la variante A: donde no hay fuente que leer, el rigor lo aporta la estructura del
  entregable.
- sdd-harness-notion: **nueva Q6 de la entrevista — volumen y horizonte**. Con su
  **regla de anclaje**: toda propuesta de infraestructura se argumenta contra ese
  número; si el volumen no la justifica, se argumenta por mantenibilidad o por costo de
  cambio, declarando cuál. Es el complemento constructivo de la regla transversal 4, que
  hasta ahora solo sabía decir *no construyas*: el número permite además declarar por
  escrito **qué mecanismos NO hacen falta a esta escala**, para que una fase posterior no
  los reintroduzca. Aplica a todo el ciclo, pero su peso cambia — para un bug es una
  línea; para un proyecto de cero gobierna la arquitectura entera.
  Motivo: proponer arquitectura es donde un agente improvisa con más confianza y menos
  base. Sin ancla cuantitativa se acaba con infraestructura de gran escala para un
  sistema que no la necesita.
- sdd-harness-notion § S6: la convención de commits y el modelo de branching se declaran
  como **decisión**, y el mecanismo se deja a `git-workflow`, que la lee del registro del
  proyecto. Evita duplicar protocolo entre dos skills.
- project-audit: los ejemplos pasan al **universo sintético vigente**. Las rutas del handoff
  en `references/plantillas-auditoria.md` eran las únicas de la suite que no salían de ningún
  universo declarado, y ataban el archivo a un sector — dos de las seis categorías que busca
  el Prompt C a la vez (rutas de repo + vocabulario sectorial). El archivo declara ahora su
  dominio ilustrativo en la cabecera, como ya hacían los de qa-*, y `rubrica-severidad.md`
  pierde el mismo sesgo en su nota de contexto sobre severidad.
  Motivo de fondo: `check-neutralidad.sh --all` pasaba limpio sobre ellas. Es sesgo
  semántico, que es justo lo que el chequeo mecánico no ve. Registrado en
  `UNIVERSOS-SINTETICOS.md` § Dónde está en uso.
- CLAUDE.md: la tabla de arquitectura no listaba `project-audit`, que sí existía en
  `skills/`, en el contrato compartido y en el README. Añadida como transversal.
- project-audit: **ningún régimen de compliance nombrado**. La rúbrica de severidad y la Q5
  de la entrevista citaban tres regímenes concretos. La Q5 se reformula con una pista
  funcional —normativa sectorial, datos personales, medios de pago, historiales sensibles—
  que conserva su poder de reconocimiento sin nombrar ninguno; la rúbrica ancla en
  "compliance declarado en Q5", que ya era el anclaje de su propia escala.
  Retiradas también las tres entradas correspondientes de
  `scripts/neutralidad-permitidos.txt`: una allowlist con entradas muertas deja pasar en
  silencio lo que ya nadie usa. Verificado que la guarda ahora las rechaza.

## 2026-07-28
- qa-discovery v1.1: **agnóstica de stack y de dominio**. Nuevo Paso 1.0
  bloqueante — detectar el stack y confirmarlo con el usuario antes de aplicar
  convención alguna; los pasos 1.1–1.4 pasan de rutas literales de un framework
  a clases de artefacto. El `description` deja de acotar la skill a un stack
  concreto: **cambio de activación**, no solo de documentación (regla 6 de
  CLAUDE.md). Nueva referencia `references/domain-knowledge.md` — plantilla para
  levantar el conocimiento de dominio del proyecto (entidades y su riesgo de
  bug, flujos críticos, nueve formas de regla que suelen romperse, casos de alto
  valor) con las preguntas que destapan cada una; sustituye al catálogo de un
  sector concreto. `references/stack-patterns.md` reescrito como mapa agnóstico
  artefacto → tipo de prueba, con las señales de detección de stack y plantilla
  en blanco para documentar el propio.
  Motivo: la suite se comparte con terceros cuyo stack y sector se desconocen.
  Un ejemplo atado a un dominio empuja al modelo a leer *cualquier* proyecto a
  través de ese dominio.
- qa-generator v1.1: **agnóstica de stack**. El runner de pruebas viene
  declarado en el handoff y la skill no impone ninguno; nueva condición de
  parada si el handoff no lo declara (generar contra un stack supuesto produce
  código que no corre). El modo `e2e` deja de depender de una herramienta
  nombrada: delega en la del entorno según la tabla de equivalencias por
  runtime y, si no hay ninguna, la materializa con una guía mínima propia — el
  modo sigue siendo ejecutable. El doble eje se condiciona a "el módulo forma
  parte de un ecosistema de repos" en lugar de a un artefacto nombrado, y la
  sección se conserva íntegra. `description` actualizado (cambio de activación).
  Se eliminan `README.md` e `install.sh`: documentación de repo e instalador de
  un runtime, no contenido de skill, que `package.sh` empaquetaba dentro del
  `.skill`.
- git-workflow v1.2: entrevista de arranque ampliada. **Q3 se desdobla** en
  política de PRs y **autorización de push** — un repo personal y uno de equipo
  con rama protegida no admiten las mismas sugerencias, y el agente no puede
  deducirlo del `remote`. **Nueva Q5, granularidad de commits:** los criterios
  de §Gestión de commits quedan declarados como *default de la skill*, no como
  preferencia del usuario, y Q5 manda sobre ellos (antes se imponía la
  separabilidad semántica sin preguntarla). **Q4 deja de asumir Notion** y pasa
  a "el gestor de contexto del proyecto", con salida explícita si el usuario no
  usa ninguno. Nueva sección de **persistencia en tres niveles**: re-detectar
  siempre lo observable en el repo, ofrecer persistir lo no inferible en el
  registro del proyecto, y caer a contexto de sesión si no hay dónde — con dos
  señales de detección añadidas (granularidad observable en el historial,
  protección de rama observable).
  Motivo: era la única skill de trigger transversal que imponía parte de sus
  convenciones en lugar de preguntarlas, y su persistencia daba por hecha una
  herramienta concreta.
- UNIVERSOS-SINTETICOS.md: nueva convención de autoría a nivel de repo. Define
  el universo sintético del que salen los ejemplos de las skills, las siete
  reglas de un universo válido, cómo añadir uno nuevo sin repetir silueta, y
  tres plantillas de prompt (crear un universo, poblar un archivo, auditar un
  archivo). **No se empaqueta en ninguna skill:** es material de autoría, no de
  ejecución.
- Guardas de neutralidad: verificación mecánica de que no entre material
  identificable al repo, sobre **cuatro superficies** — contenido de archivos,
  nombres de archivo, **mensajes de commit** y nombre de rama. El mensaje de
  commit es la superficie que ninguna lectura de diff revisa.
  `scripts/check-neutralidad.sh` con cuatro capas: correos y hosts no
  permitidos; formas con aspecto de nombre propio; lista local opcional de
  prohibidos (`.neutralidad-local`, nunca versionada); y tokens no reconocidos
  contra `scripts/neutralidad-permitidos.txt`.
  **La lista versionada es de lo permitido, no de lo prohibido.** Una lista de
  prohibidos en un repo público republica exactamente lo que pretende ocultar, y
  además no puede conocer un nombre que todavía no existe; la inversión resuelve
  las dos cosas a la vez. Hooks en `scripts/hooks/` activados con
  `core.hooksPath` vía `install-hooks.sh`, de modo que viajan versionados con el
  repo en lugar de morir en cada clon.
  Workflow de CI declarado explícitamente como **auditoría posterior al push, no
  barrera**: cuando falla, el contenido ya está en el servidor. Su valor es
  cubrir lo que los hooks no ven — ediciones desde la web de la plataforma y
  clones sin hooks instalados.
  Límite declarado por escrito: ninguna expresión regular detecta filtración
  semántica, un ejemplo sin cadenas prohibidas que aún dibuje un sector o una
  arquitectura reconocibles. Para eso está el Prompt C de
  `UNIVERSOS-SINTETICOS.md`.
- CLAUDE.md: el repo se declara **público y destinado a terceros**. La regla 2
  pasa de cubrir solo las skills a cubrir todas las superficies —incluidos
  nombres de archivo, nombres de rama y mensajes de commit— y nombra la vía
  correcta para conservar el aprendizaje de un caso real: la página de Lecciones,
  que es privada. En el repo queda la *forma* del hallazgo, nunca el dato ni el
  proyecto del que salió. Nuevas reglas 3b (los ejemplos salen del universo
  sintético; el stack es ejemplo declarado, nunca requisito) y 3c (la neutralidad
  se verifica antes de commitear, no después).

## 2026-07-25
- sdd-harness-notion v1.2: tres reglas derivadas de fallas **silenciosas** —
  casos donde nada estaba en rojo, ningún test fallaba y ningún documento se
  contradecía, pero el plan estaba mal. Nueva regla transversal 2 ("una premisa
  heredada es una hipótesis fechada, no un hecho"): lo vinculante de un
  documento es su decisión, no cada afirmación técnica que lo acompaña, así que
  toda afirmación que venga de un handoff o del plan se verifica contra código
  o medición antes de construir sobre ella. Complementa la regla 1, que solo
  cubre el conflicto visible; las reglas 2–6 previas pasan a 3–7. La regla 6
  (evidencia) gana el test de discriminación y la 7 (guardas) la obligación de
  migrar guardas cuando una fase jubila el artefacto que vigilaban.
  Antipatrones 10–11: "criterio de aceptación que no discrimina" (pasa en verde
  aunque el mecanismo esté inerte — hay evidencia, pero no prueba lo que dice
  probar) y "guarda huérfana" (sigue verde protegiendo un artefacto que otra
  fase reemplazó; el silencio se lee como cobertura).
  Motivo: en un proyecto real, tres premisas heredadas resultaron falsas sin que
  nada las contradijera, un smoke se habría aprobado con el mecanismo inerte, y
  unas guardas quedaron cubriendo un artefacto ya reemplazado. Evidencia en la
  página Lecciones SDD.

## 2026-07-21
- sdd-harness-notion v1.1: modo de granularidad alta para ejecutores de bajo
  coste. Q4 gana la dimensión de capacidad (`puntero` / `intermedio` /
  `bajo coste`) con tabla de calibración; nueva subsección "tarea de inferencia
  cero" (ubicación exacta, forma del cambio, verificación literal, criterio de
  detención); regla de escalamiento por perfil (tipos de etapa no aptos para
  bajo coste) y columna "perfil requerido" en el esquema de la tabla de etapas
  del hub (cambio interno de la skill; el contrato interop no cambia);
  verificación asimétrica en gates (salida real vs salida esperada declarada,
  defecto atribuido al plan); antipatrones 7–9 (atomización sin porqué,
  granularidad teatral, verificación delegada al barato).
  Motivo: permitir planes ejecutables por modelos pequeños/baratos trasladando
  la inteligencia del ejecutor al plan.
- sdd-harness-notion/plantillas.md: nueva plantilla "subpágina de etapa modo
  granular" (§ 4b) y columna "perfil requerido" en la plantilla del hub de fase.

## 2026-07-20
- project-audit v1: nueva skill para auditar un proyecto existente contra 4
  pilares (seguridad, escalabilidad, rendimiento, mantenibilidad) y detectar
  debilidades/deuda técnica como insumo para rehacer con mejor arquitectura.
  Regla cero; entrevista de arranque bloqueante (Q1–Q5); regla de evidencia
  `file:line` o marca `hipótesis a validar`; fases 0–3 con entregable en Notion
  y gate por fase; Fase 2 con propuesta en dos variantes según destino (rehacer
  = arquitectura objetivo / remediar = estado objetivo dentro de la arquitectura
  actual); Fase 3 handoff consumible por derivar-proyecto (taxonomía heredable /
  no heredable / muerto, cuya fuente de verdad sigue en derivar-proyecto) o por
  sdd-harness-notion (plan de remediación por etapas). Delega el plan de pruebas
  a qa-discovery; no modifica código del proyecto auditado. Recursos
  `references/rubrica-severidad.md` (severidad por pilar) y
  `references/plantillas-auditoria.md` (entregables de cada fase).
- shared/interop-notion.md: hub "Auditoría" añadido a la estructura canónica
  (página propia de project-audit, análoga a la Matriz de herencia y al hub QA).

## 2026-07-16
- shared/interop-notion.md: tabla de equivalencias por runtime
  (Notion y skills del entorno para Kiro vs Claude/Claude Code).
- sdd-harness-notion: referencia de Notion agnóstica de runtime.
- project-deck: referencia a pptx skill agnóstica de runtime.
- git-workflow: verificación de referencias hardcodeadas (resultado
  en reporte de cierre).
- CLAUDE.md: tabla de skills actualizada (7 skills, columna
  "Integración prevista", nota de portabilidad).
- qa-discovery / qa-generator: frontmatter alineado a string
  entrecomillado (si aplica).
- project-onboarding v1: nueva skill para documentar un proyecto completo en
  Notion como snapshot único (visión, arquitectura, flujos, modelo de datos,
  integraciones, setup, glosario) con diagramas Mermaid. Regla cero (proponer
  estructura → aprobar → escribir); orienta al usuario sobre qué insumos
  aportar; huecos sin fuente marcados `⚠️ PENDIENTE` + P-n en la tabla única;
  exporta los diagramas a `references/diagrams-export.md` para project-deck.
  Recurso `references/mermaid-templates.md` con plantillas por tipo de diagrama.
- project-deck v1: nueva skill para generar una presentación (PPTX) del
  proyecto como snapshot puntual. Entrevista de arranque que detecta la
  audiencia (técnica / cliente-stakeholder / manual de usuario) y adapta
  todo el deck; Regla cero (proponer índice → aprobar → generar); consumo
  del bloque `diagrams-export` de project-onboarding con fallback a insumos
  adjuntos; lectura obligatoria de la `pptx` skill del entorno antes de
  generar; slides borrador (marca visual + lista final). Recurso
  `references/slide-templates.md` con los tres índices base y fuente por slide.
- git-workflow v1.1: referencia cruzada en antipatrón 8 → señal proactiva;
  criterio observable para eliminación de ramas (sin "tiempo considerable");
  cobertura de `git stash` con protocolo y antipatrón de descarte.
- git-workflow: nueva referencia `references/branch-change-tracker.md` —
  plantilla Notion de administración de ramas, PRs, stashes y decisiones
  de branching.

## 2026-07-15
- sdd-harness-notion v1: entrevista de arranque, Regla cero, pagina de Lecciones, plantillas.
- derivar-proyecto v1: entrevista de derivacion, matriz de herencia, guardas anti-arrastre, barrido de identidad.
- shared/interop-notion.md v1: estructura canonica, tabla unica de Ps, ownership de paginas, handoffs como interfaz, gates cruzados.
- qa-discovery / qa-generator: carpetas preparadas; pendiente migrar contenido desde Kiro.
