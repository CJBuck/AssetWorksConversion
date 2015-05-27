SELECT
	'2014' [Control], '[KEY]' [Equipment Class ID],
	'64:17' [Meter Type], '64:18' [PM Meter Override],
	'64:19' [Soon Due Range]
UNION ALL
SELECT DISTINCT
	ECM.[Control], ECM.[EquipmentClassID],
	ECM.MeterType,
	ISNULL(CAST(ECM.PMMeterOverride AS VARCHAR), ''),
	ISNULL(CAST(ECM.SoonDueRange AS VARCHAR), '')
FROM TargetEquipmentClassMeter ECM
