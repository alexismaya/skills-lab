# Conocimiento de dominio del proyecto — plantilla

Esta skill **no trae el conocimiento de dominio de ningún sector**: lo trae el proyecto.
Un catálogo de reglas de negocio ajenas no ayuda a probar el tuyo — sesga el análisis hacia
un dominio que no es el que tienes delante.

Lo que esta plantilla aporta es el **método para levantarlo**: cuatro estructuras que, rellenadas
con el dominio real del proyecto, convierten conocimiento tácito en superficies de prueba
priorizadas. Rellénalas en el espacio del proyecto (hub de Notion o equivalente del usuario),
no en esta skill.

> **Cuándo usarla.** En el Paso 1.5 del discovery, cuando haya que identificar los flujos de
> negocio críticos y no baste con leer rutas y controladores. Las cuatro tablas se construyen
> **con el usuario**: él tiene el dominio, la skill tiene las preguntas.

---

## 1. Entidades del dominio → riesgo de bug

Una fila por entidad de negocio (no por tabla). La columna de riesgo es la que convierte la
entidad en prioridad de prueba.

```markdown
| Entidad | Qué representa en el negocio | Riesgo de bug |
|---|---|---|
| {entidad} | {una línea, en lenguaje del negocio} | {qué se rompe si esta entidad queda mal} |
```

Preguntas para llenarla:
- ¿Qué entidades maneja un usuario del sistema en su día a día?
- Por cada una: si sus datos quedan mal, **¿quién se entera y cuándo?** Lo que nadie detecta
  hasta meses después es riesgo alto, no bajo.
- ¿Cuál de ellas es la que "no se puede equivocar" — la que tiene consecuencia legal, contractual
  o de dinero?

---

## 2. Flujos críticos por línea de producto

Un bloque por línea de producto o por tipo de operación. Los pasos van en el orden real de
ejecución, no en el orden en que están escritos en el código.

```markdown
### {línea de producto / tipo de operación}
1. {paso}
2. {paso}
n. {paso}

**Pasos críticos:** {cuáles y por qué — típicamente los que cruzan un sistema externo,
los que persisten estado irreversible, o los que generan un documento}
```

Preguntas para llenarla:
- ¿Cuáles son los caminos completos que recorre un usuario de principio a fin?
- ¿En qué paso el sistema **deja de poder deshacer** lo hecho?
- ¿Qué paso depende de un tercero que puede tardar, fallar o responder distinto?

---

## 3. Reglas de negocio que suelen romperse

Las reglas del dominio que no son evidentes desde el código y que, por eso, nadie prueba. Esta
tabla es la que más valor tiene y la que solo el usuario puede llenar.

```markdown
### {categoría de regla}
- {regla concreta, con su condición}
```

**Formas de regla que conviene buscar activamente** — son las que producen bugs silenciosos en
cualquier dominio. Recorre la lista con el usuario y pregunta si su proyecto tiene una de cada:

| Forma | Pregunta que la destapa |
|---|---|
| **Identificador que cruza sistemas** | ¿El mismo sujeto tiene un id distinto en cada sistema? ¿Cuál es el campo de cruce confiable, y cuál parece serlo pero no lo es? |
| **Identificador inestable** | ¿Hay algún identificador que **cambia** ante cierta operación? ¿Qué se usa entonces como clave estable? |
| **Agregación no lineal** | ¿El total es la suma de las partes, o hay recargos, topes o descuentos que rompen la proporción? |
| **Cálculo en un momento distinto al de captura** | ¿Alguna magnitud se calcula con la fecha/estado del momento de confirmar, y no del momento de capturar? |
| **Frontera temporal que no es medianoche** | ¿Algún periodo empieza o termina a una hora que no es 00:00? ¿Qué pasa con zonas horarias? |
| **Tope silencioso** | ¿Hay límites máximos o mínimos que el sistema aplica sin avisar? |
| **Transición prohibida por estado** | ¿Qué operaciones dejan de ser válidas cuando el objeto entra en cierto estado? |
| **Aislamiento entre tenants** | Si el sistema es multi-tenant: ¿qué datos, catálogos o cálculos difieren por tenant y cuáles nunca deben cruzarse? |
| **Ventana de gracia** | ¿Hay plazos con tolerancia? ¿Cuánta, y qué pasa justo en el límite? |

Cada regla que el usuario confirme se convierte en un caso de prueba explícito: **son reglas que
el código cumple por convención, no por estructura, y por eso se rompen sin que nada falle.**

---

## 4. Casos de prueba de alto valor

La síntesis: los casos que atrapan bugs de negocio reales, derivados de las tres tablas
anteriores.

```markdown
| Caso | Tipo | Por qué importa |
|---|---|---|
| {escenario concreto, con su condición de frontera} | {unitario / integración / e2e} | {qué clase de bug atrapa} |
```

Criterio de selección: un caso entra aquí si atrapa un fallo que **no produciría un error
visible** — nada se cae, nada devuelve 500, y el dato queda mal. Los casos que solo verifican que
el happy path responde 200 no pertenecen a esta tabla.

Preguntas para llenarla:
- Por cada regla de la tabla 3: ¿cuál es el caso justo en el límite?
- Por cada paso crítico de la tabla 2: ¿qué pasa si el tercero no responde? ¿si responde tarde?
  ¿si se reintenta la operación completa?
- Por cada entidad de la tabla 1: ¿qué pasa si un actor de otro tenant intenta leerla?

---

## Dónde vive lo que llenes

En el espacio del proyecto (hub de Notion o el gestor de contexto equivalente del usuario), **no
en esta skill**. Razón: el conocimiento de dominio es del proyecto y cambia con él; una skill que
lo lleve dentro se lo impone al siguiente proyecto que la use.

Si el proyecto usa la suite SDD, el lugar natural es la página de documentación del proyecto o el
hub de QA (ver `references/interop-notion.md` para ownership de páginas). Las reglas de la tabla 3
que resulten generalizables — no el dato, la **forma** — son candidatas a la página de Lecciones.
