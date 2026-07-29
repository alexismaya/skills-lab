# Modo `infraestructura`

Prepara la **base de testing** que desbloquea a los demás modos. Es la opción D de qa-discovery: sin
estos cimientos, unitario/integracion/e2e no pueden generarse de forma confiable. **No** son
aserciones sobre efectos externos (eso vive en `integracion`).

> **Sobre los ejemplos.** Usan una sintaxis concreta y un dominio ilustrativo. Traduce al stack
> declarado en el handoff.

## Cuándo aplica

- El handoff de discovery marca pre-requisitos de base (falta config de entorno de test, clase base
  de test, constructores de datos de las entidades clave, semillas de prueba).
- Discovery detectó entidades sin constructor de datos (⚠️) o ausencia de aislamiento de estado.
- Se eligió la opción D antes de atacar flujos concretos.

## Qué genera

### Config de entorno de test

- BD de prueba **aislada** (nunca la de desarrollo ni la de producción).
- Servicios externos apuntando a dobles o stubs, no a endpoints reales.
- Almacenamiento de archivos simulado, colas en modo síncrono, logs en memoria.

### Clase base de test

- Utilidades comunes de aislamiento de estado para los tests de integración.
- Helpers de dominio reutilizables: fijar el tenant activo, autenticar un actor, sembrar la
  habilitación de un recurso.

```php
abstract class TestCase extends BaseTestCase
{
    use RefreshDatabase;

    protected function paraTenant(Marketplace $mp): static
    {
        // resuelve headers/contexto de tenant para las peticiones
        return $this->withHeaders(['X-Tenant' => $mp->slug]);
    }
}
```

### Constructores de datos faltantes

- Crea los que discovery marcó con ⚠️, con **estados** de dominio:
  - habilitación: `creadoGeneral()`, `habilitadoEnTenant()`, `deshabilitado()`.
  - por tenant: `paraTenant($mp)`.
- Prefiere constructores sobre fixtures estáticos siempre.

### Semillas de prueba y configuración

- Semillas de los catálogos mínimos que el dominio requiere.
- Config del runner: suites separadas (unitarias / integración) y variables de entorno de test.
- Config del runner de frontend y del de e2e (con URL base) si el repo hará esos modos.

## Guardrails

- La BD de test se resetea entre corridas; **jamás** un borrado masivo contra una BD que pudiera
  ser real. Verifica contra qué apunta la conexión antes de ejecutar nada destructivo.
- Ningún servicio externo real en la configuración de test.
- Este modo desbloquea; no escribe tests de negocio. Al terminar, sugiere el siguiente modo según
  la prioridad de discovery.

## Trazabilidad

Registra en `templates/trazabilidad.md` los cimientos creados (con modo `infraestructura`, estado
`generado`) y qué superficies quedan ahora desbloqueadas.
