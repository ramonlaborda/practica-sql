WITH tmp_table AS (
     SELECT ivr_detail.calls_ivr_id
          , IF(ivr_detail.step_name = 'CUSTOMERINFOBYDNI.TX'AND step_description_error = 'OK', 1, 0) flag
     FROM `keepcoding.ivr_detail`ivr_detail
)
SELECT tmp_table.calls_ivr_id
     , MAX(tmp_table.flag) AS info_by_dni_lg
FROM tmp_table
GROUP BY(1)

/*El enunciado de la práctica que descargué al inicio del modulo indica que la segunda condición debe ser
step_descriotion_error = UNKNOWN. Sin embargo en el enunciado actual y en el video resumen de clase la condición
cambia a step_description_error = OK

Opto por usar la versión más actualizada aunque tanto en la tabla ivr_detail como en ivr_steps (esta ultima cargada dos veces por si hubiese
habido también una actualización, no hay ningún registro que cumpla la condición actual. Todos los posibles valores del campo
step_description_error toman los valores UNKNOWN o UNKNOWN ERROR

No hay ningún info_by_dni_lg = 1*/

#2 columnas con 21674 registros