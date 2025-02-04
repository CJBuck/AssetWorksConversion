--
TRUNCATE TABLE TransformEquipment
TRUNCATE TABLE TransformEquipmentIndividualPM
TRUNCATE TABLE TransformEquipmentLegacyXwalk
TRUNCATE TABLE EquipmentIDAutoCounter

EXEC dbo.spTransformEquipmentDistributionValve
EXEC dbo.spTransformEquipmentFacilitiesEquipment
EXEC dbo.spTransformEquipmentVehicle
EXEC dbo.spTransformEquipmentProject
EXEC dbo.spTransformEquipmentHydrant
EXEC dbo.spTransformAssetHeirarchy
EXEC dbo.spTransformEquipmentSubsystem
EXEC dbo.spTransformEquipmentSubsystemParts

SELECT * FROM TransformEquipment
SELECT * FROM TransformEquipmentLegacyXwalk
SELECT * FROM TransformEquipmentProjectComponentRelationship
SELECT * FROM EquipmentIDAutoCounter
--
