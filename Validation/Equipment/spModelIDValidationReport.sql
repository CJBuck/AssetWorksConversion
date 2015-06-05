-- ===============================================================================
-- Created By : Chris Buck
-- Create Date:	03/03/2015
-- Description: Creates/modifies the spModelIDValidationReport stored
--				procedure.
-- ===============================================================================

IF OBJECT_ID('spModelIDValidationReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spModelIDValidationReport AS SELECT 1')
GO

ALTER PROCEDURE dbo.spModelIDValidationReport
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
			WITH FACS AS (
				SELECT OE.[OBJECT_ID]
				FROM SourceWicm210ObjectEquipment OE
					-- ManufacturerID Cleansing
					INNER JOIN TransformEquipmentManufacturer midc
						ON LEFT(LTRIM(RTRIM(OE.MFR_NAME)), 15) = LEFT(LTRIM(RTRIM(midc.[SourceValue])), 15)
							AND midc.[Source] LIKE '%Facilities%'
					-- ModelID Cleansing
					INNER JOIN TransformEquipmentManufacturerModel modid
						ON LEFT(LTRIM(RTRIM(midc.[TargetValue])), 15) = modid.CleansedManufacturerID
							AND LTRIM(RTRIM(OE.FAC_MODEL)) = modid.SourceModelID
				WHERE
					OE.[STATUS] = 'A' AND OE.[CLASS] NOT IN ('JAPS', 'LHPL', 'RDGDMT')
			)
			SELECT SWOE.[OBJECT_ID], SWOE.MFR_NAME,
				LEFT(LTRIM(RTRIM(SWOE.MFR_NAME)), 15) [Truncated MFR_NAME],
				SWOE.FAC_MODEL, LEFT(LTRIM(RTRIM(SWOE.FAC_MODEL)), 15) [Truncated FAC_MODEL]
			FROM SourceWicm210ObjectEquipment SWOE
			WHERE SWOE.[OBJECT_ID] NOT IN (SELECT [OBJECT_ID] FROM FACS)
				AND SWOE.[STATUS] = 'A' AND SWOE.[CLASS] NOT IN ('JAPS', 'LHPL', 'RDGDMT')
			ORDER BY SWOE.MFR_NAME, LEFT(LTRIM(RTRIM(SWOE.MFR_NAME)), 15),
				SWOE.FAC_MODEL, LEFT(LTRIM(RTRIM(SWOE.FAC_MODEL)), 15)
		END
	ELSE IF @Source = 'Hydrants'
		BEGIN
			SELECT hyds.HYD_NO, hyds.HYD_MAKE, LTRIM(RTRIM(hyds.HYD_MAKE)) [Truncated HYD_MAKE]
			FROM (
				SELECT H.HYD_NO, H.HYD_MAKE, LTRIM(RTRIM(H.HYD_MAKE)) [Truncated HYD_MAKE],
					ISNULL(manid.TargetValue, 'UNKNOWN') [ManufacturerID],
					CASE
						WHEN ISNULL(LTRIM(RTRIM(h.HYD_MAKE)), '')
							IN ('NA', '', 'N/A', 'UNKNOWN') THEN 'UNKNOWN'
						ELSE LTRIM(RTRIM(modid.CleansedModelID)) 
					END [ModelID]
				FROM SourcePups201Hydrant H
					LEFT JOIN TransformEquipmentManufacturer manid
						ON LTRIM(RTRIM(H.HYD_MAKE)) = manid.SourceValue
							AND manid.[Source] = 'Hydrants'
					LEFT JOIN TransformEquipmentManufacturerModel modid
						ON manid.TargetValue = modid.CleansedManufacturerID
							AND modid.SourceModelID = LTRIM(RTRIM(H.HYD_MAKE))
							AND modid.[Source] = 'Hydrants'
			) hyds
			WHERE ISNULL(LTRIM(RTRIM(hyds.ModelID)), '') = ''
		END
	ELSE IF @Source = 'Vehicles'
		BEGIN
			SELECT OV.[OBJECT_ID],
				ISNULL(LTRIM(RTRIM(OV.[VEH_MAKE])), '') [Make],
				LTRIM(RTRIM(OV.[VEH_MODEL])) [Source Value]
			FROM SourceWicm210ObjectVehicle OV
				INNER JOIN TransformEquipmentManufacturer manid
					ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue AND manid.[Source] LIKE '%Vehicles%'
				INNER JOIN TransformEquipmentManufacturerModel modid
					ON LTRIM(RTRIM(manid.[TargetValue])) = LTRIM(RTRIM(modid.CleansedManufacturerID))
						AND LTRIM(RTRIM(OV.[VEH_MODEL])) = LTRIM(RTRIM(modid.SourceModelID))
						AND modid.[Source] = 'Vehicles'
			WHERE
				(OV.[OBJECT_ID] IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
				AND (ISNULL(modid.CleansedModelID, '') = '')
				AND (OV.[OBJECT_ID] NOT IN ('006658', '006659', '006660', '006661', '006662', '006663',
					'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
					'006673', '006674', '006675'))
		END
	ELSE
		-- Current Valid Values
		SELECT DISTINCT
			TEMM.[CleansedManufacturerID] [Valid Manufacturer_ID],
			TEMM.[CleansedModelID] [Valid Model_ID],
			TEMM.[ModelName] [Valid Model Name],
			TEMM.[Source] [Source (Division)]
		FROM TransformEquipmentManufacturerModel TEMM
		ORDER BY TEMM.[Source], TEMM.[CleansedManufacturerID], TEMM.[CleansedModelID], TEMM.[ModelName]
END
