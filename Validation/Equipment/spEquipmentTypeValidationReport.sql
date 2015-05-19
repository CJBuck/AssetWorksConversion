-- ===============================================================================
-- Created By : Chris Buck
-- Create Date:	03/31/2015
-- Description: Creates/modifies the spEquipmentTypeValidationReport stored
--				procedure.
-- ===============================================================================

IF OBJECT_ID('spEquipmentTypeValidationReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spEquipmentTypeValidationReport AS SELECT 1')
GO

ALTER PROCEDURE dbo.spEquipmentTypeValidationReport
(
	@Source VARCHAR(15)
)
AS
--
BEGIN
	IF @Source = 'Valves'
		BEGIN
			SELECT
				LTRIM(RTRIM(SPV.VALVE_NO)) [VALVE_NO],
				LTRIM(RTRIM(SPV.VLV_FUNCTION)) [VLV_FUNCTION],
				LTRIM(RTRIM(SPV.VLV_TYPE)) [VLV_TYPE]
				FROM SourcePups201Valve SPV
					LEFT JOIN TransformEquipmentDistributionValveValueEquipmentType lkup
						ON LTRIM(RTRIM(SPV.VLV_FUNCTION)) = lkup.VLV_FUNCTION AND LTRIM(RTRIM(SPV.VLV_TYPE)) = lkup.VLV_TYPE
			WHERE
				(ISNULL(lkup.VLV_FUNCTION, '') = '' OR ISNULL(lkup.VLV_TYPE, '') = '')
				AND (
						(SPV.[STATUS] = 'A')
						OR ((SPV.[STATUS] = 'I') AND 
							(SPV.[REMARK2] LIKE '%proposed%') OR (SPV.[REMARK2] LIKE '%not yet installed%'))
						OR (
							(SPV.BYPASS_CD = 'Y')
							AND (
								(SPV.[STATUS] = 'A')
								OR ((SPV.[STATUS] = 'I') AND 
									(SPV.[REMARK2] LIKE '%proposed%') OR (SPV.[REMARK2] LIKE '%not yet installed%'))
								)
							)
					)
		END
	ELSE IF @Source = 'Facilities'
		BEGIN
			WITH FacEquipType AS (
				SELECT LTRIM(RTRIM(OE.[OBJECT_ID])) [OBJECT_ID],
					LTRIM(RTRIM(OE.MFR_NAME)) [MFR_NAME],
					LTRIM(RTRIM(OE.FAC_MODEL)) [FAC_MODEL],
					ISNULL(LTRIM(RTRIM(OE.FAC_MODEL)), '') [EquipmentType]
				FROM SourceWicm210ObjectEquipment OE
					LEFT JOIN TransformEquipmentFacilitiesEquipmentValueEquipmentType et
						ON LTRIM(RTRIM(OE.[OBJECT_ID])) = LTRIM(RTRIM(et.[OBJECT_ID]))
				WHERE
					OE.[STATUS] = 'A' AND OE.[CLASS] NOT IN ('JAPS', 'LHPL', 'RDGDMT')
					AND LTRIM(RTRIM(OE.FAC_MODEL)) IN ('NA', '', 'N/A', 'UNKNOWN')
			),
			FacEquipType2 AS (
				SELECT LTRIM(RTRIM(OE.[OBJECT_ID])) [OBJECT_ID],
					LTRIM(RTRIM(OE.MFR_NAME)) [MFR_NAME],
					LTRIM(RTRIM(OE.FAC_MODEL)) [FAC_MODEL],
					isnull(modid.ModelName, '') [EquipmentType]
				FROM SourceWicm210ObjectEquipment OE
					-- ManufacturerID Cleansing
					INNER JOIN TransformEquipmentManufacturer midc
						ON LEFT(LTRIM(RTRIM(OE.MFR_NAME)), 15) = LEFT(LTRIM(RTRIM(midc.[SourceValue])), 15)
							AND midc.[Source] LIKE '%Facilities%'
					-- ModelID Cleansing
					LEFT JOIN TransformEquipmentManufacturerModel modid
						ON LEFT(LTRIM(RTRIM(midc.[TargetValue])), 15) = modid.CleansedManufacturerID
							AND LTRIM(RTRIM(OE.FAC_MODEL)) = LTRIM(RTRIM(modid.SourceModelID))
				WHERE
					OE.[STATUS] = 'A'
					AND OE.[CLASS] NOT IN ('JAPS', 'LHPL', 'RDGDMT')
					AND LTRIM(RTRIM(OE.FAC_MODEL)) NOT IN ('NA', '', 'N/A', 'UNKNOWN')
			)
			SELECT DISTINCT et.*
			FROM (
				SELECT * FROM FacEquipType
				UNION ALL
				SELECT * FROM FacEquipType2
			) et
			WHERE et.EquipmentType IS NULL
			ORDER BY [OBJECT_ID]
		END
	ELSE IF @Source = 'Hydrants'
		BEGIN
			SELECT LTRIM(RTRIM(H.HYD_NO)) [HYD_NO], LTRIM(RTRIM(H.HYD_MAKE)) [HYD_MAKE],
				ISNULL(manid.TargetValue, 'Unknown') [ManufacturerID],
				ISNULL(manid.TargetValue, 'Unknown') [ModelID]
			FROM SourcePups201Hydrant H
				LEFT JOIN TransformEquipmentManufacturer manid
					ON LTRIM(RTRIM(H.HYD_MAKE)) = manid.SourceValue
						AND manid.[Source] = 'Hydrants'
				LEFT JOIN TransformEquipmentManufacturerModel modid
					ON LTRIM(RTRIM(H.HYD_MAKE)) = modid.SourceModelID
						AND modid.[Source] = 'Hydrants'
			WHERE LTRIM(RTRIM(H.HYD_MAKE)) NOT IN (
				SELECT HYD_MAKE FROM TransformEquipmentHydrantValueEquipmentType
				)
				AND	((H.[STATUS] IN ('A', 'I')) AND (H.HYD_SEQ# = '00'))
		END
	ELSE IF @Source = 'Vehicles'
		BEGIN
			SELECT
				LTRIM(RTRIM(OV.[OBJECT_ID])) [OBJECT_ID],
				LTRIM(RTRIM(OV.VEH_YEAR)) [VEH_YEAR],
				LTRIM(RTRIM(OV.VEH_MAKE)) [VEH_MAKE],
				LTRIM(RTRIM(OV.VEH_MODEL)) [VEH_MODEL]
			FROM SourceWicm210ObjectVehicle OV
			WHERE
				LTRIM(RTRIM(OV.[OBJECT_ID])) NOT IN (
					SELECT WICM_OBJID FROM TransformEquipmentVehicleValueSpecialEquipmentDetails
				)
				AND LTRIM(RTRIM(OV.[OBJECT_ID])) NOT IN (
					SELECT WICM_OBJID FROM TransformEquipmentVehicleValueVehicleDetails
				)
		END
	ELSE IF @Source = 'Projects'
		BEGIN
			WITH Fours AS (
				SELECT DISTINCT LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID], LTRIM(RTRIM(OP.[CLASS])) [CLASS]
				FROM SourceWicm210ObjectProject OP
					INNER JOIN SourceWicm250WorkOrderHeaderAdmin woa
						ON OP.[OBJECT_ID] = woa.[OBJECT_ID] AND woa.[STATUS] IN ('A','P')
				WHERE
					OP.[OBJECT_ID] NOT IN ('FRST', 'OTHR', 'SAFE')
					AND OP.LOCATION = '04'
					AND OP.[STATUS] = 'A'
					AND LTRIM(RTRIM(OP.[CLASS])) NOT IN ('LHTP', 'WRKSTA')
			),
			Fives AS (
				SELECT DISTINCT LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID], LTRIM(RTRIM(OP.[CLASS])) [CLASS]
				FROM SourceWicm210ObjectProject OP
				WHERE
					OP.[OBJECT_ID] NOT IN ('FRST', 'OTHR', 'SAFE')
					AND OP.LOCATION = '05'
					AND LTRIM(RTRIM(OP.[CLASS])) NOT IN ('LHTP', 'WRKSTA')
			),
			Summary AS (
				SELECT [OBJECT_ID], [CLASS]
				FROM Fours
				UNION ALL
				SELECT [OBJECT_ID], [CLASS]
				FROM Fives
			)
			SELECT DISTINCT
				LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID],
				LTRIM(RTRIM(OP.[CLASS])) [CLASS]
			FROM Summary OP
				LEFT JOIN TransformEquipmentProjectValueAssetCategory lkup
					ON LTRIM(RTRIM(OP.[CLASS])) = LTRIM(RTRIM(lkup.CLASS))
			WHERE ISNULL(lkup.EquipmentType, '') = ''
		END
END
