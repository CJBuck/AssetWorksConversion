SELECT 
	'2134' [Control], '[KEY]' [Manufacturer ID],
	'534:6' [Model ID], '534:7' [Model Name],
	'534:16' [Active]
UNION ALL
SELECT DISTINCT
	TEMM.[Control], TEMM.[CleansedManufacturerID] [Manufacturer ID],
	TEMM.[CleansedModelID] [Model ID], TEMM.[ModelName] [Model Name],
	'Y' [Active]
FROM TargetEquipmentManufacturerModel TEMM
