# Proyecciones a documento: requisitos por audiencia

Qué bloques del corpus exige cada audiencia, con qué nivel de detalle, qué omite, y qué
ocurre cuando un bloque falta. Se lee en **Q2** de la entrevista (para saber qué audiencias
son posibles con el corpus actual) y al **emitir la lista de borradores** al cierre.

Complementa `references/proyecciones.md` de `documentation-master`, que define el mismo
contrato desde el punto de vista de la extracción. Aquí está el punto de vista del
renderizador: cómo se comporta esta skill cuando los bloques faltan o están incompletos.

## Leyenda

- **obl.** — obligatorio: sin él la sección se declara bloqueada.
- *des.* — deseable: se produce sin él, declarando el hueco como borrador.
- `—` — no lo consume esta audiencia.

## Tabla de requisitos

| Bloque | Manual de usuario | Capacitación | Documentación de PM | Handover técnico | Presentación a cliente | Aval de desempeño |
|---|---|---|---|---|---|---|
| `superficie` | **obl.** | **obl.** | *des.* | **obl.** | *des.* | *des.* |
| `logica-negocio` | **obl.** (flujos de interfaz) | **obl.** | *des.* | **obl.** | *des.* | **obl.** |
| `modelo-datos` | `—` | *des.* | `—` | **obl.** | `—` | `—` |
| `integraciones` | *des.* | **obl.** | *des.* | **obl.** | `—` | `—` |
| `zonas-oscuras` | `—` | *des.* | **obl.** | **obl.** | `—` | *des.* |
| `operacion` | *des.* | **obl.** | **obl.** | **obl.** | `—` | `—` |
| `riesgo` | `—` | `—` | **obl.** | *des.* | `—` | `—` |
| `trayectoria` | `—` | `—` | *des.* | `—` | `—` | **obl.** |
| `pruebas` | `—` | *des.* | *des.* | **obl.** | `—` | *des.* |

## Por audiencia: qué pasa cuando falta un bloque

### Manual de usuario

- **`logica-negocio` falta (flujos de interfaz):** la sección de casos de uso queda bloqueada.
  Sin ella el manual es solo una portada y requisitos — no es usable como manual. Declarar
  bloqueado, responsable `documentation-master`.
- **`superficie` falta:** los requisitos de acceso y las guardas no se pueden documentar.
  Bloqueado. Responsable `documentation-master` o `project-onboarding` si existe onboarding.
- **`operacion` falta:** las preguntas frecuentes y los procedimientos de soporte quedan como
  borrador. Responsable: skill de captura operativa (entrevista).
- **Visibilidad:** solo se incluyen entradas `externa`. Si `logica-negocio` de los flujos de
  interfaz tiene solo entradas `interna`, esas secciones quedan bloqueadas hasta que alguien
  revise la visibilidad en el corpus.

### Capacitación

- **`operacion` falta:** la sección de runbook y procedimientos queda bloqueada. Es el hueco
  más frecuente y el más costoso: el equipo que se capacita se va a topar con los fallos, y
  necesita saber qué hacer. Responsable: skill de captura operativa (entrevista).
- **`integraciones` falta:** la sección de integraciones y fallos queda borrador. Responsable
  `documentation-master`.
- **`zonas-oscuras` falta:** se omite la sección de comportamientos inesperados. El material
  de capacitación es menos robusto — declararlo en el prefacio del documento.
- **Visibilidad:** uso interno; se incluyen entradas `interna`. Las entradas de procedencia
  `entrevista` se marcan como tales para que el lector sepa qué está verificado en código.

### Documentación de PM

- **`riesgo` falta:** la sección de riesgos queda bloqueada. Sin riesgos, una documentación
  de gestión no sirve para gestionar. Responsable `project-audit`.
- **`operacion` falta:** la sección de coste operativo queda bloqueada. Responsable: skill
  de captura operativa.
- **`zonas-oscuras` falta:** la sección de deuda declarada queda bloqueada. Responsable
  `documentation-master`.
- **Nota:** esta audiencia es la que más depende de bloques que `documentation-master` no
  produce sola. Informar en Q2 para que el usuario decida si espera o acepta el documento
  con borradores.

### Handover técnico

- Todos los bloques estructurales son obligatorios. Si alguno falta, la sección
  correspondiente se declara bloqueada con su responsable.
- **`operacion` falta:** quedan bloqueadas las secciones de puesta en marcha, ambientes,
  accesos, criterios de liberación y responsables — es decir, toda la guía de incorporación.
  Responsable: `documentation-master`, que lo captura en entrevista con quien opera el
  sistema. **Esta es la carencia que más se subestima en esta audiencia:** el documento se ve
  completo sin ella, porque todo lo estructural tiene evidencia, y aun así el receptor no
  puede levantar el sistema el primer día. Un handover sin puesta en marcha describe el
  sistema; no lo entrega.
- **`pruebas` falta:** queda bloqueada la sección de verificación. Responsable `qa-discovery`.
  El receptor no tiene con qué confirmar que lo que levantó funciona, y todo cambio que haga
  después parte de una base que nunca validó.
- **`zonas-oscuras` nunca se omite** en un handover: entregar un sistema sin su lista de
  trampas es entregar la mitad. Si falta en el corpus, es un bloque a producir antes del
  handover, no algo que omitir.
- **Entradas `por revalidar`:** se incluyen marcadas como "pendiente de revalidar desde
  {ancla anterior}". Quien recibe el sistema necesita saber qué puede haber cambiado.
- **Entradas de procedencia `entrevista`:** marcadas explícitamente. El receptor tiene derecho
  a saber qué está demostrado en código y qué fue declarado por una persona.

### Presentación a cliente

- Rara vez se bloquea: en muchos casos la fuente principal es la declaración del usuario,
  no el corpus.
- **`superficie` falta:** los flujos de alto nivel quedan borrador. Se puede producir desde
  la declaración del usuario marcándola como `entrevista`.
- **Visibilidad:** solo se incluyen entradas `externa`. Es la proyección más restrictiva en
  este sentido — cualquier detalle interno que apareciera en el documento sería una fuga de
  información.
- **`zonas-oscuras` y `riesgo` no se consumen.** Es una decisión de audiencia, no una omisión
  del corpus. Declararlo así en el prefacio si el usuario pregunta por qué no aparecen.

### Aval de desempeño

- **`trayectoria` falta:** bloqueado. Sin el registro de qué cambió, cuándo y a raíz de qué,
  no hay desempeño que avalar — hay una descripción del sistema en su estado actual.
  Responsable `git-workflow`.
- **`logica-negocio` falta:** las contribuciones con evidencia quedan borrador. Se puede
  producir desde la declaración del usuario marcándola como `entrevista`, pero un aval apoyado
  solo en declaraciones del evaluado tiene poco peso. Declararlo.
- **Procedencia:** es la proyección con exigencia de respaldo más alta. Una afirmación de
  procedencia `entrevista` puede acompañar, pero no puede ser la única evidencia de una
  contribución técnica.

## Cómo se declara y reporta un bloque faltante

Al emitir el índice propuesto (Regla cero) y al cierre, el reporte de borradores sigue este
formato por sección:

```
[PENDIENTE]
Sección: {nombre de la sección}
Bloque faltante: {nombre del bloque}
Estado en el corpus: {ausente / bloqueado / incompleto}
Responsable: {skill o rol que produce ese bloque}
Qué desbloquea: {qué tiene que pasar para que esta sección pueda generarse}
```

Este formato es el que se registra también en la tabla de Cobertura por proyección del hub
Corpus, si el proyecto usa Notion.

## Bloques que esta skill no produce

Si el usuario pide rellenar un bloque que falta, la respuesta es siempre la misma: remitir
a quien lo produce, con nombre concreto.

| Bloque faltante | Quién lo produce | Qué NO se hace en su lugar |
|---|---|---|
| `operacion` | `documentation-master`, en entrevista dirigida con quien opera el sistema | Deducir procedimientos del código: reconstruir la puesta en marcha leyendo el gestor de dependencias produce un procedimiento verosímil que nadie ha ejecutado |
| `pruebas` | `qa-discovery` (qué está cubierto) / `qa-generator` (las suites) | Redactar casos de prueba desde el corpus, o dar por cubierto un flujo porque exista un archivo de prueba con su nombre |
| `riesgo` | `project-audit` | Emitir juicios de calidad o severidad |
| `trayectoria` | `git-workflow` | Reconstruir la historia leyendo el estado actual del corpus |
| `logica-negocio` incompleto | `documentation-master` | Inferir la lógica de los nombres de función |
| `superficie` incompleto | `documentation-master` o `project-onboarding` | Enumerar rutas o endpoints sin evidencia |
