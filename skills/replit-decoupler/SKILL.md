---
name: replit-decoupler
description: "Desacopla de Replit un proyecto EXISTENTE para levantarlo localmente o en otro ambiente sin alterar su sustancia: inventaría archivos, variables, dominios, plugins, paquetes, servicios y supuestos de plataforma; distingue residuos eliminables de dependencias funcionales que exigen migración; y ejecuta la limpieza por gates con paridad demostrada. Usar SIEMPRE que el usuario quiera 'sacar de Replit', 'migrar fuera de Replit', 'levantar en local' un repo creado en Replit, eliminar `.replit` / `replit.nix` / `@replit/*` / `REPL_*`, sustituir Replit DB, Auth, Object Storage, Secrets o Deployments, corregir dependencias fijadas al ambiente Replit, o verificar que el proyecto ya no depende de esa plataforma. NO usar para migraciones entre proveedores donde Replit no participa, auditorías generales de calidad, crear un proyecto nuevo a partir de otro, ni rediseñar el producto aprovechando la limpieza."
---

# Desacoplamiento de Replit sin alterar la sustancia

Skill especializada para encontrar, clasificar y retirar acoplamientos de Replit en un proyecto
existente, con evidencia de que el proyecto conserva sus contratos y arranca en el ambiente
objetivo. Principio rector: **cero acoplamientos activos no justificados, no cero menciones a
cualquier costo**.

Un `grep` limpio no demuestra portabilidad. Una referencia puede vivir en un nombre de archivo,
un lockfile, un servicio administrado, un callback, una variante binaria o conocimiento operativo
que se perdería al borrar su contenedor. Por eso esta skill separa descubrimiento, clasificación,
plan, ejecución y cierre.

## Regla cero

**No eliminar ni sustituir antes de aprobar qué debe permanecer.**

1. Toda incertidumbre se registra como P-n en la tabla única del proyecto, con `gatea`.
2. Una referencia cuyo efecto no se puede demostrar es clase G: se detiene el trabajo dependiente.
3. Una dependencia de datos, autenticación, almacenamiento, secretos o despliegue nunca se borra
   directamente. Requiere contrato de sustitución, migración y rollback aprobados.
4. El usuario aprueba el contrato de sustancia (G1a), la clasificación (G1b), el plan (G2) y el
   cierre (G3). Sin el gate correspondiente no se avanza.
5. Toda acción Git la gobierna `git-workflow`; esta skill no crea ramas, stagea, commitea ni hace
   push por sí sola.

## Entrevista de arranque

Revisar primero conversación, repo y Notion accesible. Confirmar lo ya conocido; preguntar solo
los huecos.

- **Q1 — Raíz y estado:** ruta/repo, rama o referencia de lectura y cambios preexistentes que no
  deben mezclarse.
- **Q2 — Resultado objetivo:** solo inventario, plan, ejecución controlada, o verificación de una
  limpieza ya hecha.
- **Q3 — Ambientes objetivo:** OS/CPU/runtime local y, si aplica, ambiente externo donde debe
  arrancar. Sin ambiente declarado no se puede juzgar un pin nativo.
- **Q4 — Sustancia:** flujos, contratos, datos y comportamientos que no pueden cambiar.
- **Q5 — Línea base:** comandos reales de instalación, build, typecheck/lint, tests, arranque y
  señal de salud. Si no están documentados, detectarlos y presentarlos para confirmación.
- **Q6 — Contexto persistente:** hub de Notion existente, relación con SDD y quién ejecutará los
  lotes (`puntero`, `intermedio`, `bajo coste`).

Si no hay acceso suficiente a una superficie, declararla `no inspeccionada`; nunca convertir falta
de acceso en evidencia de limpieza.

## Contrato de sustancia — Gate G1a

Antes de asignar acciones, producir `substance-contract.md` con:

- capacidades y flujos que deben permanecer;
- contratos de API, datos, persistencia, auth y UX protegidos;
- comandos y señales positivas de arranque/operación;
- archivos o módulos funcionales protegidos;
- baseline fechada, incluidos fallos preexistentes;
- cambios permitidos, prohibidos y deltas aceptables;
- ambientes objetivo y superficies no inspeccionadas.

El usuario aprueba el contrato y la baseline en **G1a**. Hasta entonces el inventario contiene
candidatos, no decisiones de eliminación.

Leer `references/classification-and-parity.md` al redactar el contrato o decidir paridad.
Usar `templates/substance-contract.md`.

## Inventario multicanal

Recorrer los diez canales de `references/detection-catalog.md`:

1. nombres y rutas ocultas;
2. contenido textual, dominios y variables;
3. manifests, catálogos, lockfiles y overrides;
4. imports, SDK, plugins y carga dinámica;
5. servicios runtime y datos;
6. build y tooling de desarrollo;
7. documentación y conocimiento operativo;
8. CI/CD, contenedores, health checks y callbacks;
9. supuestos OS/CPU/libc, shell, permisos y binarios;
10. generados, ignorados, no rastreados, ilegibles y no textuales.

Ejecutar `scripts/scan_replit.py` cuando Python esté disponible. El scanner es una ayuda de
cobertura: **produce candidatos; no clasifica el efecto ni certifica el cierre**. Si no puede
usarse, aplicar el fallback de la referencia y registrar evidencia manual en el mismo esquema.

Cada hallazgo lleva:

`id · detector · canal · ruta/línea · patrón · evidencia/hash · rol · ambiente · efecto · clase · acción · equivalencia · gate · verificación`.

Usar `templates/footprint-matrix.md` y `templates/discovery-report.md`.

## Clasificación — Gate G1b

Clasificar cada candidato contra el contrato aprobado:

| Clase | Significado | Regla de acción |
|---|---|---|
| A | metadato o identidad de plataforma | eliminar/neutralizar si se demuestra que no ejecuta nada |
| B | conveniencia de desarrollo | retirar si es inerte o demostrar paridad/sustitución |
| C | dependencia funcional/runtime | contrato, migración, rollback y gate; nunca borrado directo |
| D | conocimiento operativo | migrar y verificar el destino antes de borrar el origen |
| E | resolución de dependencias/plataforma | regenerar y probar en el ambiente objetivo |
| F | referencia histórica/intencional | conservar con allowlist, dueño, motivo y revisión |
| G | efecto no determinado | abrir P y detener toda acción dependiente |

El usuario aprueba cobertura, matriz, clases y Ps en **G1b**. Bajo metodología SDD, el análisis
pasa además por A1 de `adversarial-review`.

## Plan por lotes — Gate G2

Ordenar el plan por dependencia y reversibilidad:

1. migrar conocimiento operativo;
2. materializar equivalencias funcionales y migraciones;
3. retirar tooling/configuración;
4. limpiar manifests, catálogos y lockfiles;
5. retirar residuos y reconciliar referencias.

Cada lote declara:

- IDs que resuelve y versión del contrato;
- `crea · modifica · elimina · consume`;
- archivos permitidos y protegidos;
- guardas que invalida o debe migrar;
- Ps y precondiciones;
- perfil mínimo;
- forma exacta del cambio;
- comando y salida/predicado esperado;
- smoke **propio y positivo**;
- detención, rollback y handoff.

Dos lotes solo son paralelos si sus escrituras son disjuntas, no hay relación produce/consume,
no comparten manifest/lockfile/regeneración, no dividen un mismo contrato funcional y sus smokes
son conmutativos. Si no se demuestran las cinco condiciones, son secuenciales.

Usar `templates/decoupling-plan.md`. La propuesta pasa por A2 de `adversarial-review` y por
aprobación humana en **G2** antes de modificar el proyecto. Si un hallazgo tardío cambia las
fronteras del plan, repetir A2 sobre la revisión antes de volver a solicitar G2.

### Perfiles

- **Puntero/humano:** contrato, C/G, migraciones, decisiones de paridad y gates.
- **Intermedio:** inventario contextual, lotes y migración de documentación.
- **Bajo coste:** scanner, cambios A ya aprobados y verificaciones literales; nunca juzga.

Antes de entregar un lote a bajo coste, ejecutar `scripts/validate_batch.py`. Solo un resultado
`VALID <hash>` autoriza transcripción; el ejecutor compara ese hash antes de actuar.

## Ejecución controlada

- Migrar D antes de borrar su fuente. Un tercero debe poder instalar y arrancar usando solo la
  documentación neutral y placeholders.
- Sustituir C únicamente contra una decisión de paridad aprobada.
- Retirar A/B por lotes pequeños y ejecutar el smoke de cada lote.
- Regenerar E con el gestor real en el ambiente objetivo; no editar lockfiles a ciegas.
- Comparar el diff con la lista cerrada. Un archivo funcional no autorizado detiene el lote.
- Nunca copiar valores de secretos: solo nombres, consumidores y mecanismo destino.

### Hallazgo tardío

Si durante la ejecución aparece una referencia no inventariada que extiende o contradice el
contrato:

1. detener el lote;
2. registrar `late-finding-{id}` y abrir P para el lote y sus consumidores;
3. marcar el contrato `superseded-pending-review`;
4. repetir descubrimiento del canal afectado;
5. versionar el contrato y repetir G1a/G1b; si cambian fronteras, repetir A2/G2;
6. reanudar solo con handoff actualizado y aprobación.

Un ejecutor de bajo coste solo reporta el hallazgo; no lo resuelve.

## Paridad

Toda B que conserve capacidad y toda C produce `parity-decision-{id}.md`:

- contrato observable, ambiente y baseline;
- mismo caso después y delta permitido;
- contrafactual con el reemplazo ausente/inerte: la prueba debe fallar;
- reconciliación de datos y rollback, si aplica;
- decisión `paridad demostrada | retiro aprobado por inactividad | bloqueado`;
- revisor, fecha y evidencia.

G2 exige el caso y contrafactual diseñados; G3 exige su ejecución. Un juicio oral, un log o un
build verde no cierran paridad.

## Verificación y cierre — Gate G3

Leer `references/verification-playbook.md` y producir `closure-oracle.md` antes de ejecutar el
cierre. Debe definir salidas esperadas para:

1. reconciliación de todos los IDs — cero C/G abiertas;
2. instalación limpia — código cero, warnings allowlisted, segunda instalación sin mutar
   manifest/lockfile;
3. regresión contra la baseline — cero fallos nuevos, causalidad documentada;
4. smoke — proceso vivo durante una ventana y señal/flujo positivo;
5. repetición de los diez canales y allowlist F.

`closure_state` solo puede ser:

- `complete`: libera consumidores que exigen desacoplamiento completo;
- `partial-risk-accepted`: pendientes, dueño, riesgo y gates explícitos; solo permite trabajo
  declarado independiente;
- `blocked`: ningún consumidor dependiente inicia.

Un parcial sin lista de trabajo independiente se trata como `blocked`. Solo el usuario promueve a
`complete` con nueva evidencia. Usar `templates/closure-report.md`.

## Handoff e interoperabilidad

Si el trabajo excede un chat, `replit-decoupler` produce `replit-decoupler-handoff.md` usando
`templates/sdd-handoff.md`: contrato, matriz, Ps, grafo, archivos, baseline, verificaciones,
paridad, allowlist, riesgos, perfiles y `closure_state`.

- Esta skill es dueña de sus reportes, matriz, contrato, plan, handoff y cierre.
- `sdd-harness-notion` es dueño de hubs/etapas y consume el handoff sin reinterpretar clases.
- `adversarial-review` es dueño de contra-reportes.
- QA es dueña de sus planes/suites.
- `git-workflow` gobierna Git.

Antes de tocar Notion, leer `references/interop-notion.md` en una copia instalada o empaquetada.
Si se ejecuta directamente desde este repo y esa copia inyectada no existe, leer
`../../shared/interop-notion.md`, que es la fuente única; nunca crear ni editar una copia local
manual. Editar artefactos compartidos solo de forma quirúrgica.

## Lo que esta skill NO hace

- No rediseña arquitectura ni lógica de negocio “aprovechando” la limpieza.
- No elige proveedor destino automáticamente.
- No copia, rota ni solicita valores de secretos.
- No certifica producción con un smoke local.
- No declara portabilidad por ausencia textual.
- No reemplaza project-audit, SDD, QA, adversarial-review ni git-workflow.

## Recursos

- `references/detection-catalog.md` — canales, detectores, falsos positivos y fallback.
- `references/classification-and-parity.md` — contrato, clases A–G, paridad y hallazgos tardíos.
- `references/verification-playbook.md` — baseline, instalación limpia, regresión, smoke y cierre.
- `templates/*.md` — entregables literales de descubrimiento a cierre.
- `scripts/scan_replit.py` — scanner determinista de candidatos, sin red y de solo lectura.
- `scripts/validate_batch.py` — guarda estructural para lotes de perfil bajo coste.
- `references/interop-notion.md` — contrato compartido, inyectado al empaquetar.
