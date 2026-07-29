# Modo `unitario`

Pruebas que aíslan **una unidad de comportamiento** sin salir del proceso: reglas de negocio,
validaciones, transformaciones y componentes. Base de la pirámide, feedback más rápido.

> **Sobre los ejemplos.** Usan una sintaxis concreta y un dominio ilustrativo (reserva de espacios
> compartidos) para que se lean rápido. Traduce al stack declarado en el handoff y al dominio del
> proyecto. Las **reglas** no cambian entre stacks; los ejemplos sí.

## Cuándo aplica

- La superficie es una regla de negocio, un validador, un cálculo, un mapeador o un componente
  de UI.
- No requiere BD real, red ni servicios externos (si los requiere, es `integracion`).

## Backend

```php
// discovery: CalculadoraTarifa  (helper de cálculo)
it('aplica recargo por reserva fuera de horario', function () {
    $solicitud = Solicitud::factory()->make(['hora_inicio' => '22:00']); // en memoria, sin persistir

    $tarifa = app(CalculadoraTarifa::class)->calcular($solicitud);

    expect($tarifa->recargoFueraDeHorario)->toBeGreaterThan(0);
})->group('tarifas');
```

Reglas:
- **Unitario NO toca BD.** Construir en memoria, nunca persistir (anti-patrón: lento y contamina).
- **Constructores de datos con estados semánticos** para armar los casos, sin persistir.
- **Tablas de casos** para los edge cases: límites, nulos, valores frontera de catálogo.
- **Doblar solo colaboradores externos** (clientes HTTP, pasarelas); la lógica bajo prueba se
  ejecuta real.
- **Negativas de dominio:** recurso no habilitado, tenant ajeno, catálogo inexistente → validan o
  lanzan, no fallan en silencio.

## Frontend

```ts
// discovery: FormularioSolicitud  (validación cliente)
it('deshabilita "Reservar" sin espacio seleccionado', () => {
  render(<FormularioSolicitud espacios={[]} />);
  expect(screen.getByRole('button', { name: /reservar/i })).toBeDisabled();
});
```

Reglas:
- Prueba **comportamiento observable**, no estado interno ni implementación.
- Consultas por rol o por texto accesible, no por clase CSS ni por estructura del DOM.
- Componentes que consumen API: doblar el cliente; nunca red real.

## Anti-patrones a evitar

- Reimplementar la lógica bajo prueba dentro de la aserción.
- Un test que verifica cinco cosas (divídelo).
- Depender del orden de ejecución o de estado compartido.
- Nombres genéricos (`test_1`); el nombre describe el comportamiento.

## Trazabilidad

Cada test abre con `// discovery: <Superficie>` y se registra en `templates/trazabilidad.md`.
