# Guía paso a paso — DDL de DataLab en MySQL y SQL Server
## Semana 5 — Hito 2

Esta guía explica, paso a paso, la creación de las tablas de DataLab con sus llaves, índices y restricciones, mostrando la equivalencia entre MySQL y SQL Server.

El docente entrega **5 tablas resueltas como ejemplo** (`cientifico_datos`, `proyecto`, `dataset`, `experimento`, `modelo`) y el estudiante completa **3 tablas**:

- `metrica`
- `participacion`
- `uso_dataset`

---

## 📎 Archivos adjuntos a esta guía

Junto con este documento se entregan los siguientes scripts de referencia, que deben ejecutar **después** de tener las 8 tablas creadas:

| Archivo | Motor | Contenido |
|---|---|---|
| `s05-pruebas-integridad-solucion_MySQL.sql` | MySQL 8.x | 6 pruebas de integridad con sintaxis `CURDATE()`, `RESTRICT`, códigos `1451`/`1452`/`3819` |
| `s05-pruebas-integridad-solucion_MSSQL.sql` | SQL Server 2019+ | 6 pruebas de integridad con sintaxis `CAST(GETDATE() AS DATE)`, `NO ACTION`, `GO`, código `547` |

> ⚠️ **Importante:** el archivo `s05-pruebas-integridad-solucion_MSSQL.sql` es el **mismo conjunto de pruebas** que el de MySQL, adaptado al motor. Ejecútenlo **solo sobre su propia base `datalab`** ya creada, y **no lo confundan** con la plantilla `s05-creacion-tablas-plantilla.sql` (esa es la del DDL).

---

## 0. Preparación del entorno

### MySQL

```sql
CREATE DATABASE IF NOT EXISTS datalab;
USE datalab;
```

- `CREATE DATABASE IF NOT EXISTS` → crea la base solo si no existe.
- `USE datalab` → selecciona la base como contexto.

### SQL Server

```sql
IF DB_ID('datalab') IS NULL
BEGIN
    CREATE DATABASE datalab;
END;
GO

USE datalab;
GO
```

- SQL Server **no admite** `CREATE DATABASE IF NOT EXISTS`; se simula con `IF DB_ID(...) IS NULL`.
- `GO` no es T-SQL: es un **separador de lotes** propio de SSMS / Azure Data Studio / `sqlcmd`.

---

## 1. Tablas resueltas por el docente

Se entregan ya creadas para que el estudiante las use como patrón. Aquí van las dos versiones para que quede la referencia completa.

### 1.1 `cientifico_datos`

**MySQL:**
```sql
CREATE TABLE cientifico_datos (
    id_cientifico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo_institucional VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB;
```

**SQL Server:**
```sql
CREATE TABLE cientifico_datos (
    id_cientifico        INT IDENTITY(1,1) PRIMARY KEY,
    nombre               NVARCHAR(100) NOT NULL,
    correo_institucional NVARCHAR(150) NOT NULL UNIQUE
);
GO
```

**Conceptos que ilustra esta tabla (patrón para las demás):**

| Elemento | Qué hace | MySQL | SQL Server |
|---|---|---|---|
| Autoincremento | Genera el siguiente valor al insertar | `AUTO_INCREMENT` | `IDENTITY(1,1)` |
| `PRIMARY KEY` | Identifica unívocamente cada fila | igual | igual  |
| `NOT NULL` | Obliga a que la columna tenga valor | igual | igual |
| `UNIQUE` | Índice único: no permite duplicados | igual | igual |
| `ENGINE=InnoDB` | Motor transaccional con soporte de FK | obligatorio para FK | no aplica |

> ⚠️ En MySQL, si se usa `ENGINE=MyISAM` las FK **se aceptan pero se ignoran**.

---

### 1.2 `proyecto`

**MySQL:**
```sql
CREATE TABLE proyecto (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_proyecto VARCHAR(150) NOT NULL,
    descripcion TEXT
) ENGINE=InnoDB;
```

**SQL Server:**
```sql
CREATE TABLE proyecto (
    id_proyecto     INT IDENTITY(1,1) PRIMARY KEY,
    nombre_proyecto NVARCHAR(150) NOT NULL,
    descripcion     NVARCHAR(MAX)
);
GO
```

---

### 1.3 `dataset`

**MySQL:**
```sql
CREATE TABLE dataset (
    id_dataset INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    fuente VARCHAR(20) NOT NULL,
    fecha_carga DATE NOT NULL,
    tamanio_filas INT,
    CONSTRAINT chk_dataset_fuente CHECK (fuente IN ('interna','externa')),
    CONSTRAINT chk_dataset_tamanio CHECK (tamanio_filas >= 0)
) ENGINE=InnoDB;
```

**SQL Server:**
```sql
CREATE TABLE dataset (
    id_dataset    INT IDENTITY(1,1) PRIMARY KEY,
    nombre        NVARCHAR(150) NOT NULL,
    fuente        NVARCHAR(20)  NOT NULL,
    fecha_carga   DATE          NOT NULL,
    tamanio_filas INT,
    CONSTRAINT chk_dataset_fuente
        CHECK (fuente IN ('interna','externa')),
    CONSTRAINT chk_dataset_tamanio
        CHECK (tamanio_filas >= 0)
);
GO
```

**Sobre `CHECK`:**

- Se **nombran explícitamente** para poder identificarlas cuando el motor arroje un error.
- MySQL ignora silenciosamente los CHECK antes de 8.0.16; desde 8.0.16 los aplica.
- SQL Server siempre los ha aplicado.

---

### 1.4 `experimento`

**MySQL:**
```sql
CREATE TABLE experimento (
    id_experimento INT AUTO_INCREMENT PRIMARY KEY,
    id_proyecto INT NOT NULL,
    id_cientifico INT NOT NULL,
    fecha_ejecucion DATE NOT NULL DEFAULT (CURRENT_DATE),
    configuracion TEXT,
    CONSTRAINT fk_experimento_proyecto
        FOREIGN KEY (id_proyecto) REFERENCES proyecto(id_proyecto)
        ON DELETE RESTRICT,
    CONSTRAINT fk_experimento_cientifico
        FOREIGN KEY (id_cientifico) REFERENCES cientifico_datos(id_cientifico)
        ON DELETE RESTRICT
) ENGINE=InnoDB;
```

**SQL Server:**
```sql
CREATE TABLE experimento (
    id_experimento  INT IDENTITY(1,1) PRIMARY KEY,
    id_proyecto     INT  NOT NULL,
    id_cientifico   INT  NOT NULL,
    fecha_ejecucion DATE NOT NULL
        CONSTRAINT df_experimento_fecha DEFAULT (CAST(GETDATE() AS DATE)),
    configuracion   NVARCHAR(MAX),
    CONSTRAINT fk_experimento_proyecto
        FOREIGN KEY (id_proyecto) REFERENCES proyecto(id_proyecto)
        ON DELETE NO ACTION,
    CONSTRAINT fk_experimento_cientifico
        FOREIGN KEY (id_cientifico) REFERENCES cientifico_datos(id_cientifico)
        ON DELETE NO ACTION
);
GO
```

**Puntos clave:**

- **FK** obliga a que el valor exista en la tabla padre.
- **`ON DELETE`**: `RESTRICT` / `NO ACTION` bloquea el borrado; `CASCADE` borra hijos; `SET NULL` pone NULL.
- **`DEFAULT`**: MySQL usa `CURRENT_DATE`; SQL Server usa `CAST(GETDATE() AS DATE)`.

| Cláusula | MySQL | SQL Server |
|---|---|---|
| Bloquea borrado padre | `ON DELETE RESTRICT` | `ON DELETE NO ACTION` |
| Borra hijos | `ON DELETE CASCADE` | `ON DELETE CASCADE` |
| Pone NULL | `ON DELETE SET NULL` | `ON DELETE SET NULL` |

> En SQL Server **`RESTRICT` no existe**; su equivalente es `NO ACTION`.

---

### 1.5 `modelo` (depende de `experimento`, cardinalidad 1:1)

**MySQL:**
```sql
CREATE TABLE modelo (
    id_modelo INT AUTO_INCREMENT PRIMARY KEY,
    id_experimento INT NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    version VARCHAR(50) NOT NULL,
    algoritmo VARCHAR(100) NOT NULL,
    CONSTRAINT fk_modelo_experimento
        FOREIGN KEY (id_experimento) REFERENCES experimento(id_experimento)
        ON DELETE CASCADE
) ENGINE=InnoDB;
```

**SQL Server:**
```sql
CREATE TABLE modelo (
    id_modelo       INT IDENTITY(1,1) PRIMARY KEY,
    id_experimento  INT NOT NULL UNIQUE,
    nombre          NVARCHAR(150) NOT NULL,
    version         NVARCHAR(50)  NOT NULL,
    algoritmo       NVARCHAR(100) NOT NULL,
    CONSTRAINT fk_modelo_experimento
        FOREIGN KEY (id_experimento) REFERENCES experimento(id_experimento)
        ON DELETE CASCADE
);
GO
```

**Por qué `UNIQUE` en la FK:** sin `UNIQUE`, la relación sería 1:N. Con `UNIQUE`, un experimento solo puede estar referenciado por **un** modelo → cardinalidad **1:1**. En ambos motores el `UNIQUE` crea un índice único sobre `id_experimento`.

---

## 2. Las 3 tablas que el estudiante debe crear

### 2.1 `metrica` (depende de `modelo`)

**TODO 1 — Pista para MySQL:**
```sql
-- TODO 1 — Tabla metrica
-- Depende de: modelo
-- Columnas: id_metrica (PK, auto), id_modelo (FK), nombre_metrica, valor
--           (con su CHECK del rango permitido), fecha_calculo.
```

**TODO 1 — Pista para SQL Server:**
```sql
-- TODO 1 — Tabla metrica
-- Depende de: modelo
-- Columnas: id_metrica (PK, auto), id_modelo (FK), nombre_metrica, valor
--           (con su CHECK del rango permitido), fecha_calculo.
-- Recuerden: IDENTITY(1,1), NVARCHAR, GO.
```

**Explicación línea por línea:**

| Elemento | Qué hace | MySQL | SQL Server |
|---|---|---|---|
| `id_metrica` | PK autoincremental | `AUTO_INCREMENT` | `IDENTITY(1,1)` |
| `id_modelo` | FK a `modelo` | `INT NOT NULL` | `INT NOT NULL` |
| `DECIMAL(10,4)` | 10 dígitos totales, 4 decimales | igual | igual |
| `CHECK (valor >= 0 AND valor <= 1)` | Restricción de rango | igual | igual |
| `ON DELETE CASCADE` | Borra métricas si se borra el modelo | igual | igual |

**Puntos finos:**

- `DECIMAL` es **exacto** (aritmética decimal); `FLOAT` es aproximado. Para métricas como accuracy o F1 conviene `DECIMAL`.
- Como `valor` es `NOT NULL`, el CHECK siempre se evalúa.
- Si `valor` fuera nullable, un `INSERT` con `NULL` **no violaría** el CHECK en ninguno de los dos motores.

---

### 2.2 `participacion` (puente entre `cientifico_datos` y `proyecto`)

**TODO 2 — Pista para MySQL:**
```sql
-- TODO 2 — Tabla puente participacion
-- Depende de: cientifico_datos, proyecto
-- Llave primaria compuesta por las dos FK.
```

**TODO 2 — Pista para SQL Server:**
```sql
-- TODO 2 — Tabla puente participacion
-- Depende de: cientifico_datos, proyecto
-- Llave primaria compuesta por las dos FK.
-- Recuerden: nombrar la PK (pk_participacion) y ambas FK.
```

**Concepto de tabla puente (N:M):**

- No tiene PK de una sola columna; la **PK es compuesta** por las dos FK.
- Garantiza que **no se repita** la misma pareja (científico, proyecto).
- Ambas FK con `ON DELETE CASCADE`: si se borra un científico o un proyecto, se borra la participación automáticamente.
- **Ambos motores** aceptan múltiples `ON DELETE CASCADE` en una misma tabla siempre que apunten a tablas distintas.

---

### 2.3 `uso_dataset` (puente entre `dataset` y `experimento`)

**TODO 3 — Pista para MySQL:**
```sql
-- TODO 3 — Tabla puente uso_dataset
-- Depende de: dataset, experimento
-- Llave primaria compuesta por las dos FK.
```

**TODO 3 — Pista para SQL Server:**
```sql
-- TODO 3 — Tabla puente uso_dataset
-- Depende de: dataset, experimento
-- Llave primaria compuesta por las dos FK.
-- Recuerden: nombrar la PK (pk_uso_dataset) y ambas FK.
```

**Puntos finos:**

- Misma estructura que `participacion`: **PK compuesta + dos FK con CASCADE**.
- Refuerza el patrón: cuando la relación es **N:M**, se resuelve con tabla puente cuya PK es la unión de las dos FK.

---

## 3. Índices: qué se crea automáticamente y qué no

| Restricción | Índice creado | MySQL | SQL Server |
|---|---|---|---|
| `PRIMARY KEY` | Clustered | InnoDB: clustered | Clustered por defecto |
| `UNIQUE` | Non-clustered | Sí | Sí |
| `FOREIGN KEY` | Índice sobre la columna FK | **Sí, automático** | **No, hay que crearlo** |

> ⚠️ **Diferencia crítica:** en MySQL InnoDB, declarar una FK **crea automáticamente un índice** sobre la columna. En SQL Server, la FK **no crea índice**; solo crea la restricción. Si se van a hacer muchos JOINs, conviene crear el índice explícitamente.

**SQL Server (recomendado):**
```sql
CREATE INDEX ix_metrica_id_modelo          ON metrica(id_modelo);
CREATE INDEX ix_participacion_id_proyecto  ON participacion(id_proyecto);
CREATE INDEX ix_uso_dataset_id_experimento ON uso_dataset(id_experimento);
```

**Por qué no indexar todo:**

- Cada índice ocupa disco.
- Cada `INSERT`/`UPDATE`/`DELETE` debe actualizar todos los índices → más costoso.
- Un índice mal elegido puede ser ignorado por el optimizador.

---

## 4. Pruebas de integridad — cómo ejecutarlas y qué documentar

Los archivos `s05-pruebas-integridad-solucion_MySQL.sql` y `s05-pruebas-integridad-solucion_MSSQL.sql` contienen las **6 pruebas** de integridad. Deben ejecutarlas sobre su base `datalab` **después** de crear las 8 tablas, y luego llenar las tablas de resultados de la sección **4.4** (una para cada motor).

### Resumen de las 6 pruebas

| # | Prueba | Comportamiento esperado |
|---|---|---|
| 1 | `INSERT` válido en `cientifico_datos` y `proyecto` |  |
| 2 | `INSERT` en `experimento` con `id_proyecto = 999` (no existe) |  |
| 3 | `INSERT` válido en `experimento` y `modelo` |  |
| 4 | `INSERT` en `metrica` con `valor = 1.5` (fuera de rango) |  |
| 5 | `DELETE` de `proyecto` con experimentos asociados |  |
| 6 | `INSERT` métrica válida + `DELETE` del modelo padre |  |

### 4.1 Códigos de error esperados por motor

| Prueba | MySQL | SQL Server |
|---|---|---|
| 2 (FK insert) | `ERROR 1452` | `Msg 547` (FK) |
| 4 (CHECK) | `ERROR 3819` | `Msg 547` (CHECK) |
| 5 (RESTRICT) | `ERROR 1451` | `Msg 547` (REFERENCE) |
| 6 (CASCADE) | Sin error | Sin error |

### 4.2 Cómo capturar los resultados

**MySQL (consola o Workbench):**
```sql
-- Copiar el texto del error tal cual aparece
SHOW WARNINGS;
```

**SQL Server (SSMS o Azure Data Studio):**
- Revisar la pestaña **Messages** después de ejecutar cada sentencia.
- El mensaje incluye el nombre exacto de la restricción que falló.

### 4.3 Qué anotar en cada fila

Para cada prueba, registren:

- **Resultado real:** ¿coincidió con lo esperado? (Sí / No)
- **Mensaje de error exacto** (o "sin error" si fue válida).
- **Nombre de la restricción** que aparece en el mensaje (esto confirma que la nombraron bien).
- **Predicción previa (Semana 3/4):** ¿qué habían anticipado?
- **Ajuste:** si no coincidió, ¿qué cambiaron o aprendieron?

### 4.4 Tabla de resultados — SQL Server

| # | Prueba | Resultado esperado | Resultado real | Mensaje / error exacto | Restricción involucrada | ¿Coincidió con Semana 3/4? | Observaciones |
|---|---|---|---|---|---|---|---|
| 1 | `INSERT` válido `cientifico_datos` + `proyecto` | El resultado esperado es  que se haga efectivamente que la inserción. | Es resultado fue exitoso | The statement has been terminated. / (1 fila afectada)| — | Si |No hay  |
| 2 | `INSERT` `experimento` con `id_proyecto=999` |  De fallar porque el proyecto 999 no existe.| No hubo exito|The INSERT statement conflicted with the FOREIGN KEY constraint "fk_experimento_proyecto". The conflict occurred in database "datalab", table "dbo.proyecto", column 'id_proyecto'. The statement has been terminated | `fk_experimento_proyecto` |Si ya que responde a la integridad referencial | Se respetan las reglas de padres e hijos |
| 3 | `INSERT` válido `experimento` + `modelo` |Las insercciones deberian efectuarse sin problema.  | Se realizaron sin problemas.| (1 fila afectada) | — | | Las llaves existen por ende no hay problema. |
| 4 | `INSERT` `metrica` con `valor=1.5` | Debe fallar porque 1.5 está fuera del rango permitido de 0 a 1 | Fallo porque excedio el rango | The INSERT statement conflicted with the CHECK constraint "chk_metrica_valor". The conflict occurred in database "datalab", table "dbo.metrica", column 'valor'. The statement has been terminated.| `chk_metrica_valor` | | Debemos verificar los limites del sistema ´para no excederlos|
| 5 | `DELETE` `proyecto` con hijos | Debe fallar porque existen experimentos asociados y la FK utiliza NO ACTION. | Fallo ya que no cumple con las condiciones|The DELETE statement conflicted with the REFERENCE constraint "fk_experimento_proyecto". The conflict occurred in database "datalab", table "dbo.experimento", column 'id_proyecto'. The statement has been terminated. | `fk_experimento_proyecto` | |hay que tener en cuenta la jerarquia de padres e hijos. |
| 6 | `DELETE` `modelo` con métrica | Debe eliminar todo lo asociado con dicha llave | Eliminoo todo lo relacionado | (1 fila afectada) | `fk_metrica_modelo` | Si ya que asi funciona la condicon |Debemos tener cuidado al utilizar cascade ya que borra todo lo que encuientre a suj paso. |

### 4.5 Tabla de resultados — MySQL

| # | Prueba | Resultado esperado | Resultado real | Mensaje / error exacto | Restricción involucrada | ¿Coincidió con Semana 3/4? | Observaciones |
|---|---|---|---|---|---|---|---|
| 1 | `INSERT` válido `cientifico_datos` + `proyecto` |  | | — | — | | |
| 2 | `INSERT` `experimento` con `id_proyecto=999` |  | | | `fk_experimento_proyecto` | | |
| 3 | `INSERT` válido `experimento` + `modelo` |  | | — | — | | |
| 4 | `INSERT` `metrica` con `valor=1.5` |  | | | `chk_metrica_valor` | | |
| 5 | `DELETE` `proyecto` con hijos |  | | | `fk_experimento_proyecto` | | |
| 6 | `DELETE` `modelo` con métrica |  | | — | `fk_metrica_modelo` | | |

### 4.6 Comparación entre motores

Una vez llenas las dos tablas anteriores, respondan:

1. ¿El comportamiento fue idéntico en ambos motores? ¿En qué se diferenció?
2. ¿Los códigos de error fueron los mismos? ¿Por qué creen que SQL Server unifica varios errores en `Msg 547`?
3. ¿El nombre de la restricción reportada coincidió con el que escribieron en el DDL?
4. ¿Qué hubiera pasado si la FK de `experimento` a `proyecto` hubiera sido `CASCADE` en vez de `RESTRICT`/`NO ACTION` en la Prueba 5?

### 4.7 Resumen ejecutivo para `documentacion/decisiones.md`

Al final, agreguen un bloque corto al archivo `documentacion/decisiones.md` con esta estructura:

```markdown
## Semana 5 — Resultados de las pruebas de integridad

- **Motor(es) probado(s):** MySQL 8.x / SQL Server 2019+
- **Pruebas ejecutadas:** 6 de 6
- **Predicciones de Semana 3/4 que se cumplieron:** [listar]
- **Predicciones que NO se cumplieron y por qué:** [listar]
- **Diferencias observadas entre MySQL y SQL Server:** [listar]
- **Ajustes realizados al DDL:** [listar]
```

---

## 5. Diferencias clave entre MySQL y SQL Server

| Aspecto | MySQL 8.x | SQL Server 2019+ |
|---|---|---|
| Autoincremento | `AUTO_INCREMENT` | `IDENTITY(1,1)` |
| Texto | `VARCHAR`, `TEXT` | `NVARCHAR`, `NVARCHAR(MAX)` |
| Fecha actual | `CURRENT_DATE` / `CURDATE()` | `CAST(GETDATE() AS DATE)` |
| Motor de tabla | `ENGINE=InnoDB` obligatorio para FK | No aplica |
| FK `RESTRICT` | `ON DELETE RESTRICT` | `ON DELETE NO ACTION` |
| Separador de lotes | `;` | `;` + `GO` |
| Crear BD condicional | `CREATE DATABASE IF NOT EXISTS` | `IF DB_ID(...) IS NULL` |
| Índice automático en FK | Sí | No |
| Códigos de error FK | `1451` (delete), `1452` (insert) | `547` (todo) |
| Código CHECK | `3819` | `547` |
| Ver estructura | `SHOW CREATE TABLE t;` | `EXEC sp_help 't';` |
| Listar tablas | `SHOW TABLES;` | `SELECT name FROM sys.tables;` |
| Identificadores | Backticks `` ` `` | Corchetes `[]` o comillas `""` |
| Booleanos | `TINYINT(1)` | `BIT` |
| UUID | `CHAR(36)` / `UUID()` | `UNIQUEIDENTIFIER` + `NEWID()` |

---

## 6. Resultado esperado tras ejecutar el script

### Salida en MySQL

```
mysql> SHOW TABLES;
+--------------------+
| Tables_in_datalab  |
+--------------------+
| cientifico_datos   |
| dataset            |
| experimento        |
| metrica            |
| modelo             |
| participacion      |
| proyecto           |
| uso_dataset        |
+--------------------+
8 rows in set (0.00 sec)
```

### Salida en SQL Server

```sql
SELECT name AS tabla FROM sys.tables ORDER BY name;
```

```
tabla
--------------------
cientifico_datos
dataset
experimento
metrica
modelo
participacion
proyecto
uso_dataset

(8 rows affected)
```

### Verificación de restricciones

**MySQL:**
```sql
SELECT  CONSTRAINT_NAME,
        TABLE_NAME,
        REFERENCED_TABLE_NAME,
        DELETE_RULE
FROM information_schema.REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'datalab'
ORDER BY TABLE_NAME;
```

**SQL Server:**
```sql
SELECT  fk.name AS fk_name,
        OBJECT_NAME(fk.parent_object_id)     AS tabla_hija,
        OBJECT_NAME(fk.referenced_object_id) AS tabla_padre,
        fk.delete_referential_action_desc    AS on_delete
FROM sys.foreign_keys fk
ORDER BY tabla_hija;
```

---

## 7. Errores frecuentes y cómo leerlos

| Error | Causa | Solución |
|---|---|---|
| `ERROR 1215` MySQL | No se pudo crear la FK | Verificar tabla padre, tipo y collation, y motor InnoDB |
| `Msg 1776` SQL Server | "There are no primary or candidate keys..." | La columna referenciada debe ser PK o UNIQUE |
| `Msg 547` SQL Server | Conflicto de FK o CHECK | Leer el nombre de la restricción en el mensaje |
| `ERROR 1452` MySQL | Insert con FK inexistente | Verificar el id referenciado |
| `ERROR 1451` MySQL | Delete con hijos dependientes | Cambiar política a CASCADE o borrar hijos primero |
| `Msg 2714` SQL Server | "There is already an object named..." | La tabla ya existe; usar `DROP TABLE IF EXISTS` |

---

## 8. Checklist de cierre del Hito 2

- [ ] Script `scripts/ddl/s05-creacion-tablas.sql` con las **8 tablas** (5 dadas + 3 creadas por el equipo), ejecutado sin errores en MySQL y/o SQL Server.
- [ ] Scripts `scripts/dml/s05-pruebas-integridad_MySQL.sql` y `scripts/dml/s05-pruebas-integridad_MSSQL.sql` ejecutados, con las **tablas de resultados 4.4 y 4.5 completas**.
- [ ] Script `scripts/dml/s05-datos-semilla.sql` con datos reales cargados.
- [ ] `documentacion/decisiones.md` actualizado con el bloque de la sección **4.7** y con si las predicciones de las Semanas 3–4 coincidieron con el comportamiento real.
- [ ] Commits y tag `h2-modelo-relacional`.

---

## 9. Cierre pedagógico — preguntas para discutir

1. ¿Por qué el diseño físico no es portable entre motores?
2. ¿Qué pasa si uso MyISAM en MySQL?
3. ¿Qué índices crea MySQL automáticamente?
4. ¿Qué índices crea SQL Server automáticamente?
5. ¿Por qué nombrar explícitamente las restricciones?
6. ¿Por qué SQL Server usa un solo código (`Msg 547`) para errores que MySQL separa en `1451`, `1452` y `3819`? ¿Ventajas y desventajas de cada enfoque?
7. ¿En qué casos conviene `ON DELETE CASCADE` y en qué casos `NO ACTION`/`RESTRICT`? Justifiquen con ejemplos de DataLab.