# Captura operativa: el guion de la entrevista (bloque `operacion`)

> Los ejemplos usan un dominio ilustrativo (reserva de espacios y recursos compartidos).
> Es un universo sintético: ilustra la **forma** de lo que se pregunta, no un sistema real ni
> un stack recomendado.

El bloque `operacion` es el único del corpus que **no se extrae**: se pregunta. Este
documento define a quién se le pregunta, qué se pregunta, cómo entra cada respuesta al corpus
y qué no se anota nunca.

Se lee cuando Q3 previó una proyección que exige `operacion` —capacitación, documentación de
PM o handover técnico—. Si ninguna lo exige, esta entrevista no se hace: cuesta el tiempo de
una persona que sabe operar el sistema y no se pide "por si acaso".

## La regla que separa este bloque de la invención

**Se pregunta o se marca. Nunca se infiere.**

El repo puede sugerir mucho de lo que sigue y no demuestra nada de ello. Que exista un
archivo de configuración por ambiente demuestra que el ambiente está **previsto**; no que
exista, ni a qué apunta hoy, ni quién puede entrar. Que exista un gestor de dependencias
demuestra cómo se declaran; no que el procedimiento de arranque sea el que parece.

Por eso una entrada de este bloque:

- lleva `procedencia = entrevista` y `respaldo` con **quién lo afirmó y cuándo**;
- **no lleva `ancla`** — no hay línea que citar, y ponerla falsifica la procedencia;
- **no caduca cuando el código cambia** (`incremental.md`), pero se marca `por revalidar` si
  cambió estructuralmente el componente que describe;
- nace con `visibilidad = interna` salvo decisión explícita en contra. Lo operativo describe
  cómo se entra al sistema; su valor para quien no debería entrar suele superar su valor para
  el lector.

Y un tema que nadie sabe responder **se cierra igual**: `NO DETERMINADO` con su motivo. Esa
respuesta no es un fracaso de la entrevista, es un hallazgo — un sistema cuyo procedimiento de
puesta en marcha nadie puede enunciar tiene un solo dueño real, y conviene que quede escrito
antes de que se vaya.

## A quién se entrevista

Rara vez es una sola persona, y preguntarle todo a una sola es cómo se cuela la deducción:
quien desarrolla suele *suponer* cómo se libera, y lo dirá con seguridad.

| Tema | Rol que sabe la respuesta |
|---|---|
| Puesta en marcha, ambientes | Quien haya levantado el sistema alguna vez, no quien lo diseñó |
| Accesos y quién los otorga | Quien administra las cuentas, aunque no toque el código |
| Fallos frecuentes, escalamiento | Quien recibe el aviso cuando algo falla |
| Criterios de liberación | Quien autoriza, no quien despliega |
| Estado actual y alcance vigente | Quien decide el producto |

Si un tema se responde por un rol que no es el suyo, se registra igual —con el rol real de
quien lo afirmó— y se marca como pendiente de confirmar con el dueño del tema.

## Los ocho temas

### 1. Puesta en marcha desde cero

La pregunta es literal: *si mañana entra alguien nuevo, con una máquina limpia, ¿qué hace, en
qué orden, hasta ver el sistema respondiendo?* Se recorre la secuencia completa y, por cada
paso, se anota qué se hace y qué demuestra que salió bien.

La forma de la secuencia, agnóstica del stack: obtener el código → instalar dependencias →
producir la configuración local → dejar los datos en su estado inicial → obtener la identidad
o las llaves que el sistema exige para arrancar → levantar los procesos accesorios que el
flujo necesita → verificar que responde.

Lo que hay que sacar y casi nunca se ofrece solo: **qué paso falla siempre la primera vez.**
Es el dato de mayor rendimiento de toda la entrevista y no aparece si no se pregunta así.

### 2. Ambientes y a qué apunta cada uno

Cuántos ambientes existen, cómo se llaman, y para cada uno: contra qué instancia de datos
corre, contra qué versión de cada servicio externo, y si comparte algo con otro ambiente.

El hallazgo que se busca es el ambiente que **no es réplica del siguiente**: el que apunta a
un tercero en modo de prueba mientras los demás apuntan al real, el que comparte
almacenamiento con producción. Un handover que no lo diga entrega una trampa.

Nunca se anotan direcciones ni credenciales de acceso: se anota la **topología**, no la ruta
de entrada.

### 3. Accesos necesarios y quién los otorga

Un inventario por rol: qué necesita pedir alguien que entra, a quién se lo pide, y cuánto
tarda en concederse. Repositorio, ambientes, datos, almacenamiento, credenciales de los
servicios externos, herramientas de inspección, registros de ejecución.

Se anota **el nombre del acceso y su otorgante por rol**. Nunca el valor, nunca la cuenta
concreta, nunca el canal privado por el que se pide.

### 4. Verificación de que el ambiente sirve

La secuencia mínima que alguien ejecuta a mano para convencerse de que lo que levantó
funciona de extremo a extremo. En el universo de ejemplo: obtener identidad → crear una
solicitud → confirmarla → comprobar que el comprobante se generó → comprobar que el proveedor
externo la recibió.

**Frontera con el bloque `pruebas`:** aquí va la secuencia manual de convencimiento, que es
conocimiento operativo. El mapa de superficies cubiertas y las suites automatizadas son
`pruebas`, y los produce `qa-discovery` / `qa-generator`. Registrar la secuencia manual no
cubre ese bloque ni permite darlo por lleno.

### 5. Fallos frecuentes y qué se hace con ellos

Qué falla seguido, cómo se ve cuando falla —el síntoma que se observa, no la causa que se
supone—, qué se hace para restablecerlo, y en qué momento deja de ser de quien lo detectó.

Es la parte de la entrevista donde más se filtra la deducción, porque la respuesta plausible
siempre está disponible. Si la persona dice "supongo que", eso no entra: se marca el tema como
`NO DETERMINADO` con el motivo *nadie ha observado el caso*.

### 6. Criterios de liberación

Qué tiene que cumplirse para que un cambio pase al ambiente siguiente, quién lo autoriza, qué
se comprueba después de liberar, y cómo se revierte si sale mal. Si no hay criterio escrito,
la respuesta correcta es que no lo hay —no la reconstrucción de lo que suele hacerse—.

### 7. Responsables y contactos, por rol

Quién responde por cada componente y por qué canal se le alcanza. **Por rol y canal, nunca
con datos personales**: "quien administra los ambientes, por el canal de operaciones" es la
forma correcta; un nombre propio con su correo, no.

### 8. Estado actual y alcance vigente

Qué componentes están operativos, cuáles a medias, y qué se sacó de alcance y desde cuándo.
Es la mitad de "qué está pendiente" que el código no puede dar: el código muestra lo que
existe, no lo que se decidió dejar de hacer.

Lo que **no** es de este tema: qué debería construirse después. Eso es priorización, y su
sitio es `sdd-harness-notion` o el backlog del proyecto — no el corpus.

## Cómo entra cada respuesta al corpus

Una respuesta larga son varias entradas atómicas, igual que en el resto del corpus
(`corpus.md` §3). La prosa es del renderizador.

| | Ejemplo |
|---|---|
| ❌ | `El proceso de arranque es el estándar del stack y no tiene complicaciones.` |
| ❌ | `Se instalan dependencias, se configura y se levanta.` (secuencia deducida, no relatada) |
| ✅ | `La configuración local se produce copiando la plantilla versionada y completando a mano las cuatro variables del proveedor externo; sin ellas el arranque falla al primer intento.` |
| ✅ | `El ambiente de integración apunta al proveedor externo en modo de prueba; el de validación apunta al real.` |
| ✅ | `NO DETERMINADO: quién autoriza el paso a producción. Motivo: ninguno de los dos roles entrevistados pudo enunciar un criterio; ambos describieron prácticas distintas.` |

Cada una con su `respaldo`: el rol de quien lo afirmó y la fecha de la entrevista.

## Qué no se anota nunca

- Valores de credenciales, llaves o tokens — ni siquiera parciales, ni "los de prueba".
- Direcciones, rutas o puertos cuyo único uso sea alcanzar un sistema desde fuera.
- Datos personales de contacto. Rol y canal, siempre.
- Procedimientos de recuperación que revelen cómo se obtiene acceso privilegiado.

Esto no es una excepción de este bloque: es R1 aplicada donde más tienta romperla, porque
aquí el dato prohibido es justo el que haría el documento más cómodo de usar. La forma
correcta es nombrar la variable, el rol o el canal — nunca su contenido.

## Cierre de la entrevista

La entrevista es una etapa del plan y cierra con gate como cualquier otra: se presentan las
entradas capturadas con su respaldo, y los temas que quedaron `NO DETERMINADO` con su motivo
y el rol que podría cerrarlos. Los `NO DETERMINADO` de este bloque se registran además como
**P-n en la tabla única del proyecto** cuando bloquean una proyección declarada en Q3 — que
es la mayoría de las veces, porque para eso se hizo la entrevista.
