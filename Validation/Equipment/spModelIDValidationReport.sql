-- ===============================================================================
-- Created By : Chris Buck
-- Create Date:	03/03/2015
-- Description: Creates/modifies the spManufacturerIDValidationReport stored
--				procedure.
-- ===============================================================================

IF OBJECT_ID('spManufacturerIDValidationReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spManufacturerIDValidationReport AS SELECT 1')
GO

ALTER PROCEDURE dbo.spManufacturerIDValidationReport
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
			SELECT H.HYD_NO, H.HYD_MAKE, LTRIM(RTRIM(H.HYD_MAKE)) [Truncated HYD_MAKE]
			FROM SourcePups201Hydrant H
			WHERE LTRIM(RTRIM(H.HYD_MAKE)) NOT IN (
				SELECT LTRIM(RTRIM([SourceValue]))
				FROM TransformEquipmentManufacturer
				)
				AND ISNULL(H.HYD_MAKE, '') <> ''
		END
	ELSE IF @Source = 'Vehicles'
		BEGIN
			WITH VehNoObject AS (
				SELECT OV.[OBJECT_ID], '' [Source Model]
				FROM SourceWicm210ObjectVehicle OV
				WHERE OV.[OBJECT_ID] NOT IN (
					SELECT [OBJECT_ID] FROM TransformEquipmentVehicleValueVehicleDetails
					)
			),
			SENoObject AS (
				SELECT OV.[OBJECT_ID], '' [Source Model]
				FROM SourceWicm210ObjectVehicle OV
				WHERE OV.[OBJECT_ID] NOT IN (
					SELECT [OBJECT_ID] FROM TransformEquipmentVehicleValueSpecialEquipmentDetails
					)
			),
			VehMissingModels AS (
				SELECT DISTINCT OV.[OBJECT_ID], ISNULL(vet.[AW_MODEL], '') [Source Model]
				FROM SourceWicm210ObjectVehicle OV
					INNER JOIN TransformEquipmentVehicleValueVehicleDetails vet
						ON LTRIM(RTRIM(OV.[OBJECT_ID])) = LTRIM(RTRIM(vet.[WICM_OBJID]))
					INNER JOIN TransformEquipmentManufacturer manid
						ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue
							AND manid.[Source] LIKE '%Vehicles%'
					LEFT JOIN TransformEquipmentManufacturerModel modid
						ON LTRIM(RTRIM(manid.[TargetValue])) = LTRIM(RTRIM(modid.CleansedManufacturerID))
							AND LTRIM(RTRIM(OV.[VEH_MODEL])) = LTRIM(RTRIM(modid.SourceModelID))
							AND modid.[Source] = 'Vehicles'
				WHERE
					((ISNULL(vet.[AW_MODEL], '') = '') OR (ISNULL(modid.CleansedModelID, '') = ''))
			),
			SEMissingModels AS (
				SELECT DISTINCT OV.[OBJECT_ID], ISNULL(vet.[AW_MODEL], '') [Source Model]
				FROM SourceWicm210ObjectVehicle OV
					INNER JOIN TransformEquipmentVehicleValueSpecialEquipmentDetails vet
						ON LTRIM(RTRIM(OV.[OBJECT_ID])) = LTRIM(RTRIM(vet.[WICM_OBJID]))
					INNER JOIN TransformEquipmentManufacturer manid
						ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue
							AND manid.[Source] LIKE '%Vehicles%'
					LEFT JOIN TransformEquipmentManufacturerModel modid
						ON LTRIM(RTRIM(manid.[TargetValue])) = LTRIM(RTRIM(modid.CleansedManufacturerID))
							AND LTRIM(RTRIM(OV.[VEH_MODEL])) = LTRIM(RTRIM(modid.SourceModelID))
							AND modid.[Source] = 'Vehicles'
				WHERE
					((ISNULL(vet.[AW_MODEL], '') = '') OR (ISNULL(modid.CleansedModelID, '') = ''))
			)
			SELECT DISTINCT sq.*
			FROM (
				SELECT * FROM VehNoObject
				UNION ALL
				SELECT * FROM SENoObject
				UNION ALL
				SELECT * FROM VehMissingModels
				UNION ALL
				SELECT * FROM SEMissingModels
			) sq
			ORDER BY [Source Model] DESC
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
