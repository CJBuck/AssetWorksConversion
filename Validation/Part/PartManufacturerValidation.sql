WITH Fails AS (
	SELECT DISTINCT
		TPL.PartID [Part No]
	FROM TransformPartLocation TPL
	WHERE TPL.Manufacturer NOT IN (
		SELECT TargetValue FROM TransformPartManufacturerLookup
		)
),
Length3S AS (
	SELECT F.[Part No], ph.[CATALOG] [Source Manufacturer]
	FROM Fails F
		INNER JOIN SourceWicm220PartsHeader ph ON F.[Part No] = ph.PART_NO
	WHERE LEN(F.[Part No]) = 3
),
Length4s AS (
	SELECT F.[Part No], xls.NewMfg [Source Manufacturer]
	FROM Fails F
		INNER JOIN ShawnsXLS xls ON F.[Part No] = xls.PartNo
	WHERE LEN(F.[Part No]) >= 4
)
SELECT * FROM Length3S
UNION ALL
SELECT * FROM Length4s
