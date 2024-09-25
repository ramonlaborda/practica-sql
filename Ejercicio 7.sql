WITH tmp_table AS (
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
)
SELECT  tmp_table.calls_ivr_id
      , tmp_table.step_billing_account_id AS  billing_account_id
FROM tmp_table
WHERE rn = 1

/*Mismo procedimiento que en el ejercicio 5. Esta vez solo con la palabra UNKNOWN*/

#2 columnas con 21674 registros