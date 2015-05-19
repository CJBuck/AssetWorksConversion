-- ===============================================================================
-- Created By : Chris Buck
-- Create Date:	04/23/2015
-- Description: Creates/modifies the spEquipmentRequiredFieldsValidationReport stored
--				procedure.
-- ===============================================================================

IF OBJECT_ID('spEquipmentRequiredFieldsValidationReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spEquipmentRequiredFieldsValidationReport AS SELECT 1')
GO

ALTER PROCEDURE dbo.spEquipmentRequiredFieldsValidationReport
AS
BEGIN
	SELECT
		TE.EquipmentID,
		xwalk.[Source] [Source], xwalk.LegacyIDSource, xwalk.LegacyID,
		TE.AssetType, TE.[Description],
		TE.EquipmentType, TE.PMProgramType,
		ISNULL(CAST(TE.ModelYear AS VARCHAR), '') [ModelYear], TE.ManufacturerID,
		TE.ModelID, TE.MeterTypesClass,
		TE.Maintenance, TE.PMProgram,
		TE.Standards, TE.RentalRates,
		TE.Resources, TE.AssetCategoryID,
		TE.AssignedPM, TE.AssignedRepair,
		TE.StationLocation, TE.PreferredPMShift,
		TE.DepartmentID, TE.DeptToNotifyForPM
	FROM TransformEquipment TE
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON TE.EquipmentID = xwalk.EquipmentID
	WHERE
		(ISNULL(TE.AssetType, '') = '')
		OR (ISNULL(TE.[Description], '') = '')
		OR (ISNULL(TE.EquipmentType, '') = '')
		OR (ISNULL(TE.PMProgramType, '') = '')
		OR (ISNULL(TE.ModelYear, 0) = 0)
		OR (ISNULL(TE.ManufacturerID, '') = '')
		OR (ISNULL(TE.ModelID, '') = '')
		OR (ISNULL(TE.MeterTypesClass, '') = '')
		OR (ISNULL(TE.Maintenance, '') = '')
		OR (ISNULL(TE.PMProgram, '') = '')
		OR (ISNULL(TE.Standards, '') = '')
		OR (ISNULL(TE.RentalRates, '') = '')
		OR (ISNULL(TE.Resources, '') = '')
		OR (ISNULL(TE.AssetCategoryID, '') = '')
		OR (ISNULL(TE.AssignedPM, '') = '')
		OR (ISNULL(TE.AssignedRepair, '') = '')
		OR (ISNULL(TE.StationLocation, '') = '')
		OR (ISNULL(TE.PreferredPMShift, '') = '')
		OR (ISNULL(TE.DepartmentID, '') = '')
		OR (ISNULL(TE.DeptToNotifyForPM, '') = '')
END
