SELECT * FROM TransformEquipmentClass TEC
WHERE TEC.[ClassType] = 'Ye'

INSERT INTO TransformEquipmentClass
SELECT
	'[I]', 'NOT APPLICABLE', 'NOT APPLICABLE', '', NULL, 'None', 'None', NULL, NULL, NULL, NULL, NULL,
	NULL [PMFuelServicesInOneCycle], NULL, '', '', 'N', 'N', 'N', 'Y', 'Y', 'Y',
	'Hydrants', GETDATE()
	
SELECT distinct ClassType FROM TransformEquipmentClass
WHERE EquipmentClassID = 'NOT APPLICABLE'

UPDATE TransformEquipmentClass
SET [Source] = 'Valves'
WHERE EquipmentClassID = 'NOT APPLICABLE'
	AND [Source] = 'Valves, Hydrants, Projects'
	
SELECT * FROM TransformObjectVehicleValueEquipmentClass
