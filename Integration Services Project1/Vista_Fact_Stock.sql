CREATE OR ALTER VIEW Stock_vw AS
SELECT
	TRY_CONVERT(DATE, LEFT(fecha, 10), 101) AS ID_Tiempo_FK,
	CAST(producto_id AS INT) AS ID_Producto_FK,
	CAST(Variacion AS INT) AS Variacion
FROM stock_stg