SELECT
	'2039' [Control],
	'175:2' [EquipmentID],
	'176:2' [ComponentID]
UNION ALL
SELECT
	[Control],
	EquipmentID,
	ComponentID
FROM TransformEquipmentProjectComponentRelationship
