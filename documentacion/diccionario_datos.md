
`cientifico_datos`
| Columna | Tipo de Dato | Llave | Descripción |
| `id_cientifico` | INT | PK | Identificador único del científico de datos. |
| `nombre` | VARCHAR | | Nombre completo del científico. |
| `especialidad` | VARCHAR | |Área de especialización principal

`proyecto`
| Columna | Tipo de Dato | Llave | Descripción |
| `id_proyecto` | INT | PK |Identificador único del proyecto. |
| `nombre_proyecto` | VARCHAR | | Nombre asignado al proyecto. |
| `fecha_inicio` | DATE | | Fecha en la que comenzó el proyecto. |

`dataset`
| Columna | Tipo de Dato | Llave | Descripción |
| `id_dataset` | INT | PK | Identificador único del conjunto de datos. |
| `nombre_archivo` | VARCHAR | | Nombre o ruta del archivo de datos. |
| `tamaño_mb` | INT | | Tamaño del dataset en megabytes. |

`participacion_proyecto` 
| Columna | Tipo de Dato | Llave | Descripción ||
| `id_cientifico` | INT | PK, FK| Referencia al científico que participa. |
| `id_proyecto` | INT | PK, FK | Referencia al proyecto en el que participa. |
| `rol` | VARCHAR | | Rol específico del científico en ese proyecto. |

`experimento`
| Columna | Tipo de Dato | Llave | Descripción |
| `id_experimento` | INT | PK | Identificador único del experimento. |
| `id_proyecto` | INT | FK | Referencia al proyecto al que pertenece el experimento. |
| `id_dataset` | INT | FK | Referencia al dataset utilizado en el experimento. |
| `fecha_ejecucion`| DATE | | Fecha en la que se corrió el experimento. |
| `configuracion` | TEXT | | Parámetros y configuraciones utilizadas. |

`modelo`
| Columna | Tipo de Dato | Llave | Descripción |
| `id_modelo` | INT | PK | Identificador único del modelo generado. |
| `id_experimento` | INT | FK | Referencia al experimento que originó este modelo. |
| `tipo_algoritmo` | VARCHAR | | Tipo de algoritmo usado (ej. Random Forest, Red Neuronal). |
| `version` | VARCHAR | | Versión del modelo iterado. |

`metrica`
| Columna | Tipo de Dato | Llave | Descripción |
| `id_metrica` | INT | PK | Identificador único de la métrica de evaluación. |
| `id_modelo` | INT | FK | Referencia al modelo que está siendo evaluado. |
| `nombre_metrica` | VARCHAR | | Nombre de la métrica  |
| `valor` | FLOAT | | Valor numérico resultante de la métric|