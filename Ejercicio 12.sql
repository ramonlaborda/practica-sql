CREATE OR REPLACE TABLE keepcoding.ivr_summary AS
WITH temp_table_E4 AS(
  SELECT DISTINCT ivr_detail.calls_ivr_id,
       CASE WHEN LEFT(ivr_detail.calls_vdn_label,3) = 'ATC'   THEN 'FRONT'
            WHEN LEFT(ivr_detail.calls_vdn_label,4) = 'TECH'  THEN 'TECH'
            WHEN ivr_detail.calls_vdn_label = 'ABSORPTION'    THEN 'ABSORPTION'
            ELSE 'RESTO'
       END vdn_aggregation
  FROM `keepcoding.ivr_detail` ivr_detail
), tmp_table_E5_1 AS (
  SELECT ivr_detail.calls_ivr_id
       , ivr_detail.step_document_type
       , ivr_detail.step_document_identification
       , ROW_NUMBER() OVER (PARTITION BY CAST(FLOOR(ivr_detail.calls_ivr_id*100000000) AS INT64) 
       ORDER BY 
           CASE 
             WHEN ivr_detail.step_document_type NOT IN ('UNKNOWN', 'DESCONOCIDO') THEN 1 
           ELSE 0 
           END DESC) AS rn
  FROM
    `keepcoding.ivr_detail` ivr_detail
), tmp_table_E5_2 AS (
  SELECT  tmp_table_E5_1.calls_ivr_id
        , tmp_table_E5_1.step_document_type
        , tmp_table_E5_1.step_document_identification
  FROM    tmp_table_E5_1
  WHERE
    rn = 1
), tmp_table_E6 AS (
  SELECT DISTINCT ivr_detail.calls_ivr_id
                , ivr_detail.calls_phone_number AS  customer_phone
  FROM `keepcoding.ivr_detail` ivr_detail
), tmp_table_E7_1 AS (
  SELECT
      ivr_detail.calls_ivr_id
    , ivr_detail.step_billing_account_id
    , ROW_NUMBER() OVER (PARTITION BY CAST(FLOOR(ivr_detail.calls_ivr_id*100000000) AS INT64) 
    ORDER BY 
        CASE 
          WHEN ivr_detail.step_billing_account_id NOT IN ('UNKNOWN') THEN 1 
        ELSE 0 
        END DESC) AS rn
  FROM
    `keepcoding.ivr_detail` ivr_detail
), tmp_table_E7_2 AS(
  SELECT  tmp_table_E7_1.calls_ivr_id
        , tmp_table_E7_1.step_billing_account_id AS  billing_account_id
  FROM tmp_table_E7_1
  WHERE rn = 1
), tmp_table_E8_1 AS (
     SELECT ivr_detail.calls_ivr_id
          , IF(ivr_detail.module_name = 'AVERIA_MASIVA', 1, 0) flag
     FROM `keepcoding.ivr_detail`ivr_detail
), tmp_table_E8_2 AS (
  SELECT tmp_table_E8_1.calls_ivr_id
      , MAX(tmp_table_E8_1.flag) AS masiva_lg
  FROM tmp_table_E8_1
  GROUP BY(1)
), tmp_table_E9_1 AS (
     SELECT ivr_detail.calls_ivr_id
          , IF(ivr_detail.step_name = 'CUSTOMERINFOBYPHONE.TX'AND step_description_error = 'UNKNOWN', 1, 0) flag
     FROM `keepcoding.ivr_detail`ivr_detail
), tmp_table_E9_2 AS (
SELECT tmp_table_E9_1.calls_ivr_id
     , MAX(tmp_table_E9_1.flag) AS info_by_phone_lg
FROM tmp_table_E9_1
GROUP BY(1)
), tmp_table_E10_1 AS (
     SELECT ivr_detail.calls_ivr_id
          , IF(ivr_detail.step_name = 'CUSTOMERINFOBYDNI.TX'AND step_description_error = 'OK', 1, 0) flag
     FROM `keepcoding.ivr_detail`ivr_detail
), tmp_table_E10_2 AS (
SELECT tmp_table_E10_1.calls_ivr_id
     , MAX(tmp_table_E10_1.flag) AS info_by_dni_lg
FROM tmp_table_E10_1
GROUP BY(1)
), tmp_table_E11_1 AS (
  SELECT ivr_calls.ivr_id
       , ivr_calls.phone_number
       , ivr_calls.start_date
       , LAG(ivr_calls.start_date) OVER (PARTITION BY phone_number ORDER BY ivr_calls.start_date) AS prev_call_time
       , LEAD(ivr_calls.start_date) OVER (PARTITION BY phone_number ORDER BY ivr_calls.start_date) AS next_call_time
  FROM `keepcoding.ivr_calls` ivr_calls
), tmp_table_E11_2 AS (
SELECT  tmp_table_E11_1.ivr_id AS calls_ivr_id
      , CASE WHEN tmp_table_E11_1.prev_call_time IS NOT NULL AND TIMESTAMP_DIFF(tmp_table_E11_1.start_date, tmp_table_E11_1.prev_call_time, HOUR) <= 24 THEN 1 ELSE 0
        END repeated_phone_24H
      , CASE WHEN next_call_time IS NOT NULL AND TIMESTAMP_DIFF(tmp_table_E11_1.next_call_time, tmp_table_E11_1.start_date, HOUR) <= 24 THEN 1 ELSE 0
        END cause_recall_phone_24H
FROM tmp_table_E11_1
)

SELECT DISTINCT
       ivr_detail.calls_ivr_id                     AS ivr_id
     , ivr_detail.calls_phone_number               AS phone_number 
     , ivr_detail.calls_ivr_result                 AS ivr_result
     , temp_table_E4.vdn_aggregation               AS vdn_aggregation
     , ivr_detail.calls_start_date                 AS start_date
     , ivr_detail.calls_end_date                   AS end_date
     , ivr_detail.calls_total_duration             AS total_duration
     , ivr_detail.calls_customer_segment           AS customer_segment
     , ivr_detail.calls_ivr_language               AS ivr_language
     , ivr_detail.calls_steps_module               AS steps_module
     , ivr_detail.calls_module_aggregation         AS module_aggregation
     , tmp_table_E5_2.step_document_type           AS document_type
     , tmp_table_E5_2.step_document_identification AS document_identification
     , tmp_table_E6.customer_phone                 AS customer_phone 
     , tmp_table_E7_2.billing_account_id           AS billing_account_id
     , tmp_table_E8_2.masiva_lg                    AS masiva_lg
     , tmp_table_E9_2.info_by_phone_lg             AS info_by_phone_lg  
     , tmp_table_E10_2.info_by_dni_lg              AS info_by_dni_lg
     , tmp_table_E11_2.repeated_phone_24H          AS repeated_phone_24H
     , tmp_table_E11_2.cause_recall_phone_24H      AS cause_recall_phone_24H

FROM `keepcoding.ivr_detail` ivr_detail
LEFT JOIN temp_table_E4  ON ivr_detail.calls_ivr_id = temp_table_E4.calls_ivr_id
LEFT JOIN tmp_table_E5_2 ON ivr_detail.calls_ivr_id = tmp_table_E5_2.calls_ivr_id
LEFT JOIN tmp_table_E6 ON ivr_detail.calls_ivr_id = tmp_table_E6.calls_ivr_id
LEFT JOIN tmp_table_E7_2 ON ivr_detail.calls_ivr_id = tmp_table_E7_2.calls_ivr_id
LEFT JOIN tmp_table_E8_2 ON ivr_detail.calls_ivr_id = tmp_table_E8_2.calls_ivr_id
LEFT JOIN tmp_table_E9_2 ON ivr_detail.calls_ivr_id = tmp_table_E9_2.calls_ivr_id
LEFT JOIN tmp_table_E10_2 ON ivr_detail.calls_ivr_id = tmp_table_E10_2.calls_ivr_id
LEFT JOIN tmp_table_E11_2 ON ivr_detail.calls_ivr_id = tmp_table_E11_2.calls_ivr_id

/*He creado tantas tablas temporales como ejercicios realizados en los pasos anteriores. En los casos donde en esas querys ya existía
un WITH, se crean dos temporales por ejercicio diferenciando con los prefijos _1 y _2

Como los resultados de todas esas querys tienen siempre los mismos registros, utilizo un distinct a la tabla ivr_detail para tener 
los registros únicos*/

#20 columnas con 21674 registros