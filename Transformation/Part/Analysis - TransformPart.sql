TRUNCATE TABLE TransformPart
TRUNCATE TABLE TransformPartLocation
TRUNCATE TABLE TransformPartAdjustment
TRUNCATE TABLE TransformPartLocationBin

EXEC dbo.spTransformPart

SELECT * FROM TransformPart
SELECT * FROM TransformPartLocation
SELECT * FROM TransformPartLocationBin
SELECT * FROM TransformPartAdjustment
--
SELECT * FROM TransformPart P
WHERE P.PartID = '030500'

SELECT PH.PART_COST
FROM SourceWicm220PartsHeader PH
WHERE PART_NO = '030500'

select * from SourceWicm222PartNotepad pn
where pn.PART_NO = '030500'

SELECT * FROM TransformPartLocation WHERE PartID = '301004010'

SELECT PART_NO, LOCATION, HIGH_LIM, LOW_LIM, LAST_UPD_DATE FROM SourceWicm221PartsDetail
WHERE PART_NO = '137001276' --'301004010      '
ORDER BY PART_NO, LOCATION

SELECT *
FROM SourceWicm221PartsDetail
WHERE LTRIM(RTRIM(PART_NO)) IN (SELECT PartID FROM TransformPart)
	AND CAST(HIGH_LIM AS DECIMAL) > 0

SELECT pd.PART_NO, COUNT(pd.PART_NO) [Count]
FROM SourceWicm221PartsDetail pd
WHERE pd.PART_NO IN (SELECT PartID FROM TransformPart)
GROUP BY pd.PART_NO
ORDER BY COUNT(pd.PART_NO) DESC

SELECT *
FROM ShawnsXLS
WHERE [Part #] = '914914'

