INSERT INTO [DW_Ventas].[dbo].[Fact_Ventas] (
    [ID_Tiempo_FK],
    [ID_Cliente_FK],
    [ID_Empleado_FK],
    [ID_Producto_FK],
    [ID_Age_Group_FK],
    [Cantidad_Unidades],
    [Precio_Unitario],
    [Descuento_Unitario],
    [Monto_Descuento],
    [Monto_Venta_Neto],
    [Litros_Vendidos],
    [Edad_En_Venta],
    [Antiguedad_Empleado]
)
SELECT 
    ISNULL(t.ID_Tiempo_SK, -1) AS ID_Tiempo_FK,
    ISNULL(c.ID_Cliente_SK, -1) AS ID_Cliente_FK,
    ISNULL(e.ID_Empleado_SK, -1) AS ID_Empleado_FK,
    ISNULL(p.ID_Producto_SK, -1) AS ID_Producto_FK,
    ISNULL(ag.ID_Age_Group_SK, 5) AS ID_Age_Group_FK,
    vnt.Cantidad_Unidades,
    vnt.Precio_Unitario,
    vnt.Descuento_Unitario,
    vnt.Monto_Descuento,
    vnt.Monto_Venta_Neto,
    vnt.Litros_Vendidos,
    vnt.Edad_En_Venta,
    vnt.Antiguedad_Empleado
FROM [TDC_Staging].[dbo].[Ventas_vw] vnt
LEFT JOIN [DW_Ventas].[dbo].[Dim_Tiempo] t ON vnt.ID_Tiempo_FK = t.Fecha
LEFT JOIN [DW_Ventas].[dbo].[Dim_Cliente] c ON vnt.ID_Cliente_FK = c.Customer_ID
LEFT JOIN [DW_Ventas].[dbo].[Dim_Empleado] e ON vnt.ID_Empleado_FK = e.Employee_ID
LEFT JOIN [DW_Ventas].[dbo].[Dim_Producto] p ON vnt.ID_Producto_FK = p.Product_ID
LEFT JOIN [DW_Ventas].[dbo].[Dim_Age_Group] ag ON vnt.Edad_En_Venta BETWEEN ag.Min_Age AND ag.Max_Age;