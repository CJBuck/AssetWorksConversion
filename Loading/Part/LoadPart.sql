-- TransformPart
WITH Parts AS (
	SELECT
		'2077' [Control], '302:2' [Part ID], '302:4' [Part Suffix], '303:2' [Keyword],
		'303:4' [Short Description], '303:6' [Prod. Category], '303:9' [Part Classification],
		'303:15' [Tire], '303:17' [Core], '303:19' [Controlled Substance], 
		'303:29' [ItemFabricatedWithoutCore], '303:26' [Path and File Name],
		'303:27' [File Description], '304:2' [Long Description],
		'304:35' [PurchasingDefaultAccountID], CAST('310:1' AS NTEXT) [Comments],
		'2449:2' [MarkupPercentage], '2449:3' [NoMarkupOnPart], '2449:6' [MarkupCapAmount],
		'303:12' [VRMS Code], '304:16' [ExcludeFromInvLists]
	UNION ALL
	SELECT
		'[i]', CAST(PartID AS VARCHAR), CAST(PartSuffix AS VARCHAR),
		Keyword, ShortDescription, CAST(ProductCategoryID AS VARCHAR),
		PartClassificationID, Tire, Core, [ControlledSubstance],
		ItemFabricatedWithoutCore, PathAndFileName,
		FileDescription, LongDescription,
		PurchasingDefaultAccountID, TP.Comments [Comments],
		CAST(MarkupPercentage AS VARCHAR), NoMarkupOnPart,
		CAST(MarkupCapAmount AS VARCHAR), VRMSCode,
		ExcludeFromInvLists
	FROM TargetPart TP
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
