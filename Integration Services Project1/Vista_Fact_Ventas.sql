CREATE OR ALTER VIEW Ventas_vw AS
WITH Universo_Ventas AS (
    SELECT 
        billing_id AS ID_Billing,
        CAST(date AS DATE) AS ID_Tiempo_FK,
        customer_id AS ID_Cliente_FK,
        employee_id AS ID_Empleado_FK,
        product_id AS ID_Producto_FK,
        quantity AS Cantidad_Unidades
    FROM TDCsales_stg

    UNION ALL

    SELECT 
        b.BILLING_ID AS ID_Billing,
        CAST(b.DATE AS DATE) AS ID_Tiempo_FK,
        b.CUSTOMER_ID AS ID_Cliente_FK,
        b.EMPLOYEE_ID AS ID_Empleado_FK,
        d.PRODUCT_ID AS ID_Producto_FK,
        d.QUANTITY AS Cantidad_Unidades
    FROM billing_details_stg d
    INNER JOIN billing_stg b ON d.BILLING_ID = b.BILLING_ID
),
Calculo_Precios_Base AS (
    SELECT 
        vnt.ID_Billing,
        vnt.ID_Tiempo_FK,
        vnt.ID_Cliente_FK,
        vnt.ID_Empleado_FK,
        vnt.ID_Producto_FK,
        vnt.Cantidad_Unidades,
        CAST(ISNULL(pr.PRICE, 0.00) AS DECIMAL(18,2)) AS Precio_Unitario,
        CAST(vnt.Cantidad_Unidades * ISNULL(pr.PRICE, 0.00) AS DECIMAL(18,2)) AS Monto_Bruto_Linea,
        CAST(SUM(vnt.Cantidad_Unidades * ISNULL(pr.PRICE, 0.00)) OVER(PARTITION BY vnt.ID_Billing) AS DECIMAL(18,2)) AS Monto_Total_Billing_Bruto,
        v_p.Size_Cm3,
        v_c.Birth_Date,
        v_e.Employment_Date
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
)
SELECT 
    base.ID_Billing,
    base.ID_Tiempo_FK,
    base.ID_Cliente_FK,
    base.ID_Empleado_FK,
    base.ID_Producto_FK,
    CAST(NULL AS INT) AS ID_Age_Group_FK,
    base.Cantidad_Unidades,
    base.Precio_Unitario,
    base.Monto_Bruto_Linea,
    CAST(ISNULL(base.Monto_Total_Billing_Bruto * (dsc.PERCENTAGE / 100.0), 0.00) AS DECIMAL(18,2)) AS Monto_Descuento,
    CAST(base.Monto_Total_Billing_Bruto - ISNULL(base.Monto_Total_Billing_Bruto * (dsc.PERCENTAGE / 100.0), 0.00) AS DECIMAL(18,2)) AS Monto_Venta_Neto,
    CAST(base.Cantidad_Unidades * (base.Size_Cm3 / 1000.0) AS DECIMAL(18,4)) AS Litros_Vendidos,
    ISNULL(DATEDIFF(YEAR, base.Birth_Date, base.ID_Tiempo_FK), -1) AS Edad_En_Venta,
    DATEDIFF(YEAR, base.Employment_Date, base.ID_Tiempo_FK) AS Antiguedad_Empleado

FROM Calculo_Precios_Base base
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
    ON base.ID_Tiempo_FK >= CAST(dsc.DATE_FROM AS DATE)
    AND (dsc.DATE_UNTIL IS NULL OR base.ID_Tiempo_FK <= CAST(dsc.DATE_UNTIL AS DATE))
    AND base.Monto_Total_Billing_Bruto >= dsc.TOTAL_BILLING;