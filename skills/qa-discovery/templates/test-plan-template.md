# Plan de Pruebas — [Nombre del Módulo / Release]

**Proyecto:** [Nombre del proyecto]
**Módulo:** [Módulo o feature a probar]
**Versión / Sprint:** [v1.x / Sprint N]
**Fecha:** [YYYY-MM-DD]
**Elaborado por:** [Nombre del desarrollador]
**Revisado por:** [PM o líder técnico]

---

## 1. Alcance

### 1.1 Qué se incluye en este plan
[Descripción de los flujos, módulos y funcionalidades que serán probadas]

### 1.2 Qué queda fuera de alcance
[Funcionalidades que NO se probarán en este ciclo y por qué]

---

## 2. Mapa de Superficies de Prueba

| Superficie                  | Tipo de prueba    | Prioridad  | Herramienta     | Responsable |
|-----------------------------|-------------------|------------|-----------------|-------------|
| [Endpoint / Flujo]          | [Unitario/Integr/E2E] | 🔴/🟡/🟢 | [runner del stack] | [Dev] |

---

## 3. Flujos Críticos a Verificar

### Flujo 1: [Nombre del flujo]
**Descripción:** [Qué hace este flujo en términos de negocio]
**Precondiciones:** [Datos o estado necesario para ejecutarlo]
**Pasos:**
1. [Paso 1]
2. [Paso 2]
3. [...]

**Resultado esperado:** [Qué debe pasar al final]
**Casos de error a probar:**
- [Error 1 y resultado esperado]
- [Error 2 y resultado esperado]

---

## 4. Dependencias y Pre-requisitos

| Dependencia                                    | Estado          | Bloqueante |
|------------------------------------------------|-----------------|------------|
| Config de entorno de test separada             | ✅ / ❌ Pendiente | Sí         |
| Constructores de datos de las entidades clave  | ✅ / ❌ Pendiente | Sí         |
| Dobles de los servicios externos               | ✅ / ❌ Pendiente | Sí         |
| BD de pruebas aislada                          | ✅ / ❌ Pendiente | Sí         |
| Datos de prueba (semillas)                     | ✅ / ❌ Pendiente | No         |

---

## 5. Criterios de Aceptación

Para que el módulo se considere listo para release:

- [ ] Todos los tests de prioridad 🔴 Crítica pasan
- [ ] Todos los tests de prioridad 🟡 Alta pasan
- [ ] Ningún test regresa resultados diferentes en distintas ejecuciones (flakiness = 0)
- [ ] Los tests de integración corren con mocks; sin llamadas reales a APIs externas
- [ ] El pipeline de CI ejecuta la suite completa en menos de [N] minutos

---

## 6. Riesgos Identificados

| Riesgo                                      | Probabilidad | Impacto   | Mitigación                          |
|---------------------------------------------|--------------|-----------|-------------------------------------|
| [Riesgo 1]                                  | Alta/Media/Baja | Alto/Medio/Bajo | [Acción de mitigación]     |

---

## 7. Métricas Objetivo

| Métrica                              | Objetivo         | Actual (discovery) |
|--------------------------------------|------------------|--------------------|
| Tests unitarios cubiertos            | [N tests]        | [N existentes]     |
| Tests de integración cubiertos       | [N tests]        | [N existentes]     |
| Flujos E2E cubiertos                 | [N flujos]       | [N existentes]     |
| Tiempo de ejecución de la suite      | < [N] minutos    | —                  |

---

## 8. Notas y Observaciones

[Cualquier contexto adicional relevante para PMs o stakeholders no técnicos]
