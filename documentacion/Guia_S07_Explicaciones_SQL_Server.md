# Semana 7 — Guía de Explicaciones Paso a Paso
## ALTER TABLE, DROP y Restricciones sobre Tablas Existentes

**Caso integrador:** DataLab  
**SGBD:** SQL Server  
**Herramienta:** SQL Server Management Studio (SSMS)

> **Nota sobre dialectos:** los documentos base de la Semana 7 presentan `MODIFY COLUMN` y `CHANGE COLUMN` con sintaxis de MySQL. Como el proyecto DataLab se implementa en **SQL Server**, esta guía muestra las equivalencias de SQL Server y explica la diferencia de dialecto.

---

# 1. ¿Qué vamos a aprender?

En las semanas anteriores construimos la estructura de DataLab y creamos las tablas.

Ahora aparece una situación muy común en proyectos reales:

> La base de datos ya existe, ya tiene información y el negocio necesita nuevos cambios.

Por ejemplo:

- los experimentos ahora necesitan un `estado`;
- los datasets necesitan `notas`;
- una columna necesita ampliar su tamaño;
- se necesita una nueva restricción `UNIQUE`;
- una columna antigua debe eliminarse;
- una restricción debe agregarse o eliminarse.

La pregunta es:

> **¿Tenemos que borrar la tabla y crearla nuevamente?**

No.

Para eso existe `ALTER TABLE`.

Los documentos de la Semana 7 plantean precisamente la evolución de una base existente mediante cambios incrementales sobre tablas que ya contienen datos. fileciteturn14file0L34-L38

---

# 2. DDL y evolución del esquema

Los comandos principales de esta guía pertenecen a **DDL (Data Definition Language)**.

Entre ellos:

```text
ALTER TABLE
DROP TABLE
DROP DATABASE
```

Su propósito es modificar la **estructura** de la base de datos.

Podemos pensar:

```text
DML
│
├── INSERT
├── UPDATE
└── DELETE

DDL
│
├── CREATE
├── ALTER
└── DROP
```

Una forma sencilla de entenderlo:

> **DML cambia los datos. DDL cambia la estructura que contiene los datos.**

---

# 3. Explicación Feynman: ¿qué es ALTER TABLE?

Imagina que DataLab es una casa.

La casa ya está construida:

```text
CREATE TABLE
      ↓
Casa construida
```

Y dentro de la casa ya vive información:

```text
CREATE TABLE
      ↓
Datos
      ↓
Usuarios trabajando
```

Ahora el negocio pide una ventana nueva.

No tiene sentido destruir toda la casa.

La solución es:

```text
ALTER TABLE
      ↓
Modificar la estructura existente
      ↓
Conservar los datos
```

### En palabras simples

> `ALTER TABLE` sirve para **reformar una tabla que ya existe**.

Los documentos docentes utilizan exactamente esta analogía de una casa ya construida y habitada. fileciteturn14file0L36-L38

---

# 4. ALTER TABLE — Agregar una columna

## Sintaxis SQL Server

```sql
ALTER TABLE tabla
ADD columna tipo_dato;
```

Ejemplo:

```sql
ALTER TABLE experimento
ADD estado VARCHAR(20);
```

Estamos diciendo:

```text
Tabla:
experimento

Agregar:
estado

Tipo:
VARCHAR(20)
```

---

# 5. ¿Qué ocurre con los datos existentes?

Supongamos que `experimento` ya tiene:

```text
id_experimento | fecha_ejecucion
---------------|----------------
1              | 2026-09-20
2              | 2026-09-21
3              | 2026-09-22
```

Después de:

```sql
ALTER TABLE experimento
ADD estado VARCHAR(20);
```

la tabla conceptualmente queda:

```text
id_experimento | fecha_ejecucion | estado
---------------|-----------------|--------
1              | 2026-09-20      | NULL
2              | 2026-09-21      | NULL
3              | 2026-09-22      | NULL
```

La columna existe, pero los registros anteriores necesitan un valor.

---

# 6. Agregar una columna NOT NULL

Aquí aparece un problema importante.

Si hacemos:

```sql
ALTER TABLE experimento
ADD estado VARCHAR(20) NOT NULL;
```

la operación puede fallar porque ya existen filas y SQL Server necesita un valor válido para `estado`.

La pregunta Feynman es:

> **Si la columna no puede aceptar NULL, ¿qué valor recibirán las filas que ya existen?**

Si no existe respuesta, la operación no puede completarse correctamente.

Los documentos de Semana 7 plantean este como el problema central: agregar restricciones a datos existentes puede fallar si los datos actuales no cumplen la nueva regla. fileciteturn14file0L56-L60

---

# 7. ADD con DEFAULT

Una solución es proporcionar un valor predeterminado:

```sql
ALTER TABLE experimento
ADD estado VARCHAR(20) NOT NULL
    CONSTRAINT df_experimento_estado
    DEFAULT 'planificado'
    WITH VALUES;
```

La idea es:

```text
Nueva columna
      ↓
NOT NULL
      ↓
DEFAULT
      ↓
Las filas existentes reciben un valor válido
```

En este caso:

```text
estado = 'planificado'
```

---

# 8. ¿Qué es DEFAULT?

`DEFAULT` significa:

> **Si no proporciono un valor, utiliza este valor automáticamente.**

Ejemplo:

```sql
DEFAULT 'planificado'
```

Podemos imaginarlo como una respuesta automática:

```text
¿El INSERT trae estado?
        │
     ┌──┴──┐
    Sí     No
    │       │
    ▼       ▼
 usa     usa DEFAULT
valor    'planificado'
```

---

# 9. ALTER TABLE — Agregar CHECK

Ahora queremos controlar los valores permitidos.

DataLab define cuatro estados:

```text
planificado
en_ejecucion
exitoso
fallido
```

Podemos agregar:

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

---

# 10. Explicación Feynman de CHECK

Imagina un portero.

El portero tiene una lista:

```text
Permitidos:
✓ planificado
✓ en_ejecucion
✓ exitoso
✓ fallido
```

Si alguien intenta registrar:

```text
terminado
```

el portero responde:

```text
❌ No está permitido.
```

Eso es `CHECK`.

> **CHECK define una regla que los valores deben cumplir.**

---

# 11. ¿Qué pasa si los datos existentes violan CHECK?

Supongamos que ya existe:

```text
estado = 'terminado'
```

y luego intentamos:

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

SQL Server puede rechazar la restricción porque ya existe información que viola la regla.

El procedimiento conceptual es:

```text
1. Detectar datos inválidos
        ↓
2. Corregirlos con UPDATE
        ↓
3. Agregar CHECK
        ↓
4. Verificar
```

Ejemplo:

```sql
UPDATE experimento
SET estado = 'fallido'
WHERE estado = 'terminado';
```

Después:

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

Este problema y su solución están planteados explícitamente en la guía docente. fileciteturn14file0L68-L74

---

# 12. ALTER TABLE — Modificar una columna

Los documentos fuente presentan:

```sql
ALTER TABLE dataset
MODIFY COLUMN nombre VARCHAR(200) NOT NULL;
```

Esta es sintaxis de **MySQL**.

En SQL Server usamos:

```sql
ALTER TABLE dataset
ALTER COLUMN nombre VARCHAR(200) NOT NULL;
```

La idea es la misma:

```text
ALTER COLUMN
      ↓
Cambiar definición de columna
```

---

# 13. Ejemplo: ampliar VARCHAR

Supongamos que:

```sql
nombre VARCHAR(100)
```

quedó pequeño.

Podemos ampliar:

```sql
ALTER TABLE dataset
ALTER COLUMN nombre VARCHAR(200) NOT NULL;
```

La columna conserva su nombre:

```text
nombre
```

pero cambia su definición:

```text
VARCHAR(100)
      ↓
VARCHAR(200)
```

---

# 14. ALTER COLUMN y datos existentes

Antes de modificar una columna debemos verificar:

```text
¿Los datos actuales son compatibles
con la nueva definición?
```

Por ejemplo, si queremos pasar de:

```text
VARCHAR(200)
```

a:

```text
VARCHAR(20)
```

podríamos tener datos demasiado largos.

La pregunta Feynman es:

> **¿Podemos guardar todo lo que ya existe dentro del nuevo tamaño?**

Si la respuesta es no, debemos revisar los datos antes de modificar la estructura.

---

# 15. Renombrar una columna en SQL Server

Los documentos fuente utilizan `CHANGE COLUMN`, que es sintaxis MySQL:

```sql
ALTER TABLE experimento
CHANGE COLUMN configuracion config_experimento TEXT;
```

En SQL Server podemos utilizar:

```sql
EXEC sp_rename
    'experimento.configuracion',
    'config_experimento',
    'COLUMN';
```

Aquí estamos cambiando:

```text
configuracion
      ↓
config_experimento
```

La idea importante es:

> **Renombrar no significa crear una columna nueva; significa cambiar el nombre de una columna existente.**

---

# 16. Precaución con sp_rename

Renombrar una columna puede afectar:

- consultas;
- procedimientos almacenados;
- vistas;
- scripts;
- aplicaciones;
- documentación.

Por eso debemos buscar primero dónde se utiliza el nombre anterior.

En un proyecto con Git, el cambio debe quedar documentado.

---

# 17. ALTER TABLE — Eliminar una columna

En SQL Server:

```sql
ALTER TABLE experimento
DROP COLUMN columna_obsoleta;
```

Ejemplo:

```sql
ALTER TABLE experimento
DROP COLUMN columna_obsoleta;
```

La columna desaparece de la tabla.

---

# 18. Feynman: DROP COLUMN

Piensa en una habitación.

`ADD COLUMN`:

```text
Agregar un mueble
```

`ALTER COLUMN`:

```text
Modificar el mueble
```

`DROP COLUMN`:

```text
Retirar el mueble
```

Pero hay una diferencia importante:

> **Al retirar una columna también se pierde la información almacenada en ella.**

Por eso no debemos utilizar `DROP COLUMN` sin analizar primero sus consecuencias.

---

# 19. Agregar UNIQUE

Podemos agregar una restricción `UNIQUE` a una tabla existente.

Ejemplo de los documentos:

```sql
ALTER TABLE proyecto
ADD CONSTRAINT uq_proyecto_nombre
UNIQUE (nombre_proyecto);
```

La idea es que no existan dos registros con el mismo valor.

En DataLab, antes de aplicar esta regla debemos comprobar que los datos actuales no tengan duplicados.

Conceptualmente:

```text
Datos actuales
      ↓
¿Hay duplicados?
      ↓
No ───────────→ agregar UNIQUE
      │
     Sí
      ↓
corregir datos
      ↓
agregar UNIQUE
```

---

# 20. Agregar una PRIMARY KEY

Si una tabla existente no tiene clave primaria, conceptualmente podemos agregarla con:

```sql
ALTER TABLE tabla
ADD CONSTRAINT pk_tabla
PRIMARY KEY (id);
```

Ejemplo:

```sql
ALTER TABLE tabla_prueba
ADD CONSTRAINT pk_tabla_prueba
PRIMARY KEY (id);
```

Pero primero debemos verificar:

- que no existan `NULL`;
- que no existan duplicados;
- que la columna identifique realmente cada fila.

---

# 21. Agregar una FOREIGN KEY

También podemos agregar una clave foránea:

```sql
ALTER TABLE experimento
ADD CONSTRAINT fk_experimento_proyecto
FOREIGN KEY (id_proyecto)
REFERENCES proyecto(id_proyecto);
```

La idea es:

```text
experimento.id_proyecto
          │
          ▼
proyecto.id_proyecto
```

La clave foránea protege la integridad referencial.

---

# 22. ¿Qué puede impedir agregar una FOREIGN KEY?

Si existen datos como:

```text
experimento.id_proyecto = 999
```

pero:

```text
proyecto.id_proyecto
```

no contiene `999`, la relación no puede establecerse correctamente sobre esos datos.

Primero:

```text
Detectar referencias inválidas
          ↓
Corregir datos
          ↓
Agregar FK
```

---

# 23. Eliminar una restricción

Para eliminar una restricción en SQL Server utilizamos:

```sql
ALTER TABLE tabla
DROP CONSTRAINT nombre_restriccion;
```

Ejemplo:

```sql
ALTER TABLE experimento
DROP CONSTRAINT chk_experimento_estado;
```

La restricción desaparece.

Pero los datos existentes no necesariamente desaparecen.

Esto es diferente de:

```sql
DROP TABLE
```

---

# 24. Diferencia entre DROP CONSTRAINT y DROP TABLE

| Instrucción | ¿Qué elimina? |
|---|---|
| `DROP CONSTRAINT` | Una regla |
| `DROP COLUMN` | Una columna |
| `DROP TABLE` | Una tabla completa |
| `DROP DATABASE` | Una base de datos completa |

Feynman:

```text
DROP CONSTRAINT
→ quitar una regla

DROP COLUMN
→ quitar una columna

DROP TABLE
→ quitar toda la tabla

DROP DATABASE
→ quitar toda la base de datos
```

---

# 25. DROP TABLE

Sintaxis:

```sql
DROP TABLE nombre_tabla;
```

Ejemplo:

```sql
DROP TABLE tabla_prueba_drop;
```

No es equivalente a:

```sql
DELETE FROM tabla_prueba_drop;
```

---

# 26. DELETE vs DROP TABLE

### DELETE

```sql
DELETE FROM tabla_prueba_drop;
```

Elimina filas.

La tabla continúa existiendo:

```text
Tabla
✓ existe
✓ estructura existe
✗ datos eliminados
```

### DROP TABLE

```sql
DROP TABLE tabla_prueba_drop;
```

Elimina la tabla:

```text
Tabla
✗ ya no existe
✗ estructura eliminada
✗ datos eliminados
```

Los documentos docentes enfatizan que `DROP` es una operación destructiva y que debe practicarse sobre una tabla desechable, nunca sobre las ocho tablas reales de DataLab. fileciteturn14file0L120-L136

---

# 27. DROP DATABASE

La instrucción:

```sql
DROP DATABASE datalab;
```

elimina la base de datos completa.

Feynman:

> `DELETE` vacía una habitación.  
> `DROP TABLE` elimina la habitación.  
> `DROP DATABASE` elimina toda la casa.

Por eso `DROP DATABASE` requiere extrema precaución.

---

# 28. DROP y Git

Los documentos de la Semana 7 conectan `ALTER TABLE` con el concepto de **migración de esquema**.

Una migración representa un cambio incremental y trazable.

Por ejemplo:

```text
Versión 1
experimento
      ↓
Versión 2
experimento + estado
      ↓
Versión 3
experimento + estado + CHECK
```

Git conserva el historial de los scripts que producen esa evolución.

Los documentos explican que Git versiona el diseño mediante scripts, mientras que los backups protegen el contenido de la base de datos. fileciteturn14file0L76-L80

---

# 29. Caso completo DataLab

El negocio solicita:

1. agregar `estado` a `experimento`;
2. permitir solamente cuatro estados;
3. agregar `notas` a `dataset`.

## Paso 1 — Agregar estado

```sql
ALTER TABLE experimento
ADD estado VARCHAR(20) NOT NULL
    CONSTRAINT df_experimento_estado
    DEFAULT 'planificado'
    WITH VALUES;
```

## Paso 2 — Agregar CHECK

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

## Paso 3 — Agregar notas

```sql
ALTER TABLE dataset
ADD notas VARCHAR(MAX) NULL;
```

## Paso 4 — Actualizar un experimento

```sql
UPDATE experimento
SET estado = 'exitoso'
WHERE id_experimento = 1;
```

El documento docente utiliza precisamente este cambio como ejercicio de laboratorio. fileciteturn14file0L98-L107

## Paso 5 — Verificar

```sql
SELECT
    id_experimento,
    estado
FROM experimento;
```

---

# 30. Orden recomendado para modificar un esquema

Cuando una tabla ya contiene datos, conviene pensar en este orden:

```text
1. Analizar datos existentes
          ↓
2. Identificar incompatibilidades
          ↓
3. Corregir datos si es necesario
          ↓
4. Agregar/modificar estructura
          ↓
5. Agregar restricciones
          ↓
6. Verificar
          ↓
7. Documentar
          ↓
8. Versionar con Git
```

Esto es especialmente importante cuando agregamos:

```text
NOT NULL
CHECK
UNIQUE
PRIMARY KEY
FOREIGN KEY
```

---

# 31. Tabla resumen de comandos

| Comando | Propósito | Nivel de riesgo |
|---|---|---|
| `ALTER TABLE ... ADD` | Agregar columna | Medio |
| `ALTER TABLE ... ALTER COLUMN` | Modificar columna | Medio |
| `sp_rename` | Renombrar columna | Medio |
| `ALTER TABLE ... DROP COLUMN` | Eliminar columna | Alto |
| `ADD CONSTRAINT` | Agregar restricción | Medio |
| `DROP CONSTRAINT` | Eliminar restricción | Medio |
| `UPDATE` | Modificar datos | Medio/alto |
| `DROP TABLE` | Eliminar tabla completa | Muy alto |
| `DROP DATABASE` | Eliminar base completa | Crítico |

---

# 32. Feynman: explica toda la semana en una frase

Si tuvieras que explicar la Semana 7 a alguien que nunca ha trabajado con bases de datos:

> **ALTER TABLE permite reformar una tabla existente sin reconstruirla desde cero; las restricciones mantienen las reglas de los datos y DROP elimina elementos de forma destructiva, por lo que todos estos cambios deben analizarse, probarse, documentarse y versionarse.**

Si puedes explicar esa frase con ejemplos de DataLab, comprendiste el objetivo central de la semana.

---

# 33. Checklist conceptual

Antes del laboratorio deberías poder explicar:

- [ ] Qué significa DDL.
- [ ] Para qué sirve `ALTER TABLE`.
- [ ] Cómo agregar una columna.
- [ ] Cómo modificar una columna en SQL Server.
- [ ] Cómo renombrar una columna en SQL Server.
- [ ] Cómo eliminar una columna.
- [ ] Qué significa `DEFAULT`.
- [ ] Qué significa `CHECK`.
- [ ] Qué significa `UNIQUE`.
- [ ] Cómo agregar una `PRIMARY KEY`.
- [ ] Cómo agregar una `FOREIGN KEY`.
- [ ] Cómo eliminar una restricción.
- [ ] Diferencia entre `DELETE` y `DROP TABLE`.
- [ ] Diferencia entre `DROP TABLE` y `DROP DATABASE`.
- [ ] Por qué las restricciones pueden fallar al aplicarse sobre datos existentes.
- [ ] Por qué un cambio de esquema debe versionarse con Git.

---

# 34. Idea central

```text
TABLA EXISTENTE
      │
      ▼
ALTER TABLE
      │
      ├── ADD
      ├── ALTER COLUMN
      ├── DROP COLUMN
      └── ADD/DROP CONSTRAINT
      │
      ▼
DATOS + REGLAS
      │
      ▼
VERIFICACIÓN
      │
      ▼
DOCUMENTACIÓN
      │
      ▼
GIT / MIGRACIÓN
```

> **No se trata solamente de cambiar una tabla. Se trata de evolucionar un esquema existente sin perder el control sobre los datos y las reglas del sistema.**
