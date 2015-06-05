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
			SELECT DISTINCT OV.[OBJECT_ID],
				ISNULL(OV.VEH_MAKE, '') [WICM_VEH_MAKE],
				ISNULL(OV.VEH_MODEL, '') [WICM_VEH_MODEL],
				ISNULL(OV.[CLASS], '') [WICM_CLASS]
			FROM SourceWicm210ObjectVehicle OV
				LEFT JOIN TransformObjectVehicleValueEquipmentClass vec
					ON LTRIM(RTRIM(OV.CLASS)) = vec.WICM_CLASS
						AND LTRIM(RTRIM(OV.VEH_MAKE)) = vec.WICM_VEH_MAKE
						AND LTRIM(RTRIM(OV.VEH_MODEL)) = vec.WICM_VEH_MODEL
			WHERE
				(OV.[OBJECT_ID] IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
				AND ISNULL(vec.EquipmentClassID, '') = ''
				AND (OV.[OBJECT_ID] NOT IN ('006658', '006659', '006660', '006661', '006662', '006663',
					'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
					'006673', '006674', '006675'))
		END
END
