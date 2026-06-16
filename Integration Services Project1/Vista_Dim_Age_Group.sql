CREATE OR ALTER VIEW Age_Group_stg_vw AS
SELECT 'Adolescentes' AS Age_Group, 13 AS Min_Age, 19 AS Max_Age
UNION ALL
SELECT 'Adultos Medios' AS Age_Group, 40 AS Min_Age, 50 AS Max_Age
UNION ALL
SELECT 'Edad del Gerente' AS Age_Group, 66 AS Min_Age, 66 AS Max_Age
UNION ALL
SELECT 'Otros Rangos (20-39)' AS Age_Group, 20 AS Min_Age, 39 AS Max_Age
UNION ALL
SELECT 'Otros Rangos (51-65)' AS Age_Group, 51 AS Min_Age, 65 AS Max_Age
UNION ALL
SELECT 'Otros Rangos (67+)' AS Age_Group, 67 AS Min_Age, 120 AS Max_Age
UNION ALL
SELECT 'No Especificado' AS Age_Group, -1 AS Min_Age, -1 AS Max_Age;
GO