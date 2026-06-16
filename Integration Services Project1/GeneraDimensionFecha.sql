CREATE TABLE dbo.Staging_Tiempo_Base (
    Fecha DATE PRIMARY KEY,
    Dia INT,
    Mes INT,
    NombreMes VARCHAR(50),
    Año INT,
    Trimestre INT,
    Semestre INT,
    DiaSemana INT,
    NombreDiaSemana VARCHAR(50),
    Semana INT,
    DiaAño INT
);
GO

-- 2. La poblamos usando el script con la opción MAXRECURSION habilitada
DECLARE @vFechaDesde DATE = '2000-01-01';
DECLARE @vFechaHasta DATE = '2099-12-31';

WITH Fechas (Fecha) AS (
    SELECT @vFechaDesde
    UNION ALL
    SELECT DATEADD(d,1,Fecha)
    FROM Fechas
    WHERE Fecha < @vFechaHasta
)
INSERT INTO dbo.Staging_Tiempo_Base
SELECT Fecha, DAY(Fecha), MONTH(Fecha), DATENAME(MONTH,Fecha), 
       YEAR(Fecha), DATEPART(QQ,Fecha), (DATEPART(QQ,Fecha) + 1) / 2,
       DATEPART(DW,Fecha), DATENAME(DW,Fecha), 
       DATEPART(WK,Fecha), DATEPART(DY,Fecha)
FROM Fechas
OPTION (MAXRECURSION 0);
GO
