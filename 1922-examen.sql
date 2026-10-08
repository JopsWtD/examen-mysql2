USE coworking_grupo5;

DELIMITER $$

DROP TRIGGER IF EXISTS trg_suscripciones_bi_fecha_vencimiento$$
-- En caso de que exista, se borra un trigger que fue creado en el proyecto para evitar conflictos.

DROP TRIGGER IF EXISTS trg_calcular_fecha_vencimiento$$
-- En caso de que ya exista otro trigger con el mismo nombre, se borra para crear este. 


-- Para la realización del trigger, se tuvo que cambiar el AFTER INSERT por un BEFORE INSERT debido a la estructura de la base de datos,
-- ya que todos los datos se manejaban en una misma entidad.

CREATE TRIGGER trg_calcular_fecha_vencimiento
BEFORE INSERT ON suscripciones
FOR EACH ROW

BEGIN
    SET NEW.fecha_inicio = COALESCE(NEW.fecha_inicio, CURDATE());
    -- En caso de que la fecha de inicio venga como NULL, se valida con un COALESCE para que tome como nuevo valor el resultado
    -- de la función CURDATE(), que retorna la fecha actual.
    SET NEW.fecha_fin = DATE_ADD(NEW.fecha_inicio, INTERVAL 30 DAY);
    -- Se añaden los 30 días a la fecha de inicio y se guarda ese valor en la fecha fin.
END$$

DELIMITER ;

-- Como verificación de que el trigger funciona correctamente, a continuación se realizarán inserciones de prueba.

INSERT INTO suscripciones (id_usuario, id_membresia, fecha_inicio, fecha_fin)

VALUES ((SELECT MIN(id_usuario) FROM usuarios), (SELECT MIN(id_membresia) FROM membresias), NULL, NULL), 
-- La primera prueba es para que se vea que el trigger modifica ambas fechas en caso de que vengan nulas.
	   ((SELECT MAX(id_usuario) FROM usuarios), (SELECT MIN(id_membresia) FROM membresias), NULL, '2026-10-08'),
-- Esta segunda prueba es para que se vea que aun si fecha_inicio viene nula y fecha_fin viene ya predefinida, el trigger redefinirá fecha_fin
-- de acuerdo con el nuevo valor de fecha_inicio.
	   ((SELECT MIN(id_usuario) FROM usuarios), (SELECT MAX(id_membresia) FROM membresias), '2026-11-10', NULL);
-- Esta última prueba es para que se vea que aunque fecha_fin venga nula, se calculará según fecha_inicio.
       

SELECT * FROM suscripciones
ORDER BY 1 DESC;
-- Por último, verificamos que si se hayan insertado correctamente y que el trigger haya modificado las fechas.
