-- =========================================================
-- DataLab — Pruebas de integridad referencial y restricciones — SOLUCIÓN DE REFERENCIA
-- Semana 5 — Hito 2
-- Uso: exclusivo del docente. Ejecutar DESPUÉS de s05-creacion-tablas-solucion.sql
-- =========================================================

USE datalab;

-- ---------------------------------------------------------
-- Prueba 1 — Inserciones válidas (deben funcionar sin error)
-- ---------------------------------------------------------

INSERT INTO cientifico_datos (nombre, correo_institucional)
VALUES ('Ana Torres', 'ana.torres@usta.edu.co');

INSERT INTO proyecto (nombre_proyecto, descripcion)
VALUES ('Detección de fraude en transacciones', 'Modelo de clasificación binaria sobre transacciones bancarias');

-- Resultado esperado: 2 filas insertadas sin error.
-- Verificar con: SELECT * FROM cientifico_datos; SELECT * FROM proyecto;


-- ---------------------------------------------------------
-- Prueba 2 — Violación de integridad referencial (DEBE FALLAR)
-- ---------------------------------------------------------

-- id_proyecto = 999 no existe en la tabla proyecto.
INSERT INTO experimento (id_proyecto, id_cientifico, configuracion)
VALUES (999, 1, 'lr=0.01;epochs=50;batch=32');

-- Resultado esperado (MySQL):
-- ERROR 1452 (23000): Cannot add or update a child row: a foreign key
-- constraint fails (`datalab`.`experimento`, CONSTRAINT `fk_experimento_proyecto`
-- FOREIGN KEY (`id_proyecto`) REFERENCES `proyecto` (`id_proyecto`))
--
-- Esto es exactamente lo que los equipos predijeron en la Semana 3.


-- ---------------------------------------------------------
-- Prueba 3 — Inserción válida en experimento, para poder probar CHECK después
-- ---------------------------------------------------------

INSERT INTO experimento (id_proyecto, id_cientifico, configuracion)
VALUES (1, 1, 'lr=0.01;epochs=50;batch=32');

INSERT INTO modelo (id_experimento, nombre, version, algoritmo)
VALUES (1, 'modelo_fraude_v1', '1.0', 'Random Forest');


-- ---------------------------------------------------------
-- Prueba 4 — Violación de restricción CHECK (DEBE FALLAR)
-- ---------------------------------------------------------

-- valor = 1.5 está fuera del rango permitido (0 a 1).
INSERT INTO metrica (id_modelo, nombre_metrica, valor, fecha_calculo)
VALUES (1, 'accuracy', 1.5, CURDATE());

-- Resultado esperado (MySQL 8.0.16+):
-- ERROR 3819 (HY000): Check constraint 'chk_metrica_valor' is violated.


-- ---------------------------------------------------------
-- Prueba 5 — Política RESTRICT ante DELETE (DEBE FALLAR)
-- ---------------------------------------------------------

-- proyecto con id_proyecto = 1 ya tiene un experimento asociado (Prueba 3).
DELETE FROM proyecto WHERE id_proyecto = 1;

-- Resultado esperado (MySQL):
-- ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key
-- constraint fails (`datalab`.`experimento`, CONSTRAINT `fk_experimento_proyecto`
-- FOREIGN KEY (`id_proyecto`) REFERENCES `proyecto` (`id_proyecto`))
--
-- Esto confirma la política RESTRICT que los equipos justificaron en la Semana 4.


-- ---------------------------------------------------------
-- Prueba 6 — Política CASCADE ante DELETE (referencia, no ejecutar sobre los
-- mismos datos si se quiere conservar la base para la Semana 6)
-- ---------------------------------------------------------

-- INSERT de una métrica válida para luego probar el CASCADE:
-- INSERT INTO metrica (id_modelo, nombre_metrica, valor, fecha_calculo)
-- VALUES (1, 'accuracy', 0.95, CURDATE());
--
-- DELETE FROM modelo WHERE id_modelo = 1;
-- Resultado esperado: la fila de modelo se borra Y la fila de metrica asociada
-- se borra automáticamente (CASCADE), sin error.
-- Sugerencia: mostrar esto en un esquema de práctica aparte, no en la base
-- que van a usar como datos semilla para las próximas semanas.

-- =========================================================
-- Cierre: pedir a cada equipo que registre en documentacion/decisiones.md
-- si el comportamiento real coincidió con lo que predijeron en las
-- Semanas 3 y 4, y qué ajustaron si no coincidió.
-- =========================================================
