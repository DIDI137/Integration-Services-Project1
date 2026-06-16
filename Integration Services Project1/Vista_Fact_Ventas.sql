CREATE OR ALTER VIEW Ventas_vw AS
WITH Universo_Ventas AS (
    SELECT 
        CAST(date AS DATE) AS ID_Tiempo_FK,
        customer_id AS ID_Cliente_FK,
        employee_id AS ID_Empleado_FK,
        product_id AS ID_Producto_FK,
        quantity AS Cantidad_Unidades
    FROM TDCsales_stg

    UNION ALL

    SELECT 
        CAST(b.DATE AS DATE) AS ID_Tiempo_FK,
        b.CUSTOMER_ID AS ID_Cliente_FK,
        b.EMPLOYEE_ID AS ID_Empleado_FK,
        d.PRODUCT_ID AS ID_Producto_FK,
        d.QUANTITY AS Cantidad_Unidades
    FROM billing_details_stg d
    INNER JOIN billing_stg b ON d.BILLING_ID = b.BILLING_ID
)
SELECT 
    vnt.ID_Tiempo_FK,
    vnt.ID_Cliente_FK,
    vnt.ID_Empleado_FK,
    vnt.ID_Producto_FK,

    vnt.Cantidad_Unidades,
    CAST(ISNULL(pr.PRICE, 0.00) AS DECIMAL(18,2)) AS Precio_Unitario,
    CAST(ISNULL(pr.PRICE * (dsc.PERCENTAGE / 100.0), 0.00) AS DECIMAL(18,2)) AS Descuento_Unitario,
    CAST(ISNULL((vnt.Cantidad_Unidades * pr.PRICE) * (dsc.PERCENTAGE / 100.0), 0.00) AS DECIMAL(18,2)) AS Monto_Descuento,
    CAST(ISNULL((vnt.Cantidad_Unidades * pr.PRICE), 0.00) - ISNULL(((vnt.Cantidad_Unidades * pr.PRICE) * (dsc.PERCENTAGE / 100.0)), 0.00) AS DECIMAL(18,2)) AS Monto_Venta_Neto,
    CAST(vnt.Cantidad_Unidades * (v_p.Size_Cm3 / 1000.0) AS DECIMAL(18,4)) AS Litros_Vendidos,
    ISNULL(DATEDIFF(YEAR, v_c.Birth_Date, vnt.ID_Tiempo_FK), -1) AS Edad_En_Venta,
    DATEDIFF(YEAR, v_e.Employment_Date, vnt.ID_Tiempo_FK) AS Antiguedad_Empleado

FROM Universo_Ventas vnt
INNER JOIN Clientes_vw v_c ON vnt.ID_Cliente_FK = v_c.Customer_ID 
INNER JOIN Employee_vw v_e ON vnt.ID_Empleado_FK = v_e.Employee_ID
INNER JOIN Producto_vw v_p ON vnt.ID_Producto_FK = v_p.Product_ID
LEFT JOIN prices_stg pr 
    ON vnt.ID_Producto_FK = pr.PRODUCT_ID
    AND pr.DATE = (
        SELECT ISNULL(
            (SELECT MAX(DATE) FROM prices_stg WHERE PRODUCT_ID = vnt.ID_Producto_FK AND DATE <= vnt.ID_Tiempo_FK),
            (SELECT MIN(DATE) FROM prices_stg WHERE PRODUCT_ID = vnt.ID_Producto_FK)
        )
    )
LEFT JOIN (
    SELECT 
        d.DATE_FROM,
        d.DATE_UNTIL,
        d.TOTAL_BILLING,
        d.PERCENTAGE
    FROM discounts_stg d
    WHERE d.PERCENTAGE = (
        SELECT MAX(MAX_D.PERCENTAGE)
        FROM discounts_stg MAX_D
        WHERE d.DATE_FROM = MAX_D.DATE_FROM
    )
) dsc
    ON vnt.ID_Tiempo_FK >= CAST(dsc.DATE_FROM AS DATE)
    AND (dsc.DATE_UNTIL IS NULL OR vnt.ID_Tiempo_FK <= CAST(dsc.DATE_UNTIL AS DATE))
    AND (vnt.Cantidad_Unidades * ISNULL(pr.PRICE, 0.00)) >= (dsc.TOTAL_BILLING / 10.0)