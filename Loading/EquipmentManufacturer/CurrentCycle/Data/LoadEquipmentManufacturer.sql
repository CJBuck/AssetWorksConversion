SELECT 
	'2134' [Control], '532:2' [Manufacturer ID],
	'534:2' [Manufacturer Name], '534:14' [Active],
	'[GROUPROW]' [Models]
UNION ALL
SELECT DISTINCT
	TEM.[Control], TEM.[TargetValue] [Manufacturer ID],
	TEM.ManufacturerName [Manufacturer Name],
	'Y' [Active], '[534:4;Model;1:1]' [Models]
FROM TargetEquipmentManufacturer TEM
