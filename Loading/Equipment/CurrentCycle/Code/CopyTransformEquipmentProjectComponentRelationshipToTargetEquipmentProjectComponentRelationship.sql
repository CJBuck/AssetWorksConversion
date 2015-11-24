INSERT INTO TargetEquipmentProjectComponentRelationship
SELECT *
FROM TransformEquipmentProjectComponentRelationship PCR
WHERE
	PCR.EquipmentID IS NOT NULL
	AND PCR.ComponentID IS NOT NULL
