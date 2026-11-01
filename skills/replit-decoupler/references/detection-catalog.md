# Catálogo de detección de acoplamientos Replit

Catálogo agnóstico de stack. Los nombres de herramientas públicas se usan como señales, nunca como
requisitos. Una coincidencia es **candidata**: la acción la decide la clasificación A–G contra el
contrato de sustancia.

## Diez canales

| Canal | Buscar | Evidencia mínima | Falso positivo típico |
|---|---|---|---|
| rutas | `.replit`, `replit.nix`, `replit.md`, directorios o config de plataforma | ruta completa | archivo histórico conservado deliberadamente |
| texto | palabra Replit, URLs públicas, comentarios y comandos | `archivo:línea` | ADR que documenta una migración pasada |
| entorno | `REPL_*`, `REPLIT_*` y nombres equivalentes | consumidor + línea | variable declarada pero nunca leída |
| manifests | paquetes/SDK/plugins y catálogos | manifest + clave | paquete transitivo no ejecutado directamente |
| lockfiles | resolución transitiva, overrides, exclusiones | bloque/línea | variantes opcionales para varios OS |
| código | imports, carga dinámica, guards por ambiente | import + uso | import muerto, que se clasifica por evidencia |
| servicios | DB/Auth/Storage/Secrets/Deployments/callbacks | productor, consumidor y contrato | nombre genérico sin conexión a Replit |
| operación | comandos, puertos, health checks y variables | fuente y destino neutral propuesto | documentación obsoleta |
| entrega | CI/CD, contenedores, dominios, proxies y callbacks | archivo/línea | ejemplo con dominio reservado |
| plataforma | OS/CPU/libc, binarios, Nix, shell, permisos, encoding | manifest/script + ambiente objetivo | matriz legítima multi-plataforma |

## Detectores del scanner

| Detector | Señal | Resultado |
|---|---|---|
| `platform-path` | ruta o segmento reservado de Replit | candidato A/D/G según contenido |
| `replit-package` | namespace o paquete de Replit | candidato B/C |
| `replit-env` | variable `REPL_*` o `REPLIT_*` | candidato B/C/G |
| `replit-domain` | host público de Replit | candidato C/F/G |
| `replit-token` | mención restante, case-insensitive | candidato A/D/F/G |
| `native-platform-pin` | pin OS/CPU/libc incompatible con el objetivo | candidato E/G |

El scanner evita convertir `replica`, `replication` o `.replrc` de otra herramienta en Replit por
semejanza léxica. Los hard-negatives de eval cubren esa frontera.

## Detector `native-platform-pin`

Solo tiene sentido si el usuario declaró `--target-os`. Revisa manifests, catálogos, lockfiles y
scripts de resolución para variantes como `linux-x64`, `win32-x64`, `darwin-arm64`, campos
`os`/`cpu` o exclusiones equivalentes.

- Una variante incompatible es un **candidato**, no una corrección automática.
- Un lockfile multi-plataforma puede contener varias variantes legítimas.
- Un override que conserva solo la variante del ambiente anterior puede bloquear la instalación
  aunque no contenga la palabra Replit.
- La evidencia debe incluir el ambiente objetivo; sin él, clase G.

## Cobertura no textual

El scanner declara, no oculta:

- archivos binarios;
- archivos mayores al límite configurado;
- errores de lectura/encoding;
- directorios excluidos;
- archivos ignorados no enumerables por las herramientas disponibles.

Cada uno entra en `skipped`. G1b no puede llamar limpia a una superficie que aparece allí sin una
resolución explícita.

## Fallback manual

Si Python no está disponible, registrar `detector=manual` y cubrir:

1. listado de rastreados/no rastreados y ocultos;
2. búsqueda case-insensitive de tokens, dominios y variables;
3. lectura explícita de manifests, catálogos, lockfiles y overrides;
4. imports, carga dinámica, scripts, CI/CD, Nix, contenedores y docs;
5. servicios runtime, callbacks y consumidores de secretos;
6. binarios, ilegibles, ignorados y exclusiones;
7. OS/CPU/libc, shell, permisos y rutas.

Si falta un canal: `estado=no inspeccionado`, motivo, qué acceso/comando falta y qué gate bloquea.

## Allowlist residual

Una referencia F intencional declara:

`detector · ruta · línea opcional · motivo · propietario · fecha de revisión · evidencia de no ejecución`.

La allowlist no borra el hallazgo del scanner: lo marca `allowlisted=true` para que el cierre pueda
reconciliarlo y revisar su vigencia.
