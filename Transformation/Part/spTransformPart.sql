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
	CREATE TABLE #StagingParts(
		[PartID] [varchar](22) NOT NULL,
		[PartSuffix] [int] NULL,
		[Keyword] [varchar](15) NULL,
		[ShortDescription] [varchar](120) NULL,
		[ProductCategoryID] [varchar](20) NULL,
		[PartClassificationID] [varchar](2) NULL,
		[Tire] [char](1) NULL,
		[Core] [char](1) NULL,
		[ControlledSubstance] [char](1) NULL,
		[ItemFabricatedWithoutCore] [char](1) NULL,
		[PathAndFileName] [varchar](255) NULL,
		[FileDescription] [varchar](60) NULL,
		[LongDescription] [varchar](240) NULL,
		[PurchasingDefaultAccountID] [varchar](30) NULL,
		[Comments] [varchar](8000) NULL,
		[MarkupPercentage] [decimal](22, 1) NULL,
		[NoMarkupOnPart] [char](1) NULL,
		[MarkupCapAmount] [decimal](22, 2) NULL,
		[VRMSCode] [varchar](20) NULL,
		[ExcludeFromInvLists] [char] (1) NULL
	)

	INSERT INTO #StagingParts
	SELECT
		LTRIM(RTRIM(PH.PART_NO)) [PartID],
		0 [PartSuffix],
		CASE
			WHEN LEN(LTRIM(RTRIM(PH.PART_NO))) = 3 THEN 'CHEMICAL'
			ELSE NULL
		END [Keyword],
		CASE
			WHEN LEN(LTRIM(RTRIM(PH.PART_NO))) = 3 THEN LTRIM(RTRIM(PH.PART_DESC))
			WHEN LTRIM(RTRIM(PH.PART_NO)) = '031236' THEN 'GASKET'
			ELSE NULL
		END [ShortDescription],
		CASE
			WHEN LEN(LTRIM(RTRIM(PH.PART_NO))) = 3 THEN '7720'
			ELSE NULL
		END [ProductCategoryID],
		CASE
			WHEN LEN(LTRIM(RTRIM(PH.PART_NO))) = 3 THEN 'ST'
			ELSE NULL
		END [PartClassificationID],
		CASE
			WHEN PH.PART_CAT = '9560' THEN 'Y'
			ELSE 'N'
		END [Tire],
		NULL [Core],		-- Open issue: coming from General Services
		'N' [ControlledSubstance],
		'N' [ItemFabricatedWithoutCore],
		NULL [PathAndFileName],		-- Open issue
		NULL [FileDescription],		-- Open issue
		CASE
			WHEN LEN(LTRIM(RTRIM(PH.PART_NO))) = 3 THEN LTRIM(RTRIM(PH.PART_DESC))
			ELSE ''
		END [LongDescription],
		'6000-0000-145300-000000-00000' [PurchasingDefaultAccountID],
		dbo.GroupConcatComments(LTRIM(RTRIM(PH.[PART_NO]))) [Comments],
		000.0 [MarkupPercentage],
		'Y' [NoMarkupOnPart],
		000.0 [MarkupCapAmount],
		CASE
			WHEN LEN(LTRIM(RTRIM(PH.PART_NO))) = 3 THEN LTRIM(RTRIM(PH.PART_GROUP))
			ELSE NULL
		END [VRMSCode],
		CASE
			WHEN PH.PART_CAT = '7950' THEN 'Y'
		END  [ExcludeFromInvLists]
	FROM SourceWicm220PartsHeader PH

	-- Updates from Shawns XLS.
	UPDATE #StagingParts
	SET
		Keyword =
			CASE
				WHEN LEN(SP.PartID) >= 4 THEN xls.Keyword
				ELSE SP.Keyword
			END,
		ShortDescription =
			CASE
				WHEN ((LEN(SP.PartID) >= 4) AND (SP.PartID <> '031236')) THEN xls.NewDescription
				ELSE SP.ShortDescription
			END,
		ProductCategoryID =
			CASE
				WHEN LEN(SP.PartID) >= 4 THEN xls.Cat
				ELSE SP.ProductCategoryID
			END,
		PartClassificationID =
			CASE
				WHEN LEN(SP.PartID) >= 4 THEN xls.PartsClassID
				ELSE SP.PartClassificationID
			END,
		LongDescription =
			CASE
				WHEN LEN(SP.PartID) >= 4 THEN xls.CurrentDescription
				ELSE SP.LongDescription
			END,
		VRMSCode =
			CASE
				WHEN LEN(SP.PartID) >= 4 THEN xls.[Group]
				ELSE SP.VRMSCode
			END
	FROM #StagingParts SP
		INNER JOIN ShawnsXLS xls ON SP.PartID = xls.PartNo
	
	-- Remap obsolete ProductCategoryID (see email 06/01/2015 "FW: Product Category 7536 and 7542")
	UPDATE #StagingParts
	SET ProductCategoryID = CASE ProductCategoryId WHEN 7536 THEN 7530
								 WHEN 7542 THEN 7541
								 ELSE ProductCategoryID
						    END
		
	-- Copy #StagingParts to TransformPart
	TRUNCATE TABLE TransformPart;
	INSERT INTO TransformPart
	SELECT * FROM #StagingParts
		
	CREATE TABLE #StagingPartLocation(
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
	SELECT
		SP.PartID [PartID],
		0 [PartSuffix],
		invLook.AW_InventoryLocation AS InventoryLocationID,
		NULL AS [UnitOfMeasure],
		'[335:35;Bin;1-2:1-2]' [BinID],
		'APRIL' [InventoryMonth],
		CASE
			WHEN LEN(SP.PartID) = 3 THEN 'STOCKED'
			ELSE ''
		END [StockStatus],
		NULL AS [Manufacturer],
		NULL AS [ManufacturerPartNumber],
		'Min-Max' [ReplenishMethod],
		'' AS [PerformMinMaxCalculation],
		ISNULL(PD.LOW_LIM, 0) [MinAvailable],
		ISNULL(PD.HIGH_LIM, 0) [MaxAvailable],
		ISNULL(PD.CRITICAL_LIM, 0) [SafetyStock],	-- Open issue (missing from spec)
		NULL AS [PreferredVendorID],
		'REQUISITION' [DefaultReplenishmentGenerationType],
		CASE
			WHEN LTRIM(RTRIM(PD.LOCATION)) <> '60' THEN 'STOREROOM'
			ELSE NULL
		END [SuppliedByLocationIfTransferRequest],
		NULL AS [Comments]
	FROM SourceWicm221PartsDetail PD
	INNER JOIN #StagingParts sp 
		ON dbo.TRIM(PD.PART_NO) = sp.PartID
	LEFT JOIN TransformPartInventoryLocationLookup invLook
		ON PD.LOCATION = invLook.WICM_Location
	WHERE ISNULL(invLook.IncludeInLoad,1) = 1 --temporary measure to handle undefined locations

	-- *************************************************************************

	-- UnitOfMeasure, StockStatus, Manufacturer, ManufacturerPartNo
	UPDATE #StagingPartLocation
	SET
		UnitOfMeasure =
			CASE
				WHEN LEN(SPL.PartID) = 3 THEN LEFT(LTRIM(RTRIM(ph.UNIT_ISSUE)), 10)
				ELSE LEFT(LTRIM(RTRIM(xls.[U/I])), 10)
			END,
		StockStatus =
			CASE
				WHEN LEN(SPL.PartID) >= 4 
					THEN LEFT(LTRIM(RTRIM(UPPER(xls.AW_StockStatus))), 30)
				ELSE SPL.StockStatus
			END,
		Manufacturer =			
			CASE
				WHEN LEN(SPL.PartID) = 3 THEN LEFT(LTRIM(RTRIM(ph.[CATALOG])), 15)
				ELSE ''
			END,
		ManufacturerPartNo =
			CASE
				WHEN LEN(SPL.PartID) = 3 THEN LEFT(LTRIM(RTRIM(ph.MFG_NUMBER)), 22)
				ELSE ISNULL(LEFT(LTRIM(RTRIM(xls.NewMfgNo)), 22), '')
			END
	FROM #StagingPartLocation SPL
	INNER JOIN SourceWicm220PartsHeader ph 
		ON SPL.PartID = ph.PART_NO
	LEFT JOIN ShawnsXLS xls 
		ON ph.PART_NO = xls.PartNo

	-- Cleanse Manaufacturer
	UPDATE #StagingPartLocation
	SET Manufacturer = tpml.TargetValue
	FROM #StagingPartLocation SPL
	LEFT JOIN ShawnsXLS xls 
			ON SPL.PartID = xls.PartNo
	INNER JOIN TransformPartManufacturerLookup tpml 
		ON xls.NewMfg = tpml.SourceValue
	WHERE LEN(SPL.PartID) >= 4
		
	-- Copy #StagingPartsLocation to TransformPartLocation
	TRUNCATE TABLE TransformPartLocation;
	INSERT INTO TransformPartLocation
	SELECT * FROM #StagingPartLocation;

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
	WHERE PartID IN (SELECT PartID FROM TransformPartLocation)
	ORDER BY PartID

	--Insert non60Bins into TransformPartLocationBin
	INSERT INTO [dbo].[TransformPartLocationBin]
	(
		PartID,
		LocationId,
		BinID,
		PrimaryBin,
		NewBin
	)
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

		UNION 

		SELECT pd.PART_NO, pd.LOCATION , PL_LOC2 AS PL_LOC, 'N' AS PrimaryBin
		FROM dbo.SourceWicm220PartsHeader ph
		INNER JOIN dbo.SourceWicm221PartsDetail pd
		ON ph.PART_No = pd.PART_NO
		WHERE PL_LOC2 IS NOT NULL AND PL_LOC2 != '' AND pd.LOCATION != '60'

		UNION 

		SELECT pd.PART_NO, pd.LOCATION , PL_LOC3 AS PL_LOC, 'N' AS PrimaryBin
		FROM dbo.SourceWicm220PartsHeader ph
		INNER JOIN dbo.SourceWicm221PartsDetail pd
		ON ph.PART_No = pd.PART_NO
		WHERE PL_LOC3 IS NOT NULL AND PL_LOC3 != '' AND pd.LOCATION != '60'
	)
	AS non60Parts
	LEFT JOIN dbo.TransformPartInventoryLocationLookup invLook
		ON non60Parts.LOCATION = invLook.WICM_Location
	WHERE ISNULL(invLook.IncludeInLoad,1) = 1

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
	WHERE dbo.TRIM(PH.PART_NO) IN (SELECT PartID FROM TransformPart)
	AND CAST(PD.QTY_ONHAND AS NUMERIC(18,3)) > 0 
	AND ISNULL(invLook.IncludeInLoad,1) = 1 --temporary measure to handle undefined locations
END

-- Clean up
IF OBJECT_ID('tempdb..#StagingParts') IS NOT NULL
	DROP TABLE #StagingParts
IF OBJECT_ID('tempdb..#StagingPartLocation') IS NOT NULL
	DROP TABLE #StagingPartLocation
