-- ===============================================================================
-- Created By : Chris Buck
-- Create Date:	03/31/2015
-- Description: Creates/modifies the spEquipmentClassIDValidationReport stored
--				procedure.
-- ===============================================================================

IF OBJECT_ID('spEquipmentClassValidationReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spEquipmentClassValidationReport AS SELECT 1')
GO

ALTER PROCEDURE dbo.spEquipmentClassValidationReport
(
	@Source VARCHAR(15)
)
AS
--
BEGIN
	IF @Source = 'Valves'
		BEGIN
			SELECT 'No Data' [VALVE_NO], '' [VLV_MAKE], '' [Truncated VLV_MAKE]
		END
	ELSE IF @Source = 'Facilities'
		BEGIN
			SELECT 'No Data' [OBJECT_ID], '' [MFR_NAME], '' [Truncated MFR_NAME],
				'' [FAC_MODEL], '' [Truncated FAC_MODEL]
		END
	ELSE IF @Source = 'Hydrants'
		BEGIN
			SELECT 'No Data' [HYD_NO], '' [HYD_MAKE], '' [Truncated HYD_MAKE]
		END
	ELSE IF @Source = 'Vehicles'
		BEGIN
			WITH VehMissingClass AS (
				SELECT DISTINCT OV.[OBJECT_ID], ISNULL(OV.VEH_MAKE, '') [WICM_VEH_MAKE],
					ISNULL(OV.VEH_MODEL, '') [WICM_VEH_MODEL], ISNULL(OV.[CLASS], '') [WICM_CLASS]
				FROM SourceWicm210ObjectVehicle OV
					INNER JOIN TransformEquipmentVehicleValueVehicleDetails vehdet
						ON OV.[OBJECT_ID] = vehdet.[WICM_OBJID]
					LEFT JOIN TransformObjectVehicleValueEquipmentClass vec
						ON LTRIM(RTRIM(OV.CLASS)) = vec.WICM_CLASS
							AND LTRIM(RTRIM(OV.VEH_MAKE)) = vec.WICM_VEH_MAKE
							AND LTRIM(RTRIM(OV.VEH_MODEL)) = vec.WICM_VEH_MODEL
				WHERE
					OV.[OBJECT_ID] NOT IN ('006656', '006533', '006657', '006565', '006572', '006573', '006678')
					AND ISNULL(vec.EquipmentClassID, '') = ''
			),
			SEMissingClass AS (
				SELECT DISTINCT OV.[OBJECT_ID], ISNULL(OV.VEH_MAKE, '') [WICM_VEH_MAKE],
					ISNULL(OV.VEH_MODEL, '') [WICM_VEH_MODEL], ISNULL(OV.[CLASS], '') [WICM_CLASS]
				FROM SourceWicm210ObjectVehicle OV
					INNER JOIN TransformEquipmentVehicleValueSpecialEquipmentDetails vehdet
						ON OV.[OBJECT_ID] = vehdet.[WICM_OBJID]
					LEFT JOIN TransformObjectVehicleValueEquipmentClass vec
						ON LTRIM(RTRIM(OV.CLASS)) = vec.WICM_CLASS
							AND LTRIM(RTRIM(OV.VEH_MAKE)) = vec.WICM_VEH_MAKE
							AND LTRIM(RTRIM(OV.VEH_MODEL)) = vec.WICM_VEH_MODEL
				WHERE
					OV.[OBJECT_ID] NOT IN ('006656', '006533', '006657', '006565', '006572', '006573', '006678')
					AND ISNULL(vec.EquipmentClassID, '') = ''
			)
			SELECT DISTINCT sq.*
			FROM (
				SELECT * FROM VehMissingClass
				UNION ALL
				SELECT * FROM SEMissingClass
			) sq
			ORDER BY [OBJECT_ID]
		END
END
