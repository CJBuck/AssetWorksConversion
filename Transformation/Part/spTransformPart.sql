-- =================================================================================================
-- Created By:	Chris Buck
-- Create Date:	01/30/2015
-- Breaking Updates:  
--		05/22/2015 (Gerald Davis) - Added LocationId to TransformPartLocationBin all values set to 'STOREROOM'.
--								  - Added truncation of loading tables to ensure procedure is idempotent
--		06/01/2015 (Gerald Davis) - Remapped obsolete ProductCategoryIds(7536 -> 7530, 7542 -> 7541)
-- 
-- Description: Creates/modifies the spTransformPart stored procedure.  Populates
--		the TransformPart, TransformPartAdjustment, TransformPartLocation, and
--		TransformPartLocationBin tables.
-- =================================================================================================

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spTransformPart') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformPart AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformPart
AS
BEGIN
-- =================================================================================================
-- Build dbo.TransformPart
-- =================================================================================================
	IF OBJECT_ID('tempdb..#StagingParts') IS NOT NULL
		DROP TABLE #StagingParts

	CREATE TABLE #StagingParts(
		PartID varchar(22) NOT NULL,
		PartSuffix int NULL,
		Keyword varchar(15) NULL,
		ShortDescription varchar(120) NULL,
		ProductCategoryID varchar(20) NULL,
		PartClassificationID varchar(2) NULL,
		Tire char(1) NULL,
		Core char(1) NULL,
		ControlledSubstance char(1) NULL,
		ItemFabricatedWithoutCore char(1) NULL,
		PathAndFileName varchar(255) NULL,
		FileDescription varchar(60) NULL,
		LongDescription varchar(240) NULL,
		PurchasingDefaultAccountID varchar(30) NULL,
		Comments varchar(600) NULL,
		MarkupPercentage decimal(22, 1) NULL, -- check w/ S. (spec says integer)
		NoMarkupOnPart char(1) NULL,
		MarkupCapAmount decimal(22, 2) NULL, -- check w/ S. (spec says integer)
		VRMSCode varchar(20) NULL,
		ExcludeFromInvLists char (1) NULL
	)

	--load common values first
	INSERT INTO #StagingParts
	(
		PartId,
		PartSuffix,
		Tire,
		ControlledSubstance,
		ItemFabricatedWithoutCore,
		PurchasingDefaultAccountID,
		Comments,
		MarkupPercentage,
		NoMarkupOnPart,
		MarkupCapAmount,
		ExcludeFromInvLists
	)
	SELECT
		dbo.Trim(PH.PART_NO) AS PartID,
		0 AS PartSuffix,
		CASE WHEN PH.PART_CAT = '9560' THEN 'Y' ELSE 'N' END AS Tire,
		'N' ControlledSubstance,
		'N' ItemFabricatedWithoutCore,
		'6000-0000-145300-000000-00000' AS PurchasingDefaultAccountID,
		dbo.GroupConcatComments(LTRIM(RTRIM(PH.PART_NO))) AS Comments,
		000.0 AS MarkupPercentage,
		'Y' AS NoMarkupOnPart,
		000.0 AS MarkupCapAmount,
		CASE WHEN PH.PART_CAT = '7950' THEN 'Y' END AS ExcludeFromInvLists
	FROM SourceWicm220PartsHeader PH

	-- Update chemical parts (not included in Shawns XLS)
	UPDATE sp
	SET
		Keyword = 'CHEMICAL',
		ShortDescription = dbo.TRIM(swph.PART_DESC),
		ProductCategoryID = '7720',
		PartClassificationID = 'ST',
		LongDescription = dbo.TRIM(swph.PART_DESC),
		VRMSCode = dbo.TRIM(swph.PART_GROUP)		
	FROM #StagingParts sp
	INNER JOIN dbo.SourceWicm220PartsHeader swph
		ON sp.PartId = dbo.TRIM(swph.PART_NO)
	WHERE LEN (sp.PartId) = 3

	-- Updates from Shawns XLS (for non chemical parts).
	UPDATE sp
 	SET
		Keyword = xls.Keyword,
		ShortDescription = xls.NewDescription,
		ProductCategoryID = xls.Cat,
		PartClassificationID = xls.PartsClassID,
		LongDescription = xls.CurrentDescription,
		VRMSCode = xls.[Group]
	FROM #StagingParts sp
	INNER JOIN ShawnsXLS xls 
		ON sp.PartID = xls.PartNo
	WHERE LEN(sp.PartId) > 3  -- Check w/ S.  There is a single part w/ 3 digit Part
	
	-- Remap obsolete ProductCategoryID (see email 06/01/2015 "FW: Product Category 7536 and 7542")
	UPDATE #StagingParts
	SET ProductCategoryID = CASE ProductCategoryId WHEN 7536 THEN 7530
								 WHEN 7542 THEN 7541
								 ELSE ProductCategoryID
						    END

	-- Update PartClassificationId for parts with fractional quantities (per spec update v2.0.9)
	UPDATE #StagingParts
	SET PartClassificationId = 'FS'
	WHERE PartId IN 
	(
		SELECT DISTINCT dbo.Trim(part_no)
		FROM sourcewicm221partsdetail
		WHERE QTY_ONHAND not like '%.000'
	)
		
	-- Copy #StagingParts to TransformPart
	TRUNCATE TABLE TransformPart;
	INSERT INTO TransformPart
	SELECT * FROM #StagingParts

-- =================================================================================================
-- Build dbo.TransformPartLocation
-- =================================================================================================
IF OBJECT_ID('tempdb..#StagingPartLocation') IS NOT NULL
	DROP TABLE #StagingPartLocation
		
	CREATE TABLE #StagingPartLocation
	(
		[PartID] [varchar](22) NOT NULL,
		[PartSuffix] [int] NOT NULL,
		[InventoryLocation] [varchar](10) NULL,
		[UnitOfMeasure] [varchar](10) NULL,
		[Bins] [varchar](255) NULL,
		[InventoryMonth] [varchar](50) NULL,
		[StockStatus] [varchar](30) NULL,
		[Manufacturer] [varchar](15) NULL,
		[ManufacturerPartNo] [varchar](22) NULL,
		[ReplenishMethod] [varchar](10) NULL,
		[PerformMinMaxCalculation] [char](1) NULL,
		[MinAvailable] [decimal](22, 2) NULL,
		[MaxAvailable] [decimal](22, 2) NULL,
		[SafetyStock] [decimal](22, 2) NULL,
		[PreferredVendorID] [varchar](15) NULL,
		[DefaultReplenishmentGenerationType] [varchar](20) NULL,
		[SuppliedByLocationIfTransferRequest] [varchar](10) NULL,
		[Comments] [varchar](600) NULL
	)
	
	INSERT INTO #StagingPartLocation
	(
		PartID,
		PartSuffix,
		InventoryLocation,
		Bins,
		InventoryMonth,
		ReplenishMethod,
		PerformMinMaxCalculation,
		MinAvailable,
		MaxAvailable,
		SafetyStock,
		DefaultReplenishmentGenerationType,
		SuppliedByLocationIfTransferRequest
	)
	SELECT
		tp.PartID [PartID],
		0 [PartSuffix],
		invLook.AW_InventoryLocation AS InventoryLocationID,
		'[335:35;Bin;1-3:1-2]' [BinID],
		'APRIL' [InventoryMonth],
		'Min-Max' [ReplenishMethod],
		'' AS [PerformMinMaxCalculation],
		ISNULL(pd.LOW_LIM, 0) [MinAvailable],
		ISNULL(pd.HIGH_LIM, 0) [MaxAvailable],
		ISNULL(pd.CRITICAL_LIM, 0) [SafetyStock],	-- Open issue (missing from tpec)
		'REQUISITION' [DefaultReplenishmentGenerationType],
		CASE WHEN LTRIM(RTRIM(pd.LOCATION)) <> '60' THEN 'STOREROOM' ELSE NULL END AS [SuppliedByLocationIfTransferRequest]
	FROM SourceWicm221PartsDetail pd
	INNER JOIN dbo.TransformPart tp 
		ON pd.PART_NO = tp.PartID
	LEFT JOIN dbo.TransformPartInventoryLocationLookup AS invlook
		ON pd.LOCATION = invlook.WICM_Location
	--WHERE ISNULL(invlook.IncludeInLoad, 1) = 1 --moved to spLoadPart to keep exclusion consistent (all records in Transform, exclude in Transform->Target)
	
	-- Set UnitOfMeasure, StockStatus, Manufacturer, ManufacturerPartNo for Chemicals
	UPDATE #StagingPartLocation
	SET
		UnitOfMeasure = LEFT(dbo.TRIM(ph.UNIT_ISSUE), 10),
		StockStatus = 'STOCKED',
		Manufacturer = tpml.TargetValue,		
		ManufacturerPartNo = LEFT(dbo.TRIM(ph.MFG_NUMBER), 22)
	FROM #StagingPartLocation spl
	INNER JOIN SourceWicm220PartsHeader ph 
		ON spl.PartID = ph.PART_NO
	LEFT JOIN TransformPartManufacturerLookup tpml 
		ON dbo.TRIM(ph.[CATALOG]) = tpml.SourceValue
	WHERE LEN(spl.PartId) = 3

	-- Set UnitOfMeasure, StockStatus, Manufacturer, ManufacturerPartNo for non Chemicals (using Shawns XLS)
	UPDATE #StagingPartLocation
	SET
		UnitOfMeasure = LEFT(dbo.TRIM(xls.[U/I]), 10),
		StockStatus = UPPER(dbo.TRIM(xls.AW_StockStatus)),
		Manufacturer = tpml.TargetValue,		
		ManufacturerPartNo = LEFT(dbo.TRIM(xls.NewMfgNo), 22)
	FROM #StagingPartLocation spl
	INNER JOIN ShawnsXLS xls 
		ON spl.PartId = xls.PartNo
	LEFT JOIN TransformPartManufacturerLookup tpml 
		ON xls.NewMfg = tpml.SourceValue
	WHERE LEN(spl.PartId) > 3

	-- Copy #StagingPartsLocation to TransformPartLocation
	TRUNCATE TABLE TransformPartLocation;
	INSERT INTO dbo.TransformPartLocation
	SELECT *
	FROM #StagingPartLocation AS spl;

-- =================================================================================================
-- Build dbo.TransformPartLocationBin
-- =================================================================================================

	-- Part Location Bin
	TRUNCATE TABLE TransformPartLocationBin;

	--Insert Loc60 ('STOREROOM') Bins into TransformPartLocationBin
	WITH BinsPivot AS (
		SELECT
			LTRIM(RTRIM(xls.[PartNo])) [PartID],
			'STOREROOM' [LocationId], --As of 05/22/2015 all defined bins are @ storeroom location
			xls.[Bin1] [BinID],
			'Y' [PrimaryBin],
			'N' [NewBin]
		FROM ShawnsXLS xls
		WHERE ISNULL(xls.[Bin1], '') <> ''
		UNION ALL
		SELECT
			LTRIM(RTRIM(xls.[PartNo])),
			'STOREROOM' [LocationId],
			xls.[Bin2] [BinID],
			'N' [PrimaryBin],
			'N' [NewBin]
		FROM ShawnsXLS xls
		WHERE ISNULL(xls.[Bin2], '') <> ''
		UNION ALL
		SELECT
			LTRIM(RTRIM(xls.[PartNo])) [PartID],
			'STOREROOM' [LocationId],
			xls.[Bin3] [BinID],
			'N' [PrimaryBin],
			'N' [NewBin]
		FROM ShawnsXLS xls
		WHERE ISNULL(xls.[Bin3], '') <> ''
	)
	INSERT INTO TransformPartLocationBin
	SELECT *
	FROM BinsPivot
	ORDER BY PartID

	--Insert non60Bins into TransformPartLocationBin
	INSERT INTO TransformPartLocationBin
	SELECT
		non60Parts.PART_NO AS PartId,
		ISNULL(invLook.AW_InventoryLocation,'') AS LocationId,
		non60Parts.PL_LOC AS BinId,
		non60Parts.PrimaryBin AS PrimaryBin,
		'N' AS NewBin
	FROM
	(
		SELECT pd.PART_NO, pd.LOCATION , PL_LOC1 AS PL_LOC, 'Y' AS PrimaryBin
		FROM dbo.SourceWicm220PartsHeader ph
		INNER JOIN dbo.SourceWicm221PartsDetail pd
			ON ph.PART_No = pd.PART_NO
		WHERE PL_LOC1 IS NOT NULL AND PL_LOC1 != '' AND pd.LOCATION != '60'

		UNION ALL

		SELECT pd.PART_NO, pd.LOCATION , PL_LOC2 AS PL_LOC, 'N' AS PrimaryBin
		FROM dbo.SourceWicm220PartsHeader ph
		INNER JOIN dbo.SourceWicm221PartsDetail pd
			ON ph.PART_No = pd.PART_NO
		WHERE PL_LOC2 IS NOT NULL AND PL_LOC2 != '' AND pd.LOCATION != '60'

		UNION ALL

		SELECT pd.PART_NO, pd.LOCATION , PL_LOC3 AS PL_LOC, 'N' AS PrimaryBin
		FROM dbo.SourceWicm220PartsHeader ph
		INNER JOIN dbo.SourceWicm221PartsDetail pd
			ON ph.PART_No = pd.PART_NO
		WHERE PL_LOC3 IS NOT NULL AND PL_LOC3 != '' AND pd.LOCATION != '60'
	)
	AS non60Parts
	LEFT JOIN dbo.TransformPartInventoryLocationLookup invLook
		ON non60Parts.LOCATION = invLook.WICM_Location
	--WHERE ISNULL(invLook.IncludeInLoad,1) = 1 --moved to spLoadPart to keep exclusion consistent (all records in Transform, exclude in Transform->Target)

	-- Part Adjustment
	TRUNCATE TABLE TransformPartAdjustment;
	INSERT INTO TransformPartAdjustment
	SELECT
		LTRIM(RTRIM(PH.PART_NO)) AS [PartID],
		ISNULL(invLook.AW_InventoryLocation,'') [LocationID],
		0 [PartSuffix],
		'ADD' [Action],
		'QTY AT A DIFFERENT PRICE' [Adjustment Type],
		PD.QTY_ONHAND [Quantity],
		PH.PART_COST [UnitPrice]
	FROM SourceWicm220PartsHeader PH
	INNER JOIN SourceWicm221PartsDetail PD
		ON dbo.TRIM(PH.PART_NO) = dbo.TRIM(PD.PART_NO)
	LEFT JOIN TransformPartInventoryLocationLookup invLook
		ON PD.LOCATION = invLook.WICM_Location
	WHERE CAST(PD.QTY_ONHAND AS NUMERIC(18,3)) > 0 
	--AND ISNULL(invLook.IncludeInLoad,1) = 1 --moved to spLoadPart to keep exclusion consistent (all records in Transform, exclude in Transform->Target)
END
