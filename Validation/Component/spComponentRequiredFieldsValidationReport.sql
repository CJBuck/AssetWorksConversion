-- ===============================================================================
-- Created By : Chris Buck
-- Create Date:	06/04/2015
-- Description: Creates/modifies the spComponentRequiredFieldsValidationReport
--				stored procedure.
-- ===============================================================================

IF OBJECT_ID('spComponentRequiredFieldsValidationReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spComponentRequiredFieldsValidationReport AS SELECT 1')
GO

ALTER PROCEDURE dbo.spComponentRequiredFieldsValidationReport
AS
BEGIN
	SELECT
		TC.AssetID,
		xwalk.[Source] [Source], xwalk.LegacyIDSource, xwalk.LegacyID,
		TC.[Description],
		TC.EquipmentType, TC.PMProgramType,
		ISNULL(CAST(TC.ModelYear AS VARCHAR), '') [ModelYear], TC.ManufacturerID,
		TC.ModelID, TC.MeterTypesClass,
		TC.Maintenance, TC.PMClass,
		TC.Standards, TC.RentalRates,
		TC.Resources, TC.AssetCategoryID,
		TC.AssignedPM, TC.AssignedRepair,
		TC.StationLocation, TC.PreferredPMShift,
		TC.DepartmentID, TC.DepartmentForPM
	FROM TransformComponent TC
		INNER JOIN TransformComponentLegacyXwalk xwalk ON TC.AssetID = xwalk.AssetID
	WHERE
		TC.[Control] IS NOT NULL
		OR TC.AssetID IS NOT NULL
		OR TC.[Description] IS NOT NULL
		OR TC.ModelYear IS NOT NULL
		OR TC.ManufacturerID IS NOT NULL
		OR TC.ModelID IS NOT NULL
		OR TC.EquipmentType IS NOT NULL
		OR TC.PMProgramType IS NOT NULL
		OR TC.MeterTypesClass IS NOT NULL
		OR TC.Maintenance IS NOT NULL
		OR TC.PMClass IS NOT NULL
		OR TC.Standards IS NOT NULL
		OR TC.RentalRates IS NOT NULL
		OR TC.Resources IS NOT NULL
		OR TC.AssetCategoryID IS NOT NULL
		OR TC.AssignedPM IS NOT NULL
		OR TC.AssignedRepair IS NOT NULL
		OR TC.PreferredPMShift IS NOT NULL
		OR TC.StationLocation IS NOT NULL
		OR TC.DepartmentID IS NOT NULL
		OR TC.DepartmentForPM IS NOT NULL
		OR TC.WorkOrders IS NOT NULL
END
