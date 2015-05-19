SELECT 
	'2014' [Control], '57:2' [Equipment Class ID],
	'58:2' [Description], '58:4' [Class Type],
	'58:7' [Overhead Amount], '64:4' [Meter 1 Type],
	'64:5' [Meter 2 Type], '64:7' [Meter 1 Edit Range],
	'64:8' [Meter 2 Edit Range], '64:10' [Comeback Range (Days)],
	'64:12' [PM Soon Due (Days)], '64:14' [PM Fuel Quantity Override],
	'76:2' [PM Services in One Cycle], '76:4' [PM Quantity of Time Units],
	'76:5' [PM Time Unit], '58:9' [Value Depreciation ID],
	'2407:1' [Meter Types], '2407:3' [Maintenance],
	'2407:5' [PM Program], '2407:7' [Standards],
	'2407:9' [Rental Rates], '2407:11' [Resources]
UNION ALL
SELECT DISTINCT
	TEC.[Control], TEC.[EquipmentClassID],
	TEC.[Description], TEC.ClassType,
	CAST(TEC.OverheadAmount AS VARCHAR), TEC.Meter1Type,
	TEC.Meter2Type [Meter 2 Type], CAST(TEC.Meter1EditRange AS VARCHAR),
	CAST(TEC.Meter2EditRange AS VARCHAR), CAST(TEC.ComebackRange AS VARCHAR),
	CAST(TEC.PMSoonDue AS VARCHAR), CAST(TEC.PMFuelQuantityOverride AS VARCHAR),
	CAST(TEC.PMServicesInOneCycle AS VARCHAR), CAST(TEC.PMQuantityOfTimeUnits AS VARCHAR),
	TEC.PMTimeUnit, TEC.[ValueDepreciation ID],
	TEC.MeterTypes, TEC.Maintenance,
	TEC.[PM Program], TEC.Standards,
	TEC.RentalRates, TEC.Resources
FROM TargetEquipmentClass TEC

--
INSERT INTO TransformEquipmentClass
SELECT
	'[i]',
	LEFT(LTRIM(RTRIM(EquipmentClassID)), 30),
	LEFT(LTRIM(RTRIM([Description])), 30),
	LEFT(LTRIM(RTRIM(ClassType)), 2),
	OverheadAmount,
	LEFT(LTRIM(RTRIM(Meter1Type)), 10), LEFT(LTRIM(RTRIM(Meter2Type)), 10),
	Meter1EditRange, Meter2EditRange,
	ComebackRange, PMSoonDue,
	PMFuelQuantityOverride,
	PMServicesInOneCycle,
	PMQuantityOfTimeUnits,
	LEFT(LTRIM(RTRIM(PMTimeUnit)), 15), LEFT(LTRIM(RTRIM([ValueDepreciation ID])), 8),
	LEFT(LTRIM(RTRIM(MeterTypes)), 1), LEFT(LTRIM(RTRIM(Maintenance)), 1),
	LEFT(LTRIM(RTRIM([PM Program])), 1), LEFT(LTRIM(RTRIM(Standards)), 1),
	LEFT(LTRIM(RTRIM(RentalRates)), 1), LEFT(LTRIM(RTRIM(Resources)), 1),
	LEFT(LTRIM(RTRIM([Source])), 100), GETDATE()
FROM Staging_EquipmentClass
