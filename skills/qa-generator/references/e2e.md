# Modo `e2e`

Flujos de navegador completos por rol y tenant. Este modo produce **specs de escenario** y las
delega a la herramienta de e2e del entorno (ver § Delegación). Solo si no hay ninguna disponible,
las materializa con el runner de e2e que declare el handoff.

> **Sobre los ejemplos.** Usan un dominio ilustrativo (reserva de espacios compartidos). Traduce al
> dominio y al stack del proyecto.

## Cuándo aplica

- La superficie es un flujo end-to-end en una de las aplicaciones cliente del proyecto.
- El valor está en el camino completo, no en una unidad aislada.

## Contrato de salida: la spec de escenario

```yaml
# discovery: Flujo solicitud → confirmación (E2E)
id: sol-confirmacion-01
flujo: Solicitar → seleccionar espacio → confirmar → descargar comprobante
rol: ocupante
tenant: tenant-demo
estado_habilitacion: { recurso: sala, estado: habilitado_en_tenant }
modo_ejecucion: standalone   # backend simulado desde la especificación; o "ecosistema"
given:
  - ocupante autenticado en el portal del tenant-demo
  - recurso "sala" habilitado para el tenant
when:
  - solicita con datos válidos de fecha y aforo
  - selecciona un espacio disponible
  - confirma la reserva
  - descarga el comprobante
then:
  - se muestra el folio de confirmación
  - el comprobante descargado es un PDF no vacío
  - (ecosistema) el documento existe en el almacenamiento y el evento de confirmación en el log
```

## Flujos críticos a especificar primero (por valor)

**Portal de usuario:** autenticación → recursos disponibles → solicitud → confirmación → pago →
descarga del comprobante.

**Panel de administración:** crear recurso general → habilitarlo a un tenant → gestionar ocupantes
→ ver solicitudes.

## Reglas

- **Standalone:** backend simulado (intercepción de red) desde la especificación de API versionada;
  sin APIs reales.
- **Ecosistema:** contra ambiente desplegado, versión fijada; incluye aserciones de observabilidad
  donde aplique.
- **Esperas por estado, nunca por reloj.** Ninguna espera fija de N segundos.
- **Selectores centralizados** en objetos de página; nunca repetidos por archivo de test.
- Un flujo por spec; incluye las negativas relevantes (recurso no habilitado, sesión de otro
  tenant).

## Delegación

Entrega las specs a la herramienta o skill de e2e disponible en el entorno del usuario, en el
formato que consuma. Consulta la tabla de equivalencias por runtime en
`references/interop-notion.md` para resolver cuál es en tu runtime activo.

**Si el entorno no ofrece ninguna:** notifícalo al usuario y materializa las specs con el runner de
e2e que declare el handoff, aplicando la guía mínima de abajo. El modo sigue siendo ejecutable.

### Guía mínima si materializas tú

1. **Un archivo por flujo**, nombrado con el `id` de la spec.
2. **Objeto de página por pantalla:** cada selector vive en un único lugar.
3. **Traduce cada `when` a una acción** y cada `then` a una aserción — uno a uno, sin agrupar.
4. **Toda espera es por estado observable** (elemento visible, petición resuelta, texto presente),
   nunca por tiempo transcurrido.
5. **Datos de arranque** desde el `given`, aprovisionados por API antes de abrir el navegador — no
   navegando por la UI para preparar el escenario.

Registra cada spec en `templates/trazabilidad.md` con su superficie de discovery y su modo de
ejecución.
