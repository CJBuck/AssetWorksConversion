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
			WHERE SPV.VALVE_NO NOT IN
			 (
				SELECT
					LTRIM(RTRIM(SPV.VALVE_NO)) [VALVE_NO]	FROM SourcePups201Valve SPV
				WHERE
					SPV.VALVE_NO IN ('028539', '028540')
					OR SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'BALL' AND VLV_SIZE < 16
					OR SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'BUTTERFLY' AND VLV_SIZE >= 16
					OR SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'BUTTERFLY' AND VLV_SIZE < 16
					OR SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'GATE' AND VLV_SIZE >= 16
					OR SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'UNKNOWN' AND VLV_SIZE >= 16
					OR SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'UNKNOWN' AND VLV_SIZE < 16
					OR SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'GATE' AND VLV_SIZE < 16
					OR SPV.VLV_FUNCTION = '03' AND SPV.VLV_TYPE = 'GATE' AND VLV_SIZE < 16
					OR SPV.VLV_FUNCTION = '03' AND SPV.VLV_TYPE = 'UNKNOWN' AND VLV_SIZE < 16
					OR SPV.VLV_FUNCTION = '04' AND SPV.VLV_MAKE NOT LIKE 'GIL%' AND VLV_SIZE <= '02'
					OR SPV.VLV_FUNCTION = '04' AND SPV.VLV_MAKE LIKE 'GIL%' AND VLV_SIZE = '02'
					OR SPV.VLV_FUNCTION = '04' AND VLV_SIZE > '02'
					OR SPV.VLV_FUNCTION = '05' AND SPV.VLV_TYPE = 'AIR RELEAS'
					OR SPV.VLV_FUNCTION = '05' AND SPV.VLV_TYPE IN ('GATE', 'MANUAL', 'UNKNOWN')
					OR SPV.VLV_FUNCTION = '05' AND SPV.VLV_TYPE = 'COMBINATIO'
					OR SPV.VLV_FUNCTION = '06' AND SPV.VLV_TYPE IN ('GATE', 'UNKNOWN') AND SPV.VLV_SIZE < 16
					OR SPV.VLV_FUNCTION = '06' AND SPV.VLV_SIZE >= 16
					OR SPV.VLV_FUNCTION = '07' AND SPV.VLV_TYPE = 'CHECK' AND SPV.VALVE_NO NOT IN ('028539', '028540')
					OR SPV.VLV_FUNCTION = '07' AND SPV.VLV_TYPE = 'PRV' AND SPV.VALVE_NO NOT IN ('028539', '028540')
					OR SPV.VLV_FUNCTION = '08' AND SPV.VLV_TYPE IN ('BUTTERFLY', 'GATE') AND SPV.VLV_SIZE >= 16
					OR SPV.VLV_FUNCTION = '08' AND SPV.VLV_TYPE = 'BUTTERFLY' AND SPV.VLV_SIZE < 16
					OR SPV.VLV_FUNCTION = '08' AND SPV.VLV_TYPE IN ('BUTTERFLY', 'GATE', 'UNKNOWN') AND SPV.VLV_SIZE < 16
					OR SPV.VLV_FUNCTION = '10' AND SPV.VLV_TYPE IN ('GATE', 'UNKNOWN') AND SPV.VLV_SIZE < 16
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
				ISNULL(manid.TargetValue, '') [ManufacturerID],
				ISNULL(manid.TargetValue, '') [ModelID]
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
			WITH Vehs AS (
				SELECT
					LTRIM(RTRIM(OV.[OBJECT_ID])) [OBJECT_ID], LTRIM(RTRIM(OV.VEH_YEAR)) [ModelYear],
					ISNULL(manid.TargetValue, '') [ManufacturerID], ISNULL(modid.CleansedModelID, '') [ModelID]
				FROM SourceWicm210ObjectVehicle OV
					INNER JOIN TransformEquipmentManufacturer manid
						ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue
							AND manid.[Source] LIKE '%Vehicles%'
					INNER JOIN TransformEquipmentManufacturerModel modid
						ON LTRIM(RTRIM(manid.[TargetValue])) = LTRIM(RTRIM(modid.CleansedManufacturerID))
							AND LTRIM(RTRIM(OV.[VEH_MODEL])) = LTRIM(RTRIM(modid.SourceModelID))
							AND modid.[Source] = 'Vehicles'
				WHERE
					(OV.[OBJECT_ID] IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
					AND (OV.[OBJECT_ID] NOT IN ('006658', '006659', '006660', '006661', '006662', '006663',
						'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
						'006673', '006674', '006675'))
			)
			SELECT
				LTRIM(RTRIM(OV.[OBJECT_ID])) [OBJECT_ID],
				LTRIM(RTRIM(OV.VEH_YEAR)) [VEH_YEAR],
				LTRIM(RTRIM(OV.VEH_MAKE)) [VEH_MAKE],
				LTRIM(RTRIM(OV.VEH_MODEL)) [VEH_MODEL]
			FROM SourceWicm210ObjectVehicle OV
				INNER JOIN Vehs ON OV.[OBJECT_ID] = Vehs.[OBJECT_ID]
				INNER JOIN TransformObjectVehicleValueEquipmentClass vec
					ON LTRIM(RTRIM(OV.CLASS)) = vec.WICM_CLASS
						AND LTRIM(RTRIM(OV.VEH_MAKE)) = vec.WICM_VEH_MAKE
						AND LTRIM(RTRIM(OV.VEH_MODEL)) = vec.WICM_VEH_MODEL
				INNER JOIN TransformEquipmentClass tec ON vec.EquipmentClassID = tec.EquipmentClassID
				LEFT JOIN (
					SELECT DISTINCT VEH_YEAR, VEH_MAKE, VEH_MODEL, EquipmentClass, EquipmentType
					FROM TransformEquipmentVehicleValueEquipmentType
					) vet
					ON vehs.ManufacturerID = vet.VEH_MAKE
						AND vehs.ModelID = vet.VEH_MODEL
						AND vehs.ModelYear = vet.VEH_YEAR
						AND vec.EquipmentClassID = vet.EquipmentClass
			WHERE ISNULL(LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30), '') = ''
		END
	ELSE IF @Source = 'Projects'
		BEGIN
			SELECT DISTINCT
				LTRIM(RTRIM([OBJECT_ID])) [OBJECT_ID],
				LTRIM(RTRIM([CLASS])) [CLASS]
			FROM (
				SELECT DISTINCT
					LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID],
					LTRIM(RTRIM(OP.[CLASS])) [CLASS],
					CASE
						WHEN ISNULL(Step1.EquipmentType, '') <> '' THEN Step1.EquipmentType
						WHEN ISNULL(Step2.EquipmentType, '') <> '' THEN Step2.EquipmentType
						ELSE ''
					END [EquipmentType]
				FROM SourceWicm210ObjectProject OP
					LEFT JOIN
						(
							SELECT DISTINCT LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID],
								LTRIM(RTRIM(OP.[CLASS])) [CLASS], lkup.EquipmentType
							FROM SourceWicm210ObjectProject OP
								INNER JOIN TransformEquipmentProjectValueAssetCategory lkup ON
									ISNULL(LTRIM(RTRIM(OP.CLASS)), '') = lkup.CLASS
							WHERE
								OP.[Object_ID] NOT IN (SELECT DISTINCT [OBJECT_ID] FROM TransformEquipmentProjectValueAssetCategory)
						) Step1 ON OP.[OBJECT_ID] = Step1.[OBJECT_ID]
					LEFT JOIN
						(
							SELECT DISTINCT LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID],
								LTRIM(RTRIM(OP.[CLASS])) [CLASS], lkup.EquipmentType
							FROM SourceWicm210ObjectProject OP
								INNER JOIN TransformEquipmentProjectValueAssetCategory lkup ON
									OP.[OBJECT_ID] = lkup.[OBJECT_ID]
						) Step2 ON OP.[OBJECT_ID] = Step2.[OBJECT_ID]
				WHERE
					(OP.[OBJECT_ID] IN (
						SELECT DISTINCT LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID]
						FROM SourceWicm210ObjectProject OP
							INNER JOIN SourceWicm250WorkOrderHeaderAdmin woa
								ON OP.[OBJECT_ID] = woa.[OBJECT_ID] AND woa.[STATUS] IN ('A','P')
						WHERE
							OP.[OBJECT_ID] NOT IN ('FRST', 'OTHR', 'SAFE')
							AND OP.LOCATION = '04'
							AND OP.[STATUS] = 'A'
							AND LTRIM(RTRIM(OP.[CLASS])) NOT IN ('LHTP', 'WRKSTA')
					)
					OR OP.[OBJECT_ID] IN (
						SELECT DISTINCT LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID]
						FROM SourceWicm210ObjectProject OP
						WHERE
							OP.[OBJECT_ID] NOT IN ('FRST', 'OTHR', 'SAFE')
							AND OP.LOCATION = '05'
							AND LTRIM(RTRIM(OP.[CLASS])) NOT IN ('LHTP', 'WRKSTA')
					)	)
				) Summary
				
			WHERE
				Summary.EquipmentType = ''
	END
END
