# Semana 8 — Actividades y Ejercicios

## DML completo, filtros, operadores, orden y funciones de agregación

**Caso hilo conductor:** DataLab

---

# 1. Objetivo

Aplicar de manera práctica:

- `INSERT`
- `SELECT`
- `UPDATE`
- `DELETE`
- `WHERE`
- Operadores de comparación.
- `BETWEEN`
- `IN`
- `LIKE`
- `IS NULL`
- `IS NOT NULL`
- `AND`
- `OR`
- `NOT`
- `ORDER BY`
- `COUNT`
- `SUM`
- `AVG`
- `MIN`
- `MAX`
- `GROUP BY`
- `HAVING`

Además, resolver preguntas de negocio utilizando los datos de DataLab.

---

# 2. Entorno de trabajo

Trabajar sobre la base de datos `datalab` construida durante las semanas anteriores.

El archivo principal de consultas será:

```text
scripts/consultas/s08-filtros-orden-agregacion.sql
```

Las preguntas de negocio deben documentarse en:

```text
casos_uso/s06-preguntas-negocio.md
```

---

# BLOQUE 1 — Actividades conceptuales

## Actividad 1 — Los cuatro comandos DML

Completa la siguiente tabla:

| Comando | ¿Qué hace? | Tabla DataLab donde lo aplicarías |
|---|---|---|
| `INSERT` | Añade nuevas filas o registros a una tabla | En la tabla proyecto para agregar uno nuevo.|
| `SELECT` | Muestra información almacendad en la tabla que le especifiquemos| En la tabla cientifico de datos para consultar un correo institucional|
| `UPDATE` | Actualiza los valores de los campos o filas que ya existen | En un dataset para actualizar las notas|
| `DELETE` | Elimina filas existentes de una tabla | En la tabla experimento para eliminar uno ya finalizado|

### Pregunta Feynman

Explica con tus propias palabras la diferencia entre `UPDATE` y `ALTER TABLE`.

Respuesta: UPDATE cambia valores de las filas existentes, mientras que ALTER TABLE cambia o modifica el diseño de la tabla , agregando o eliminando columnas por ejemplo.

---

# Actividad 2 — UPDATE y DELETE sin WHERE

Analiza:

```sql
UPDATE experimento
SET estado = 'fallido';
```

Responde:

1. ¿Es una instrucción válida?

Respuesta: En términos de sintaxis si es una instrucción valida, y dentro de nuestra base de datos ,tambien, ya que cambió el estado de todos los experimentos a fallido.

2. ¿Qué filas modifica?

Respuesta: Modificó toda la tabla ya que no se especifico que fila que se queria trabajar en especifico con WHERE.

3. ¿Por qué puede ser peligrosa?

Respuesta: Es peligroso porque atenta directamente con la integridad de la información al alterar todos los registros de una tabla, lo que puede llegar a marcar los experimentos exitosos como fallidos, por ejemplo.

4. ¿Cómo comprobarías primero qué filas serán afectadas?

Respuesta: Con SELECT se verifica que filas seran afectadas, lo que nos permite saber que se modificaria antes de ejecutar cualquier cambio a las tablas.

Ahora analiza:

```sql
DELETE FROM experimento;
```

Explica qué diferencia existe entre eliminar las filas y eliminar la tabla.

Respuesta: Eliminar las filas borra todo el contenido dentro de la tabla, pero dejando su estructuta intacta. Sin embargo eliminar la tabla, borra su contenido tanto como su estructura.

---

# Actividad 3 — Operadores

Completa con un ejemplo de DataLab:

| Operador | Ejemplo | ¿Qué busca? |
|---|---|---|
| `=` |WHERE estado = 'fallido' | Filas donde el estado sea fallido|
| `<>` |WHERE estado <> 'fallido' | Filas donde el estado no sea fallido|
| `>` | WHERE version > 1.0 | Filas donde la versión sea mayor que 1.0|
| `<` | WHERE version <1.0| Filas donde la versión sea menor que 1.0|
| `>=` |WHERE version >=1.0 | Filas donde la versión sea mayor o igual que 1.0 |
| `<=` |WHERE version <>=1.0 | Filas donde la versión sea menor o igual que 1.0|
| `BETWEEN` | WHERE version BETWEEN 0.5 AND 1.0 | Busca valores dentro de un rango|
| `IN` | WHERE estado IN ('exitoso', 'fallido')| Registros que coincidan con cualquiera de los elementos de una lista.|
| `LIKE` | 	WHERE nombre LIKE 'juan%' | Filas que cumplan con una cadena de texto especificada |
| `IS NULL` | WHERE notas  IS NULL| Filas donde el valor está vacio|
| `IS NOT NULL` | WHERE notas  IS NOT NULL| Filas donde el valor no está vacio|

---

# Actividad 4 — NULL

Explica por qué esta consulta no es la forma correcta de buscar valores nulos:

```sql
SELECT *
FROM dataset
WHERE notas = NULL;
```

Escribe la consulta correcta.

Respuesta: Esta consulta es incorrecta ya que NULL no es un valor concreto , si no la ausencia de valor, por lo que no se puede usar un operador lógico con el. La consulta correcta será :

```sql
SELECT *
FROM dataset
WHERE notas IS NULL;
```


---

# Actividad 5 — AND, OR y NOT

Construye consultas que permitan:

### a)
Obtener experimentos exitosos.

```sql
SELECT * FROM experimento
WHERE estado = "exitoso";
```


### b)
Obtener experimentos exitosos o fallidos.

```sql
SELECT * FROM experimento
WHERE estado = "exitoso" OR estado = "fallido";
```

### c)
Obtener métricas cuyo valor esté entre 0.70 y 0.90.

```sql
SELECT * FROM metricas
WHERE valor >= 0.70 AND valor <= 0.90;
```

### d)
Obtener experimentos cuyo estado no sea `fallido`.

```sql
SELECT * FROM experimento
WHERE NOT estado = "fallido";
```

### e)
Crear una consulta que combine `AND` y `OR` utilizando 
paréntesis.

```sql
SELECT * FROM experimento 
WHERE (estado = 'exitoso' OR estado = 'en_progreso') 
  AND fecha_inicio >= '2026-01-01';
```

Explica por qué utilizaste los paréntesis.
Respuesta: Para indicar prioridad en una consulta , ya que en este caso primero se ejecuta el or y despues el AND , cosa que sin los parentesis no se podria.
---

# BLOQUE 2 — Laboratorio de filtros

## Actividad 6 — Filtros básicos

Crea una consulta para cada caso:

1. Buscar un proyecto por su nombre.

```sql
SELECT * FROM proyecto 
WHERE nombre = "Predicción de demanda"
```
2. Buscar métricas mayores a `0.80`.

```sql
SELECT * FROM metricas
WHERE valor  > 0.80;
```

3. Buscar métricas menores o iguales a `0.50`.

```sql
SELECT * FROM metricas
WHERE valor <= 0.50;
```

4. Buscar métricas entre `0.70` y `0.90`.

```sql
SELECT * FROM metricas
WHERE valor BETWEEN 0.70 AND 0.90;
```

5. Buscar experimentos cuyo estado esté dentro de una lista de estados.

```sql
SELECT * FROM experimentos
WHERE estado IN ('exitoso','planificado','fallido');
```

6. Buscar datasets cuyo nombre comience por una palabra determinada.

```sql
SELECT * FROM dataset
WHERE nombre LIKE 'ventas%';
```

7. Buscar datasets sin notas.

```sql
SELECT * FROM dataset
WHERE notas IS NULL;
```

8. Buscar datasets que sí tengan notas.

```sql
SELECT * FROM dataset
WHERE notas IS NOT NULL;
```


Guarda todas las consultas en:

```text
scripts/consultas/s08-filtros-orden-agregacion.sql
```

---

# Actividad 7 — Comparación de operadores

Para una misma tabla, crea tres consultas:

```text
Consulta A → utilizando OR
Consulta B → utilizando IN
Consulta C → utilizando NOT IN
```

Explica cuándo sería más conveniente cada una.

Respuesta: OR es conveniente cuando se evaluan pocas condiciones , IN es ideal cuando se tienen ciertos valores posible y NOT IN lo usamos cuando sabemos los valores que queremos descartar.


```sql
CONSULTA A
SELECT * FROM experimento 
WHERE estado = 'exitoso' OR estado = 'fallido;
```

```sql
CONSULTA B
SELECT * FROM experimento
WHERE estado IN ('exitoso', 'planificado', 'fallido');
```

```sql
CONSULTA C
SELECT * FROM dataset
WHERE notas IS NOT NULL;
```
---

# Actividad 8 — LIKE

Utilizando `dataset.nombre`, crea consultas para:

1. Nombres que comiencen por `EEG`.

```sql
SELECT * FROM dataset
WHERE nombre LIKE 'EEG%';
```

2. Nombres que terminen en una palabra que elijas.

```sql
SELECT * FROM dataset
WHERE nombre LIKE '%clientes'
```

3. Nombres que contengan una palabra determinada.

```sql
SELECT * FROM
WHERE nombre LIKE '%2026%'
```

4. Nombres con un patrón de longitud utilizando `_`.

```sql
SELECT * FROM
WHERE nombre LIKE 'ventas___'
```

Documenta el resultado obtenido.

---

# BLOQUE 3 — Ordenamiento

## Actividad 9 — ORDER BY

Crea las siguientes consultas:

### a)
Datasets ordenados por nombre ascendente.

```sql
SELECT * FROM dataset
ORDER BY nombre ASC;
```

### b)
Datasets ordenados por fecha de carga descendente.

```sql
SELECT * FROM datset
ORDER BY fecha_carga DESC;
```

### c)
Datasets ordenados por fuente y, en caso de empate, por fecha de carga descendente.


```sql
ORDER BY fuente ASC, fecha_carga DESC;
```

### Pregunta

Si dos datasets tienen la misma fuente, ¿qué criterio decide cuál aparece primero?

Respuesta: En caso de tener la misma fuente , la consulta los organiza por su fecha de carga , es decir de el mas reciente a el mas antiguo.
---

# BLOQUE 4 — Funciones de agregación

## Actividad 10 — COUNT

Responde mediante SQL:

1. ¿Cuántos datasets existen?

```sql
SELECT COUNT(*) AS total_datasets FROM dataset;

total_datasets = 5
```

2. ¿Cuántos experimentos existen?

```sql
SELECT COUNT(*) AS total_experimentos FROM experimento;

total_experimentos = 6
```

3. ¿Cuántos modelos existen?

```sql
SELECT COUNT(*) AS total_modelos FROM modelo;

total_modelos = 6
```

4. ¿Cuántas métricas existen?

```sql
SELECT COUNT(*) AS total_metricas FROM metrica;

total_metrica = 12

```

---

# Actividad 11 — AVG, MIN y MAX

Para la tabla `metrica`, calcula:

- Promedio: 0.753333
- Valor mínimo: 0.0900
- Valor máximo: 0.9500

```sql
SELECT 
    AVG(valor) AS promedio_global,
    MIN(valor) AS valor_minimo_global,
    MAX(valor) AS valor_maximo_global
FROM metrica;
```
```sql
SELECT 
    nombre_metrica,
    AVG(valor) AS promedio,
    MIN(valor) AS valor_minimo,
    MAX(valor) AS valor_maximo
FROM metrica
GROUP BY nombre_metrica;
```


# Actividad 12 — GROUP BY

Resuelve:

### a)
¿Cuántos datasets existen por fuente?

```sql
SELECT fuente, COUNT(*) AS cantidad
FROM dataset
GROUP BY fuente;
2 externos y 3 interno 
```

### b)
¿Cuántos experimentos existen por estado?

```sql
SELECT estado, COUNT(*) AS cantidad
FROM experimento
GROUP BY estado;
6 fallidos
```

### c)
¿Cuántas métricas existen por tipo de métrica?

```sql
SELECT nombre_metrica, COUNT(*) AS cantidad
FROM metrica
GROUP BY nombre_metrica;
4 accuracy, 4 F1 , 2 MAE y 2 R2
```

---

# Actividad 13 — HAVING

Construye una consulta que muestre únicamente los tipos de métrica cuyo promedio sea superior a `0.8`.

La solución debe utilizar:

```text
GROUP BY
HAVING
AVG()
```

No utilices:

```sql
WHERE AVG(valor) > 0.8
```

Explica por qué.

```sql
SELECT nombre_metrica, AVG(valor) AS promedio
FROM metrica
GROUP BY nombre_metrica
HAVING AVG(valor) > 0.8;
```
No se puede usar WHERE ya que esta consulta filtra los valores antes del agrupamiento, por lo tanto es necesario usar otra como AVG que trabaja sobre grupos ya consolidados.

---

# BLOQUE 5 — UPDATE seguro

## Actividad 14 — SELECT primero

Selecciona un registro de DataLab que puedas modificar de forma controlada.

### Paso 1

Escribe el `SELECT` que identifica el registro.

```sql
SELECT id_dataset, nombre, notas 
FROM dataset 
WHERE id_dataset = 1 ;
```

### Paso 2

Realiza una modificación mediante `UPDATE`.
```sql
UPDATE dataset
SET notas = 'Update controlado'
WHERE id_dataset = 1;
```


### Paso 3

Ejecuta nuevamente el `SELECT`.

### Evidencia

Documenta:

- Valor inicial: NULL
- Valor modificado: Update controlado
- Condición utilizada en `WHERE`: id_dataset = 1
- Resultado después del `UPDATE`: notas = "Update controlado"

---

# BLOQUE 6 — DELETE seguro

## Actividad 15 — Registro de prueba

Inserta un registro temporal claramente identificable.

Ejemplo:

```sql
INSERT INTO proyecto (nombre, descripcion)
VALUES (
    'FILA_DE_PRUEBA_BORRAR',
    'Registro creado para practicar DELETE'
);
```

Comprueba su existencia:

```sql
SELECT *
FROM proyecto
WHERE nombre = 'FILA_DE_PRUEBA_BORRAR';
```

Elimínalo:

```sql
DELETE FROM proyecto
WHERE nombre = 'FILA_DE_PRUEBA_BORRAR';
```

Comprueba nuevamente:

```sql
SELECT *
FROM proyecto
WHERE nombre = 'FILA_DE_PRUEBA_BORRAR';
```

### Pregunta

¿Por qué es importante que el registro de prueba sea claramente identificable?

Respuesta: Para que sepamos de que registro se esta hablando exactamente, evitar confusiones y tener certeza de que vamos a eliminar en especifico.

---

# BLOQUE 7 — Preguntas de negocio

## Actividad 16 — Retomar las preguntas de la Semana 6

Revisen:

```text
casos_uso/s06-preguntas-negocio.md
```

Identifiquen una pregunta que anteriormente no podían resolver fácilmente y que ahora pueda responderse utilizando filtros u operaciones de agregación.

Actualicen el archivo con:

```text
Pregunta:

¿Cómo podemos listar los proyectos en orden alfabético?

Objetivo:
Poder realizar consultas con el filtro de orden alfabetico para establecer un orden o jerarquia entre ellos

Consulta SQL:

```sql
SELECT * FROM datset
ORDER BY fecha_carga DESC


Resultado: Se obtiene toda la tabla dataset pero con la fecha de carga listada con el filtro de descendiente.


Interpretación:
Se muestra del registro más reciente a el más antiguo.
```

---

# Actividad 17 — Nuevas preguntas de negocio

Resuelve las siguientes preguntas utilizando SQL.

## Pregunta de negocio 1

**¿Cuántos datasets existen por fuente?**

Requisito:

```text
GROUP BY + COUNT
```

```sql
SELECT fuente, COUNT(*) AS total_datasets
FROM dataset
GROUP BY fuente;
2 externos y 3 internos
```


---

## Pregunta de negocio 2

**¿Cuántos experimentos se encuentran en cada estado?**

Requisito:

```text
GROUP BY estado + COUNT
```

```sql
SELECT estado, COUNT(*) AS cantidad_experimentos
FROM experimento
GROUP BY estado;
6 fallidos
```

---

## Pregunta de negocio 3

**¿Cuál es el promedio de cada tipo de métrica?**

Requisito:

```text
GROUP BY + AVG
```
```sql
SELECT nombre_metrica, AVG(valor) AS promedio
FROM metrica
GROUP BY nombre_metrica
HAVING AVG(valor) > 0.8;
```

## Pregunta de negocio 4

**¿Qué tipos de métrica tienen un promedio superior a 0.8?**

Requisito:

```text
GROUP BY + AVG + HAVING
```

```sql
SELECT nombre_metrica, AVG(valor) AS valor_promedio
FROM metrica
GROUP BY nombre_metrica
HAVING AVG(valor) > 0.8;
 

Accuracy = 0.905000
F1 = 0.865000
R2 = 0.865000
```

---

## Pregunta de negocio 5

**¿Cuál es el dataset más reciente de cada fuente?**

Resolver primero con los conceptos disponibles esta semana.

Pista:

```text
filtro + ordenamiento
```

```sql
SELECT fuente, MAX(fecha_carga) AS ultima_fecha
FROM dataset
GROUP BY fuente;
```



Si consideran que la solución completa requiere conceptos todavía no estudiados, documenten la limitación y propongan una aproximación.

---

## Pregunta de negocio 6

**¿Qué experimentos tienen estados considerados como exitosos o fallidos?**

Requisito:

```text
IN
```
```sql
SELECT * FROM experimento 
WHERE estado IN ('exitoso', 'fallido');
6 estados fallidos
```

---

## Pregunta de negocio 7

**¿Qué datasets tienen información en el campo `notas`?**

Requisito:


IS NOT NULL


```sql
SELECT * FROM dataset
WHERE notas IS NOT NULL;
ventas_historicas : notas = update controlado
```

## Pregunta de negocio 8

**¿Qué métricas tienen valores entre 0.70 y 0.90?**

Requisito:

```text
BETWEEN
```

```sql
SELECT * FROM metrica
WHERE valor BETWEEN 0.70 AND 0.90;
metricas con id 1 , 5 , 6 , 8 , 11 y 12.
```
---

## Actividad 18 — Crear una pregunta de negocio propia

Cada equipo debe proponer una pregunta relacionada con DataLab que pueda resolverse utilizando únicamente los conceptos estudiados hasta esta semana.

La pregunta debe:

1. Tener un contexto de negocio.
2. Ser verificable con datos.
3. Utilizar SQL.
4. Tener una respuesta interpretable.

Formato:

```text
Pregunta de negocio:
¿Que cientificos estan particiapndo en que proyectos?

¿Por qué es importante?
Para determinar que cientifico genera más valor en la empresa 

Tablas utilizadas:
Participacion
```

Consulta SQL:

```sql
SELECT 
    id_cientifico, 
    COUNT(*) AS cantidad_participaciones
FROM participacion
GROUP BY id_cientifico
ORDER BY cantidad_participaciones DESC;
```
```text
Resultado:
La consulta SQL muestra quien es el cientifico con mas participaciones en los proyectos 

Interpretación:
Del resultado anterior se puede inferir que los cientificos con el id 1 y 2 generan más valor comparados con los cientificos 3 y 4.
```

---

# BLOQUE 8 — Desafío Feynman

## Actividad 19 — Explícalo sin SQL

Explica a un compañero:

### ¿Qué diferencia existe entre WHERE y HAVING?

La explicación debe ser suficientemente clara para que la otra persona pueda comprenderla sin mirar una consulta SQL.

WHERE realiza consultas sobre elemntos individuales de una tabla , a diferencia de HAVING que realiza las comparaciones sobre agrupaciones ya consolidadas.

---

## Actividad 20 — Explícalo con un ejemplo

Explica por qué:

```sql
WHERE notas = NULL
```

no debe utilizarse para buscar valores nulos.

Después explica la solución:

```sql
WHERE notas IS NULL
```
```text
La diferencia es que en el primer caso no se puede usar un operador lógico que compare con una abstracción de nulidad, porque NULL no tiene un valor definido. Sin embargo en el segundo caso se esta verificando si notas esta vacio con la sintaxis adecuada. 
```
---

# BLOQUE 9 — Comparación SQL Server / MySQL

## Actividad 21

Ejecuta una consulta equivalente en SQL Server y MySQL.

Identifica:

- Qué parte de la consulta es idéntica: La selección de columna , el origen de los datos, y el criterio de ordenamiento.

- Qué parte cambia: La sintaxis para restringir las filas . SQL server añade el operador al inicio del SELECT, mientras que MYSQL lo agrega al final de la consulta.

- Por qué cambia: Porque aunque cada base de datos tenga principios relacionales similares, cada una define sus palabras clave con base a sus necesidades de optimizacióny demás aspevctos.

Utiliza como referencia la limitación de resultados:

### SQL Server

```sql
SELECT TOP 5 *
FROM dataset
ORDER BY fecha_carga DESC;
```

### MySQL

```sql
SELECT *
FROM dataset
ORDER BY fecha_carga DESC
LIMIT 5;
```

---

# BLOQUE 10 — Entregable

El archivo principal debe quedar en:

```text
scripts/consultas/s08-filtros-orden-agregacion.sql
```

Debe contener:

- Consultas con operadores de comparación.
- `BETWEEN`.
- `IN`.
- `LIKE`.
- `IS NULL`.
- `IS NOT NULL`.
- `AND` / `OR` / `NOT`.
- `ORDER BY` con múltiples criterios.
- `COUNT`.
- `SUM`, cuando sea aplicable.
- `AVG`.
- `MIN`.
- `MAX`.
- `GROUP BY`.
- `HAVING`.
- Al menos un `UPDATE` seguro.
- Al menos un `DELETE` seguro.
- Consultas correspondientes a preguntas de negocio.

Actualizar también:

```text
casos_uso/s06-preguntas-negocio.md
```

---

# BLOQUE 11 — Git

Al finalizar:

```bash
git add scripts/consultas/s08-filtros-orden-agregacion.sql
git add casos_uso/s06-preguntas-negocio.md
```

Commit:

```bash
git commit -m "consulta: filtros, orden y funciones de agregación sobre DataLab"
```

---

# BLOQUE 12 — Checklist

- [ ] Practiqué los cuatro comandos DML.
- [ ] Comprendí el riesgo de `UPDATE` sin `WHERE`.
- [ ] Comprendí el riesgo de `DELETE` sin `WHERE`.
- [ ] Utilicé `=`, `<>`, `<`, `>`, `<=`, `>=`.
- [ ] Utilicé `BETWEEN`.
- [ ] Utilicé `IN`.
- [ ] Utilicé `LIKE`.
- [ ] Utilicé `IS NULL` e `IS NOT NULL`.
- [ ] Combiné condiciones con `AND`, `OR` y `NOT`.
- [ ] Utilicé paréntesis en condiciones complejas.
- [ ] Utilicé `ORDER BY` con múltiples criterios.
- [ ] Utilicé funciones de agregación.
- [ ] Utilicé `GROUP BY`.
- [ ] Utilicé `HAVING`.
- [ ] Apliqué la disciplina de `SELECT` primero.
- [ ] Realicé al menos un `UPDATE` controlado.
- [ ] Realicé al menos un `DELETE` controlado.
- [ ] Resolví preguntas de negocio.
- [ ] Actualicé `casos_uso/s06-preguntas-negocio.md`.
- [ ] Guardé las consultas en `scripts/consultas/s08-filtros-orden-agregacion.sql`.
- [ ] Realicé el commit de la semana.
