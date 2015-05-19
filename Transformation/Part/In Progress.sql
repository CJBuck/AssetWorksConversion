--
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
		[Comments] [varchar](600) NULL,
		[MarkupPercentage] [decimal](22, 1) NULL,
		[NoMarkupOnPart] [char](1) NULL,
		[MarkupCapAmount] [decimal](22, 2) NULL,
		[VRMSCode] [varchar](50) NULL
	)

	INSERT INTO #StagingParts
	SELECT
		LTRIM(RTRIM(PH.PART_NO)) [PartID],
		0 [PartSuffix],
		CASE
			WHEN LEN(LTRIM(RTRIM(PH.PART_NO))) = 3 THEN 'CHEMICAL'
			ELSE ''
		END [Keyword],
		CASE
			WHEN LEN(LTRIM(RTRIM(PH.PART_NO))) = 3 THEN LTRIM(RTRIM(PH.PART_DESC))
			ELSE ''
		END [ShortDescription],
		CASE
			WHEN LEN(LTRIM(RTRIM(PH.PART_NO))) = 3 THEN '7720'
			ELSE ''
		END [ProductCategoryID],
		CASE
			WHEN LEN(LTRIM(RTRIM(PH.PART_NO))) = 3 THEN 'ST'
			ELSE ''
		END [PartClassificationID],
		CASE
			WHEN PH.PART_CAT = '9560' THEN 'Y'
			ELSE 'N'
		END [Tire],
		'' [Core],		-- Open issue: coming from General Services
		'N' [ControlledSubstance],
		'N' [ItemFabricatedWithoutCore],
		'' [PathAndFileName],		-- Open issue
		'' [FileDescription],		-- Open issue
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
			ELSE ''
		END [VRMSCode]
	FROM SourceWicm220PartsHeader PH
	WHERE
		PH.[STATUS] = 'A'

	UPDATE #StagingParts
	SET
		Keyword =
			CASE
				WHEN LEN(SP.PartID) >= 4 THEN xls.Keyword
				ELSE SP.Keyword
			END,
		ShortDescription =
			CASE
				WHEN LEN(SP.PartID) >= 4 THEN xls.NewDescription
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
		
	-- Copy #StagingParts to TransformPart
	INSERT INTO TransformPart
	SELECT * FROM #StagingParts
		
	CREATE TABLE #StagingPartLocation(
		[PartID] [varchar](22) NOT NULL,
		[InventoryLocation] [varchar](10) NULL,
		[UnitOfMeasure] [varchar](10) NULL,
		[Bins] [varchar](16) NULL,
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
		LTRIM(RTRIM(PD.LOCATION)) [InventoryLocationID],
		'' [UnitOfMeasure],
		'[335:35;Bin;1:1]' [BinID],
		'APRIL' [InventoryMonth],
		CASE
			WHEN LEN(SP.PartID) = 3 THEN 'STOCKED'
			ELSE ''
		END [StockStatus],
		'' [Manufacturer],
		'' [ManufacturerPartNumber],
		'Min-Max' [ReplenishMethod],
		'' [PerformMinMaxCalculation],
		ISNULL(PD.LOW_LIM, 0) [MinAvailable],
		ISNULL(PD.HIGH_LIM, 0) [MaxAvailable],
		ISNULL(PD.CRITICAL_LIM, 0) [SafetyStock],	-- Open issue (missing from spec)
		'' [PreferredVendorID],
		'REQUISITION' [DefaultReplenishmentGenerationType],
		CASE
			WHEN LTRIM(RTRIM(PD.LOCATION)) <> '60' THEN 'STOREROOM'
			ELSE ''
		END [SuppliedByLocationIfTransferRequest],
		'' [Comments]
	FROM SourceWicm221PartsDetail PD
		INNER JOIN #StagingParts sp ON LTRIM(RTRIM(PD.PART_NO)) = sp.PartID
	
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
				WHEN LEN(SPL.PartID) >= 4 THEN LEFT(LTRIM(RTRIM(xls.StockStatusLocationID)), 30)
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
		INNER JOIN SourceWicm220PartsHeader ph ON SPL.PartID = ph.PART_NO
		INNER JOIN ShawnsXLS xls ON ph.PART_NO = xls.PartNo

	-- Cleanse Manaufacturer
	UPDATE #StagingPartLocation
	SET Manufacturer = tpml.TargetValue
	FROM #StagingPartLocation SPL
		INNER JOIN ShawnsXLS xls ON SPL.PartID = xls.PartNo
		INNER JOIN TransformPartManufacturerLookup tpml ON xls.NewMfg = tpml.SourceValue
	WHERE LEN(SPL.PartID) >= 4
		
	-- Copy #StagingParts to TransformPart
	INSERT INTO TransformPartLocation
	SELECT * FROM #StagingPartLocation
END

-- Clean up
IF OBJECT_ID('tempdb..#StagingParts') IS NOT NULL
	DROP TABLE #StagingParts
IF OBJECT_ID('tempdb..#StagingPartLocation') IS NOT NULL
	DROP TABLE #StagingPartLocation

select * from #StagingParts

select * from #StagingPartLocation
--WHERE PARTID = '301004010'
where ManufacturerPartNo IS NULL

SELECT *
FROM SourceWicm220PartsHeader PH
WHERE PH.[STATUS] = 'A'

select *
from TransformPartManufacturerLookup

select *
from ShawnsXLS xls
where xls.NewMfg not in (
	select SourceValue from TransformPartManufacturerLookup
	)

select PD.PART_NO, COUNT(PD.PART_NO) [Count]
from SourceWicm221PartsDetail PD
group by PD.PART_NO
order by COUNT(PD.PART_NO) desc

select PD.PART_NO, pd.LOCATION
from SourceWicm221PartsDetail PD
WHERE PD.PART_NO = '137001297'
ORDER BY PD.PART_NO, pd.LOCATION
