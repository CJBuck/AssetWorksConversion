INSERT INTO TargetEquipment
SELECT *
FROM TransformEquipment TE
WHERE
	TE.[Control] IS NOT NULL
	AND TE.EquipmentID IS NOT NULL
	AND TE.AssetType IS NOT NULL
	AND TE.[Description] IS NOT NULL
	AND TE.EquipmentType IS NOT NULL
	AND TE.PMProgramType IS NOT NULL
	AND TE.ModelYear IS NOT NULL
	AND TE.ManufacturerID IS NOT NULL
	AND TE.ModelID IS NOT NULL
	AND TE.MeterTypesClass IS NOT NULL
	AND TE.Maintenance IS NOT NULL
	AND TE.PMProgram IS NOT NULL
	AND TE.Standards IS NOT NULL
	AND TE.RentalRates IS NOT NULL
	AND TE.Resources IS NOT NULL
	AND TE.AssetCategoryID IS NOT NULL
	AND TE.AssignedPM IS NOT NULL
	AND TE.AssignedRepair IS NOT NULL
	AND TE.StationLocation IS NOT NULL
	AND TE.PreferredPMShift IS NOT NULL
	AND TE.DepartmentID IS NOT NULL
	AND TE.DeptToNotifyForPM IS NOT NULL
	AND TE.WorkOrders IS NOT NULL
