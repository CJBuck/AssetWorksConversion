SELECT
	'2014' [Control], '[KEY]' [Equipment Class ID],
	'2960:3' [PM Service],
	'2960:4' [Meter 1 Override],
	'2960:5' [Meter 2 Override],
	'2960:7' [Number of Time Units],
	'2960:8' [Time Units]
UNION ALL
SELECT DISTINCT
	PMI.[Control], PMI.[EquipmentClassID],
	PMI.PMService, PMI.Meter1Override,
	PMI.Meter2Override,
	PMI.NumberOfTimeUnits, PMI.TimeUnits
FROM TargetEquipmentClassPMIndividual PMI
