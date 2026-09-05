
`cientifico_datos`
| Columna | Tipo de Dato | Llave | Descripción |
|---|---|---|---|
| `id_cientifico` | INT | PK | Identificador único del científico de datos. |
| `nombre` | VARCHAR | | Nombre completo del científico. |
| `especialidad` | VARCHAR | |Área de especialización principal

`proyecto`
| Columna | Tipo de Dato | Llave | Descripción |
|---|---|---|---|
| `id_proyecto` | INT | PK |Identificador único del proyecto. |
| `nombre_proyecto` | VARCHAR | | Nombre asignado al proyecto. |
| `fecha_inicio` | DATE | | Fecha en la que comenzó el proyecto. |

`dataset`
| Columna | Tipo de Dato | Llave | Descripción |
|---|---|---|---|
| `id_dataset` | INT | PK | Identificador único del conjunto de datos. |
| `nombre_archivo` | VARCHAR | | Nombre o ruta del archivo de datos. |
| `tamaño_mb` | INT | | Tamaño del dataset en megabytes. |

`participacion_proyecto` 
| Columna | Tipo de Dato | Llave | Descripción |
|---|---|---|---|
| `id_cientifico` | INT | PK, FK| Referencia al científico que participa. |
| `id_proyecto` | INT | PK, FK | Referencia al proyecto en el que participa. |
| `rol` | VARCHAR | | Rol específico del científico en ese proyecto. |

`experimento`
| Columna | Tipo de Dato | Llave | Descripción |
|---|---|---|---|
| `id_experimento` | INT | PK | Identificador único del experimento. |
| `id_proyecto` | INT | FK | Referencia al proyecto al que pertenece el experimento. |
| `id_dataset` | INT | FK | Referencia al dataset utilizado en el experimento. |
| `fecha_ejecucion`| DATE | | Fecha en la que se corrió el experimento. |
| `configuracion` | TEXT | | Parámetros y configuraciones utilizadas. |

`modelo`
| Columna | Tipo de Dato | Llave | Descripción |
|---|---|---|---|
| `id_modelo` | INT | PK | Identificador único del modelo generado. |
| `id_experimento` | INT | FK | Referencia al experimento que originó este modelo. |
| `tipo_algoritmo` | VARCHAR | | Tipo de algoritmo usado (ej. Random Forest, Red Neuronal). |
| `version` | VARCHAR | | Versión del modelo iterado. |

`metrica`
| Columna | Tipo de Dato | Llave | Descripción |
|---|---|---|---|
| `id_metrica` | INT | PK | Identificador único de la métrica de evaluación. |
| `id_modelo` | INT | FK | Referencia al modelo que está siendo evaluado. |
| `nombre_metrica` | VARCHAR | | Nombre de la métrica  |
| `valor` | FLOAT | | Valor numérico resultante de la métric|

Tabla semana 3
------------------------------------------------------------------
| Tabla | Columna | Tipo de dato | Restricciones |
| --- | --- | --- | --- |
| cientifico_datos | id_cientifico | INT | PK, NOT NULL |
| cientifico_datos | nombre | VARCHAR(100) | NOT NULL |
| cientifico_datos | correo | VARCHAR(100) | NOT NULL |
| proyecto | id_proyecto | INT | PK, NOT NULL |
| proyecto | nombre | VARCHAR(150) | NOT NULL |
| proyecto | descripcion | TEXT | Opcional |
| dataset | id_dataset | INT | PK, NOT NULL |
| dataset | nombre | VARCHAR(150) | NOT NULL |
| dataset | fuente | VARCHAR(150) | NOT NULL |
| dataset | fecha_carga | DATE | NOT NULL |
| dataset | tamanio_filas | INT | NOT NULL |
| experimento | id_experimento | INT | PK, NOT NULL |
| experimento | nombre_experimento | VARCHAR(150) | NOT NULL |
| experimento | fecha_ejecucion | DATE | NOT NULL |
| experimento | configuracion | TEXT | Opcional |
| experimento | id_proyecto | INT | FK, NOT NULL |
| experimento | id_dataset | INT | FK, NOT NULL |
| experimento | id_cientifico | INT | FK, NOT NULL |
| modelo | id_modelo | INT | PK, NOT NULL |
| modelo | nombre | VARCHAR(100) | NOT NULL |
| modelo | version | VARCHAR(20) | NOT NULL |
| modelo | algoritmo | VARCHAR(100) | NOT NULL |
| modelo | id_experimento | INT | FK, UNIQUE, NOT NULL |
| metrica | id_metrica | INT | PK, NOT NULL |
| metrica | nombre_metrica | VARCHAR(50) | NOT NULL |
| metrica | valor | FLOAT | NOT NULL |
| metrica | fecha_calculo | DATE | NOT NULL |
| metrica | id_modelo | INT | FK, NOT NULL |
| participacion | id_cientifico | INT | PK (Compuesta), FK, NOT NULL |
| participacion | id_proyecto | INT | PK (Compuesta), FK, NOT NULL |
| proyecto_dataset | id_proyecto | INT | PK (Compuesta), FK, NOT NULL |
| proyecto_dataset | id_dataset | INT | PK (Compuesta), FK, NOT NULL |