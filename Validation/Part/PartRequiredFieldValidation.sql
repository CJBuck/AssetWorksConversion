SELECT
	TP.PartID, TP.PartSuffix, TP.Keyword, TP.ShortDescription,
	TP.ProductCategoryID, TP.PartClassificationID
FROM TransformPart TP
WHERE
	(ISNULL(TP.PartSuffix, 99) = 99)
	OR (ISNULL(TP.Keyword, '') = '')
	OR (ISNULL(TP.ShortDescription, '') = '')
	OR (ISNULL(TP.ProductCategoryID, '') = '')
	OR (ISNULL(TP.PartClassificationID, '') = '')
ORDER BY TP.PartID
