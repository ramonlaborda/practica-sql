SELECT DISTINCT ivr_detail.calls_ivr_id,
       CASE WHEN LEFT(ivr_detail.calls_vdn_label,3) = 'ATC'   THEN 'FRONT'
            WHEN LEFT(ivr_detail.calls_vdn_label,4) = 'TECH'  THEN 'TECH'
            WHEN ivr_detail.calls_vdn_label = 'ABSORPTION'    THEN 'ABSORPTION'
            ELSE 'RESTO'
       END vdn_aggregation

FROM `keepcoding.ivr_detail` ivr_detail

#2 columnas con 21674 registros