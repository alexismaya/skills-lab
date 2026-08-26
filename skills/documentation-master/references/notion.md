# Operación en Notion

Cómo vive el corpus dentro del hub del proyecto, sin pisar el ownership de las demás skills
de la suite. El contrato compartido (`interop-notion.md`) manda sobre este documento: aquí
solo está lo específico de `documentation-master`.

## Estructura de páginas

```
{Proyecto} (hub raíz)
├── Preguntas abiertas (P)      ← tabla ÚNICA del proyecto (ajena: compartida)
├── Documentación                ← ajena: project-onboarding
├── Auditoría                    ← ajena: project-audit
└── Corpus                       ← hub de esta skill
    ├── (cabecera autodescriptiva) ← bloque fijo: reglas del corpus (corpus.md §10)
    ├── Entradas del corpus      ← tabla propia (esquema en corpus.md)
    ├── Plan de etapas           ← una subpágina por etapa
    ├── Anclas de ejecución      ← tabla propia (incremental.md)
    └── Cobertura por proyección ← tabla propia (proyecciones.md)
```

Si el proyecto ya tiene estructura propia, esta convención **se adapta a ella**: se agregan
las páginas que falten con la nomenclatura existente, no se reorganiza lo que hay.

**Ownership.** Esta skill crea y edita únicamente el hub **Corpus** y sus subpáginas. La
tabla de Ps es compartida y se edita de forma quirúrgica (una fila nueva, una celda de
resolución), nunca reescribiéndola. Las páginas de `project-onboarding`, `project-audit` y
`sdd-harness-notion` son de solo lectura para esta skill, sin excepción y sin "corrección de
paso".

## La tabla de entradas del corpus

Propiedades, en el orden en que conviene verlas:

| Propiedad | Tipo en Notion | Notas |
|---|---|---|
| `id` | título | `C-n`, correlativo del proyecto |
| `afirmacion` | texto | Una frase; reglas en `corpus.md` §3 |
| `bloque` | selección | Vocabulario cerrado, `corpus.md` §2 |
| `procedencia` | selección | `codigo` / `entrevista` / `auditoria` / `historial` |
| `respaldo` | texto | Formato según procedencia |
| `ancla` | relación → Anclas de ejecución | Unidireccional |
| `estado` | selección | `nuevo` / `vigente` / `por revalidar` / `obsoleto` |
| `entidad` | relación → entidades del proyecto | **Unidireccional** |
| `visibilidad` | selección | `externa` / `interna` |
| `etapa` | relación → Plan de etapas | Unidireccional |
| `p_relacionada` | texto | `P-n`; texto, no relación, para no tocar la tabla compartida |
| `sustituye_a` | texto | `id` de la entrada que deja obsoleta |

Vistas útiles sobre la misma tabla —crear las que el proyecto necesite, no las doce—:
por bloque, por estado (para ver de un vistazo lo `por revalidar`), solo `NO DETERMINADO`,
y solo `visibilidad = externa` (la vista que un renderizador de entregable externo consume).

## Relaciones unidireccionales

En Notion, una relación bidireccional **crea una propiedad recíproca en la tabla destino**.
Eso es una modificación de un artefacto ajeno, y esta skill no las hace. Al crear cualquier
relación hacia una tabla que no le pertenece, se configura **sin propiedad recíproca**
(relación de un solo sentido).

Consecuencia asumida: desde la tabla ajena no se ve el vínculo inverso. Se entra siempre por
el corpus. Es el precio de no mutar lo que no se posee, y es más barato que la alternativa
—cada skill añadiendo columnas a las tablas de las demás hasta que nadie sepa quién escribió
qué—.

Si `project-onboarding` documentó el proyecto como **páginas de texto** en vez de tablas, no
hay destino relacionable: en ese caso `entidad` se llena con el nombre del módulo o flujo como
texto y se enlaza la página con un vínculo normal. Un enlace tampoco muta nada.

**Si de verdad hiciera falta una columna en una tabla ajena**, eso no se resuelve
escribiéndola: es una **enmienda al contrato compartido**, se propone al usuario y se decide
fuera de la ejecución. El precedente de procedimiento es cómo `project-audit` incorporó su
hub a la estructura canónica.

## Preguntas abiertas

- Viven en la **tabla única de Ps del proyecto**, con numeración compartida que continúa la
  secuencia existente y nunca se reinicia.
- Columnas mínimas del contrato compartido: id · tema · origen · gatea · estado · resolución.
  El `origen` de las de esta skill es `documentation-master` más la etapa.
- **`gatea` es el campo que hace útil la P**: dice qué trabajo está detenido. Una P que no
  declara qué bloquea se convierte en una nota que nadie revisa.
- Una P se cierra con **cómo se resolvió y quién lo confirmó**. Si la resolución aporta un
  hecho nuevo del sistema, ese hecho entra al corpus con procedencia `entrevista` — cerrar la
  P no es archivar el conocimiento, es incorporarlo.

Nada de esto vive en el chat. Esta skill está diseñada para ejecutarse en varias sesiones; lo
que solo existe en una conversación se pierde al cerrarla.

## Etapas y gates

Cada etapa del plan es una subpágina bajo **Plan de etapas**, escrita para que un chat nuevo
la ejecute sin más contexto que ella misma:

1. **Alcance del tramo** — qué entra y qué no, explícitamente.
2. **Insumos** — repos, rutas, ancla de ejecución, y qué entradas de corpus previas se leen.
3. **Bloque y perfil de ejecutor** — de `extraccion.md` §9.
4. **Qué cuenta como evidencia** en este tramo.
5. **Dónde escribir** — la tabla del corpus, y qué NO tocar.
6. **Checklist de cierre** — los seis puntos de `extraccion.md` §11.
7. **Gate** — casilla de aprobación del usuario, con espacio para su corrección.

Mientras el gate no está aprobado, las entradas de la etapa quedan en `estado = nuevo` y la
etapa siguiente no arranca. Un gate aprobado promueve el lote a `vigente`.

## Operación

- **Crear**: proponer la estructura completa, esperar aprobación, luego crear. La página
  `Corpus` se crea **con su cabecera autodescriptiva** (`corpus.md` §10) antes de la primera
  entrada: quien lea la tabla sin haber cargado esta skill tiene que encontrar ahí las reglas
  que la gobiernan.
- **Editar**: siempre quirúrgico —una fila, una celda, un bloque—. Reescribir una página
  compartida está prohibido para todas las skills de la suite: destruye historial, anclas y
  bloques de otras skills.
- **Leer** el hub existente antes de proponer nada, para adaptarse a su nomenclatura.
- **Acceso entre integraciones**: si las páginas las creó otro agente con su propia
  integración, pueden nacer inaccesibles. Se pide al usuario compartirlas o moverlas a una
  sección conectada. **Nunca aceptar un token de integración pegado en el chat**: se comparte
  la página, no el secreto.
- **Pruebas**: si se está probando la skill y no operando un proyecto real, escribir en una
  página sandbox. Esta skill crea tablas y relaciones; una prueba mal dirigida contamina el
  corpus de trabajo.
- La equivalencia de herramientas por runtime (conector de Notion en Claude, MCP en Kiro)
  está en el contrato compartido.

## Lecciones

Al cerrar cada gate, ofrecer registrar en la página **"Lecciones SDD"** del usuario lo que
esta skill aprende mejor que ninguna otra: qué afirmación resultó ser una invención por
completar el patrón, qué se marcó `NO DETERMINADO` y en realidad estaba a una lectura de
distancia, y qué pregunta de la entrevista faltó para no descubrir tarde el alcance real.
