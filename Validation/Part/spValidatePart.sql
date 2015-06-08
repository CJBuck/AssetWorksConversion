USE AssetWorksConversion
GO

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spValidatePart') IS NULL
	EXEC ('CREATE PROCEDURE dbo.spValidatePart AS SELECT 1')
GO

ALTER PROCEDURE dbo.spValidatePart
AS 
BEGIN
-- Summary table setup
----------------------------------------------------------------
IF OBJECT_ID('tempdb..#PartSetValidationSummary') IS NOT NULL
	DROP TABLE #PartSetValidationSummary

CREATE TABLE #PartSetValidationSummary
(
	Entity varchar(8000),
	StatusLine varchar(8000),
	RecordCount int
);

---------------------------------------------------------------
-- Part                                                      --
---------------------------------------------------------------

DECLARE @Part_SourceCount int;
DECLARE @Part_TransformCount int;
DECLARE @Part_TargetCount int;
DECLARE @Part_DropCount int;
DECLARE @Part_Validation1 int;
DECLARE @Part_Validation2 int;

SELECT @Part_SourceCount = COUNT(*) 
FROM dbo.SourceWicm220PartsHeader

SELECT @Part_TransformCount = COUNT(*) 
FROM dbo.TransformPart;

SELECT @Part_TargetCount = COUNT(*) 
FROM dbo.TargetPart;

--DropCount is set of all records failing at least one validation rule
SELECT @Part_DropCount = COUNT(*) 
FROM dbo.TransformPart tpl
LEFT JOIN Staging_KeywordLookup skl
	ON tpl.Keyword = skl.Keyword
WHERE skl.Keyword IS NULL
	OR ISNULL(PartClassificationID,'') NOT IN ('CS', 'FB', 'RR', 'ST','SW','WA','WC');

--Individial validation rules (note total of all validation rules will not equal drop count because one record can fail one or more validation rules)
SELECT @Part_Validation1 = COUNT(*) 
FROM dbo.TransformPart tpl
LEFT JOIN Staging_KeywordLookup skl
	ON tpl.Keyword = skl.Keyword
WHERE ISNULL(PartClassificationID,'') NOT IN ('CS', 'FB', 'RR', 'ST','SW','WA','WC');

SELECT @Part_Validation2 = COUNT(*) 
FROM dbo.TransformPart tpl
LEFT JOIN Staging_KeywordLookup skl
	ON tpl.Keyword = skl.Keyword
WHERE skl.Keyword IS NULL;

INSERT INTO #PartSetValidationSummary
VALUES
('Part', 'Total Source Records (SourceWicm220PartsHeader)', @Part_SourceCount),
('Part', 'Total Transform Records (TransformPart)', @Part_TransformCount),
('Part', 'Total Dropped Records (one or more errors)', @Part_DropCount),
('Part', 'Total Target Records (TargetPart)', @Part_TargetCount),
('Part', 'Validation: Missing, unknown, or bad PartClassificationID', @Part_Validation1),
('Part', 'Validation: Missing, unknown, or bad Keyword', @Part_Validation2),
('Part', 'Discrepency', @Part_SourceCount - (@Part_TargetCount + @Part_DropCount))

---------------------------------------------------------------
-- PartLocation                                              --
---------------------------------------------------------------
DECLARE @PartLocation_SourceCount1 int;
DECLARE @PartLocation_SourceCount2 int;
DECLARE @PartLocation_SourceCount3 int;
DECLARE @PartLocation_TransformCount int;
DECLARE @PartLocation_TargetCount int;
DECLARE @PartLocation_DropCount int;
DECLARE @PartLocation_Validation1 int;
DECLARE @PartLocation_Validation2 int;
DECLARE @PartLocation_Validation3 int;

--The extract source has detail records that have a part id which does not exist in header records.
--Per BA we are importing only the set (INNER JOIN) of entities which have a record in both PartsHeader and PartsDetail
SELECT @PartLocation_SourceCount1 = COUNT(*)
FROM dbo.SourceWicm220PartsHeader;

SELECT @PartLocation_SourceCount2 = COUNT(*)
FROM dbo.SourceWicm221PartsDetail;

SELECT @PartLocation_SourceCount3 = COUNT(*)
FROM dbo.SourceWicm220PartsHeader AS swph 
INNER JOIN  dbo.SourceWicm221PartsDetail AS swpd
	ON swph.PART_NO = swpd.PART_NO;

SELECT @PartLocation_TransformCount = COUNT(*) 
FROM dbo.TransformPartLocation;

SELECT @PartLocation_TargetCount = COUNT(*) 
FROM dbo.TargetPartLocation;

-- Individual validation rules (sum of individual rules does not equal drop count because one record can fail more than one rule)

-- Exclude locations identified per spec to be excluded (included=0)
SELECT @PartLocation_Validation1 = COUNT(*) 
FROM dbo.TransformPartLocation tpl
WHERE tpl.InventoryLocation IN (SELECT AW_InventoryLocation FROM TransformPartInventoryLocationLookup WHERE IncludeInLoad = 0);

-- Source 'LOCATION' is unknown, missing, or invalid.  InventoryLocation (scrubbed result) is null when no match is found
SELECT @PartLocation_Validation2 = COUNT(*) 
FROM dbo.TransformPartLocation tpl 
WHERE tpl.InventoryLocation IS NULL;

-- UnitOfMeasure is required field
SELECT @PartLocation_Validation3 = COUNT(*) 
FROM dbo.TransformPartLocation tpl 
WHERE tpl.UnitOfMeasure IS NULL;

-- Dropped is all records which fail at least one validation
SELECT @PartLocation_DropCount = COUNT(*) 
FROM dbo.TransformPartLocation tpl 
WHERE tpl.InventoryLocation IS NULL 
	OR tpl.UnitOfMeasure IS NULL
	OR tpl.InventoryLocation IN (SELECT AW_InventoryLocation FROM TransformPartInventoryLocationLookup WHERE IncludeInLoad = 0);

INSERT INTO #PartSetValidationSummary
VALUES
('PartLocation', 'Total Source Records (SourceWicm220PartsHeader)', @PartLocation_SourceCount1),
('PartLocation', 'Total Source Records (SourceWicm221PartsDetail)', @PartLocation_SourceCount2),
('PartLocation', 'Total Source Records (inner join)', @PartLocation_SourceCount3),
('PartLocation', 'Total Transform Records (TransformPartLocation)', @PartLocation_TransformCount),
('PartLocation', 'Total Dropped Records (one or more errors)', @PartLocation_DropCount),
('PartLocation', 'Total Target Records (TargetPartLocation)', @PartLocation_TargetCount),
('PartLocation', 'Validation: Location excluded from loading', @PartLocation_Validation1),
('PartLocation', 'Validation: Missing, unknown, or bad Location', @PartLocation_Validation2),
('PartLocation', 'Validation: Missing Unit of Measure', @PartLocation_Validation3),
('PartLocation', 'Discrepency', @PartLocation_SourceCount3 - (@PartLocation_TargetCount + @PartLocation_DropCount))

---------------------------------------------------------------
-- PartLocationBin                                           --
---------------------------------------------------------------
DECLARE @PartLocationBin_SourceCountNonStoreroom int;
DECLARE @PartLocationBin_SourceCountStoreroom int;
DECLARE @PartLocationBin_TransformCount int;
DECLARE @PartLocationBin_TargetCount int;
DECLARE @PartLocationBin_DropCount int;
DECLARE @PartLocationBin_Validation1 int;
DECLARE @PartLocationBin_Validation2 int;
DECLARE @PartLocationBin_Validation3 int;

SELECT @PartLocationBin_SourceCountStoreroom = COUNT(Bin1) + COUNT(Bin2) + COUNT(Bin3)
FROM dbo.ShawnsXLS AS sx -- Contains only storeroom bins (LOCATION 60)

SELECT @PartLocationBin_SourceCountNonStoreroom = COUNT(NULLIF(PL_LOC1,'')) + COUNT(NULLIF(PL_LOC2,'')) + COUNT(NULLIF(PL_LOC3,''))
FROM dbo.SourceWicm220PartsHeader AS swph 
INNER JOIN  dbo.SourceWicm221PartsDetail AS swpd
	ON swph.PART_NO = swpd.PART_NO
WHERE swpd.LOCATION != '60' -- everything but LOCATION 60 = "Storeroom"

SELECT @PartLocationBin_TransformCount = COUNT(*)
FROM dbo.TransformPartLocationBin

SELECT @PartLocationBin_TargetCount = COUNT(*)
FROM dbo.TargetPartLocationBin

SELECT @PartLocationBin_DropCount = COUNT(*)
FROM dbo.TransformPartLocationBin tplb 
LEFT JOIN dbo.TargetPartLocation tpl
	ON tplb.PartID = tpl.PartID
	AND tplb.LocationId = tpl.InventoryLocation
WHERE tpl.PartID IS NULL -- parent does not exist
	OR tplb.LocationId IS NULL -- invalid, missing, or unknown location
	OR tplb.LocationId IN (SELECT AW_InventoryLocation FROM TransformPartInventoryLocationLookup WHERE IncludeInLoad = 0); -- excluded location

-- Individual validation rules (sum of individual rules does not equal drop count because one record can fail more than one rule)

-- Exclude records where parent record does not exist
SELECT @PartLocationBin_Validation1 = COUNT(*) 
FROM dbo.TransformPartLocationBin tplb 
LEFT JOIN dbo.TargetPartLocation tpl
	ON tplb.PartID = tpl.PartID
	AND tplb.LocationId = tpl.InventoryLocation
WHERE tpl.PartID IS NULL

-- Exclude records where locations is identified per spec to be excluded (included=0)
SELECT @PartLocationBin_Validation2 = COUNT(*) 
FROM dbo.TransformPartLocationBin tplb
WHERE tplb.LocationId IN (SELECT AW_InventoryLocation FROM TransformPartInventoryLocationLookup WHERE IncludeInLoad = 0);

-- Exclude locations which do not exist in location scrub
SELECT @PartLocationBin_Validation3 = COUNT(*) 
FROM dbo.TransformPartLocationBin tplb 
WHERE tplb.LocationId IS NULL;

INSERT INTO #PartSetValidationSummary
VALUES
('PartLocationBin', 'Source Storeroom Records (shawnsxls)', @PartLocationBin_SourceCountStoreroom),
('PartLocationBin', 'Source Non-Storeroom Records (SourceWicm221PartsDetail)', @PartLocationBin_SourceCountNonStoreroom),
('PartLocationBin', 'Total Source Records', @PartLocationBin_SourceCountStoreroom + @PartLocationBin_SourceCountNonStoreroom),
('PartLocationBin', 'Total Transform Records (TransformPartLocationBin)', @PartLocationBin_TransformCount),
('PartLocationBin', 'Total Dropped Records (one or more errors)', @PartLocationBin_DropCount),
('PartLocationBin', 'Total Target Records (TargetPartLocationBin)', @PartLocationBin_TargetCount),
('PartLocationBin', 'Validation: Parent record does not exist (or was dropped)', @PartLocationBin_Validation1),
('PartLocationBin', 'Validation: Location excluded from loading', @PartLocationBin_Validation2),
('PartLocationBin', 'Validation: Missing, unknown, or bad Location', @PartLocationBin_Validation3),
('PartLocationBin', 'Discrepency', (@PartLocationBin_SourceCountStoreroom + @PartLocationBin_SourceCountNonStoreroom) - (@PartLocationBin_TargetCount + @PartLocationBin_DropCount))

-- PartAdjustment
---------------------------------------------------------------
DECLARE @PartAdjustment_SourceRawCount int;
DECLARE @PartAdjustment_SourceExcludeCount int;
DECLARE @PartAdjustment_TransformCount int;
DECLARE @PartAdjustment_TargetCount int;
DECLARE @PartAdjustment_DropCount int;
DECLARE @PartAdjustment_Validation1 int;
DECLARE @PartAdjustment_Validation2 int;
DECLARE @PartAdjustment_Validation3 int;

SELECT @PartAdjustment_SourceRawCount = COUNT(*)
FROM SourceWicm220PartsHeader PH
INNER JOIN SourceWicm221PartsDetail PD
	ON dbo.TRIM(PH.PART_NO) = dbo.TRIM(PD.PART_NO)

SELECT @PartAdjustment_SourceExcludeCount = COUNT(*)
FROM dbo.SourceWicm220PartsHeader AS swph
INNER JOIN dbo.SourceWicm221PartsDetail AS swpd
	ON swph.PART_NO = swpd.PART_NO
WHERE CAST(swpd.QTY_ONHAND AS numeric(18,3)) = 0

SELECT @PartAdjustment_TransformCount = COUNT(*)
FROM dbo.TransformPartAdjustment

SELECT @PartAdjustment_TargetCount = COUNT(*) 
FROM dbo.TargetPartAdjustment

SELECT @PartAdjustment_DropCount = COUNT(*)
FROM dbo.TransformPartAdjustment tpa
LEFT JOIN dbo.TargetPartLocation tpl
	ON tpa.PartID = tpl.PartID
	AND tpa.LocationId = tpl.InventoryLocation
WHERE tpl.PartID IS NULL		-- parent record does not exist
	OR tpa.LocationID IS NULL	-- location is invalid
	OR tpa.LocationId IN (SELECT AW_InventoryLocation FROM TransformPartInventoryLocationLookup WHERE IncludeInLoad = 0); -- explicitly excluded

-- Individual validation rules (sum of individual rules does not equal drop count because one record can fail more than one rule)

-- parent record does not exist
SELECT @PartAdjustment_Validation1 = COUNT(*) 
FROM dbo.TransformPartAdjustment tpa 
LEFT JOIN dbo.TargetPartLocation tpl
	ON tpa.PartID = tpl.PartID
	AND tpa.LocationId = tpl.InventoryLocation	
WHERE tpl.PartID IS NULL	

-- Invalid location
SELECT @PartAdjustment_Validation2 = COUNT(*) 
FROM dbo.TargetPartAdjustment tpa 
WHERE tpa.LocationID IS NULL

-- locations explicitly excluded (included=0)
SELECT @PartAdjustment_Validation3 = COUNT(*) 
FROM dbo.TransformPartAdjustment tpa
WHERE tpa.LocationId IN (SELECT AW_InventoryLocation FROM TransformPartInventoryLocationLookup WHERE IncludeInLoad = 0);

INSERT INTO #PartSetValidationSummary
VALUES
('PartAdjustment', 'Raw Source Records (SourceWicm221PartsDetail)', @PartAdjustment_SourceRawCount),
('PartAdjustment', 'Source Exclusion Criteria: Quantity is zero', @PartAdjustment_SourceExcludeCount),
('PartAdjustment', 'Net Source Records (SourceWicm221PartsDetail QTY_ONHAND > 0', @PartAdjustment_SourceRawCount - @PartAdjustment_SourceExcludeCount),
('PartAdjustment', 'Total Transform Records (TransformPartAdjustment)', @PartAdjustment_TransformCount),
('PartAdjustment', 'Total Dropped Records (one or more errors)', @PartAdjustment_DropCount),
('PartAdjustment', 'Total Target Records (TargetPartAdjustment)', @PartAdjustment_TargetCount),
('PartAdjustment', 'Validation: Parent record does not exist (or was dropped)', @PartAdjustment_Validation1),
('PartAdjustment', 'Validation: Location excluded from loading', @PartLocationBin_Validation2),
('PartAdjustment', 'Validation: Missing, unknown, or bad Location', @PartAdjustment_Validation3),
('PartAdjustment', 'Discrepency', @PartAdjustment_SourceRawCount - @PartAdjustment_SourceExcludeCount - (@PartAdjustment_TargetCount + @PartAdjustment_DropCount))

-- Display results and cleanup
---------------------------------------------------------------
SELECT * FROM #PartSetValidationSummary
DROP TABLE #PartSetValidationSummary

END