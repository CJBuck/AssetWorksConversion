--
SELECT *
FROM SourceWicm220PartsHeader PH
WHERE
	PH.[STATUS] = 'A' AND
	PH.PART_NO IN (SELECT PartNo FROM LegacyPartsForTesting)


SELECT PartNo FROM LegacyPartsForTesting
WHERE PartNo NOT IN (
	SELECT PART_NO FROM SourceWicm220PartsHeader
	)
