-- TransformPart
WITH Parts AS (
	SELECT
		'[i]' AS [Control], 
		CAST(PartID AS VARCHAR) [Part ID], 
		CAST(PartSuffix AS VARCHAR) [Part Suffix],
		Keyword [Keyword], 
		ShortDescription [Short Description], 
		CAST(ProductCategoryID AS VARCHAR) [Prod. Category],
		PartClassificationID [Part Classification], 
		Tire, 
		Core, 
		ControlledSubstance [Controlled Substance],
		ItemFabricatedWithoutCore, 
		PathAndFileName [Path and File Name],
		FileDescription [File Description], 
		LongDescription [Long Description],
		PurchasingDefaultAccountID, 
		Comments,
		CAST(MarkupPercentage AS VARCHAR) MarkupPercentage, 
		NoMarkupOnPart,
		CAST(MarkupCapAmount AS VARCHAR) MarkupCapAmount, 
		VRMSCode,
		ExcludeFromInvLists
	FROM TargetPart
)
SELECT * FROM Parts P
ORDER BY DATALENGTH(P.Comments) DESC

-- TransformPartLocation
SELECT
	'2085' [Control], '334:2' [Part ID], '334:5' [Part Suffix],
	'334:7' [Inventory Location], '335:14' [Unit of Measure],
	'[GROUPROW]' [Bins],
	'336:2' [Inventory Month], '336:4' [Stock Status],
	'337:2' [Manufacturer], '337:4' [Manufacturer Part #],
	'339:2' [Replen Method], '339:38' [Perform Min-Max Calculation],
	'339:14' [Min Available], '339:16' [Max Available],
	'339:8' [Safety Stock], '339:40' [DefaultReplenishmentGenerationType],
	'339:57' [SuppliedByLocationIfTransferRequest]
UNION ALL
SELECT
	'[i]', TPL.PartID, CAST(TPL.PartSuffix AS VARCHAR),
	TPL.InventoryLocation,
	TPL.UnitOfMeasure, TPL.Bins, TPL.InventoryMonth,
	TPL.StockStatus, TPL.Manufacturer, TPL.ManufacturerPartNo,
	TPL.ReplenishMethod, TPL.PerformMinMaxCalculation,
	CAST(TPL.MinAvailable AS VARCHAR), CAST(TPL.MaxAvailable AS VARCHAR),
	CAST(TPL.SafetyStock AS VARCHAR), TPL.DefaultReplenishmentGenerationType,
	TPL.SuppliedByLocationIfTransferRequest
FROM TargetPartLocation TPL

-- TransformPartLocationBin
SELECT
	'2085' [Control], '[KEY]' [Key], '335:37' [Bin ID],
	'335:39' [Primary Bin], '335:55' [New Bin]
UNION ALL
SELECT
	'[i]', TPLB.PartID, TPLB.BinID, TPLB.PrimaryBin, TPLB.NewBin
FROM TargetPartLocationBin TPLB

-- TransformPartAdjustment
SELECT
	'2091' [Control], '380:2' [Part ID], '380:5' [Part Suffix],
	'380:7' [Location ID], '381:2' [Action], '381:4' [Adjustment Type],
	'381:6' [Quantity], '381:8' [Unit Price]
UNION ALL
SELECT
	'[i]', TPA.PartID, CAST(TPA.PartSuffix AS VARCHAR),
	TPA.LocationID, TPA.[Action], TPA.AdjustmentType,
	CAST(TPA.Quantity AS VARCHAR),
	CAST(TPA.UnitPrice AS VARCHAR)
FROM
	TargetPartAdjustment TPA

-- TransformPartManufacturer
SELECT
	'2276' [Control], '7547:2' [Part Manufacturer ID],
	'7548:2' [Name], '7548:3' [Part Catalog],
	'7548:5' [Active]
UNION ALL
SELECT
	'[I]', ManufacturerID, ManufacturerName,
	PartCatalog, Active
FROM TargetPartManufacturer
