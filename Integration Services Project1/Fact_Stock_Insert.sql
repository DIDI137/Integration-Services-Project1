INSERT INTO [DW_Ventas].[dbo].[Fact_Stock] (
    [ID_Tiempo_FK],
    [ID_Producto_FK],
    [Variacion]
)
SELECT 
    ISNULL(t.ID_Tiempo_SK, -1) AS ID_Tiempo_FK,
    ISNULL(p.ID_Producto_SK, -1) AS ID_Producto_FK,
    stk.Variacion
FROM [TDC_Staging].[dbo].[Stock_vw] stk
LEFT JOIN [DW_Ventas].[dbo].[Dim_Tiempo] t ON stk.ID_Tiempo_FK = t.Fecha
LEFT JOIN [DW_Ventas].[dbo].[Dim_Producto] p ON stk.ID_Producto_FK = p.Product_ID;