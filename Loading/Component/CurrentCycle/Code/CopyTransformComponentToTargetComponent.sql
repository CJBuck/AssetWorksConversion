INSERT INTO TargetComponent
SELECT *
FROM TransformComponent TC
WHERE
	TC.[Control] IS NOT NULL
	AND TC.AssetID IS NOT NULL
	AND TC.[Description] IS NOT NULL
	AND TC.ModelYear IS NOT NULL
	AND TC.ManufacturerID IS NOT NULL
	AND TC.ModelID IS NOT NULL
	AND TC.EquipmentType IS NOT NULL
	AND TC.PMProgramType IS NOT NULL
	AND TC.MeterTypesClass IS NOT NULL
	AND TC.Maintenance IS NOT NULL
	AND TC.PMClass IS NOT NULL
	AND TC.Standards IS NOT NULL
	AND TC.RentalRates IS NOT NULL
	AND TC.Resources IS NOT NULL
	AND TC.AssetCategoryID IS NOT NULL
	AND TC.AssignedPM IS NOT NULL
	AND TC.AssignedRepair IS NOT NULL
	AND TC.PreferredPMShift IS NOT NULL
	AND TC.StationLocation IS NOT NULL
	AND TC.DepartmentID IS NOT NULL
	AND TC.DepartmentForPM IS NOT NULL
	AND TC.WorkOrders IS NOT NULL
