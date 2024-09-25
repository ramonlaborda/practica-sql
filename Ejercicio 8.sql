WITH tmp_table AS (
     SELECT ivr_detail.calls_ivr_id
          , IF(ivr_detail.module_name = 'AVERIA_MASIVA', 1, 0) flag
     FROM `keepcoding.ivr_detail`ivr_detail
)
SELECT tmp_table.calls_ivr_id
     , MAX(tmp_table.flag) AS masiva_lg
FROM tmp_table
GROUP BY(1)

/*Primero creo tabla temporal con todos un flag dicotomico y despues llamo a la tabla con un maximo*/

#2 columnas con 21674 registros