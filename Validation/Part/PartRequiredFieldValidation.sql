SELECT
	TP.PartID, TP.PartSuffix, TP.Keyword, TP.ShortDescription,
	TP.ProductCategoryID, TP.PartClassificationID,
	-- WICM Fields
	ph.MFG_NUMBER, ph.PART_NO, ph.PART_CAT, ph.[STATUS],
	ph.RECTYPE, ph.PART_TYPE, ph.VENDOR_CD, ph.USAGE_CD,
	ph.UNIT_ISSUE, ph.PART_GROUP
FROM TransformPart TP
	INNER JOIN SourceWicm220PartsHeader ph ON TP.PartID = ph.PART_NO
WHERE
	(ISNULL(TP.PartSuffix, 99) = 99)
	OR (ISNULL(TP.Keyword, '') = '')
	OR (ISNULL(TP.ShortDescription, '') = '')
	OR (ISNULL(TP.ProductCategoryID, '') = '')
	OR (ISNULL(TP.PartClassificationID, '') = '')
ORDER BY TP.PartID
