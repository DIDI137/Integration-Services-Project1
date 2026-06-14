CREATE OR ALTER VIEW Producto_vw AS
SELECT
	CAST(producto_id AS VARCHAR(50)) AS Product_ID,
	CAST(detalle AS VARCHAR(200)) AS Detail,
	CAST(
        CASE
            WHEN detalle LIKE '%cola%' THEN 'cola'
            WHEN detalle LIKE '%beer%' THEN 'beer'
            WHEN detalle LIKE '%soda%' THEN 'soda'
            WHEN detalle LIKE '%juice%' THEN 'juice'
            WHEN detalle LIKE '%energy drink%' THEN 'energy drink'
            ELSE 'Unknown'
        END AS VARCHAR(50)
    ) AS Category,

    CAST(
        CASE 
            WHEN volumen LIKE '%can%'   THEN 'can'
            WHEN volumen LIKE '%liter%' THEN 'bottle'
            ELSE 'Unknown'
        END AS VARCHAR(50)
    ) AS Package_Type,

    CAST(
        CASE 
            WHEN volumen LIKE '%330%' THEN 330
            WHEN volumen LIKE '%500%' THEN 500
            WHEN volumen LIKE '%670%' THEN 670
            WHEN volumen LIKE '%1%liter%' THEN 1000
            WHEN volumen LIKE '%2%liter%' THEN 2000
            ELSE NULL 
        END AS INT
    ) AS Size_Cm3,

    CAST(
        CASE 
            WHEN detalle LIKE '%diet%' THEN 1
            ELSE 0
        END AS BIT
    ) AS Is_Diet

FROM products_stg