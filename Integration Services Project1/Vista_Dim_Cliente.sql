CREATE OR ALTER VIEW Clientes_vw AS
WITH Clientes_Union AS (
	SELECT
		CUSTOMER_ID,
		FULL_NAME,
		BIRTH_DATE,
		CITY,
		STATE,
		ZIPCODE,
		'Retail' AS Customer_Type
	FROM Customer_R

	UNION ALL

	SELECT
		CUSTOMER_ID,
		FULL_NAME,
		BIRTH_DATE,
		CITY,
		STATE,
		ZIPCODE,
		'Wholesale' AS Customer_Type
	FROM Customer_W
)

SELECT
	CAST(C.CUSTOMER_ID AS VARCHAR(50)) AS Customer_ID,
    CAST(C.FULL_NAME AS VARCHAR(150)) AS Full_Name,
    CAST(C.Customer_Type AS VARCHAR(20)) AS Customer_Type,
	TRY_CONVERT(DATE, REPLACE(REPLACE(C.BIRTH_DATE, '*', ''), 'j', ''), 101) AS Birth_Date,
    CAST(C.CITY AS VARCHAR(100)) AS City,
    CAST(C.STATE AS VARCHAR(100)) AS State,
	CAST(ISNULL(R.region, 'Unknown') AS VARCHAR(50)) AS Region
FROM Clientes_Union C
LEFT JOIN regions_stg R
    ON LTRIM(RTRIM(C.ZIPCODE)) = LTRIM(RTRIM(R.codigo_postal))
	AND LTRIM(RTRIM(C.CITY)) = LTRIM(RTRIM(R.ciudad))
	AND LTRIM(RTRIM(C.STATE)) = LTRIM(RTRIM(R.estado));