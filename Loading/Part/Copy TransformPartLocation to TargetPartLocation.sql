INSERT INTO TargetPartLocation
SELECT *
FROM TransformPartLocation
WHERE
	PartID IS NOT NULL
	AND PartSuffix IS NOT NULL
	AND InventoryLocation IS NOT NULL
	AND UnitOfMeasure IS NOT NULL
	AND Bins IS NOT NULL
	AND InventoryMonth IS NOT NULL
	AND StockStatus IS NOT NULL
	AND Manufacturer IS NOT NULL
	AND ManufacturerPartNo IS NOT NULL
	AND ReplenishMethod IS NOT NULL
	AND PerformMinMaxCalculation IS NOT NULL
	AND MinAvailable IS NOT NULL
	AND MaxAvailable IS NOT NULL
	AND SafetyStock IS NOT NULL
	
