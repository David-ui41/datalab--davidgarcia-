# Actividad — Manipulación de Datos con SQL

## INSERT, SELECT, UPDATE y DELETE

**Proyecto integrador:** DataLab  
**SGBD:** SQL Server  
**Herramienta:** SQL Server Management Studio (SSMS)  
**Tipo de actividad:** Práctica guiada  
**Repositorio:** GitHub del equipo

---

## 1. Propósito

En esta actividad trabajaremos con los datos del proyecto integrador **DataLab**.

Aprenderemos a utilizar:

- `SELECT` → consultar
- `INSERT` → insertar
- `UPDATE` → modificar
- `DELETE` → eliminar

No estudiaremos estos comandos de manera aislada. Los utilizaremos sobre las tablas reales del proyecto, respetando PK, FK, restricciones e integridad referencial.

La idea central es trabajar mediante el ciclo:

```text
SELECT → INSERT → SELECT → UPDATE → SELECT → DELETE → SELECT
```

> **Cada operación de modificación debe poder ser comprobada mediante una consulta.**

---

## 2. Objetivos de aprendizaje

Al finalizar la actividad, el estudiante podrá:

- consultar información utilizando `SELECT`;
- insertar nuevos registros utilizando `INSERT`;
- modificar registros utilizando `UPDATE`;
- eliminar registros utilizando `DELETE`;
- utilizar `WHERE` de forma segura;
- comprender el efecto de PK, FK y restricciones;
- verificar modificaciones mediante `SELECT`;
- utilizar `COMMIT` y `ROLLBACK`;
- documentar las operaciones realizadas;
- versionar los scripts en Git.

---

## 3. Contexto: DataLab

El modelo actual cuenta con ocho tablas:

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

Las relaciones entre estas tablas hacen que una modificación pueda tener consecuencias sobre otras.

Por ejemplo:

```text
cientifico_datos
       │
       ├──────── participacion ──────── proyecto
       │
       └──────── experimento
                       │
                       └──── modelo
                               │
                               └──── metrica
```

Por eso debemos comprender no solamente la sintaxis SQL, sino también **qué datos estamos modificando y qué relaciones existen**.

---

# 4. Preparar el entorno

Antes de comenzar:

1. Abrir SQL Server Management Studio.
2. Seleccionar la base de datos DataLab.
3. Verificar que existen las ocho tablas.
4. Ejecutar:

```text
scripts/dml/s06-reset-datos.sql
```

5. Cargar nuevamente:

```text
scripts/dml/s06-datos-semilla.sql
```

6. Verificar los datos:

```sql
SELECT * FROM cientifico_datos;
SELECT * FROM proyecto;
SELECT * FROM dataset;
SELECT * FROM experimento;
SELECT * FROM modelo;
SELECT * FROM metrica;
```

---

# 5. SELECT — Consultar información

`SELECT` permite recuperar información almacenada en las tablas.

La estructura básica es:

```sql
SELECT columnas
FROM tabla;
```

Ejemplo:

```sql
SELECT nombre, descripcion
FROM proyecto;
```

También podemos filtrar:

```sql
SELECT *
FROM proyecto
WHERE id_proyecto = 1;
```

> **SELECT consulta información; no modifica los datos.**

---

# 6. SELECT como herramienta de validación

Antes y después de modificar información utilizaremos `SELECT`.

Por ejemplo:

```sql
SELECT *
FROM proyecto
WHERE id_proyecto = 1;
```

Después de modificar el registro, ejecutamos nuevamente la consulta para comprobar el resultado.

Esto convierte a `SELECT` en una herramienta de **validación**.

---

# 7. INSERT — Crear nuevos datos

`INSERT` permite agregar registros.

Sintaxis:

```sql
INSERT INTO tabla
    (columna1, columna2)
VALUES
    (valor1, valor2);
```

Ejemplo:

```sql
INSERT INTO proyecto
    (nombre, descripcion)
VALUES
    ('Prediccion de demanda',
     'Proyecto para analizar y predecir la demanda de servicios.');
```

Después:

```sql
SELECT *
FROM proyecto
WHERE nombre = 'Prediccion de demanda';
```

Flujo:

```text
INSERT
  ↓
SELECT
  ↓
Verificar
```

---

# 8. INSERT y columnas IDENTITY

Si `id_proyecto` está definido como:

```sql
IDENTITY(1,1)
```

SQL Server genera automáticamente el identificador.

Por eso normalmente escribimos:

```sql
INSERT INTO proyecto
    (nombre, descripcion)
VALUES
    (...);
```

y no:

```sql
INSERT INTO proyecto
    (id_proyecto, nombre, descripcion)
VALUES
    (...);
```

---

# 9. INSERT y restricciones

Podemos crear un científico:

```sql
INSERT INTO cientifico_datos
    (nombre, correo)
VALUES
    ('Laura Gomez', 'laura.gomez@datalab.com');
```

Verificamos:

```sql
SELECT *
FROM cientifico_datos
WHERE correo = 'laura.gomez@datalab.com';
```

Si `correo` tiene una restricción `UNIQUE`, intentar insertar nuevamente el mismo correo debe producir un error.

Las restricciones definidas en el modelo continúan aplicándose cuando manipulamos los datos.

---

# 10. INSERT y claves foráneas

Un `experimento` necesita referencias válidas:

```text
id_proyecto
id_cientifico
fecha_ejecucion
configuracion
```

Ejemplo:

```sql
INSERT INTO experimento
    (id_proyecto, id_cientifico, fecha_ejecucion, configuracion)
VALUES
    (1, 1, '2026-09-24', 'Configuracion inicial del experimento');
```

Aquí:

```text
id_proyecto
     ↓
debe existir en proyecto

id_cientifico
     ↓
debe existir en cientifico_datos
```

Una referencia inexistente debe ser rechazada por la integridad referencial.

---

# 11. Actividad — Crear registros

Crea:

### 11.1 Un científico

```text
Nombre:
[ ]

Correo:
[ ]
```

### 11.2 Un proyecto

```text
Nombre:
[ ]

Descripción:
[ ]
```

### 11.3 Un dataset

```text
Nombre:
[ ]

Fuente:
[ ]

Fecha de carga:
[ ]

Tamaño de filas:
[ ]
```

### 11.4 Un experimento

Debe utilizar IDs existentes de:

```text
proyecto
cientifico_datos
```

Después de cada `INSERT`, utiliza `SELECT` para verificar.

---

# 12. UPDATE — Modificar información

`UPDATE` permite modificar registros existentes.

Sintaxis:

```sql
UPDATE tabla
SET columna = nuevo_valor
WHERE condicion;
```

Ejemplo:

```sql
UPDATE proyecto
SET descripcion = 'Nueva descripcion del proyecto'
WHERE id_proyecto = 1;
```

Verificación:

```sql
SELECT *
FROM proyecto
WHERE id_proyecto = 1;
```

---

# 13. La importancia de WHERE

Observa:

```sql
UPDATE proyecto
SET descripcion = 'Nueva descripcion';
```

Esta instrucción puede modificar **todos los proyectos**.

Por eso debemos identificar primero el registro:

```sql
UPDATE proyecto
SET descripcion = 'Proyecto actualizado'
WHERE id_proyecto = 2;
```

> Antes de ejecutar un `UPDATE`, verifica con `SELECT` que la condición identifica exactamente los registros esperados.

---

# 14. Actividad — Modificar información

Realiza:

1. Actualiza la descripción de un proyecto.
2. Actualiza el nombre de un científico.
3. Actualiza la fuente de un dataset.
4. Actualiza la configuración de un experimento.

Después de cada operación utiliza `SELECT` para comprobar el resultado.

---

# 15. DELETE — Eliminar información

`DELETE` permite eliminar registros.

Sintaxis:

```sql
DELETE FROM tabla
WHERE condicion;
```

Ejemplo:

```sql
DELETE FROM proyecto
WHERE id_proyecto = 5;
```

---

# 16. La regla de oro de DELETE

Nunca ejecutes directamente:

```sql
DELETE FROM proyecto;
```

sin comprender las consecuencias.

Esta instrucción elimina todos los registros de la tabla.

Primero:

```sql
SELECT *
FROM proyecto
WHERE id_proyecto = 5;
```

Después, si el registro es el correcto:

```sql
DELETE FROM proyecto
WHERE id_proyecto = 5;
```

Finalmente:

```sql
SELECT *
FROM proyecto
WHERE id_proyecto = 5;
```

El resultado debería ser vacío.

---

# 17. DELETE y claves foráneas

Supongamos:

```text
proyecto
   │
   └──── experimento
```

Si intentamos:

```sql
DELETE FROM proyecto
WHERE id_proyecto = 1;
```

SQL Server puede impedir la operación si existen registros relacionados y la política de integridad no permite eliminar el registro padre.

Debemos preguntarnos:

> **¿Qué otros datos dependen del registro que quiero eliminar?**

---

# 18. Actividad — DELETE controlado

Identifica un registro creado específicamente para la práctica.

Primero:

```sql
SELECT *
FROM proyecto
WHERE id_proyecto = [ID];
```

Después:

```sql
DELETE FROM proyecto
WHERE id_proyecto = [ID];
```

Finalmente:

```sql
SELECT *
FROM proyecto
WHERE id_proyecto = [ID];
```

Documenta:

- qué registro eliminaste;
- por qué lo seleccionaste;
- si existían relaciones;
- qué resultado obtuviste.

---

# 19. Comparación de las cuatro operaciones

| Comando | Acción | ¿Modifica datos? |
|---|---|---:|
| `SELECT` | Consultar | No |
| `INSERT` | Crear registros | Sí |
| `UPDATE` | Modificar registros | Sí |
| `DELETE` | Eliminar registros | Sí |

---

# 20. CRUD

Las operaciones se relacionan con **CRUD**:

```text
C → Create  → INSERT
R → Read    → SELECT
U → Update  → UPDATE
D → Delete  → DELETE
```

En DataLab:

```text
CREATE
→ registrar un proyecto

READ
→ consultar proyectos

UPDATE
→ modificar un proyecto

DELETE
→ eliminar un proyecto
```

---

# 21. Ciclo CRUD aplicado a DataLab

## Paso 1 — READ

```sql
SELECT *
FROM proyecto
WHERE id_proyecto = 1;
```

## Paso 2 — CREATE

```sql
INSERT INTO proyecto
    (nombre, descripcion)
VALUES
    ('Proyecto CRUD DataLab',
     'Proyecto creado para practicar operaciones DML.');
```

## Paso 3 — READ

```sql
SELECT *
FROM proyecto
WHERE nombre = 'Proyecto CRUD DataLab';
```

## Paso 4 — UPDATE

```sql
UPDATE proyecto
SET descripcion = 'Proyecto actualizado durante la practica DML.'
WHERE nombre = 'Proyecto CRUD DataLab';
```

## Paso 5 — READ

```sql
SELECT *
FROM proyecto
WHERE nombre = 'Proyecto CRUD DataLab';
```

## Paso 6 — DELETE

```sql
DELETE FROM proyecto
WHERE nombre = 'Proyecto CRUD DataLab';
```

## Paso 7 — READ

```sql
SELECT *
FROM proyecto
WHERE nombre = 'Proyecto CRUD DataLab';
```

---

# 22. Práctica integrada — DataLab

Cada equipo desarrollará un escenario propio.

## Escenario

El equipo de DataLab necesita registrar un nuevo proyecto.

El proyecto debe:

1. ser creado;
2. ser consultado;
3. ser actualizado;
4. ser consultado nuevamente;
5. ser eliminado;
6. comprobar que fue eliminado.

---

# 23. Paso 1 — Diseñar antes de ejecutar

Documenta:

```text
Nombre del proyecto:
[ ]

Descripción:
[ ]

¿Por qué se crea?
[ ]

¿Quién es responsable?
[ ]

¿Qué otros datos necesitará posteriormente?
[ ]
```

---

# 24. Paso 2 — Crear

Construye el `INSERT`:

```sql
INSERT INTO proyecto
    (nombre, descripcion)
VALUES
    (...);
```

---

# 25. Paso 3 — Leer

Construye el `SELECT`:

```sql
SELECT
    id_proyecto,
    nombre,
    descripcion
FROM proyecto
WHERE ...;
```

---

# 26. Paso 4 — Actualizar

Modifica una característica del proyecto:

```sql
UPDATE proyecto
SET ...
WHERE ...;
```

---

# 27. Paso 5 — Verificar

```sql
SELECT
    id_proyecto,
    nombre,
    descripcion
FROM proyecto
WHERE ...;
```

---

# 28. Paso 6 — Eliminar

Elimina únicamente el registro creado para la práctica:

```sql
DELETE FROM proyecto
WHERE ...;
```

---

# 29. Paso 7 — Verificar eliminación

```sql
SELECT *
FROM proyecto
WHERE ...;
```

El resultado debe demostrar que el registro ya no existe.

---

# 30. Segundo reto — Operaciones relacionadas

Registrar:

```text
Científico
     ↓
Proyecto
     ↓
Experimento
```

El orden debe ser:

```text
1. cientifico_datos
          ↓
2. proyecto
          ↓
3. experimento
```

Esto se debe a las claves foráneas de `experimento`.

---

# 31. Experimento de integridad

Intenta realizar deliberadamente una operación incorrecta:

```sql
INSERT INTO experimento
    (id_proyecto, id_cientifico, fecha_ejecucion, configuracion)
VALUES
    (9999, 1, '2026-09-24', 'Prueba de integridad');
```

Documenta:

```text
¿Qué ocurrió?
[ ]

¿Por qué ocurrió?
[ ]

¿Qué restricción intervino?
[ ]

¿Qué relación del modelo está protegiendo SQL Server?
[ ]
```

Conecta:

```text
Modelo relacional
      ↓
Clave foránea
      ↓
Integridad referencial
      ↓
Restricción en SQL Server
```

---

# 32. Transacciones

Durante las prácticas de `UPDATE` y `DELETE` podemos utilizar transacciones.

Ejemplo:

```sql
BEGIN TRANSACTION;

UPDATE proyecto
SET descripcion = 'Prueba temporal'
WHERE id_proyecto = 1;

SELECT *
FROM proyecto
WHERE id_proyecto = 1;

ROLLBACK TRANSACTION;
```

`ROLLBACK` deshace los cambios realizados dentro de la transacción.

---

# 33. COMMIT

Si estamos seguros de la operación:

```sql
BEGIN TRANSACTION;

UPDATE proyecto
SET descripcion = 'Nueva descripcion'
WHERE id_proyecto = 1;

SELECT *
FROM proyecto
WHERE id_proyecto = 1;

COMMIT TRANSACTION;
```

Diferencia:

```text
ROLLBACK
→ deshacer

COMMIT
→ confirmar
```

---

# 34. Regla de seguridad para UPDATE y DELETE

Antes de ejecutar:

```text
UPDATE
```

o:

```text
DELETE
```

realiza primero un `SELECT` con la misma condición.

Ejemplo:

```sql
SELECT *
FROM proyecto
WHERE id_proyecto = 3;
```

Después:

```sql
UPDATE proyecto
SET descripcion = 'Nueva descripcion'
WHERE id_proyecto = 3;
```

---

# 35. Errores críticos

## UPDATE sin WHERE

Evita:

```sql
UPDATE proyecto
SET descripcion = 'Nueva descripcion';
```

a menos que quieras modificar todos los proyectos.

## DELETE sin WHERE

Evita:

```sql
DELETE FROM proyecto;
```

Esta instrucción elimina todos los registros de `proyecto`.

---

# 36. Organización de los scripts

El repositorio debe quedar:

```text
scripts/
│
├── ddl/
│   └── s05-creacion-tablas.sql
│
├── dml/
│   ├── s06-reset-datos.sql
│   ├── s06-datos-semilla.sql
│   └── s07-operaciones-dml.sql
│
└── consultas/
    └── s06-consultas-basicas.sql
```

Para esta actividad se recomienda:

```text
s07-operaciones-dml.sql
```

---

# 37. Organización sugerida del script

```sql
/*
    DataLab
    Semana 7
    Operaciones DML

    INSERT
    SELECT
    UPDATE
    DELETE
*/

-- 1. SELECT

-- 2. INSERT

-- 3. SELECT DE VERIFICACIÓN

-- 4. UPDATE

-- 5. SELECT DE VERIFICACIÓN

-- 6. DELETE

-- 7. SELECT DE VERIFICACIÓN
```

---

# 38. Documentación

Actualizar:

```text
casos_uso/s06-preguntas-negocio.md
```

y:

```text
documentacion/decisiones.md
```

Ejemplo de decisión:

```text
Decisión:
Se utiliza SELECT antes de UPDATE y DELETE.

Justificación:
Permite verificar previamente qué registros serán afectados
y reducir el riesgo de modificar o eliminar información incorrecta.
```

---

# 39. Evidencias

El repositorio debe permitir comprobar:

- qué registros fueron creados;
- qué registros fueron modificados;
- qué registros fueron eliminados;
- qué consultas verificaron las operaciones;
- qué errores de integridad fueron probados;
- qué decisiones tomó el equipo.

No basta con presentar el resultado final.

Debe poder observarse **el proceso**.

---

# 40. Reto Feynman

Explica con tus propias palabras:

1. ¿Qué hace `SELECT`?
2. ¿Qué hace `INSERT`?
3. ¿Qué hace `UPDATE`?
4. ¿Qué hace `DELETE`?
5. ¿Por qué `UPDATE` necesita normalmente `WHERE`?
6. ¿Por qué `DELETE` puede verse afectado por las claves foráneas?
7. ¿Por qué debemos consultar antes de modificar?
8. ¿Cómo se relacionan `INSERT`, `SELECT`, `UPDATE` y `DELETE` con CRUD?
9. ¿Qué ocurriría si intentas crear un experimento utilizando un `id_proyecto` inexistente?

---

# 41. Entregables

El repositorio debe contener:

```text
scripts/dml/s07-operaciones-dml.sql
```

y actualizar:

```text
casos_uso/s06-preguntas-negocio.md
documentacion/decisiones.md
```

Además:

- [ ] Operaciones `SELECT`.
- [ ] Operaciones `INSERT`.
- [ ] Operaciones `UPDATE`.
- [ ] Operaciones `DELETE`.
- [ ] Consultas de verificación.
- [ ] Prueba de integridad referencial.
- [ ] Uso de transacciones en al menos una práctica.
- [ ] Documentación.
- [ ] Commit.
- [ ] Push al repositorio.

---

# 42. Commit sugerido

```bash
git add .
git commit -m "dml: implementar operaciones CRUD sobre DataLab"
git push
```

---

# 43. Checklist final

- [ ] Sé explicar `SELECT`.
- [ ] Sé explicar `INSERT`.
- [ ] Sé explicar `UPDATE`.
- [ ] Sé explicar `DELETE`.
- [ ] Comprendo CRUD.
- [ ] Puedo insertar un registro.
- [ ] Puedo consultar un registro.
- [ ] Puedo modificar un registro.
- [ ] Puedo eliminar un registro.
- [ ] Sé utilizar `WHERE`.
- [ ] Comprendo el riesgo de `UPDATE` sin `WHERE`.
- [ ] Comprendo el riesgo de `DELETE` sin `WHERE`.
- [ ] Sé verificar una modificación utilizando `SELECT`.
- [ ] Comprendo el papel de las claves foráneas.
- [ ] Puedo explicar un error de integridad referencial.
- [ ] Sé utilizar `COMMIT`.
- [ ] Sé utilizar `ROLLBACK`.
- [ ] Puedo explicar las operaciones desarrolladas.
- [ ] El código está versionado en GitHub.

---

# 44. Cierre

Hasta ahora hemos construido DataLab.

Ahora comenzamos a **trabajar con sus datos**.

```text
              DATA LAB
                  │
                  ▼
          ┌───────────────┐
          │     SELECT    │
          │     LEER      │
          └───────┬───────┘
                  │
        ┌─────────┼─────────┐
        ▼         ▼         ▼
     INSERT     UPDATE    DELETE
      CREAR     CAMBIAR   ELIMINAR
        │         │         │
        └─────────┼─────────┘
                  ▼
             SELECT
             VERIFICAR
```

La meta no es memorizar cuatro comandos.

La meta es comprender que **SQL permite gestionar el ciclo de vida de los datos**, siempre respetando las reglas y relaciones definidas en el modelo de DataLab.

> **Diseñamos la estructura. Creamos los datos. Los consultamos. Los modificamos. Los eliminamos. Y verificamos cada operación.**
