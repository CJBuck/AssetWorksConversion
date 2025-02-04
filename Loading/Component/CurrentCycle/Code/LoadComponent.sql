SELECT
	'2180' [Control],
	'2508:2' [AssetID], '2507:13' [Description],
	'2507:2' [ModelYear], '2507:4' [ManufacturerID], '2507:7' [ModelID],
	'2507:10' [EquipmentType],	'2507:15' [SerialNumber],
	'2507:17' [PMProgramType], '2507:27' [Asset Number],
	'2509:2' MeterTypesClass, '2509:6' [Meter1Type],
	'2509:8' [Meter1AtDelivery], '2509:10' [Latest Meter 1 Reading], '2509:14' [MaxMeter1Value],
	'2509:32' [Meter2Type], '2509:33' [Meter2AtDelivery],
	'2509:36' [MaxMeter2AtDelivery], '2510:3' [Maintenance],
	'2510:6' [PMClass], '2510:9' [Standards],
	'2510:12' [RentalRates], '2510:15' [Resources],
	'2510:18' [AssetCategoryID], '2511:2' [StoredLocation],
	'2511:8' [Assigned PM], '2511:11' [PreferredPMShift],
	'2511:13' [Assigned Repair], '2511:16' [StationLocation],
	'2512:7' [DepartmentID], '2512:10' [DepartmentForPM],
	'2527:2' [AccountIDWO], '2527:17' [AccountIDLabor],
	'2527:20' [AccountIDPart], '2527:23' [AccountIDCommercial],
	'2527:26' [AccountIDFuel], '2527:29' [AccountIDUsage],
	'2528:10' [LifeCycleStatusCodeID], '2528:21' [ConditionRating],
	'2529:1' [WorkOrders], '2529:3' [UsageTickets],
	'2529:5' [FuelTickets], '2529:8' [FuelCardID],
	'2531:2' [NextPMServiceNumber], '2531:7' [NextPMDueDate],
	'2532:10' [DefaultWOPriorityID], '2335:5' [ActualDeliveryDate],
	'2535:8' [ActualInServiceDate], '2535:10' [OriginalCost],
	'2536:2' [Depreciation Method], '2536:5' [Life Months],
	'2536:15' [Ownership]
UNION ALL
SELECT
	[Control],
	AssetID, [Description],
	ISNULL(CAST(ModelYear AS VARCHAR), '') [ModelYear],
	ManufacturerID,
	ModelID, EquipmentType,
	SerialNumber, PMProgramType, AssetNumber,
	MeterTypesClass, Meter1Type,
	CAST(Meter1AtDelivery AS VARCHAR), CAST(LatestMeter1Reading AS VARCHAR),
	CAST(MaxMeter1Value AS VARCHAR), Meter2Type,
	CAST(Meter2AtDelivery AS VARCHAR), CAST(MaxMeter2Value AS VARCHAR),
	Maintenance, PMClass, Standards, RentalRates, Resources, AssetCategoryID,
	StoredLocation, AssignedPM, PreferredPMShift, AssignedRepair,
	StationLocation, DepartmentID, DepartmentForPM, AccountIDWO,
	AccountIDLabor, AccountIDPart, AccountIDCommercial, AccountIDFuel,
	AccountIDUsage, LifeCycleStatusCodeID, ConditionRating,
	WorkOrders, UsageTickets, FuelTickets, FuelCardID,
	ISNULL(CAST(NextPMServiceNumber AS VARCHAR), ''),
	ISNULL((CONVERT(VARCHAR(10), CAST(NextPMDueDate AS DATE), 101)), ''),
	DefaultWOPriorityID,
	ISNULL((CONVERT(VARCHAR(10), CAST(ActualDeliveryDate AS DATE), 101)), ''),
	ISNULL((CONVERT(VARCHAR(10), CAST(ActualInServiceDate AS DATE), 101)), ''),
	ISNULL(CAST(OriginalCost AS VARCHAR), '') [OriginalCost],
	DepreciationMethod, CAST(LifeMonths AS VARCHAR),
	[Ownership]
FROM TransformComponent
