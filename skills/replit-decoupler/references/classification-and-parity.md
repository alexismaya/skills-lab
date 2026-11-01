# Clasificación, contrato de sustancia y paridad

## Regla de decisión

La evidencia textual dice **dónde** está una referencia; el contrato dice **qué puede cambiar**.
Clasificar antes de aprobar el contrato convierte la intuición del agente en alcance.

## Clases A–G

### A — metadato o identidad

Señales: archivo de workspace, banner, comentario de procedencia, configuración solo de IDE.

Para eliminar: demostrar que no es consumido por comandos, build, runtime ni operación. Si contiene
comandos/puertos/variables, la información es D aunque el contenedor sea A.

### B — conveniencia de desarrollo

Señales: overlay, plugin visual, banner, cartografía o comando auxiliar.

- Si era inerte en el ambiente objetivo, demostrar el guard/condición y el smoke neutral.
- Si forma parte de la sustancia aprobada, reemplazar y probar paridad.
- “Solo desarrollo” no significa “sin valor”; el contrato decide.

### C — funcional/runtime

Señales: datos, auth, storage, secrets, deployment, callback, dominio activo o servicio administrado.

Obliga a: contrato de sustitución, inventario de consumidores, estrategia de datos, rollback,
prueba antes/después y contrafactual. Un C nunca baja a perfil barato.

### D — conocimiento operativo

Señales: comandos, puertos, variables o secuencia de arranque guardados en archivos de plataforma.

Migrar primero. El criterio discriminante es que un tercero pueda instalar/arrancar con la fuente
neutral y placeholders, sin consultar el archivo eliminado.

### E — resolución/plataforma

Señales: lockfile, override, paquete nativo, Nix, shell o permiso acoplado al ambiente anterior.

Regenerar con el gestor real en el ambiente objetivo; segunda instalación idempotente. No editar el
lockfile para obtener un diff “limpio” sin ejecutar el gestor.

### F — histórica/intencional

Señales: ADR, guía de migración o nota que debe mencionar Replit. Conservar solo con allowlist,
propietario, motivo, revisión y evidencia de que no participa en ejecución.

### G — no determinada

Falta evidencia o acceso. Abrir P con `gatea`; nunca “resolver” el hueco durante ejecución.

## Contrato de sustancia

El contrato es versionado e incluye:

- `contract_id`, versión, fecha y aprobador;
- ambientes objetivo;
- flujos/capacidades protegidos;
- contratos técnicos/datos protegidos;
- archivos o zonas protegidas;
- baseline y fallos preexistentes;
- cambios permitidos/prohibidos;
- deltas aceptables;
- superficies no inspeccionadas.

Estado: `draft | approved | superseded-pending-review | obsolete`.

## Decisión de paridad

Una ficha por B con capacidad o por C:

```markdown
# parity-decision-{id}
- Contrato: {id@versión}
- Ambiente: {objetivo}
- Entrada/condición: {caso}
- Baseline: {comando + código + predicado}
- Después: {mismo caso + delta permitido}
- Contrafactual: {cómo se vuelve inerte y qué debe fallar}
- Datos/rollback: {si aplica}
- Decisión: paridad demostrada | retiro aprobado por inactividad | bloqueado
- Revisor/fecha/evidencia: {...}
```

### Prueba del mecanismo inerte

Preguntar: *si el reemplazo no participara, ¿esta evidencia fallaría?*

- Registro/configuración: no basta.
- Build verde: no basta.
- Log emitido: no basta.
- Endpoint 200: no basta si no demuestra el efecto.
- Conteo sin valor esperado: no basta.

## Hallazgo tardío

Un hallazgo de ejecución que contradice el contrato no se “incorpora” silenciosamente:

1. detener lote;
2. `late-finding-{id}` con evidencia;
3. P que gatea lote y consumidores;
4. contrato → `superseded-pending-review`;
5. repetir canal y revisar matriz/plan/baseline/rollback;
6. nueva versión + G1a/G1b; A2/G2 si cambian fronteras.

## Secretos

Solo registrar nombre, consumidor, obligatoriedad y mecanismo destino. Nunca pedir, copiar,
mostrar ni guardar valores. Si aparece un valor, detenerse y recomendar su revocación/rotación por
el canal seguro del usuario; no reproducirlo en reportes.
