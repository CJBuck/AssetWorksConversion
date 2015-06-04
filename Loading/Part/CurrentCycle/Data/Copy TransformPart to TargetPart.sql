INSERT INTO TargetPart
SELECT *
FROM TransformPart
WHERE
	PartID IS NOT NULL
	AND ISNULL(PartSuffix, 99999) <> 99999
	AND Keyword IS NOT NULL
	AND ShortDescription IS NOT NULL
	AND ProductCategoryID IS NOT NULL
	AND PartClassificationID IS NOT NULL
