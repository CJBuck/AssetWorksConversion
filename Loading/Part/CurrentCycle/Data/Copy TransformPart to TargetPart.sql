INSERT INTO TargetPart
SELECT *
FROM TransformPart
WHERE
	PartID IS NOT NULL
	AND PartSuffix IS NOT NULL
	AND Keyword IS NOT NULL
	AND ShortDescription IS NOT NULL
	AND ProductCategoryID IS NOT NULL
	AND PartClassificationID IS NOT NULL
