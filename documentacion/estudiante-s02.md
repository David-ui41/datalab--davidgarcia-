# Semana 2 — Guía del Estudiante

## Modelo Relacional y Conversión del Modelo E-R (3.1–3.2)
### Caso hilo conductor: DataLab

---

## Objetivos de la semana

Al final de esta semana estarán en capacidad de:

- Definir el modelo relacional (tabla, tupla, atributo, dominio, grado) y distinguirlo con precisión del modelo E-R.
- Aplicar las reglas de conversión de un modelo E-R a un modelo relacional.
- Convertir su propio modelo E-R de DataLad (del Hito 1) en un esquema relacional completo.
- Digitalizar ese esquema y dejar registrado el avance hacia el **Hito 2** (semana 5).

**Equipo:** David Santiago García Rusinque

---

## BLOQUE 1 — Formalización (2 horas, sin PC)

### Retomar el Hito 1

Tengan a la mano su diagrama E-R final de la Semana 1. Antes de empezar, respondan de memoria (sin mirar el diagrama):

**a)** ¿Cómo resolvieron ustedes la participación parcial entre EXPERIMENTO y MODELO?

- Un experimento puede ejecutarse y fallar; no generando ningún modelo. Por lo tanto el modelo requiere obligatoriamente un experimento, pero el experimento
no siempre resulta en modelo.

### El modelo relacional

Completen la tabla de equivalencias mientras el docente explica:

| Término técnico |Equivalente en la analogía|
|-----------------|-------------------------|
| Relación        |        Tabla            |
| Tupla           |      Fila/Registro      |
| Atributo        |     Columna/Campo       |
| Dominio         |  Tipo de dato permitido |
| Grado           |   Número de columnas    |
| Cardinalidad    |   Bpumero de filas      |

> ⚠️ **Atención con esta palabra:** "relación" significa algo distinto en el modelo E-R y en el modelo relacional. Antes de seguir, respondan:

**b)** En el modelo E-R (Semana 1), "relación" significa: Es un vinculo o asociación entre las entidades.

**c)** En el modelo relacional (esta semana), "relación" significa: Basicamente, una tabla, compuesta por filas y columnas que contiene datos.

**d)** ¿La cardinalidad de una tabla (número de filas) es lo mismo que la cardinalidad E-R (1:1, 1:N, N:M)? Expliquen la diferencia con sus palabras.
No son lo mismo. La cardinalidad de una tabla es simplemente cuántas filas existen. La cardinalidad E-R (1:1, 1:N) es una regla estructural que define el límite de vínculos permitidos de forma permanente.
_______________________________________________________________________________

### Reglas de conversión E-R → relacional

Anoten cada regla en sus propias palabras a medida que el docente las explica:

**Regla 1 — Entidad → tabla:**
Toda entidad fuerte se convierte en una tabla independiente, y sus atributos pasan a ser las columnas.
_______________________________________________________________________________

**Regla 2 — Relación 1:N:**
La llave primaria (PK) del lado "1" se copia como llave foránea (FK) en la tabla del lado "N"._______________________________________________________________________________

**Regla 3 — Relación N:M:**
Se crea una tabla "puente" intermedia. Sus llaves foráneas son las PK de ambas entidades conectadas, formando juntas una llave primaria compuesta

_______________________________________________________________________________

**Regla 4 — Atributo multivaluado:**
Se extrae a una nueva tabla exclusiva, combinando el valor de dicho atributo con la PK de la entidad original para formar su llave.
_______________________________________________________________________________

**Regla 5 — Entidad débil:**
Se convierte en tabla, construyendo su llave primaria al unir su identificador parcial con la PK de la entidad fuerte de la que depende lógicamente.
_______________________________________________________________________________

**e)** ¿Por qué DataLab no tiene entidades débiles en su núcleo? ¿Alguna de las seis entidades depende de otra para existir?
Porque las entidades de DataLab pueden identificarse mediante sus propios identificadores y no dependen de otra entidad para existir. Por lo tanto, ninguna de las seis entidades principales necesita una entidad fuerte para identificarse.
_______________________________________________________________________________

### Ejercicio guiado en papel

Conviertan a mano, sobre su propio diagrama E-R del Hito 1, estas dos partes del modelo:

**a)** La relación N:M CIENTIFICO_DATOS–PROYECTO → dibujen la tabla puente resultante, con sus columnas.

**b)** La relación 1:N PROYECTO–EXPERIMENTO → indiquen en qué tabla queda la llave foránea y por qué.

*(Guarden esta hoja — la van a necesitar completa en el laboratorio.)*

### Tarea de transición

Antes del laboratorio, completen a mano la conversión de las tablas restantes: `dataset`, `experimento`, `modelo`, `metrica`, con todas sus columnas y llaves.

---

## BLOQUE 2 — Laboratorio (3 horas, con PC)

### Revisión cruzada (20 min)

Intercambien su conversión a mano con otro equipo por 5 minutos. Busquen un posible error y anótenlo como pregunta (no lo corrijan ustedes):

**Pregunta que le dejamos al otro equipo:** ¿Como se puede asegurar que la llave foranea esta ubicada de una manera correcta ?

### Digitalización del esquema relacional (60 min)

Abran dbdiagram.io o MySQL Workbench (vista de modelado) y construyan las tablas completas de DataLab: `cientifico_datos`, `proyecto`, `dataset`, `experimento`, `modelo`, `metrica`, más las tablas puente que identificaron.

**Herramienta usada:** dbdiagram.io

> 💡 En dbdiagram.io, cada tabla se escribe así:
> ```
> Table experimento {
>   id_experimento int [pk]
>   id_proyecto int [ref: > proyecto.id_proyecto]
>   id_dataset int
>   fecha_ejecucion date
>   configuracion text
> }
> ```
(Imagen en diagramas)

### Descanso (15 min)

### Nombrar bien las tablas puente (40 min)

Para cada tabla puente que crearon, justifiquen el nombre elegido (no valen nombres genéricos como `tabla1`):

|      Tabla puente     |         ¿Qué representa cada fila?                | ¿Por qué se llama así? |
|-----------------------|---------------------------------------------------|------------------------|
|participacion_proyecto |Un cientifico fue asignado a un proyecto concreto  |Describe evento real,para evitar nombres raros

**Pregunta de cierre:** si borran una fila de su tabla puente `participacion` (o como la hayan llamado), ¿qué le pasa al científico? ¿y al proyecto?

Si se elimina una fila de participacion_proyecto, únicamente se elimina dicha vinculación o asignación. Los registros originales del científico (en su tabla) y del proyecto (en la suya) deberian permanecer completamente intactos.
_______________________________________________________________________________

### Documentación (30 min)

1. Actualicen `documentacion/diccionario_datos.md` al nivel lógico: cada tabla, sus columnas, tipo de dato preliminar, PK y FK.
2. Escriban en `documentacion/decisiones.md` por qué nombraron así sus tablas puente y qué atributos (si los hay) quedaron en ellas.

### Commit y cierre (15 min)

- Exporten el esquema a `diagramas/relacional/s02-esquema-relacional.png` (o el enlace de dbdiagram.io).
- Commit: `git commit -m "modelo: conversión de E-R a esquema relacional de DataLab"`.

> **Nota:** esto todavía no es el Hito 2 — ese llega en la Semana 5, después de normalizar el modelo y crearlo en un motor real. Por ahora es avance registrado.

---

## Verificación de comprensión — antes de salir

**1.** ¿Cuál es la diferencia entre "relación" en el modelo E-R y "relación" en el modelo relacional?
En el modelo E-R, es el vínculo conceptual o lógico entre entidades (verbo). En el modelo relacional, el término se refiere a la estructura organizatival; es decir, la tabla.
_______________________________________________________________________________

**2.** ¿Por qué la llave foránea de una relación 1:N va del lado "N" y no del lado "1"?
Se hace para por la atomicidad. Si la FK estuviera en el lado "1", se tendria que guardar una lista de IDs en una sola celda, lo cual viola las reglas relacionales. Al ponerla en el lado "N", cada registro hijo tiene una sola celda que se dirige a un único padre.
_______________________________________________________________________________

**3.** ¿Qué le pasaría al modelo de DataLab si CIENTIFICO_DATOS–PROYECTO fuera 1:N en vez de N:M?
Significaría que un científico estaría bloqueado para trabajar en un solo proyecto de forma exclusiva , eliminando la posibilidad de trabajo colaborativo y simultáneo con demás compañeros.
_______________________________________________________________________________

---

## Avance hacia el Hito 2

- [X ] Esquema relacional completo digitalizado en `diagramas/relacional/s02-esquema-relacional.png`.
- [ X] Diccionario de datos actualizado a nivel lógico en `documentacion/diccionario_datos.md`.
- [X ] Decisiones sobre tablas puente registradas en `documentacion/decisiones.md`.
- [X ] Commit realizado con el mensaje sugerido.

*(El Hito 2 completo — normalización + creación en motor real — se cierra en la Semana 5.)*
