WITH tmp_table AS (
  SELECT
      ivr_detail.calls_ivr_id
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
)
SELECT
      tmp_table.calls_ivr_id
    , tmp_table.step_document_type
    , tmp_table.step_document_identification
FROM
  tmp_table
WHERE
  rn = 1;

/*Primero he buscado todos los posibles valores que toma la columna document_type. Después creo una tabla temporal 
que contenga todas las llamadas con sus ditintos steps y asigno una numeracion ordenando descendetemente sin contar
con los dos valores que menos me interesa (UNKNOWN y DESCONOCIDO).

Por último obtengo el primer valor (consigue que obtenga valores únicos) del rn

Para hacer el rn he tenido que cambiar el id ya que es tipo float a entero. Además para no perder id * por una potencia de 10 elevada*/

#3 columnas con 21674 registros