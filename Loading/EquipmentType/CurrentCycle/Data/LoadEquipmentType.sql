SELECT 
	'2017' [Control], '79:2' [Equipment Type],
	'80:2' [Description], '80:4' [Year],
	'80:6' [Manufacturer ID], '80:9' [Model ID],
	'80:12' [Department ID], '80:15' [Location ID],
	'80:18' [Equipment Class ID], '80:22' [Active],
	'80:21' [Comments]
UNION ALL
SELECT DISTINCT
	ET.[Control] [Control], ET.[EquipmentType],
	ET.[Description], ISNULL(CAST(ET.[Year] AS VARCHAR(4)), '') [Year],
	ISNULL(ET.ManufacturerID, '') [Manufacturer ID], ISNULL(ET.ModelID, '') [Model ID],
	'' [Department ID], '' [Location ID],
	ISNULL(ET.EquipmentClassID, '') [Equipment Class ID], 'Y' [Active],
	'' [Comments]
FROM TargetEquipmentType ET
