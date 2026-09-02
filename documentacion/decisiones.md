a) ¿En qué se parece su boceto al de otros equipos?
Respuesta: Se parecen ya que se entiende que los cientificos de datos son las entidades, y realizan difernwtes actividades con datsets , relacionadas al modelado.
b) ¿En qué se diferencia? ¿Alguna diferencia les genera dudas sobre cuál versión es la correcta?
Sobre quien o que deberia ser la identidad superior 
c) Preguntas abiertas que les quedan después de ver otros bocetos:
Como se púede relacionar de manera efectiva los concetos de entidades y relaciones


Niveles de modelado 

"Un experimento puede producir, como máximo, un modelo" 	Conceptual
"La tabla EXPERIMENTO tiene una llave foránea id_dataset"	Lógico 
"La columna fecha_ejecucion es de tipo DATE"	            Físico




Relación : CIENTIFICO_DATOS – participa en – PROYECTO	
Cardinalidad  = N:M	
Participación: Total en CIENTIFICO_DATOS ya que cada científico de datos debe participar en al menos un proyecto . Total en PROYECTO: cada proyecto debe tener al menos UN científico de datos.

Relación: DATASET – se usa en – EXPERIMENTO	
Cardinalidad: 1:N	
Participación: Parcial en DATASET ya que puede existir sin haber sido usado todavía en un experimento. Total en EXPERIMENTO: cada experimento debe utilizar UN dataset.

Relación: EXPERIMENTO – produce – MODELO	
Cardinalidad: 1:1	
Paricipación: Total en EXPERIMENTO ya que cada experimento produce un modelo. Parcial en MODELO: un modelo puede existir sin estar asociado a un experimento en particular.

Relación: MODELO – se evalúa con – METRICA	
Cardinalidad: N:M	
Participación: Total en MODELO ya que cada modelo debe ser evaluado con al menos una métrica. Total en METRICA: cada métrica registrada debe utilizarse para evaluar al menos un modelo.




CIENTIFICO_DATOS: Las llaves candidatas son id_cientifico y correo. Se elige id_cientifico como llave primaria porque identifica de forma única a cada científico de datos.

PROYECTO: La llave candidata es id_proyecto. Se elige como llave primaria porque identifica de manera única cada proyecto.

DATASET: La llave candidata es id_dataset. Se elige como llave primaria porque identifica de forma única cada dataset.

MODELO: La llave candidata es id_modelo. Se elige como llave primaria porque permite identificar de manera única cada modelo.

METRICA: Las llaves candidatas son id_metrica y nombre_metrica. Se elige id_metrica como llave primaria porque identifica de forma única cada métrica y no depende de su nombre.





Hito semana 2:
1. Tablas puente (N:M)

Decisión: Crear la tabla participacion_proyecto.

Por qué: Describe una acción real. Se agregó la columna rol porque el rol depende de esa participación específica, no del científico en general.

2. Llaves Foráneas (1:N)

Decisión: La FK siempre va en el lado "muchos" 

Por qué: Para asegurar que solo haya un dato por celda (atomicidad).

3. Participación parcial

Decisión: La FK id_experimento se colocó dentro de la tabla modelo.

Por qué: Todo modelo necesita obligatoriamente un experimento para existir, pero un experimento puede ejecutarse y no generar ningún modelo.