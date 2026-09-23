# Semana 6 — Guía Paso a Paso
## SQL como Lenguaje Relacional y Sintaxis Básica

**Caso hilo conductor:** DataLab  
**SGBD:** SQL Server  
**Herramienta:** SQL Server Management Studio (SSMS)

---

## 1. Propósito de la semana

En las semanas anteriores construiste progresivamente el modelo de datos de **DataLab**:

- Semana 1: modelo conceptual E-R.
- Semana 2: transformación al modelo relacional.
- Semana 3: tablas, columnas, dominios y restricciones.
- Semana 4: integridad referencial y normalización.
- Semana 5: diseño físico y creación de las tablas en SQL Server.

Ahora comienza una nueva etapa: **utilizar SQL para consultar los datos almacenados en la base de datos**.

El propósito de esta semana es comprender qué es SQL, por qué se considera un lenguaje declarativo, cuáles son sus principales sublenguajes y cómo construir las primeras consultas utilizando `SELECT`.

Además, se establecerá un flujo controlado para preparar los datos de DataLab antes de realizar las consultas.

> **Idea central:** primero construimos la estructura de la base de datos; ahora comenzamos a hacerle preguntas a esa estructura.

---

# 2. Objetivos de aprendizaje

Al finalizar esta semana deberás ser capaz de:

1. Explicar qué es SQL.
2. Diferenciar un lenguaje declarativo de uno procedural.
3. Identificar los principales sublenguajes de SQL.
4. Diferenciar SQL estándar de los dialectos particulares de cada SGBD.
5. Reconocer la sintaxis básica de una consulta SQL.
6. Utilizar `SELECT` para recuperar información.
7. Seleccionar columnas específicas.
8. Utilizar alias.
9. Utilizar `DISTINCT`.
10. Ordenar resultados mediante `ORDER BY`.
11. Limitar la cantidad de registros utilizando la sintaxis propia de SQL Server.
12. Identificar qué preguntas de negocio requieren información de una sola tabla.
13. Identificar qué preguntas requerirán información de varias tablas.
14. Preparar y utilizar datos semilla para las consultas.
15. Utilizar un script de reinicio para repetir el laboratorio de manera controlada.

---

# 3. Antes de comenzar: ¿qué tenemos hasta ahora?

El modelo DataLab cuenta con ocho tablas:

```text
cientifico_datos
proyecto
dataset
experimento
modelo
metrica
participacion
uso_dataset
```

En la Semana 5 estas tablas fueron creadas físicamente en SQL Server.

Ahora necesitamos información sobre ellas para poder realizar consultas.

Pero existe un problema:

> ¿Qué sucede si ejecutaste varias veces los `INSERT` y ahora tienes datos duplicados?

O:

> ¿Qué sucede si quieres volver a realizar el laboratorio desde cero?

Para solucionar esta situación vamos a trabajar con dos scripts:

```text
scripts/
└── dml/
    ├── s06-reset-datos.sql
    └── s06-datos-semilla.sql
```

---

# 4. El flujo de trabajo de esta semana

A partir de esta semana utilizaremos el siguiente flujo:

```text
              SEMANA 5
                  │
                  ▼
        ┌───────────────────┐
        │ DDL               │
        │ Crear estructura  │
        │ de las tablas     │
        └─────────┬─────────┘
                  │
                  ▼
        ┌───────────────────┐
        │ RESET             │
        │ Limpiar datos     │
        │ Reiniciar IDENTITY│
        └─────────┬─────────┘
                  │
                  ▼
        ┌───────────────────┐
        │ DATOS SEMILLA     │
        │ Insertar datos    │
        │ controlados       │
        └─────────┬─────────┘
                  │
                  ▼
        ┌───────────────────┐
        │ SELECT            │
        │ Consultar datos   │
        └───────────────────┘
```

Este flujo permite que todos los integrantes trabajen con un estado conocido de la base de datos.

---

# 5. ¿Qué es SQL?

**SQL (Structured Query Language)** es el lenguaje utilizado para trabajar con bases de datos relacionales.

Permite, entre otras cosas:

- crear estructuras;
- consultar información;
- insertar datos;
- modificar datos;
- eliminar datos;
- controlar permisos;
- administrar transacciones.

Una característica fundamental de SQL es que es principalmente un lenguaje **declarativo**.

---

# 6. Declarativo vs. procedural

Supongamos que queremos obtener los nombres de los proyectos de DataLab.

En un enfoque procedural podríamos pensar:

```text
1. Abrir la tabla.
2. Recorrer los registros.
3. Obtener el nombre.
4. Guardarlo.
5. Repetir hasta terminar.
```

En SQL simplemente declaramos qué información queremos:

```sql
SELECT nombre
FROM proyecto;
```

No estamos indicando explícitamente cómo SQL debe recorrer físicamente los datos.

Estamos diciendo:

> "Quiero obtener la columna `nombre` de la tabla `proyecto`."

El SGBD decide cómo ejecutar la consulta.

---

# 7. SQL y el optimizador de consultas

Cuando ejecutamos:

```sql
SELECT nombre
FROM proyecto;
```

SQL Server debe determinar cómo obtener la información.

Internamente puede decidir, entre otras cosas:

- qué índice utilizar;
- cómo acceder a los datos;
- en qué orden realizar determinadas operaciones;
- cómo minimizar el costo de ejecución.

Por eso es importante distinguir:

```text
Lo que el usuario solicita
            ↓
       SQL declarativo
            ↓
   Plan de ejecución
            ↓
     SQL Server ejecuta
```

El estudiante no necesita conocer todavía todos los detalles del optimizador, pero sí debe comprender la idea fundamental:

> **SQL expresa qué información necesitamos; el SGBD determina cómo obtenerla.**

---

# 8. Principales sublenguajes de SQL

SQL puede agruparse conceptualmente en diferentes categorías.

| Categoría | Propósito | Ejemplos |
|---|---|---|
| DDL | Definir estructuras | `CREATE`, `ALTER`, `DROP` |
| DML | Manipular datos | `INSERT`, `UPDATE`, `DELETE` |
| DCL | Controlar permisos | `GRANT`, `REVOKE` |
| TCL | Controlar transacciones | `COMMIT`, `ROLLBACK` |
| DQL* | Consultar datos | `SELECT` |

> En algunos materiales `SELECT` se presenta como parte del DML y en otros se separa como DQL. Lo importante en este curso es comprender su función: **consultar información**.

Durante esta semana nos concentraremos principalmente en:

```sql
SELECT
```

---

# 9. SQL estándar y dialectos

SQL posee estándares definidos por organismos como ANSI/ISO.

Sin embargo, cada SGBD puede incorporar características particulares.

Por ejemplo, para limitar registros:

### SQL Server

```sql
SELECT TOP 3 *
FROM proyecto;
```

### MySQL / PostgreSQL

```sql
SELECT *
FROM proyecto
LIMIT 3;
```

Esto demuestra que:

> SQL tiene una base común, pero cada SGBD puede implementar características particulares.

Por esta razón, en este curso debemos distinguir entre:

```text
SQL estándar
        +
dialecto de SQL Server
```

Nuestro SGBD es **SQL Server**, por lo que los ejercicios prácticos de esta asignatura utilizarán su sintaxis.

---

# 10. Preparación de los datos

Antes de comenzar las consultas debemos preparar la base de datos.

## 10.1 ¿Por qué utilizar datos semilla?

Los datos semilla son un conjunto inicial de información controlada que permite que todos los estudiantes puedan realizar las mismas consultas sobre un conjunto de datos conocido.

Por ejemplo:

```text
4 científicos de datos
4 proyectos
5 datasets
6 experimentos
6 modelos
12 métricas
```

Esto permite comparar resultados y validar las consultas.

---

# 11. ¿Qué hace `s06-reset-datos.sql`?

El archivo:

```text
scripts/dml/s06-reset-datos.sql
```

permite devolver la base de datos a un estado limpio.

El script:

1. elimina los datos existentes;
2. respeta las dependencias entre las tablas;
3. reinicia los contadores `IDENTITY`;
4. verifica que las tablas hayan quedado vacías.

Por ejemplo:

```sql
DELETE FROM metrica;

DBCC CHECKIDENT ('metrica', RESEED, 0);
```

El resultado esperado es que el siguiente registro generado mediante `IDENTITY` vuelva a comenzar en:

```text
1
```

---

# 12. `DELETE`, `TRUNCATE` y `DBCC CHECKIDENT`

Estos comandos no significan lo mismo.

## `DELETE`

```sql
DELETE FROM proyecto;
```

Elimina las filas de una tabla.

Puede utilizarse con condiciones:

```sql
DELETE FROM proyecto
WHERE id_proyecto = 3;
```

En este caso solamente se elimina un registro.

---

## `TRUNCATE TABLE`

```sql
TRUNCATE TABLE proyecto;
```

Elimina todas las filas de la tabla.

Además, normalmente reinicia el contador `IDENTITY`.

Sin embargo, SQL Server tiene restricciones para utilizar `TRUNCATE` cuando existen determinadas relaciones mediante claves foráneas.

Por eso DataLab utilizará:

```text
DELETE + DBCC CHECKIDENT
```

para que el procedimiento sea explícito y flexible para el laboratorio.

---

## `DBCC CHECKIDENT`

Permite verificar o modificar el valor utilizado por una columna `IDENTITY`.

En nuestro script:

```sql
DBCC CHECKIDENT ('proyecto', RESEED, 0);
```

significa que queremos establecer el valor base para que el siguiente registro generado sea:

```text
1
```

---

# 13. Orden de reinicio de DataLab

Las relaciones entre las tablas obligan a respetar determinadas dependencias.

Por ejemplo:

```text
cientifico_datos
       ▲
       │
participacion
```

Por lo tanto, primero eliminamos los registros de:

```text
participacion
```

y posteriormente los de:

```text
cientifico_datos
```

Otro ejemplo:

```text
experimento
     ▲
     │
   modelo
     ▲
     │
   metrica
```

Por eso eliminamos primero:

```text
metrica
modelo
experimento
```

y posteriormente las tablas de las que dependen.

Esto no es solamente una regla de sintaxis.

Es una consecuencia directa del **modelo relacional y de la integridad referencial** estudiada en la Semana 4.

---

# 14. Ejecutar el reinicio

En SSMS:

1. Abrir la base de datos DataLab.
2. Abrir:

```text
scripts/dml/s06-reset-datos.sql
```

3. Verificar que se está trabajando sobre la base de datos correcta.
4. Ejecutar el script.
5. Revisar la consulta de verificación.

El resultado esperado es:

```text
tabla                 registros
--------------------------------
cientifico_datos      0
proyecto              0
dataset               0
experimento           0
modelo                0
metrica               0
participacion         0
uso_dataset           0
```

---

# 15. Cargar los datos semilla

Después de reiniciar la base de datos ejecutaremos:

```text
scripts/dml/s06-datos-semilla.sql
```

Este script inserta el conjunto de datos de trabajo de DataLab.

El orden es importante porque existen claves foráneas.

Después de ejecutarlo debemos verificar que los datos hayan sido cargados correctamente.

Por ejemplo:

```sql
SELECT COUNT(*)
FROM proyecto;
```

---

# 16. Primera consulta: `SELECT`

La estructura básica es:

```sql
SELECT columnas
FROM tabla;
```

Por ejemplo:

```sql
SELECT nombre
FROM proyecto;
```

Estamos solicitando:

> Los nombres de todos los proyectos.

---

# 17. Consultar todas las columnas

Podemos utilizar:

```sql
SELECT *
FROM proyecto;
```

El símbolo `*` significa:

> todas las columnas.

Aunque es útil para explorar una tabla, no siempre es recomendable utilizarlo en consultas definitivas.

Es preferible indicar explícitamente las columnas que necesitamos:

```sql
SELECT id_proyecto, nombre, descripcion
FROM proyecto;
```

---

# 18. Seleccionar varias columnas

Podemos seleccionar varias columnas:

```sql
SELECT nombre, descripcion
FROM proyecto;
```

El orden de las columnas en el `SELECT` determina el orden en que aparecen en el resultado.

---

# 19. Alias

Podemos cambiar temporalmente el nombre mostrado de una columna:

```sql
SELECT nombre AS proyecto
FROM proyecto;
```

También podemos utilizar alias para facilitar la lectura:

```sql
SELECT
    nombre AS nombre_proyecto,
    descripcion AS descripcion_proyecto
FROM proyecto;
```

El alias no modifica la estructura de la tabla.

Solamente modifica el encabezado del resultado de la consulta.

---

# 20. `DISTINCT`

Supongamos que queremos conocer los valores diferentes de una columna.

```sql
SELECT DISTINCT algoritmo
FROM modelo;
```

`DISTINCT` elimina las repeticiones del resultado.

Conceptualmente:

```text
Datos originales

Random Forest
Random Forest
Regresión Lineal
XGBoost
XGBoost

        ↓ DISTINCT

Random Forest
Regresión Lineal
XGBoost
```

---

# 21. Ordenar resultados con `ORDER BY`

Podemos ordenar los resultados:

```sql
SELECT nombre
FROM proyecto
ORDER BY nombre;
```

Por defecto, el orden es ascendente.

También podemos especificarlo:

```sql
SELECT nombre
FROM proyecto
ORDER BY nombre ASC;
```

Para orden descendente:

```sql
SELECT nombre
FROM proyecto
ORDER BY nombre DESC;
```

---

# 22. Limitar resultados en SQL Server

SQL Server utiliza:

```sql
TOP
```

Por ejemplo:

```sql
SELECT TOP 3 *
FROM proyecto;
```

Esto devuelve como máximo tres registros.

También podemos combinarlo con `ORDER BY`:

```sql
SELECT TOP 3 nombre
FROM proyecto
ORDER BY nombre ASC;
```

Esto tiene una diferencia importante respecto a:

```sql
SELECT TOP 3 nombre
FROM proyecto;
```

Cuando necesitamos hablar de los "primeros" registros según algún criterio, debemos definir explícitamente el orden.

---

# 23. De una pregunta de negocio a SQL

Una consulta SQL debe responder una pregunta.

No debemos comenzar escribiendo código sin saber qué queremos conocer.

Utilizaremos este proceso:

```text
Pregunta de negocio
        ↓
¿Qué información necesito?
        ↓
¿En qué tabla está?
        ↓
¿Qué columnas necesito?
        ↓
¿Necesito eliminar duplicados?
        ↓
¿Necesito ordenar?
        ↓
¿Necesito limitar resultados?
        ↓
Consulta SQL
```

---

# 24. Ejemplos con DataLab

## Pregunta 1

**¿Cuántos científicos de datos existen?**

Esta pregunta requiere una función de agregación:

```sql
SELECT COUNT(*) AS cantidad_cientificos
FROM cientifico_datos;
```

> Las funciones de agregación serán estudiadas con mayor profundidad posteriormente. Aquí se utiliza solamente como introducción.

---

## Pregunta 2

**¿Cuáles son los proyectos registrados?**

```sql
SELECT nombre
FROM proyecto;
```

---

## Pregunta 3

**¿Cuáles son los datasets registrados?**

```sql
SELECT nombre, fuente
FROM dataset;
```

---

## Pregunta 4

**¿Qué algoritmos de modelos existen?**

```sql
SELECT DISTINCT algoritmo
FROM modelo;
```

---

## Pregunta 5

**¿Cuáles son los tres proyectos ordenados alfabéticamente?**

```sql
SELECT TOP 3 nombre
FROM proyecto
ORDER BY nombre ASC;
```

---

# 25. ¿Una tabla o varias tablas?

Esta semana comenzaremos con consultas sencillas.

Por ejemplo:

```sql
SELECT nombre
FROM proyecto;
```

Solo necesitamos una tabla.

Pero algunas preguntas de DataLab requieren información que está distribuida en varias tablas.

Por ejemplo:

> ¿Qué científico ejecutó cada experimento?

Necesitamos información de:

```text
cientifico_datos
       +
experimento
```

Otra pregunta:

> ¿Qué modelos fueron generados a partir de cada experimento?

Requiere:

```text
experimento
       +
modelo
```

Estas consultas nos llevarán posteriormente al concepto de:

```text
JOIN
```

Los `JOIN` se estudiarán en las semanas correspondientes a consultas multitabla.

Por ahora, el objetivo es **identificar que la pregunta requiere más de una tabla**.

---

# 26. Actividad práctica

## Paso 1 — Preparar la base

Ejecutar:

```text
s06-reset-datos.sql
```

Verificar que todas las tablas tengan:

```text
0 registros
```

---

## Paso 2 — Cargar datos

Ejecutar:

```text
s06-datos-semilla.sql
```

Verificar que los datos estén disponibles.

---

## Paso 3 — Crear las consultas

Crear:

```text
scripts/consultas/s06-consultas-basicas.sql
```

El archivo debe contener consultas que permitan responder preguntas sobre DataLab.

Como mínimo incluir:

1. Consulta de científicos.
2. Consulta de proyectos.
3. Consulta de datasets.
4. Consulta de experimentos.
5. Consulta de modelos.
6. Consulta utilizando `DISTINCT`.
7. Consulta utilizando `ORDER BY`.
8. Consulta utilizando `TOP`.

---

# 27. Preguntas de negocio

Crear o actualizar:

```text
casos_uso/s06-preguntas-negocio.md
```

Para cada consulta documentar:

```text
Pregunta:
¿Qué proyectos están registrados?

Tabla(s):
proyecto

Consulta:
SELECT nombre
FROM proyecto;

Resultado esperado:
Listado de proyectos.
```

El objetivo no es únicamente guardar código SQL.

Debemos poder explicar:

> **Qué pregunta responde cada consulta y cómo la consulta obtiene esa información.**

---

# 28. Organización del repositorio

Al finalizar la actividad deberíamos tener:

```text
datalab-<equipo>/
│
├── scripts/
│   ├── ddl/
│   │   └── s05-creacion-tablas.sql
│   │
│   ├── dml/
│   │   ├── s06-reset-datos.sql
│   │   └── s06-datos-semilla.sql
│   │
│   └── consultas/
│       └── s06-consultas-basicas.sql
│
├── casos_uso/
│   └── s06-preguntas-negocio.md
│
└── documentacion/
    └── decisiones.md
```

---

# 29. Git y control de versiones

Después de completar el trabajo:

```bash
git status
```

Revisar los archivos modificados.

Después:

```bash
git add .
```

Crear el commit:

```bash
git commit -m "consulta: primeras consultas SELECT básicas sobre DataLab"
```

Finalmente:

```bash
git push
```

La evidencia debe quedar disponible en el repositorio.

---

# 30. ¿Qué debemos documentar?

En `decisiones.md` podemos registrar decisiones como:

```text
Decisión:
Se incorpora un script de reinicio de datos para los laboratorios
de SQL.

Justificación:
Permite que el equipo pueda regresar la base de datos a un estado
controlado antes de ejecutar nuevamente los datos semilla.

Fecha:
[fecha]

Responsables:
[integrantes]
```

Esto convierte el repositorio en una **bitácora de evolución del proyecto**, no solamente en un lugar donde almacenar archivos.

---

# 31. Preguntas de comprensión

Antes de finalizar responde:

### Pregunta 1
¿Por qué SQL se considera un lenguaje declarativo?

### Pregunta 2
¿Cuál es la diferencia entre DDL y DML?

### Pregunta 3
¿Qué diferencia existe entre SQL estándar y el dialecto de SQL Server?

### Pregunta 4
¿Qué hace `SELECT`?

### Pregunta 5
¿Cuál es la diferencia entre:

```sql
SELECT *
FROM proyecto;
```

y:

```sql
SELECT nombre
FROM proyecto;
```

### Pregunta 6
¿Para qué sirve `DISTINCT`?

### Pregunta 7
¿Para qué sirve `ORDER BY`?

### Pregunta 8
¿Por qué SQL Server utiliza `TOP` en lugar de `LIMIT`?

### Pregunta 9
¿Por qué el script de reinicio debe eliminar primero determinadas tablas?

### Pregunta 10
¿Cuál es la diferencia entre `DELETE` y `TRUNCATE TABLE`?

### Pregunta 11
¿Qué función cumple `DBCC CHECKIDENT`?

### Pregunta 12
¿Por qué utilizamos `DELETE + DBCC CHECKIDENT` en el laboratorio DataLab?

---

# 32. Reto Feynman

Explica a un compañero, sin utilizar diapositivas ni consultar documentación:

> **¿Qué ocurre desde que escribimos un `SELECT` hasta que SQL Server nos devuelve los resultados?**

Después explica:

> **¿Por qué necesitamos reiniciar los datos antes de ejecutar nuevamente los datos semilla?**

Si puedes explicarlo utilizando un ejemplo de DataLab y sin limitarte a memorizar definiciones, has comprendido el concepto.

---

# 33. Errores frecuentes

### Error 1 — Ejecutar varias veces los datos semilla

Esto puede generar:

```text
datos duplicados
```

Solución:

```text
RESET → DATOS SEMILLA
```

---

### Error 2 — Ejecutar el reset después de cargar los datos

El reset elimina los datos.

Por lo tanto, el orden correcto es:

```text
RESET
   ↓
DATOS SEMILLA
   ↓
CONSULTAS
```

---

### Error 3 — Confundir `DELETE` con `TRUNCATE`

No son equivalentes.

Recuerda:

```text
DELETE
→ elimina filas

TRUNCATE TABLE
→ elimina todas las filas y tiene un comportamiento diferente
  frente a IDENTITY y restricciones

DBCC CHECKIDENT
→ permite controlar el contador IDENTITY
```

---

### Error 4 — Consultar sin saber qué pregunta se quiere responder

No debemos comenzar por:

```sql
SELECT *
```

sin propósito.

Primero debemos formular la pregunta:

```text
¿Qué quiero conocer?
```

y después construir la consulta.

---

# 34. Entregables de la Semana 6

Al finalizar la semana el repositorio debe contener:

- [ ] `scripts/dml/s06-reset-datos.sql`
- [ ] `scripts/dml/s06-datos-semilla.sql`
- [ ] `scripts/consultas/s06-consultas-basicas.sql`
- [ ] `casos_uso/s06-preguntas-negocio.md`
- [ ] documentación de decisiones relevantes;
- [ ] commit de la semana;
- [ ] cambios publicados en GitHub.

---

# 35. Checklist final

Antes de entregar verifica:

- [ ] Comprendo qué es SQL.
- [ ] Comprendo qué significa que SQL sea declarativo.
- [ ] Diferencio DDL, DML, DCL y TCL.
- [ ] Comprendo la diferencia entre SQL estándar y SQL Server.
- [ ] Sé utilizar `SELECT`.
- [ ] Sé seleccionar columnas específicas.
- [ ] Sé utilizar alias.
- [ ] Sé utilizar `DISTINCT`.
- [ ] Sé utilizar `ORDER BY`.
- [ ] Sé utilizar `TOP`.
- [ ] Sé reiniciar los datos de DataLab.
- [ ] Comprendo el propósito de `DBCC CHECKIDENT`.
- [ ] Sé cargar los datos semilla.
- [ ] Puedo explicar la diferencia entre `DELETE` y `TRUNCATE`.
- [ ] Puedo identificar consultas de una tabla y de varias tablas.
- [ ] Mis consultas están documentadas.
- [ ] Mi trabajo está versionado en Git.
- [ ] Puedo explicar y defender las consultas que desarrollé.

---

## 36. Cierre

Esta semana marca el paso de:

```text
DISEÑAR
   ↓
IMPLEMENTAR
   ↓
CONSULTAR
```

Hasta ahora DataLab era principalmente un modelo que diseñamos y convertimos en tablas.

A partir de ahora comenzamos a utilizar SQL para **extraer conocimiento de los datos**.

La pregunta fundamental cambia de:

> **¿Cómo construimos la base de datos?**

a:

> **¿Qué preguntas podemos responder utilizando la base de datos?**

En las próximas semanas las consultas evolucionarán desde `SELECT` sencillos hacia filtros, funciones, agrupaciones, consultas multitabla, `JOIN` y preguntas de negocio cada vez más complejas.

---

## Commit sugerido

```bash
git add .
git commit -m "consulta: primeras consultas SELECT básicas sobre DataLab"
git push
```