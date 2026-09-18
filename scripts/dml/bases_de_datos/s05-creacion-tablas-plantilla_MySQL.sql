-- =========================================================
-- DataLab — Script de creación de tablas (DDL) — PLANTILLA DE TRABAJO
-- Semana 5 — Hito 2
-- Motor: MySQL 8.x (ENGINE=InnoDB obligatorio para soportar FOREIGN KEY)
--
-- Instrucciones: las primeras 3 tablas ya están resueltas como ejemplo,
-- porque no tienen dependencias (no llevan FOREIGN KEY). Completen las
-- 5 tablas restantes siguiendo el mismo patrón y respetando el orden
-- de dependencias explicado en la guía. Reemplacen cada bloque "-- TODO"
-- por la sentencia CREATE TABLE completa.
-- =========================================================

CREATE DATABASE IF NOT EXISTS datalab;
USE datalab;

-- ---------------------------------------------------------
-- Tablas sin dependencias (resueltas como ejemplo)
-- ---------------------------------------------------------

CREATE TABLE cientifico_datos (
    id_cientifico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo_institucional VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE proyecto (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_proyecto VARCHAR(150) NOT NULL,
    descripcion TEXT
) ENGINE=InnoDB;

CREATE TABLE dataset (
    id_dataset INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    fuente VARCHAR(20) NOT NULL,
    fecha_carga DATE NOT NULL,
    tamanio_filas INT,
    CONSTRAINT chk_dataset_fuente CHECK (fuente IN ('interna','externa')),
    CONSTRAINT chk_dataset_tamanio CHECK (tamanio_filas >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- TODO 1 — Tabla experimento
-- Depende de: proyecto, cientifico_datos
-- Columnas: id_experimento (PK, auto), id_proyecto (FK), id_cientifico (FK),
--           fecha_ejecucion (DATE, NOT NULL, DEFAULT hoy), configuracion (TEXT)
-- Política ON DELETE definida en la Semana 4 para cada FK.
-- ---------------------------------------------------------

-- Escriban aquí su CREATE TABLE experimento ...


-- ---------------------------------------------------------
-- TODO 2 — Tabla modelo
-- Depende de: experimento
-- Recuerden: la FK a experimento debe ser UNIQUE (fuerza la cardinalidad 1:1,
-- ver Semana 3).
-- Columnas: id_modelo (PK, auto), id_experimento (FK, UNIQUE), nombre,
--           version, algoritmo.
-- ---------------------------------------------------------

-- Escriban aquí su CREATE TABLE modelo ...


-- ---------------------------------------------------------
-- TODO 3 — Tabla metrica
-- Depende de: modelo
-- Columnas: id_metrica (PK, auto), id_modelo (FK), nombre_metrica, valor
--           (con su CHECK del rango permitido), fecha_calculo.
-- ---------------------------------------------------------

-- Escriban aquí su CREATE TABLE metrica ...


-- ---------------------------------------------------------
-- TODO 4 — Tabla puente participacion
-- Depende de: cientifico_datos, proyecto
-- Llave primaria compuesta por las dos FK.
-- ---------------------------------------------------------

-- Escriban aquí su CREATE TABLE participacion ...


-- ---------------------------------------------------------
-- TODO 5 — Tabla puente uso_dataset
-- Depende de: dataset, experimento
-- Llave primaria compuesta por las dos FK.
-- ---------------------------------------------------------

-- Escriban aquí su CREATE TABLE uso_dataset ...


-- =========================================================
-- Cuando terminen: ejecuten el script completo contra su base `datalab`
-- y verifiquen con SHOW TABLES; que las 8 tablas se crearon correctamente.
-- =========================================================
