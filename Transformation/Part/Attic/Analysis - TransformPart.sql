--
SELECT * FROM TransformPart P
WHERE P.PartID = '0015'

TRUNCATE TABLE TransformPart

EXEC dbo.spTransformPart

--
SELECT * FROM SourceWicm220PartsHeader
WHERE PART_NO = '012196'

SELECT * FROM SourceWicm221PartsDetail
WHERE PART_NO = '012196'