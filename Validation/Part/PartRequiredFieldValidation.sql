WITH PartFails AS (
	SELECT
		TP.PartID, TP.PartSuffix, TP.Keyword, TP.ShortDescription,
		TP.ProductCategoryID, TP.PartClassificationID,
		-- WICM Fields
		ph.MFG_NUMBER,
		LTRIM(RTRIM(ph.PART_NO)) [PART_NO],
		ph.PART_CAT, ph.[STATUS],
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
),
XLS AS (
	SELECT
		PartNo, Keyword [XLS_Keyword], NewDescription [XLS_NewDescription], Cat [XLS_Cat], PartsClassID [XLS_PartsClassID], CurrentDescription [XLS_CurrentDescription],
		[Group] [XLS_Group], [U/I] [XLS_U/I], AW_StockStatus [XLS_AW_StockStatus], NewMfgNo [XLS_NewMfgNo],
		Bin1 [XLS_Bin1], Bin2 [XLS_Bin2], Bin3 [XLS_Bin3]
	FROM ShawnsXLS
)
SELECT PF.*, X.*
FROM PartFails PF
	LEFT JOIN XLS x ON LTRIM(RTRIM(PF.PartID)) = LTRIM(RTRIM(x.PartNo))
ORDER BY PF.PartID
