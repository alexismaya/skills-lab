# Plantillas de revisión adversarial — listas para llenar

`{placeholder}` se sustituye; los bloques marcados como opcionales se eliminan si no aplican.
El idioma de las plantillas sigue al del proyecto del usuario.

---

## 0. Paquete de revisión (lo que se arma ANTES de abrir el chat nuevo)

Lo arma el dueño del artefacto, no el revisor. Un paquete mal armado produce un contra-reporte
que discute con la conversación en vez de con el artefacto.

```markdown
# Paquete de revisión adversarial — {artefacto}

**Punto de intervención:** {A1 análisis | A2 propuesta de fases/etapas | A3 cierre de fase | A4 handoff}
**Artefacto:** {URL de Notion o texto completo, tal cual está}

## Fuentes primarias
1. {repo/ruta o URL del código que el artefacto dice haber leído}
2. {DDL, esquema o migración — la fuente real, no lo que el código sugiere}
3. {contrato / spec / colección, si existe}
4. **Declarado por el usuario, literal:** {sus palabras, entrecomilladas, sin parafrasear}

## Decisiones ya cerradas (no están en discusión)
- {P-x cerrada: decisión y quién la confirmó}
- {restricción no negociable declarada}

## NO se adjunta
- La conversación donde se produjo el artefacto.
- El razonamiento del autor sobre por qué eligió lo que eligió.
```

### Instrucción de arranque (texto literal para el chat nuevo)

```markdown
> Actúa como revisor adversarial de este artefacto. Tu trabajo es intentar
> tumbarlo, no mejorarlo: no edites el artefacto, no propongas soluciones y no
> reescribas nada. Lee `adversarial-review` y entrega el contra-reporte del
> punto {A1|A2|A3|A4}. Paquete de revisión: {URL o contenido}
```

---

## 1. Contra-reporte A1 — reporte de la Fase de Análisis

```markdown
# Contra-reporte A1 — Análisis de {proyecto/alcance}

**Artefacto revisado:** {enlace o título + fecha del artefacto}
**Fecha de revisión:** {fecha}
**Paquete:** {limpio | **contaminado** — incluía {qué}, el veredicto vale menos por ello}

## Objeciones (R-n)
{fichas, ordenadas por lo que gatean — lo que más bloquea, primero. Si no hay
ninguna, escribir "Ninguna sostenida" y pasar a la sección de lo que no pudo tumbarse.}

## Premortem
{hasta tres escenarios; ver § 6}

## Qué intenté tumbar y no pude
| Qué ataqué | Con qué | Por qué resistió |
|---|---|---|
| {decisión / afirmación / sección} | {la fuente primaria que abrí, el escenario que construí} | {qué lo sostiene} |

## Cobertura de la revisión
| Tipo | Aplicado | Resultado |
|---|---|---|
| premisa-no-verificada | sí/no aplica | {R-x / sin objeción} |
| alternativa-de-paja | | |
| ancla-ausente | | |
| criterio-que-no-discrimina | | |
| frontera-ambigua | | |
| p-ausente | | |
| guarda-ausente-u-huerfana | | |
| inferencia-encadenada | | |

## Veredicto
**{sin objeciones sostenidas | objeciones que corregir antes de ejecutar | objeciones que bloquean}**
{Una línea: qué queda detenido, si algo. El gate lo decide el usuario, no este reporte.}
```

> En la variante desde cero, la sección de decisiones de arquitectura se ataca decisión por
> decisión: cada una necesita alternativas reales, ancla al número declarado, y su condición de
> invalidación. Las tres faltan juntas con frecuencia — y aun así son tres tipos distintos, no
> una ficha genérica de "decisión mal argumentada".

---

## 2. Contra-reporte A2 — propuesta de fases/etapas (antes de crear páginas)

Misma estructura que A1, con una sección propia que la sustituye a la cobertura por tipo: el
recorrido de antipatrones de planificación. Es el punto más barato del ciclo y el que más
devuelve.

```markdown
# Contra-reporte A2 — Propuesta de fases/etapas de {proyecto}

**Artefacto revisado:** {la propuesta, tal como se presentó}
**Fecha de revisión:** {fecha}
**Paquete:** {limpio | contaminado}

## Objeciones (R-n)
{fichas}

## Recorrido de antipatrones de planificación
| # | Antipatrón | ¿Presente? | Dónde (cita) |
|---|---|---|---|
| 1 | Etapa tardía reintroduce lo que una temprana excluyó | | |
| 2 | Verificación diferida sin red intermedia | | |
| 3 | Frontera ambigua | | |
| 4 | Handoff ausente | | |
| 5 | P abierta sin gate | | |
| 6 | Checkbox sin evidencia | | |
| 7 | Atomización sin porqué | | |
| 8 | Granularidad teatral | | |
| 9 | Verificación delegada al ejecutor barato | | |
| 10 | Criterio de aceptación que no discrimina | | |
| 11 | Guarda huérfana | | |

{Un antipatrón "no presente" se declara así. No se rellena con una objeción inventada.}

## Grafo de dependencias — artefactos sin dueño claro
| Artefacto | Quién lo crea | Quién lo consume | Problema |
|---|---|---|---|

## Premortem
{hasta tres escenarios}

## Qué intenté tumbar y no pude
{tabla}

## Veredicto
**{...}**
```

---

## 3. Contra-reporte A3 — reporte de cierre de fase

Aquí el objetivo es distinto: no se ataca lo que el plan propone, se ataca **lo que la evidencia
demuestra**. La pregunta rectora es si algún criterio pasaría en verde con el mecanismo inerte.

```markdown
# Contra-reporte A3 — Cierre de Fase {N}: {nombre}

**Artefacto revisado:** {reporte de cierre + evidencias adjuntas}
**Fecha de revisión:** {fecha}
**Paquete:** {limpio | contaminado}

## Evidencia por criterio — prueba del mecanismo inerte
| Criterio | Evidencia presentada | ¿Pasaría con el mecanismo inerte? | Ficha |
|---|---|---|---|
| {n} | {artefacto citado} | {sí + cómo / no + qué lo impide} | {R-x / —} |

{Un "sí" en la tercera columna es siempre una ficha: la evidencia no prueba lo que dice probar.}

## Objeciones (R-n)
{fichas}

## Desviaciones no declaradas
{Decisiones tomadas donde el plan pedía detenerse, dependencias añadidas, alcance ampliado —
que el reporte no menciona. Una desviación declarada y justificada no es objeción.}

## Barrido de handoffs de la fase (A4 en lote)
{ver § 4}

## Premortem
{hasta tres escenarios}

## Qué intenté tumbar y no pude
{tabla}

## Veredicto
**{...}**
```

---

## 4. Barrido de handoff (A4)

Corre en lote dentro de A3, o suelto a demanda de la skill que va a consumir el handoff. No
produce contra-reporte propio salvo que se invoque suelto: produce esta tabla.

```markdown
## Barrido de handoffs — Fase {N}

| Etapa | Handoff | Qué falta para quien lo consume | Consumidor afectado | Ficha |
|---|---|---|---|---|
| E{n} | {enlace} | {el dato concreto, no "es pobre"} | {etapa siguiente / qa-discovery / documentation-master / project-doc} | {R-x / —} |

Preguntas del barrido, por handoff:
- ¿Nombra los artefactos que produjo, con ruta, o solo los describe?
- ¿Declara las decisiones que tomó, incluidas las menores que la siguiente etapa heredará?
- ¿Dice qué quedó fuera y por qué, o solo lo que hizo?
- ¿La etapa siguiente puede arrancar con esto y su propia subpágina, sin releer el repo?
- ¿Hay alguna afirmación aquí que la siguiente etapa vaya a tratar como hecho sin verificarla?
```

---

## 5. Ficha de refutación `R-{n}`

```markdown
### [R-{n}] {título corto, la objeción en una línea}
- **Tipo:** premisa-no-verificada | alternativa-de-paja | ancla-ausente | criterio-que-no-discrimina | frontera-ambigua | p-ausente | guarda-ausente-u-huerfana | inferencia-encadenada
- **Cita:** «{fragmento literal del artefacto}» — {ubicación: sección, tarea, criterio n, etapa}
- **Por qué no se sostiene:** {el argumento. Si hay contra-evidencia en el código, con `archivo:línea`. Si la objeción es que no es verificable con lo declarado, decirlo así — no afirmar que es falsa.}
- **Qué haría falta para sostenerlo:** {la condición concreta que cierra la objeción}
- **Qué gatearía si se acepta:** {etapa, fase o entregable que queda detenido. Si este campo queda vacío, esto no era una ficha.}
```

Notas menores (opcional, al final del contra-reporte, sin ficha):

```markdown
## Notas menores (no gatean nada)
- {observación en una línea}
```

---

## 6. Premortem

```markdown
## Premortem
> La fase terminó. El gate se aprobó. Tres meses después esto se rehízo. ¿Qué falló?

1. **{escenario en una frase}** — {anclado a: cita del artefacto → se convierte en R-x}
2. **{escenario}** — {descartado porque: {motivo concreto}}
3. **{escenario}** — {anclado / descartado}
```

Máximo tres. Cada escenario termina anclado a una línea del artefacto o descartado con motivo;
un escenario que no es ninguna de las dos cosas no se escribe.

---

## 7. Alta de P-n derivadas de refutaciones aceptadas

Lo ejecuta el dueño del artefacto tras aceptar la objeción, con edición quirúrgica sobre la tabla
única del proyecto. La numeración continúa la del proyecto: **nunca se reinicia**.

```markdown
| id | tema | origen | gatea | estado | resolución |
|---|---|---|---|---|---|
| P-{n} | {el tema de la objeción, no su título} | adversarial-review · {A1/A2/A3/A4} · R-{x} | {etapa o fase detenida} | abierta | |
```

Refutación rechazada (no genera P; se registra en el gate):

```markdown
**Objeción R-{x} rechazada.** Motivo: {la razón del usuario}. Riesgo asumido: {qué pasa si la
objeción resulta correcta}. Candidata a Lecciones SDD: {sí/no}.
```

---

## 8. Hub de Revisión adversarial en Notion

```markdown
# Revisión adversarial — {Proyecto}

> Contra-reportes del proyecto. Cada uno revisa un artefacto en un punto del ciclo y
> **no lo modifica**: las correcciones las hace el dueño del artefacto.

## Contra-reportes
| Fecha | Punto | Artefacto revisado | Veredicto | Objeciones sostenidas | Ps derivadas |
|---|---|---|---|---|---|
| {fecha} | A{n} | {enlace} | {veredicto} | {n} | {P-x, P-y} |

## Omisiones declaradas
| Gate | Punto omitido | Motivo | Quién lo decidió |
|---|---|---|---|
{Un contra-reporte que no se hizo se anota aquí. Un punto obligatorio (A1, A2) omitido se
declara también en el gate correspondiente.}
```
