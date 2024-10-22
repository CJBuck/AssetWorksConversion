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
			AND ((SPV.[STATUS] = 'A')
			OR ((SPV.[STATUS] = 'I') AND 
				(SPV.[REMARK2] LIKE '%proposed%') OR (SPV.[REMARK2] LIKE '%not yet installed%'))
			OR (
				(SPV.BYPASS_CD = 'Y')
				AND (
					(SPV.[STATUS] = 'A')
					OR ((SPV.[STATUS] = 'I') AND 
						(SPV.[REMARK2] LIKE '%proposed%') OR (SPV.[REMARK2] LIKE '%not yet installed%'))
					)
				))
	END
ELSE IF @Source = 'Facilities'
	BEGIN
		SELECT OE.[OBJECT_ID], OE.MFR_NAME,
			LEFT(LTRIM(RTRIM(OE.MFR_NAME)), 15) [Truncated MFR_NAME]
		FROM SourceWicm210ObjectEquipment OE
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
		WHERE
			LTRIM(RTRIM(H.HYD_MAKE)) NOT IN (
				SELECT LTRIM(RTRIM([SourceValue])) FROM TransformEquipmentManufacturer
			)
			AND
				((H.[STATUS] IN ('A', 'I')) AND (H.HYD_SEQ# = '00'))
	END
ELSE IF @Source = 'Vehicles'
	BEGIN
		--SELECT OV.[OBJECT_ID],
		--	ISNULL(LTRIM(RTRIM(OV.[VEH_MAKE])), '') [Make],
		--	ISNULL(manid.SourceValue, '') [Source Value]
		--FROM SourceWicm210ObjectVehicle OV
		--	LEFT JOIN TransformEquipmentManufacturer manid
		--		ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue AND manid.[Source] LIKE '%Vehicles%'
		--WHERE
		--	(OV.[OBJECT_ID] IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
		--	AND (ISNULL(manid.TargetValue, '') = '')
		--	AND (OV.[OBJECT_ID] NOT IN ('006658', '006659', '006660', '006661', '006662', '006663',
		--		'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
		--		'006673', '006674', '006675'))
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
				AND (OV.[OBJECT_ID] NOT IN ('006533', '006565', '006572', '006573', '006656', '006657', '006658',
					  '006659', '006660', '006661', '006662', '006663', '006664', '006665', '006666', '006667',
					  '006668', '006669', '006670', '006672', '006673', '006674', '006675', '006678'))
	)
	SELECT
		  LTRIM(RTRIM(OV.[OBJECT_ID])) [OBJECT_ID],
		  LTRIM(RTRIM(OV.VEH_YEAR)) [VEH_YEAR],
		  LTRIM(RTRIM(OV.VEH_MAKE)) [VEH_MAKE],
		  LTRIM(RTRIM(OV.VEH_MODEL)) [VEH_MODEL],
		  ISNULL(LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30), '') [EquipmentType]
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
	ORDER BY OV.[OBJECT_ID]
 
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
