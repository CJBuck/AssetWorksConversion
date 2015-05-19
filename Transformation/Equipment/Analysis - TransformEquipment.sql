--
TRUNCATE TABLE TransformEquipment
TRUNCATE TABLE TransformEquipmentLegacyXwalk
TRUNCATE TABLE EquipmentIDAutoCounter

EXEC dbo.spTransformEquipmentDistributionValve
EXEC dbo.spTransformEquipmentFacilitiesEquipment
EXEC dbo.spTransformEquipmentVehicle
EXEC dbo.spTransformEquipmentProject
EXEC dbo.spTransformEquipmentHydrant

SELECT * FROM TransformEquipment
SELECT * FROM TransformEquipmentLegacyXwalk
SELECT * FROM EquipmentIDAutoCounter
--
