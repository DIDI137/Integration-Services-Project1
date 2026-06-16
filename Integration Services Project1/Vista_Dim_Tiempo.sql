CREATE OR ALTER VIEW Tiempo_vw AS
SELECT 
    t.Fecha,
    YEAR(t.Fecha) AS Anio,
    DATEPART(QQ, t.Fecha) AS Trimestre,
    MONTH(t.Fecha) AS Mes,
    DAY(t.Fecha) AS Dia,
    CASE 
        WHEN h.Date IS NOT NULL THEN 1 
        ELSE 0 
    END AS Es_Feriado
FROM dbo.Staging_Tiempo_Base t
LEFT JOIN (
    SELECT CAST(Date AS DATE) AS Date
    FROM dbo.holidays_2_stg
) h
    ON t.Fecha = h.Date;
GO