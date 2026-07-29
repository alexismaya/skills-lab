# Modo `integracion`

Pruebas que cruzan fronteras: endpoints con BD real, contratos entre servicios del ecosistema,
flujo que atraviesa varios módulos, y **efectos de infraestructura observables** (almacenamiento
de archivos, logs, colas).

> **Sobre los ejemplos.** Usan una sintaxis concreta y un dominio ilustrativo (reserva de espacios
> compartidos). Traduce al stack declarado en el handoff. Las **reglas** son del método, no del
> lenguaje.

## Cuándo aplica

- La superficie es un endpoint, un contrato entre dos servicios, un flujo que toca varios
  componentes o la BD, o el efecto de infraestructura de un flujo (p. ej. la confirmación deja un
  PDF en el almacenamiento).

## Endpoint + BD

```php
// discovery: POST /api/solicitudes  (espacio no habilitado)
it('rechaza reservar un espacio no habilitado para el tenant', function () {
    $mp = Marketplace::factory()->create();
    Espacio::factory()->sala()->creadoGeneral()->create(); // NO habilitado en ese tenant

    $res = $this->paraTenant($mp)->postJson('/api/solicitudes', payloadSolicitudValido());

    $res->assertStatus(422)->assertJsonPath('error', 'recurso_no_habilitado');
})->group('solicitudes');
```

Reglas:
- **Aislamiento de estado siempre** entre tests de integración (evita contaminación).
- Constructores de datos con estados de habilitación (`creadoGeneral`, `habilitadoEnTenant`,
  `deshabilitado`); cubre la **máquina de estados** y sus negativas.
- **Aislamiento de tenant:** un endpoint nunca devuelve recursos de otro tenant → test negativo
  explícito.
- Servicios externos con el interceptor de red del stack; nunca APIs reales.

## Efectos de infraestructura observables

Cuando la superficie es un flujo que genera efectos fuera del proceso, aserta el efecto observable:

```php
// discovery: Controller@confirmarReserva  (modifica BD + genera PDF)
it('deposita el documento de la reserva en el almacenamiento al confirmar', function () {
    Storage::fake('documentos');

    confirmarSolicitud($solicitud);

    Storage::disk('documentos')->assertExists("reservas/{$solicitud->folio}.pdf");
})->group('confirmacion');
```

- **Almacenamiento de archivos:** existencia del documento, ruta con espacio de nombres por tenant,
  tipo de archivo, sin sobrescritura entre tenants.
- **Logs / telemetría:** afirma la **presencia** de los eventos esperados (inicio, confirmación,
  error) vía identificador de correlación; no el texto literal completo. Standalone: canal de log en
  memoria. Ecosistema: consulta de solo lectura por folio.
- **Idempotencia:** reprocesar el mismo mensaje u operación no duplica el registro ni el cobro.

## Contract tests (entre servicios del ecosistema)

Solo si el módulo forma parte de un ecosistema de repos. Fuente de verdad: **la especificación de
API versionada**.

- **Proveedor:** sus respuestas satisfacen el esquema publicado.
- **Consumidor:** sus peticiones cumplen el esquema y sabe leer las respuestas.
- **Standalone:** el consumidor corre contra un **servidor de simulación generado desde la
  especificación** (local), no contra el servicio real.
- **Drift:** si standalone pasa contra el doble pero ecosistema falla el mismo contrato → doble
  desactualizado (clase de fallo distinta); regenéralo desde la especificación vigente.

```php
it('la respuesta de solicitar cumple el esquema v3 de espacios', function () {
    $res = $this->postJson('/api/solicitudes', payloadSolicitudValido());
    expect($res->json())->toMatchOpenApi('openapi/api-espacios.v3.yaml', '/solicitudes', 'post');
})->group('contract');
```

## Flujo que cruza módulos

Un recorrido que atraviesa catálogos + servicio de dominio + administración: aprovisiona en orden
topológico (catálogos → recurso → administración → portal) y verifica coherencia extremo a extremo.

## Trazabilidad

Cada test abre con `// discovery: <Superficie>` y se registra en `templates/trazabilidad.md` con su
modo de ejecución (standalone/ecosistema cuando aplique).
