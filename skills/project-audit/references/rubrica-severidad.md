# Rúbrica de severidad por pilar

Referencia para calibrar la severidad de los hallazgos de forma consistente y no
arbitraria. Leer al asignar severidad en la Fase 1. La severidad **no** es una propiedad
intrínseca del defecto: es función de su **impacto** en el contexto del proyecto (Q5:
compliance, recursos compartidos, criticidad del negocio). Un mismo patrón puede ser crítico
en un sistema que maneja datos de terceros y medio en una herramienta interna.

## Regla de oro

**La severidad se justifica, no se declara.** Cada hallazgo enlaza su severidad a un impacto
concreto y a la evidencia `file:line` que lo demuestra. Si no hay evidencia, no hay hallazgo
(es `hipótesis a validar`, y las hipótesis no llevan severidad hasta confirmarse).

## Definición de impacto

El impacto responde tres preguntas, y las tres deben quedar escritas en la ficha del hallazgo:

- **Qué se rompe** — el efecto concreto (fuga de datos, caída bajo carga, corrupción, lentitud).
- **Para quién** — usuarios, otro sistema que comparte recursos, el equipo que mantiene.
- **Bajo qué condición** — siempre, bajo carga, con cierto input, en cierto rol, con el tiempo.

## Escala de severidad (transversal)

| Severidad | Criterio general | Expectativa de acción |
|---|---|---|
| **Crítica** | Explotable/ocurre en producción con daño grave e inmediato: fuga o pérdida de datos, acceso no autorizado, caída total, incumplimiento de compliance declarado en Q5. | Bloquea "rehacer sin corregir"; primera en el plan de remediación. |
| **Alta** | Daño serio pero condicionado (cierto rol, cierta carga, cierto input) o degradación marcada; deuda que frena de forma tangible la evolución. | Debe resolverse antes de crecer/escalar; alta prioridad. |
| **Media** | Impacto real pero acotado o con workaround; riesgo que crece con el tiempo si no se atiende. | Se planifica; no bloquea. |
| **Baja** | Molestia, inconsistencia o mejora menor; sin impacto inmediato. | Quick win o backlog. |

## Criterios por pilar

Los criterios orientan el nivel típico; el impacto real (arriba) manda sobre la tabla.

### Seguridad
| Hallazgo | Severidad típica |
|---|---|
| Secreto/credencial real en repo o historial git; auth ausente en ruta sensible; inyección explotable; IDOR con datos de terceros | Crítica |
| Validación de entrada ausente en superficie expuesta; dependencia con CVE crítico/alto explotable; autorización inconsistente | Alta |
| CORS permisivo sin datos sensibles detrás; error que filtra stack trace; PII en logs internos | Media |
| Endurecimiento recomendable sin vector demostrado (headers, rotación de secretos ya fuera del repo) | Baja |

### Escalabilidad
| Hallazgo | Severidad típica |
|---|---|
| Estado en proceso que impide correr más de una instancia en un sistema que ya lo necesita; contención que ya causa incidentes | Crítica |
| Acoplamiento o diseño síncrono que topará bajo el crecimiento previsto; jobs no idempotentes que duplican al reintentar | Alta |
| Paginación ausente en colección que aún es pequeña pero crecerá; pool mal dimensionado con margen | Media |
| Límite de diseño teórico lejano al uso actual | Baja |

### Rendimiento
| Hallazgo | Severidad típica |
|---|---|
| N+1 o query sin índice en el camino crítico con volumen real que ya degrada la experiencia | Crítica/Alta |
| Llamada externa síncrona sin timeout en request de usuario; carga completa en memoria de colección grande | Alta |
| Ausencia de caché en acceso repetido de costo medio; cálculo repetido evitable | Media |
| Ineficiencia en ruta fría o de bajo volumen | Baja |

### Mantenibilidad
| Hallazgo | Severidad típica |
|---|---|
| Ausencia total de tests sobre lógica crítica que cambia seguido; código muerto que confunde decisiones de negocio | Alta |
| Complejidad/duplicación que ya frena cambios; documentación de setup ausente que bloquea onboarding | Alta/Media |
| Inconsistencia de patrones; `TODO`/`FIXME` sin ticket; README desactualizado | Media |
| Nombres/estilo inconsistentes de bajo impacto; código muerto trivial | Baja |

## Notas de calibración

- **No inflar.** Si todo es crítico, nada lo es (antipatrón 2 del SKILL). Reservar "crítica"
  para daño grave e inmediato demostrable.
- **Compliance de Q5 sube el piso.** Un hallazgo que viola un requisito declarado (PCI/HIPAA/
  GDPR) escala al menos a alta, típicamente crítica.
- **Recurso compartido de Q5 sube el impacto.** Un defecto que afecta a un sistema vecino que
  comparte BD/colas/buckets pesa más que uno contenido en el proyecto.
- **Hipótesis no tienen severidad.** Se listan aparte con qué haría falta para confirmarlas.
