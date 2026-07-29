# Universos sintéticos — convención de autoría

Este repo es **público y está pensado para que lo use gente ajena a quien lo escribe**. De ahí dos
reglas que gobiernan todo ejemplo dentro de una skill:

1. **Confidencialidad.** Ningún ejemplo lleva nombres, reglas de negocio, identificadores,
   dominios ni estructuras de un proyecto real.
2. **Neutralidad.** Un ejemplo tomado de un sector concreto empuja al modelo a leer *cualquier*
   proyecto a través de ese sector. El ejemplo tiene que enseñar la **forma**, no el dominio.

Un **universo sintético** es un dominio ficticio, deliberadamente anodino, del que salen todos los
nombres que los ejemplos necesitan. Este archivo define los universos vigentes y cómo se crean
nuevos.

> **Este archivo no se empaqueta en ninguna skill.** Es una convención de autoría: se consulta al
> escribir o editar una skill, no en tiempo de ejecución.

---

## Reglas de un universo válido

1. **Evidentemente ficticio.** Nada que pueda confundirse con una empresa, producto o marca real.
2. **Sin nombre de empresa.** Si el ejemplo funciona con un rol ("el proveedor externo", "el panel
   de administración"), va el rol. Solo se inventan identificadores donde el código exige un
   símbolo. *Genérico antes que ficticio.*
3. **Anodino y ajeno.** El sector se elige por aburrido y por no ser el de nadie en particular.
4. **Estructuralmente suficiente.** Debe cubrir lo que los ejemplos de la suite necesitan: multi-
   tenancy, un tercero externo, un flujo de varios pasos con un punto irreversible, un cálculo con
   condiciones, y un documento generado.
5. **Coherente en todo el repo.** Un mismo concepto se llama igual en todos los archivos. Dos
   sistemas que se cruzan llevan los mismos nombres en cada ejemplo donde aparecen.
6. **Dominios reservados.** Cualquier host de ejemplo usa un dominio reservado para documentación
   (`example.com`, `example.org`, `example.net`). Nunca un dominio que resuelva a algo real.
7. **La forma se conserva, el dato no.** Un cruce de identificadores entre dos sistemas, una
   agregación no lineal, una frontera horaria que no es medianoche: eso es método y se reescribe.
   Los porcentajes, plazos y reglas concretas de un negocio real desaparecen.

---

## Universo 1 — Reserva de espacios y recursos compartidos *(vigente)*

Plataforma multi-tenant donde cada organización publica sus espacios (salas, escritorios, equipo) y
sus miembros los reservan. Hay un proveedor externo de por medio y un flujo
*solicitud → confirmación → comprobante*.

### Entidades

| Entidad | Qué es |
|---|---|
| `Solicitud` | Petición de reserva antes de confirmarse; lleva la tarifa calculada |
| `Reserva` | Solicitud confirmada; genera comprobante |
| `Espacio` | Recurso reservable (sala, escritorio, equipo) |
| `Ocupante` | Persona que usará el espacio |
| `Solicitante` | Quien reserva y paga; puede no ser el ocupante |
| `Tarifa` | Monto de la reserva |
| `Marketplace` / `Tenant` | Organización que opera en la plataforma |
| `Incidencia` | Problema reportado sobre una reserva en curso |

### Operaciones

`solicitar` · `confirmar` · `modificar` · `prorrogar` · `cancelar`

### Campos con forma deliberada

| Campo | Forma que ilustra |
|---|---|
| `ocupante_id` (distinto del `id` en otro sistema) | Identificador que cruza sistemas |
| `folio_reserva` / `codigo_confirmacion` | Identificador inestable vs. clave estable |
| `tarifa_total` / `tarifa_periodo` | Agregación no lineal (total ≠ periodo × n) |
| `hora_inicio` → `recargoFueraDeHorario` | Recargo condicionado por un atributo |
| `identificador_externo` | Campo de cruce entre sistemas |

### Estados

- Habilitación de un recurso: `creadoGeneral` → `habilitadoEnTenant` → `deshabilitado`
- Acceso de un ocupante: `sinAcceso`, `conRestriccion`

### Símbolos de código

`ProveedorService` · `ProveedorClient` · `SyncEstadoProveedor` · `CalculadoraTarifa` ·
`ConfirmarReservaJob` · `FormularioSolicitud` · `SolicitudPage` · `ConfirmacionPage` ·
`FormateadorTarifas`

### Ecosistema

| Pieza | Nombre |
|---|---|
| Portal de usuario | `portal-front` |
| Panel de administración | `admin-front` |
| Servicio de catálogos | `api-catalogos` |
| Especificación de API | `api-espacios.v3.yaml` |
| Tenant de ejemplo | `tenant-demo` |
| Host externo | `api.example.com` |
| Endpoint de ejemplo | `POST /api/solicitudes` |
| Selector de ejemplo | `#btn-reservar` |

### Dónde está en uso

`qa-discovery/SKILL.md` (tabla de superficies) · `qa-discovery/references/coverage-antipatterns.md`
· `qa-generator/references/{unitario,integracion,e2e,infraestructura}.md` ·
`qa-generator/templates/trazabilidad.md` · `git-workflow/SKILL.md` (ejemplo de nombre de rama)

---

## Cómo añadir un universo

Se añade uno nuevo cuando **un solo dominio empieza a sesgar**: si todos los ejemplos de la suite
transcurren en el mismo sitio, el lector concluye que la suite es para ese tipo de sistema. Dos o
tres universos rotando entre skills lo evitan.

Reglas al añadir:

- **No mezclar universos dentro de un mismo archivo.** Un archivo, un universo.
- **Declarar el universo** al principio del archivo ("los ejemplos usan un dominio ilustrativo: …").
- **Registrar el universo aquí**, con su tabla de entidades y dónde está en uso.
- Elegir un sector que **no comparta forma** con los ya registrados: si el universo 1 es un flujo
  *solicitud → confirmación → documento*, el 2 debería tener otra silueta (p. ej. un pipeline de
  procesamiento por lotes, o un catálogo de contenidos con moderación).

---

## Plantillas de prompt

Para nutrir los universos con un agente. Sustituir `{…}` antes de usar.

### Prompt A — Crear un universo nuevo

```
Necesito un universo sintético para los ejemplos de código de una suite de skills públicas.

Restricciones no negociables:
- Sector deliberadamente anodino y ajeno a cualquier negocio real. NO uses:
  seguros, banca, salud, ni {sectores ya usados: …}.
- Nada que pueda confundirse con una empresa, producto o marca reales. Sin nombre
  de empresa: si un rol genérico basta ("el proveedor externo"), usa el rol.
- Hosts de ejemplo solo con dominios reservados para documentación.
- Debe tener una SILUETA distinta a la de los universos ya registrados:
  {describir la silueta del universo 1, p. ej. "solicitud → confirmación → documento"}.

El universo debe cubrir estructuralmente:
1. Multi-tenancy con catálogos que difieren por tenant.
2. Un servicio de un tercero que puede tardar, fallar o responder distinto.
3. Un flujo de varios pasos con un punto a partir del cual no se puede deshacer.
4. Un cálculo con condiciones (recargos, topes o descuentos) que rompa la
   proporcionalidad simple.
5. Un artefacto generado (documento, export, reporte) que se deposita en algún
   almacenamiento.
6. Al menos un identificador que difiera entre dos sistemas, y al menos uno que
   sea inestable frente a cierta operación.

Entrégame:
- Tabla de entidades (nombre → qué es en el negocio).
- Lista de operaciones del dominio.
- Tabla de campos con la FORMA que ilustra cada uno.
- Estados de la máquina de habilitación y de acceso.
- Símbolos de código (servicios, jobs, componentes, calculadoras).
- Nombres del ecosistema (frontends, servicios, especificación, tenant de ejemplo,
  host externo, endpoint de ejemplo, selector de ejemplo).

Formato: igual al de `UNIVERSOS-SINTETICOS.md` § Universo 1.
```

### Prompt B — Poblar un archivo con un universo ya existente

```
Reescribe los ejemplos de {ruta/al/archivo.md} usando el universo sintético
"{nombre del universo}" definido en UNIVERSOS-SINTETICOS.md.

Reglas:
- Cambia SOLO los ejemplos. El método, las reglas y la estructura del documento
  no se tocan.
- Un archivo, un universo: no mezcles con otros.
- Declara el universo al principio del archivo con la nota de "dominio ilustrativo".
- Conserva la FORMA de cada ejemplo. Si el ejemplo original mostraba una agregación
  no lineal o un cruce de identificadores, el nuevo debe mostrar lo mismo — con los
  nombres del universo, no con los originales.
- Si el ejemplo original tenía un valor concreto de negocio (un porcentaje, un plazo,
  una hora), NO lo traduzcas: elimínalo y deja solo la forma.
- Los bloques de código mantienen la sintaxis que tenían, pero añade la nota de que
  la sintaxis es ilustrativa y el patrón no depende del lenguaje.

Entrégame el archivo completo reescrito y una tabla `antes → después` de cada
sustitución.
```

### Prompt C — Auditar un archivo contra el universo

```
Audita {ruta/al/archivo.md} y dime si queda algún rastro de material identificable
o de sesgo de dominio.

Busca:
1. Nombres propios que no sean (a) del universo sintético declarado, (b) otra skill
   de esta suite, o (c) una herramienta pública conocida.
2. Valores de negocio concretos: porcentajes, plazos, horas, topes, límites de edad.
   La forma de la regla puede quedarse; el número no.
3. Dominios, hosts, correos o selectores que no sean de ejemplo reservado.
4. Rutas de archivo que revelen la estructura de un repo concreto.
5. Vocabulario que ate el archivo a un sector cuando debería ser agnóstico.
6. Vocabulario que ate el archivo a un stack cuando debería ser agnóstico, o un
   stack presentado como requisito en vez de como ejemplo declarado.

Para cada hallazgo: `archivo:línea`, la cita mínima, el tipo, y la sustitución
propuesta. Si no hay hallazgos, dilo explícitamente.

No edites nada: entrégame el reporte.
```
