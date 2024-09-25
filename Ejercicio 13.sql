CREATE OR REPLACE FUNCTION keepcoding.clean_integer(valor INT64)
RETURNS INT64
AS (
  CASE
    WHEN valor IS NULL THEN -999999
    ELSE valor
  END
);