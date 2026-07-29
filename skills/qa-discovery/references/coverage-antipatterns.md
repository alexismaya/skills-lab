# Anti-patrones de Cobertura

Lista de anti-patrones que dan **falsa sensación de seguridad** en la suite de tests.
Leer cuando el repo ya tenga tests pero se reporten bugs que "deberían haber sido atrapados",
o cuando la cobertura de código es alta pero los releases siguen siendo riesgosos.

> **Sobre los ejemplos.** Usan una sintaxis concreta y un dominio ilustrativo (reserva de espacios
> compartidos) solo para que se lean rápido. **El anti-patrón es del método, no del lenguaje ni del
> sector:** tradúcelo al stack y al dominio del proyecto que tengas delante.

---

## Anti-patrones de diseño de tests

### 1. Tests que solo verifican que no explotan

```php
// ❌ Anti-patrón: el test pasa aunque el resultado sea incorrecto
public function test_solicitar()
{
    $response = $this->postJson('/api/solicitudes', $datos);
    $response->assertStatus(200); // Solo verifica que no fue 500
}

// ✅ Correcto: verificar el contenido de la respuesta
public function test_solicitar_devuelve_tarifa_calculada()
{
    $response = $this->postJson('/api/solicitudes', $datos);
    $response->assertStatus(200)
             ->assertJsonStructure(['tarifa_total', 'tarifa_periodo', 'espacios'])
             ->assertJsonPath('tarifa_total', fn($v) => $v > 0);
}
```

### 2. Tests que se prueban entre sí (interdependencia)

```php
// ❌ Anti-patrón: test B depende del estado que dejó test A
public function test_a_crear_reserva() { ... }   // Crea registro en BD
public function test_b_cancelar_reserva() { ... } // Asume que el registro existe

// ✅ Correcto: cada test crea su propio estado
public function test_cancelar_reserva()
{
    $reserva = Reserva::factory()->confirmada()->create();
    // ahora cancelar...
}
```

### 3. Fixtures estáticos como única fuente de datos

```php
// ❌ Anti-patrón: fixture hardcodeado que nunca cambia
$datos = json_decode(file_get_contents('tests/fixtures/ocupante.json'), true);

// Problema: si el esquema cambia, el fixture no lo refleja automáticamente.
// Peor: el fixture puede tener valores inválidos que no se detectan.

// ✅ Correcto: constructor de datos con estados semánticos
$ocupante = Ocupante::factory()->sinAcceso()->conRestriccion()->make();
```

### 4. Sustituir con un doble justo lo que se quiere probar

```php
// ❌ Anti-patrón: doblar el servicio que es precisamente lo que se prueba
$proveedor = Mockery::mock(ProveedorService::class);
$proveedor->shouldReceive('consultar')->andReturn($tarifaFalsa);
// Este test no prueba la lógica de ProveedorService::consultar(), la omite

// ✅ Correcto: doblar las dependencias del servicio, no el servicio mismo
Http::fake(['api.example.com/*' => Http::response($respuestaProveedor, 200)]);
$resultado = app(ProveedorService::class)->consultar($datos);
$this->assertEquals($tarifaEsperada, $resultado->tarifa);
```

### 5. Tests E2E para todo

```
// ❌ Anti-patrón: usar el runner de navegador para probar validación de un campo
// Un test E2E que prueba "el campo X es requerido" tarda un orden de magnitud más
// que un unitario y falla por razones de infraestructura (navegador, red, estado).

// ✅ Correcto: reservar E2E para flujos completos de negocio
// E2E      → flujo solicitud-a-confirmación completo
// Unitario → validación del campo X en el componente
```

### 6. Nombres sin intención

```php
// ❌ Anti-patrón: nombre que no dice qué se prueba ni cuándo falla
public function test_reserva() { ... }
public function it_works() { ... }
public function test_caso_1() { ... }

// ✅ Correcto: nombre describe escenario + resultado esperado
public function test_confirmacion_falla_cuando_ocupante_no_tiene_acceso() { ... }
public function test_tarifa_incluye_recargo_en_total() { ... }
```

---

## Anti-patrones de infraestructura de tests

### 7. Sin configuración de entorno de test separada

Si los tests corren con la configuración de desarrollo en lugar de una dedicada:

- Pueden apuntar a una base de datos real
- Pueden hacer llamadas reales a APIs externas
- El mecanismo de reseteo de BD puede **borrar datos reales**

**Verificar:** ejecutar la suite con la config limpia y comprobar contra qué base de datos apunta,
antes de que corra el primer test.

### 8. Sin aislamiento de estado entre tests de integración

```php
// ❌ Anti-patrón: test de integración sin reseteo de estado
class ReservaTest extends TestCase
{
    // Sin aislamiento: el estado de un test contamina al siguiente
}

// ✅ Correcto: el mecanismo de aislamiento del stack, siempre
class ReservaTest extends TestCase
{
    use RefreshDatabase;
}
```

### 9. Llamadas reales a APIs externas en CI

Síntoma: los tests pasan en local pero fallan en el pipeline, o viceversa.

```
// Detectar: buscar en los tests
// - instanciación directa del cliente del tercero sin doble previo
// - peticiones HTTP a un host externo sin interceptor
// - lectura de URLs remotas desde el propio test
```

### 10. Esperas por reloj en tests E2E

```typescript
// ❌ Anti-patrón: espera fija
await page.click('#btn-reservar');
await page.waitForTimeout(3000); // "espero que 3 segundos sea suficiente"

// ✅ Correcto: espera por estado
await page.click('#btn-reservar');
await page.waitForSelector('.resultado-solicitud', { state: 'visible' });
// o
await expect(page.locator('.tarifa-total')).toBeVisible();
```

### 11. Selectores repetidos en E2E

Cuando los tests E2E tienen selectores hardcodeados en múltiples archivos:

```typescript
// ❌ Anti-patrón: selector repetido en 10 tests
await page.click('#btn-reservar');
// Si el identificador cambia → 10 tests rotos

// ✅ Correcto: centralizarlo en un objeto de página
class SolicitudPage {
  async clickReservar() {
    await this.page.click('#btn-reservar');
  }
}
// Si el identificador cambia → 1 lugar para actualizar
```

---

## Señales de "cobertura cosmética"

Alta cobertura de líneas **no garantiza** que el software funcione. Buscar estas señales:

| Señal                                              | Qué significa realmente                          |
|----------------------------------------------------|--------------------------------------------------|
| Cobertura alta pero bugs frecuentes en producción  | Los tests no cubren los casos de negocio reales  |
| La suite tarda mucho en total                      | Probablemente E2E haciendo trabajo de unitarios  |
| Ningún test de caso negativo / error               | Solo se prueba el happy path                     |
| Constructores de datos sin estados semánticos      | Los datos de prueba no representan casos reales  |
| Todos los tests en un solo archivo enorme          | Difícil mantener; indica tests escritos "de una" |
| Cero tests de autorización o de aislamiento entre tenants | El aislamiento de datos no está verificado |
