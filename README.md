# Trigger - 1922

Objetivo: Evaluar la comprensión de los triggers y su aplicación en la lógica del sistema.

Enunciado:

Crea un trigger SQL que, al insertar una nueva membresía, calcule y complete automáticamente la fecha de vencimiento sumando 30 días a la fecha de inicio.

    El trigger debe ejecutarse después de insertar (AFTER INSERT) una membresía.

    La fecha de vencimiento debe guardarse en el mismo registro de la membresía.

    Incluye un comentario explicando brevemente cómo funciona el trigger.


# SOLUCION:

El enunciado pedía el trigger con un AFTER INSERT, pero esto no fue posible porque, tal y como estaba organizada la base de datos, era imposible hacerlo de esta forma, ya que MySQL impide que un trigger con AFTER modifique datos de la misma tabla que está activando el trigger, generalmente por problemas con la recursividad, ya que esto ocasionaría un bucle infinito.

Debido a esto, se tuvo que replantear el problema y hacerlo con un BEFORE INSERT.

Y como en la base de datos ya existía un trigger que cubría básicamente la misma funcionalidad, en el mismo script se dejó una sentencia SQL para borrarlo antes de crear este otro, para evitar conflictos.

Adicionalmente, en el script también se puede encontrar la explicación línea por línea de la creación del trigger, pero de todos modos voy a explicar nuevamente el procedimiento aquí:

1. Lo primero fue elegir el nombre para el trigger... Y, por convención, se debe añadir el prefijo trg antes del nombre del trigger, asi que quedó como: trg_calcular_fecha_vencimiento.

2. Luego, se clasificó con BEFORE INSERT en la respectiva tabla (En este caso, **suscripciones**) y se marcó con "FOR EACH ROW" para indicar que se debe activar para cada fila afectada.

3. En el procedimiento, lo que se hizo fue simplemente modificar **fecha_inicio** para que, en caso de que viniera como null por defecto, pasara por un COALESCE que, posteriormente, haría que la columna tomara el valor retornado por **CURDATE()**... Es decir, la fecha actual. Luego, se asignó a **fecha_fin** el valor resultante de fecha_inicio + 30 días.


Después de haber creado el trigger, se realizaron pruebas para verificar que funcionara correctamente. **Las inserciones realizadas como prueba se pueden encontrar en el script SQL de la creación del trigger junto con una consulta para verificar que todo haya salido bien**.
