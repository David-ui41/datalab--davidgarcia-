# Semana 3 — Guía del Estudiante

## Tablas, Columnas, Dominios, Restricciones y Llaves (3.3–3.4)
### Caso hilo conductor: DataLab

---

## Objetivos de la semana

Al final de esta semana estarán en capacidad de:

- Definir con precisión qué es un dominio y asignar el tipo de dato correcto a cada columna de un esquema relacional.
- Aplicar restricciones a nivel de columna y de tabla: `NOT NULL`, `UNIQUE`, `DEFAULT`, `CHECK`.
- Formalizar las reglas de llave primaria (simple y compuesta) y llave foránea, incluyendo el caso especial de `UNIQUE + FK` para forzar una relación 1:1.
- Dejar el esquema relacional de DataLab completamente tipado y con restricciones, listo para crearse en un motor real en la Semana 5.

**Equipo:** David Santiago Garcpia Rusinque

---

## BLOQUE 1 — Formalización (2 horas, sin PC)

### Retomar la Semana 2

Muestren brevemente al resto del curso el nombre que le dieron a sus tablas puente.

### Dominios y tipos de datos

Completen la tabla mientras el docente explica, con un ejemplo propio de DataLab para cada tipo:

| Tipo | Uso típico | Ejemplo en DataLab |
|---|---|---|
| `INT` | Número de documento | La cédula de cada uno de los cientificso de datos|
| `VARCHAR(n)` |Nombre y Apellido | Nombres y cargos|
| `TEXT` |Instrucciones e indicaciones | Comentarios sobre el código modificado |
| `DATE` | Fecha o plazos importantes | Dia de finalización del proyecto|
| `DECIMAL(p,e)` | Montos de dinero| Salario de los Data Scientist |
| `BOOLEAN` |Estado de trabajador | Activo o desconectado |

**a)** ¿Cuál es la diferencia entre el tipo de dato de una columna y una restricción sobre esa columna?

El tipo de dato de una columna indica que clase de valores puede almacenar esta columna. Por ejemplo si el dato es INT , VARCHAR , BOOLEAN , etc.
Por otro lado, la restricción sobre una columna establece que condiciones deben cumplir los valores de dicha columna 

_______________________________________________________________________________

### Restricciones

Completen con un ejemplo propio de DataLab para cada restricción:

| Restricción | Qué garantiza | Ejemplo en DataLab |
|---|---|---|
| `NOT NULL` | | |
| `UNIQUE` | | |
| `DEFAULT` | | |
| `CHECK` | | |

**b)** ¿Todas las métricas de desempeño de un modelo caben bien en un `CHECK (valor BETWEEN 0 AND 1)`? Piensen en al menos una métrica que no encajaría y expliquen por qué.

_______________________________________________________________________________

### Llaves primarias y foráneas, formalizadas

**c)** ¿Qué significa que una llave primaria sea "compuesta"? Den un ejemplo del esquema de DataLab.

_______________________________________________________________________________

**d)** La relación EXPERIMENTO–produce–MODELO es 1:1 con participación parcial en EXPERIMENTO. Si `modelo.id_experimento` es FK pero no tiene `UNIQUE`, ¿qué error de diseño se podría colar? (piensen: ¿cuántas filas de `modelo` podrían terminar apuntando al mismo experimento?)

_______________________________________________________________________________

### Ejercicio en papel

Para cada tabla de su esquema (de la Semana 2), completen esta ficha:

| Tabla | Columna | Tipo de dato | Restricciones |
|---|---|---|---|
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |

*(Agreguen filas según necesiten — deben quedar las 8 tablas: 6 entidades + 2 puente.)*

---

## BLOQUE 2 — Laboratorio (3 horas, con PC)

### Retomar (20 min)

¿En qué tabla o columna tuvo dudas su equipo al asignar tipo o restricción?

_______________________________________________________________________________

### Digitalizar el esquema tipado (50 min)

En dbdiagram.io (continuando el archivo de la Semana 2) o MySQL Workbench, agreguen tipos de dato y restricciones a todas las columnas.

**Herramienta usada:** _______________________

> 💡 En DBML, las restricciones se escriben así:
> ```
> Table metrica {
>   id_metrica int [pk]
>   id_modelo int [ref: > modelo.id_modelo, not null]
>   nombre_metrica varchar(50) [not null]
>   valor decimal(5,4) [not null, note: 'CHECK valor BETWEEN 0 AND 1']
>   fecha_calculo date [not null]
> }
> ```

### Descanso (15 min)

### Ficha de especificación completa (50 min)

Traduzcan el esquema digitalizado a una tabla de especificación completa en `documentacion/diccionario_datos.md`, con columnas: **tabla, columna, tipo de dato, restricciones, referencia (si es FK)**. Este documento va a ser la fuente de verdad para escribir el `CREATE TABLE` real en la Semana 5.

**Ejercicio aplicado (sin ejecutar SQL todavía):** si intentaran insertar en `experimento` una fila con `id_proyecto = 999` y ese proyecto no existe en la tabla `proyecto`, ¿qué debería pasar? Respondan como decisión de diseño, no como sintaxis.

_______________________________________________________________________________

### Revisión cruzada final (30 min)

Intercambien su ficha de especificación con otro equipo y verifiquen:

**a)** ¿Cada FK tiene claramente indicada su tabla y columna de referencia?

_______________________________________________________________________________

**b)** ¿Encontraron algún `NOT NULL` que debería ser opcional, o viceversa?

_______________________________________________________________________________

### Commit y cierre (15 min)

- Exporten el esquema tipado a `diagramas/relacional/s03-esquema-tipado.png` (guarden también el `.dbml` fuente si lo usaron).
- Commit: `git commit -m "modelo: esquema relacional de DataLab con tipos de dato y restricciones"`.

---

## Verificación de comprensión — antes de salir

**1.** ¿Cuál es la diferencia entre un tipo de dato y una restricción?

_______________________________________________________________________________

**2.** ¿Por qué `modelo.id_experimento` necesita ser `UNIQUE` además de `FK`?

_______________________________________________________________________________

**3.** Si `dataset.tamanio_filas` tuviera un valor negativo, ¿qué restricción lo habría evitado?

_______________________________________________________________________________

---

## Avance hacia el Hito 2

- [ ] Esquema relacional tipado y con restricciones en `diagramas/relacional/s03-esquema-tipado.png`.
- [ ] `documentacion/diccionario_datos.md` con la ficha de especificación completa de las 8 tablas.
- [ ] Commit realizado con el mensaje sugerido.

*(El Hito 2 completo — normalización + creación en motor real — se cierra en la Semana 5.)*
