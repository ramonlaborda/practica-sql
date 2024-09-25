WITH tmp_table AS (
  SELECT ivr_calls.ivr_id
       , ivr_calls.phone_number
       , ivr_calls.start_date
       , LAG(ivr_calls.start_date) OVER (PARTITION BY phone_number ORDER BY ivr_calls.start_date) AS prev_call_time
       , LEAD(ivr_calls.start_date) OVER (PARTITION BY phone_number ORDER BY ivr_calls.start_date) AS next_call_time
  FROM `keepcoding.ivr_calls` ivr_calls
)
SELECT  tmp_table.ivr_id AS calls_ivr_id
      , CASE WHEN tmp_table.prev_call_time IS NOT NULL AND TIMESTAMP_DIFF(tmp_table.start_date, tmp_table.prev_call_time, HOUR) <= 24 THEN 1 ELSE 0
        END repeated_phone_24H
      , CASE WHEN next_call_time IS NOT NULL AND TIMESTAMP_DIFF(tmp_table.next_call_time, tmp_table.start_date, HOUR) <= 24 THEN 1 ELSE 0
        END cause_recall_phone_24H
FROM tmp_table;

/*Primero creamos tabla temporal que utiliza el registro y el numero de telefono ademas de la fecha de entrada de llamada
para crear 2 nuevas columnas que con el numero de telefono (no el id) me indique la hora de la llamada anterior y la siguiente

Se usa solo la tabla de llamadas y aplicamos una llamada a la tabla temporal con un case when donde la diferencia de tiempo es inferior a 24 H*/

# 3 columnas con 21674 registros