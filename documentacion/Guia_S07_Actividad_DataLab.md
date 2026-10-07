# Semana 7 — Guía de Actividad
## Evolución del esquema de DataLab con ALTER TABLE, restricciones y DROP

**Caso integrador:** DataLab  
**SGBD:** SQL Server  
**Herramienta:** SQL Server Management Studio (SSMS)  
**Modalidad:** Formalización + laboratorio  
**Repositorio:** GitHub del equipo

---

# 1. Propósito

Durante las semanas anteriores construyeron la base de datos DataLab.

Ahora el sistema ya tiene:

- tablas;
- relaciones;
- restricciones;
- datos semilla;
- información real de prueba.

Pero los sistemas reales evolucionan.

El equipo de DataLab recibe dos nuevas necesidades:

1. conocer el **estado** de cada experimento;
2. registrar **observaciones libres** sobre cada dataset.

Los documentos de Semana 7 plantean estos dos cambios como el escenario central para aprender a evolucionar un esquema existente. fileciteturn14file0L32-L34

---

# 2. Objetivos

Al finalizar la actividad podrás:

- modificar tablas existentes con `ALTER TABLE`;
- agregar columnas;
- modificar columnas;
- renombrar columnas;
- eliminar columnas de una tabla de prueba;
- agregar restricciones;
- identificar problemas causados por datos existentes;
- utilizar `UPDATE` para preparar datos antes de aplicar restricciones;
- comprender el riesgo de `DROP TABLE` y `DROP DATABASE`;
- documentar una evolución del esquema;
- versionar el cambio mediante Git.

Estos objetivos corresponden a los resultados establecidos para la Semana 7. fileciteturn14file1L8-L15

---

# 3. Regla fundamental de la actividad

Durante esta actividad trabajaremos sobre la base existente.

Por eso:

> **No vamos a borrar y reconstruir las ocho tablas de DataLab para resolver los cambios.**

Vamos a evolucionarlas.

La idea es:

```text
Modelo existente
      ↓
Datos existentes
      ↓
Nueva necesidad
      ↓
ALTER TABLE
      ↓
Nueva versión del esquema
```

---

# 4. Preparar el entorno

## Paso 1 — Abrir SSMS

Conéctate a SQL Server mediante SQL Server Management Studio.

## Paso 2 — Seleccionar DataLab

Trabaja sobre:

```text
datalab
```

## Paso 3 — Verificar las tablas

Comprueba que existen:

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

## Paso 4 — Verificar que existen datos

Ejecuta:

```sql
SELECT * FROM experimento;
```

y:

```sql
SELECT * FROM dataset;
```

La actividad depende de que existan datos reales, porque el objetivo es aprender a modificar un esquema que ya está en uso. fileciteturn14file0L17-L20

---

# 5. BLOQUE 1 — Formalización sin PC

## Paso 1 — Analizar el escenario

DataLab solicita:

```text
Cambio 1
Agregar estado a experimento

Cambio 2
Agregar notas a dataset
```

Escribe:

```text
¿Por qué no sería apropiado volver a ejecutar
CREATE TABLE para resolver estos cambios?

Respuesta: Porque la tabla ya tiene datos históricos, por lo tanto, en el caso hipotetico en el que se eliminara , no habria forma de recuperar dichos datos que reposaban en la misma, además de que tambien se verian afectadas las relaciones que se tenian inicialmente, generando posible errores.


```

---

# 6. Paso 2 — Diseñar el cambio `estado`

La tabla:

```text
experimento
```

debe incorporar:

```text
estado
```

Los estados permitidos serán:

```text
planificado
en_ejecucion
exitoso
fallido
```

Antes de escribir SQL, define:

```text
Nombre:
estado

Tipo:
VARCHAR(20)

¿Puede ser NULL?
No

DEFAULT:
planificado

CHECK:
planificado
en_ejecucion
exitoso
fallido
```

---

# 7. Paso 3 — Predecir el problema

Antes de ejecutar:

```sql
ALTER TABLE experimento
ADD estado VARCHAR(20) NOT NULL;
```

responde:

```text
¿Qué ocurrirá si experimento ya tiene registros?

SQL rechazaria la operación ya que al declarar la columna como NOT NULL pero sin asignarle ningun valor , se violaria inmediatamente dicha restricción.
```

La idea que debes identificar es:

```text
Filas existentes
      +
Nueva columna NOT NULL
      =
¿qué valor recibirán las filas?
```

---

# 8. Paso 4 — Diseñar la solución

Propón una solución utilizando:

```text
DEFAULT
```

Escribe primero el comando en papel.

```sql
ALTER TABLE experimento
ADD estado VARCHAR(20) NOT NULL
    CONSTRAINT df_experimento_estado DEFAULT 'planificado';;
```

Después explica:

```text
¿Qué valor recibirán los registros existentes?

Recibiran el valor de "planificado" en la columna estado, lo que cumple con la restricción de NOT NULL, a diferencia de la solución anterior.
```

---

# 9. Paso 5 — Diseñar el CHECK

Escribe la restricción que permita únicamente:

```text
planificado
en_ejecucion
exitoso
fallido
```

```sql
ALTER TABLE experimento
ADD CONSTRAINT chk_experimento_estado
CHECK (estado IN ('planificado', 'en_ejecucion', 'exitoso', 'fallido'));;
```

---

# 10. Paso 6 — Cambio en dataset

Ahora DataLab solicita una nueva columna:

```text
notas
```

Propón:

```text
Nombre:
notas

Tipo:
VARCHAR

¿Puede ser NULL?
Si , ya que pueden existir datasets nuevos que necesariamente no tengan observaciones
```

Escribe el `ALTER TABLE`:

```sql
ALTER TABLE dataset
ADD notas VARCHAR(MAX) NULL;
```

---

# 11. Paso 7 — Relación con UPDATE

El documento de la Semana 7 propone actualizar algunos experimentos después de agregar `estado`. fileciteturn14file0L98-L107

Escribe:

```sql
UPDATE experimento
SET estado = 'exitoso'
WHERE id_experimento = 1;
```

Antes de ejecutarlo, explica:

```text
¿Por qué se utiliza WHERE?

Se utiliza WHERE para establecer un limite de donde queremos realizar la modificación, que en este caso es la fila 1 de id experimento. Si no hubiera dicha restricción , el UPDATE afectaria a todas las filas en la tabla experimento (cosa que claramente no nos conviene)
```

---

# 12. Paso 8 — Relación con Git

Explica:

```text
¿Por qué este cambio puede considerarse
una migración de esquema?

____________________________________________________

____________________________________________________
```

La idea central es que el script de modificación representa una evolución incremental y trazable del diseño. fileciteturn14file0L76-L80

---

# 13. BLOQUE 2 — Laboratorio con PC

## Paso 1 — Verificar nuevamente los datos

Ejecuta:

```sql
SELECT *
FROM experimento;
```

Después:

```sql
SELECT *
FROM dataset;
```

Guarda mentalmente o documenta el estado inicial.

---

# 14. Paso 2 — Agregar `estado`

Ejecuta la solución diseñada.

Una implementación posible en SQL Server es:

```sql
ALTER TABLE experimento
ADD estado VARCHAR(20) NOT NULL
    CONSTRAINT df_experimento_estado
    DEFAULT 'planificado'
    WITH VALUES;
```

Después verifica:

```sql
SELECT
    id_experimento,
    estado
FROM experimento;
```

---

# 15. Paso 3 — Agregar `CHECK`

Ejecuta:

```sql
ALTER TABLE experimento
ADD CONSTRAINT chk_experimento_estado
CHECK (
    estado IN (
        'planificado',
        'en_ejecucion',
        'exitoso',
        'fallido'
    )
);
```

Verifica los datos:

```sql
SELECT
    id_experimento,
    estado
FROM experimento;
```

---

# 16. Paso 4 — Probar el CHECK

Intenta:

```sql
UPDATE experimento
SET estado = 'terminado'
WHERE id_experimento = 1;
```

Observa el resultado.

Documenta:

```text
¿Qué ocurrió?

SQL devolvió este error: Mens. 547, Nivel 16, Estado 0, Línea 1
The UPDATE statement conflicted with the CHECK constraint "chk_experimento_estado". The conflict occurred in database "datalab", table "dbo.experimento", column 'estado'.
The statement has been terminated.

Hora de finalización: 2026-10-06T18:13:28.6989274-05:00


¿Por qué SQL Server rechazó o aceptó la operación?

Porque el valor terminado no esta dentro de los valores de estado. En su lugar, una opción podria ser exitoso.
```

La prueba permite comprobar que la restricción realmente está funcionando.

---

# 17. Paso 5 — Actualizar un estado válido

Ahora utiliza un valor permitido:

```sql
UPDATE experimento
SET estado = 'exitoso'
WHERE id_experimento = 1;
```

Verifica:

```sql
SELECT
    id_experimento,
    estado
FROM experimento
WHERE id_experimento = 1;
```

---

# 18. Paso 6 — Agregar `notas`

Ejecuta:

```sql
ALTER TABLE dataset
ADD notas VARCHAR(MAX) NULL;
```

Verifica:

```sql
SELECT
    id_dataset,
    nombre,
    notas
FROM dataset;
```

---

# 19. Paso 7 — Agregar una restricción adicional

Revisa el modelo.

Identifica una regla que pueda faltar.

Por ejemplo:

```text
UNIQUE
```

Si corresponde a tu modelo, agrega una restricción:

```sql
ALTER TABLE proyecto
ADD CONSTRAINT uq_proyecto_nombre
UNIQUE (nombre_proyecto);
```

> Antes de ejecutar la restricción, verifica que no existan duplicados en los datos actuales.

Documenta:

```text
Restricción agregada:

ALTER TABLE proyecto
ADD CONSTRAINT uq_proyecto_nombre
UNIQUE (nombre);

¿Por qué es necesaria?

Porque previene que un proyecto tenga el mismo nombre lo que garantiza consistencia a nivel conceptual dentro del modelo.
```

---

# 20. Paso 8 — Practicar modificación de columna

Identifica una columna `VARCHAR` cuyo tamaño pueda ampliarse de manera justificada.

En SQL Server:

```sql
ALTER TABLE tabla
ALTER COLUMN columna VARCHAR(200);

ALTER TABLE cientifico_datos
ALTER COLUMN especialidad VARCHAR(150) NOT NULL;
```

Antes de ejecutar:

```text
¿Qué tamaño tenía?

100

¿Qué tamaño tendrá?

150

¿Por qué se amplía?

Basicamente, por hacer el ejercicio , aunque en casos mas especificos, se puede aplicar a descripciones , notas , etc.
```

---

# 21. Paso 9 — Renombrar una columna

Los documentos fuente presentan `CHANGE COLUMN`, que corresponde a MySQL.

Para esta práctica en SQL Server se puede utilizar:

```sql
EXEC sp_rename
    'tabla.columna_actual',
    'columna_nueva',
    'COLUMN';
```

No renombres una columna real de DataLab sin justificarlo y verificar las dependencias.

El objetivo principal es comprender la operación y reconocer la diferencia entre dialectos.

---

# 22. Paso 10 — Practicar DROP de forma segura

**No ejecutar `DROP` sobre las ocho tablas reales de DataLab.**

Crea una tabla desechable:

```sql
CREATE TABLE tabla_prueba_drop (
    id INT PRIMARY KEY,
    dato VARCHAR(50)
);
```

Inserta un registro:

```sql
INSERT INTO tabla_prueba_drop
VALUES (1, 'prueba');
```

Consulta:

```sql
SELECT *
FROM tabla_prueba_drop;
```

---

# 23. Paso 11 — DROP COLUMN

Ahora elimina únicamente la columna de prueba:

```sql
ALTER TABLE tabla_prueba_drop
DROP COLUMN dato;
```

Verifica la estructura.

El objetivo es observar la diferencia entre:

```text
eliminar una columna
```

y:

```text
eliminar una tabla
```

---

# 24. Paso 12 — DROP TABLE

Cuando hayas terminado:

```sql
DROP TABLE tabla_prueba_drop;
```

Después intenta consultar:

```sql
SELECT *
FROM tabla_prueba_drop;
```

Observa el resultado.

Esto permite experimentar con `DROP` sin poner en riesgo las tablas reales.

La guía docente establece expresamente que esta es la tabla desechable para practicar `DROP`. fileciteturn14file0L120-L136

---

# 25. Reto — Detectar un problema antes de agregar una restricción

Supón que queremos agregar:

```text
UNIQUE(nombre)
```

Primero consulta:

```sql
SELECT
    nombre,
    COUNT(*) AS cantidad
FROM proyecto
GROUP BY nombre
HAVING COUNT(*) > 1;
```

Analiza:

```text
¿Existen duplicados?

No ya que depsues de ejecutar la consulta, se retornan filas vacias

¿Se puede agregar UNIQUE inmediatamente?

Solo se puede agregar si no existen duplicdos 

¿Qué habría que hacer primero?

Hay que identificar y corregir los registros duplicados , despues , ahi si se puede aplicar la restricción UNIQUE
```

---

# 26. Reto — CHECK sobre datos existentes

Imagina que existe:

```text
estado = 'terminado'
```

y la nueva regla solo permite:

```text
planificado
en_ejecucion
exitoso
fallido
```

El procedimiento correcto sería:

```text
1. Detectar datos inválidos
        ↓
2. Corregirlos con UPDATE
        ↓
3. Agregar CHECK
        ↓
4. Verificar
```

Documenta un ejemplo.

1. Detectar datos invalidos

SELECT * FROM experimento 
WHERE estado NOT IN ('planificado', 'en_ejecucion', 'exitoso', 'fallido');

2. Corregir con update

UPDATE experimento 
SET estado = 'planificado' 
WHERE estado NOT IN ('planificado', 'en_ejecucion', 'exitoso', 'fallido');

3. Verificar los cambios
---

# 27. Reto — Diferenciar DML y DDL

Clasifica:

```text
INSERT
UPDATE
DELETE
SELECT
ALTER TABLE
DROP TABLE
CREATE TABLE
```

Completa:

```text
DML:
Es el data manipulation language, que trabaja con los datos que estan dentro de las tablas con comandos como UPDATE , INSERT , DELETE , etc.

DDL:
Es el data definition language, que trabaja con la estructura de la base de datos , y usa comandos como ALTER TABLE, DROP TABLE , CREATE TABLE ,
```

Explica la diferencia con tus propias palabras.

---

# 28. Documentación

Actualiza:

```text
documentacion/diccionario_datos.md
```

Incluye:

```text
experimento
└── estado

dataset
└── notas
```

También documenta las restricciones nuevas.

---

# 29. Registrar decisiones

Actualiza:

```text
documentacion/decisiones.md
```

Incluye:

```text
Fecha:
[ ]

Cambio realizado:
[ ]

Motivo:
[ ]

Problema encontrado:
[ ]

Solución:
[ ]

Restricciones afectadas:
[ ]

Impacto sobre datos existentes:
[ ]
```

La guía docente solicita registrar específicamente qué ocurrió al aplicar restricciones sobre datos existentes y qué ajustes fueron necesarios. fileciteturn14file0L138-L145

---

# 30. Organizar los scripts

El repositorio debería contener:

```text
scripts/
├── ddl/
│   └── s05-creacion-tablas.sql
│
├── dml/
│   ├── s06-reset-datos.sql
│   └── s06-datos-semilla.sql
│
└── ddl/
    └── s07-evolucion-esquema.sql
```

Para evitar duplicar el nombre `ddl/`, la estructura recomendada final es:

```text
scripts/
├── ddl/
│   ├── s05-creacion-tablas.sql
│   └── s07-evolucion-esquema.sql
│
└── dml/
    ├── s06-reset-datos.sql
    └── s06-datos-semilla.sql
```

---

# 31. Estructura sugerida del script

```sql
/*
    DataLab
    Semana 7
    Evolución del esquema

    ALTER TABLE
    Restricciones
    UPDATE
    DROP de prueba
*/

-- ==========================================
-- 1. AGREGAR ESTADO
-- ==========================================


-- ==========================================
-- 2. AGREGAR CHECK
-- ==========================================


-- ==========================================
-- 3. AGREGAR NOTAS
-- ==========================================


-- ==========================================
-- 4. ACTUALIZAR ESTADOS
-- ==========================================


-- ==========================================
-- 5. RESTRICCIÓN ADICIONAL
-- ==========================================


-- ==========================================
-- 6. MODIFICACIÓN DE COLUMNA
-- ==========================================


-- ==========================================
-- 7. PRUEBA DROP
-- ==========================================
```

---

# 32. Git

Después de validar:

```bash
git status
```

Agregar cambios:

```bash
git add .
```

Crear commit:

```bash
git commit -m "ddl: evolucion del esquema de DataLab (estado en experimento, notas en dataset)"
```

Enviar:

```bash
git push
```

El mensaje de commit corresponde al propuesto en los documentos de la Semana 7. fileciteturn14file0L143-L145

---

# 33. Evidencias de la actividad

El equipo debe poder demostrar:

- estado inicial de las tablas;
- columna `estado` agregada;
- `DEFAULT` aplicado;
- `CHECK` funcionando;
- columna `notas` agregada;
- modificación realizada con `UPDATE`;
- restricción adicional practicada;
- `DROP` realizado únicamente sobre tabla de prueba;
- diccionario actualizado;
- decisiones documentadas;
- commit realizado.

---

# 34. Reto Feynman

Explica a un compañero, sin leer el código:

### Reto 1

¿Por qué utilizamos `ALTER TABLE` y no `CREATE TABLE` nuevamente?

### Reto 2

¿Por qué agregar `NOT NULL` sobre una tabla que ya tiene datos puede generar un problema?

### Reto 3

¿Por qué necesitamos `DEFAULT`?

### Reto 4

¿Qué problema puede aparecer al agregar un `CHECK` sobre datos existentes?

### Reto 5

¿Cuál es la diferencia entre:

```text
DELETE
DROP COLUMN
DROP TABLE
DROP DATABASE
```

### Reto 6

¿Por qué `ALTER TABLE` puede considerarse una migración de esquema?

### Reto 7

¿Por qué debemos probar `DROP` únicamente sobre una tabla desechable?

---

# 35. Checklist de entrega

## Base de datos

- [ ] `estado` agregado a `experimento`.
- [ ] `DEFAULT` configurado.
- [ ] `CHECK` configurado.
- [ ] `notas` agregada a `dataset`.
- [ ] Al menos una restricción adicional practicada.
- [ ] Al menos una modificación de columna practicada.
- [ ] `UPDATE` ejecutado y verificado.
- [ ] `DROP COLUMN` practicado en tabla de prueba.
- [ ] `DROP TABLE` practicado en tabla de prueba.
- [ ] Ninguna tabla real de DataLab fue eliminada.

## Documentación

- [ ] `documentacion/diccionario_datos.md` actualizado.
- [ ] `documentacion/decisiones.md` actualizado.
- [ ] Cambios explicados.
- [ ] Errores encontrados documentados.

## Git

- [ ] Script versionado.
- [ ] Commit realizado.
- [ ] Push realizado.
- [ ] Historial permite identificar la evolución.

---

# 36. Criterio de éxito

La actividad no se considera completa simplemente porque los comandos se ejecuten sin errores.

El equipo debe demostrar que comprende:

```text
Necesidad de negocio
        ↓
Cambio de esquema
        ↓
Análisis de datos existentes
        ↓
ALTER TABLE
        ↓
Restricciones
        ↓
UPDATE si es necesario
        ↓
Pruebas
        ↓
Documentación
        ↓
Git
```

La guía del estudiante establece como cierre la existencia de `estado`, `notas`, una restricción adicional, práctica controlada de `DROP`, documentación y commit. fileciteturn14file1L171-L178

---

# 37. Cierre

DataLab ya no es una base de datos estática.

Ahora empieza a comportarse como un sistema real:

```text
              DATA LAB
                  │
                  ▼
          ┌───────────────┐
          │    ESQUEMA    │
          └───────┬───────┘
                  │
             necesidad
                  │
                  ▼
            ALTER TABLE
                  │
        ┌─────────┼─────────┐
        ▼         ▼         ▼
      ADD      ALTER      DROP
        │         │         │
        └─────────┼─────────┘
                  ▼
             CONSTRAINTS
                  │
                  ▼
             VALIDACIÓN
                  │
                  ▼
              DOCUMENTACIÓN
                  │
                  ▼
                 GIT
```

> **El objetivo no es solamente aprender comandos. El objetivo es aprender a evolucionar una base de datos existente de forma controlada, verificable y trazable.**
