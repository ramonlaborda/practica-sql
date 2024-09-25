WITH tmp_table AS (
     SELECT ivr_detail.calls_ivr_id
          , IF(ivr_detail.step_name = 'CUSTOMERINFOBYPHONE.TX'AND step_description_error = 'UNKNOWN', 1, 0) flag
     FROM `keepcoding.ivr_detail`ivr_detail
)
SELECT tmp_table.calls_ivr_id
     , MAX(tmp_table.flag) AS info_by_phone_lg
FROM tmp_table
GROUP BY(1)

#2 columnas con 21674 registros