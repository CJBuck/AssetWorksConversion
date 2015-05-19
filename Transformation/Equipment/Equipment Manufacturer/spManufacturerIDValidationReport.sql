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
		SELECT SPV.VALVE_NO, SPV.VLV_MAKE,
			LEFT(LTRIM(RTRIM(SPV.VLV_MAKE)), 15) [Truncated VLV_MAKE]
		FROM SourcePups201Valve SPV
		WHERE LEFT(LTRIM(RTRIM(SPV.VLV_MAKE)), 15) NOT IN (
			SELECT DISTINCT LEFT(LTRIM(RTRIM([SourceValue])), 15)
			FROM TransformEquipmentManufacturer
			WHERE [Source] LIKE '%Valves%'
			)
	END
ELSE IF @Source = 'Facilities'
	BEGIN
		SELECT OE.[OBJECT_ID], OE.MFR_NAME,
			LEFT(LTRIM(RTRIM(OE.MFR_NAME)), 15) [Truncated MFR_NAME]
		FROM SourceWicm210ObjectEquipment OE
		-- ManufacturerID Cleansing
		WHERE
			OE.[STATUS] = 'A' AND OE.[CLASS] NOT IN ('JAPS', 'LHPL', 'RDGDMT')
			AND LEFT(LTRIM(RTRIM(OE.MFR_NAME)), 15) NOT IN (
				SELECT DISTINCT LEFT(LTRIM(RTRIM([SourceValue])), 15)
				FROM  TransformEquipmentManufacturer
				WHERE [Source] LIKE '%Facilities%'
				)
	END
ELSE IF @Source = 'Hydrants'
	BEGIN
		SELECT H.HYD_NO, H.HYD_MAKE, LTRIM(RTRIM(H.HYD_MAKE)) [Truncated HYD_MAKE]
		FROM SourcePups201Hydrant H
		WHERE LTRIM(RTRIM(H.HYD_MAKE)) NOT IN (
			SELECT LTRIM(RTRIM([SourceValue]))
			FROM TransformEquipmentHydrantManufacturerIDLookup
			)
	END
ELSE IF @Source = 'Vehicles'
	BEGIN
		SELECT OV.[OBJECT_ID],
			ISNULL(vet.[Make], '') [Make], ISNULL(manid.SourceValue, '') [Source Value]
		FROM SourceWicm210ObjectVehicle OV
			LEFT JOIN TransformEquipmentVehicleValueEquipmentType vet
				ON OV.[OBJECT_ID] = vet.[OBJECT_ID]
			LEFT JOIN TransformEquipmentManufacturer manid
				ON vet.Make = manid.SourceValue AND manid.[Source] LIKE '%Vehicles%'
		WHERE
			(ISNULL(vet.[Make], '') = '')
			OR (ISNULL(manid.SourceValue, '') = '')
	END
ELSE
	-- Current Valid Values
	SELECT DISTINCT
		TEM.[SourceValue] [Valid Manufacturer_ID],
		TEM.ManufacturerName [Valid Manufacturer Name],
		TEM.[Source] [Source (Division)]
	FROM TransformEquipmentManufacturer TEM
	ORDER BY TEM.[Source], TEM.[SourceValue], TEM.ManufacturerName
END
