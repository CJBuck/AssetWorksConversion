--USE [AssetWorksConversion]
--
WITH ExtractName AS (
	SELECT '1' [ID], 'SourcePups201Hydrant' [ExtractName]
	UNION ALL
	SELECT '2' [ID], 'SourcePups201Valve' [ExtractName]
	UNION ALL
	SELECT '3', 'SourceWicm210ObjectEquipment'
	UNION ALL
	SELECT '4', 'SourceWicm210ObjectVehicle'
	UNION ALL
	SELECT '5', 'SourceWicm210ObjectProject'
	UNION ALL
	SELECT '6', 'SourceWicm210ObjectVehicle'
	UNION ALL
	SELECT '7', 'SourceWicm220PartsHeader'
	UNION ALL
	SELECT '8', 'SourceWicm221PartsDetail'
	UNION ALL
	SELECT '9', 'Shawn''s Spreadsheet (Table ShawnsXLS)'
	UNION ALL
	SELECT '10', 'SourceWicm220PartsHeader'
),
ExtractCounts AS (
	SELECT '1' [ID], COUNT(HYD_NO) [NoInExtract]
	FROM SourcePups201Hydrant
	UNION ALL
	SELECT '2', COUNT(VALVE_NO)
	FROM SourcePups201Valve
	UNION ALL
	SELECT '3', COUNT([OBJECT_ID])
	FROM SourceWicm210ObjectEquipment
	UNION ALL
	SELECT '4', COUNT([OBJECT_ID])
	FROM SourceWicm210ObjectVehicle
	UNION ALL
	SELECT '5', COUNT([OBJECT_ID])
	FROM SourceWicm210ObjectProject
	UNION ALL
	SELECT '6', COUNT([OBJECT_ID])
	FROM SourceWicm210ObjectVehicle
	UNION ALL
	SELECT '7', COUNT(PART_NO)
	FROM SourceWicm220PartsHeader
	UNION ALL
	SELECT '8', COUNT(PART_NO)
	FROM SourceWicm221PartsDetail
	UNION ALL
	SELECT '9', COUNT(PartNo)
	FROM ShawnsXLS
	UNION ALL
	SELECT '10', COUNT(PART_NO)
	FROM SourceWicm220PartsHeader
),
TargetTableName AS (
	SELECT '1' [ID], 'TargetEquipment' [TargetTableName]
	UNION ALL
	SELECT '2' [ID], 'TargetEquipment' [TargetTableName]
	UNION ALL
	SELECT '3' [ID], 'TargetEquipment' [TargetTableName]
	UNION ALL
	SELECT '4' [ID], 'TargetEquipment' [TargetTableName]
	UNION ALL
	SELECT '5' [ID], 'TargetEquipment' [TargetTableName]
	UNION ALL
	SELECT '6', 'TargetComponent'
	UNION ALL
	SELECT '7', 'TargetPart'
	UNION ALL
	SELECT '8', 'TargetPartLocation'
	UNION ALL
	SELECT '9', 'TargetPartLocationBin'
	UNION ALL
	SELECT '10', 'TargetPartAdjustment'
),
TargetTableCounts AS (
	SELECT '1' [ID], COUNT(EquipmentID) [NoInTargetTable]
	FROM TargetEquipment WHERE EquipmentID LIKE 'HYD%'
	UNION ALL
	SELECT '2' [ID], COUNT(EquipmentID) [NoInTargetTable]
	FROM TargetEquipment WHERE EquipmentID LIKE 'VLV%'
	UNION ALL
	SELECT '3' [ID], COUNT(TE.EquipmentID) [NoInTargetTable]
	FROM TargetEquipment TE
		INNER JOIN TransformEquipmentLegacyXwalk xw ON TE.EquipmentID = xw.EquipmentID
	WHERE xw.[Source] = 'SourceWicm210ObjectEquipment'
	UNION ALL
	SELECT '4' [ID], COUNT(TE.EquipmentID) [NoInTargetTable]
	FROM TargetEquipment TE
		INNER JOIN TransformEquipmentLegacyXwalk xw ON TE.EquipmentID = xw.EquipmentID
	WHERE TE.EquipmentID LIKE 'GS%'
		AND xw.[Source] = 'SourceWicm210ObjectVehicle'
	UNION ALL
	SELECT '5' [ID], COUNT(TE.EquipmentID) [NoInTargetTable]
	FROM TargetEquipment TE
		INNER JOIN TransformEquipmentLegacyXwalk xw ON TE.EquipmentID = xw.EquipmentID
	WHERE xw.[Source] = 'SourceWicm210ObjectProject'
	UNION ALL
	SELECT '6' [ID], COUNT(TC.AssetID) [NoInTargetTable]
	FROM TargetComponent TC
	UNION ALL
	SELECT '7', COUNT(PH.PartID)
	FROM TargetPart PH
	UNION ALL
	SELECT '8', COUNT(PL.PartID)
	FROM TargetPartLocation PL
	UNION ALL
	SELECT '9', COUNT(PLB.PartID)
	FROM TargetPartLocationBin PLb
	UNION ALL
	SELECT '10', COUNT(PartID)
	FROM TargetPartAdjustment
),
ExclusionLogic AS (
	SELECT '1' [ID], '([STATUS] IN (''A'', ''I'')) AND (HYD_SEQ# <> ''00'')''' [ExclusionLogic]
	UNION ALL
	SELECT '2', '([STATUS] = ''A'')
		OR (([STATUS] = ''I'') AND 
			([REMARK2] LIKE ''%proposed%'') OR ([REMARK2] LIKE ''%not yet installed%''))
		OR (
			BYPASS_CD = ''Y'')
			AND (
				([STATUS] = ''A'')
				OR (([STATUS] = ''I'') AND 
					([REMARK2] LIKE ''%proposed%'') OR ([REMARK2] LIKE ''%not yet installed%''))
				)
			)'
	UNION ALL
	SELECT '3',
		'[STATUS] = ''A'' AND LTRIM(RTRIM([CLASS])) NOT IN (''JAPS'', ''LHPL'', ''RDGDMT'')'''
	UNION ALL
	SELECT '4',
		'([OBJECT_ID] IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
		AND ([OBJECT_ID] NOT IN (''006658'', ''006659'', ''006660'', ''006661'', ''006662'', ''006663'',
			''006664'', ''006665'', ''006666'', ''006667'', ''006668'', ''006669'', ''006670'', ''006672'',
			''006673'', ''006674'', ''006675''))'
	UNION ALL
	SELECT '5' [ID],
		'([OBJECT_ID] NOT IN (''FRST'', ''OTHR'', ''SAFE'')
		AND LOCATION = ''04''
		AND [STATUS] = ''A''
		AND LTRIM(RTRIM([CLASS])) NOT IN (''LHTP'', ''WRKSTA'')) OR
		([OBJECT_ID] NOT IN (''FRST'', ''OTHR'', ''SAFE'')
		AND LOCATION = ''05''
		AND LTRIM(RTRIM([CLASS])) NOT IN (''LHTP'', ''WRKSTA''))'
	UNION ALL
	SELECT '6',
		'([OBJECT_ID] NOT IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
		AND ([OBJECT_ID] NOT IN (''006658'', ''006659'', ''006660'', ''006661'', ''006662'', ''006663'',
			''006664'', ''006665'', ''006666'', ''006667'', ''006668'', ''006669'', ''006670'', ''006672'',
			''006673'', ''006674'', ''006675''))'
	UNION ALL
	SELECT '7', ''
	UNION ALL
	SELECT '8', ''
	UNION ALL
	SELECT '9', ''
	UNION ALL
	SELECT '10', ''
),
NoExcluded AS (
	SELECT '1' [ID], COUNT(H.HYD_NO) [Excluded]
	FROM SourcePups201Hydrant H
	WHERE (H.[STATUS] NOT IN ('A', 'I')) OR (H.HYD_SEQ# <> '00')
	UNION ALL
	SELECT '2' [ID], COUNT(V.VALVE_NO) [Excluded]
	FROM SourcePups201Valve V
	WHERE V.VALVE_NO NOT IN (
		SELECT SPV.VALVE_NO
		FROM SourcePups201Valve SPV
		WHERE
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
	UNION ALL
	SELECT '3', COUNT(OE.[OBJECT_ID])
	FROM SourceWicm210ObjectEquipment OE
	WHERE
		(OE.[STATUS] <> 'A') OR (LTRIM(RTRIM(OE.[CLASS])) IN ('JAPS', 'LHPL', 'RDGDMT'))
	UNION ALL
	SELECT '4', COUNT(OV.[OBJECT_ID])
	FROM SourceWicm210ObjectVehicle OV
	WHERE
		(OV.[OBJECT_ID] NOT IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
		OR (OV.[OBJECT_ID] IN ('006658', '006659', '006660', '006661', '006662', '006663',
			'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
			'006673', '006674', '006675'))
	UNION ALL
	SELECT '5', COUNT(OP.[OBJECT_ID])
	FROM SourceWicm210ObjectProject OP
	WHERE LTRIM(RTRIM(OP.[OBJECT_ID])) NOT IN (
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
	AND LTRIM(RTRIM(OP.[OBJECT_ID])) NOT IN (
		SELECT DISTINCT LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID]
		FROM SourceWicm210ObjectProject OP
		WHERE
			OP.[OBJECT_ID] NOT IN ('FRST', 'OTHR', 'SAFE')
			AND OP.LOCATION = '05'
			AND LTRIM(RTRIM(OP.[CLASS])) NOT IN ('LHTP', 'WRKSTA')
	)
	UNION ALL
	SELECT '6', COUNT(OV.[OBJECT_ID])
	FROM SourceWicm210ObjectVehicle OV
	WHERE
		(OV.[OBJECT_ID] IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
		OR (OV.[OBJECT_ID] IN ('006658', '006659', '006660', '006661', '006662', '006663',
			'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
			'006673', '006674', '006675'))
	UNION ALL
	SELECT '7', '0'
	UNION ALL
	SELECT '8', '0'
	UNION ALL
	SELECT '9', '0'
	UNION ALL
	SELECT '10', ''
),
MissingReqdFields AS (
	SELECT '1' [ID], COUNT(TE.EquipmentID) [MissingReqdFields]
	FROM TransformEquipment TE
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON TE.EquipmentID = xwalk.EquipmentID
	WHERE
		(TE.EquipmentID LIKE 'HYD%') AND (
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
		)
	UNION ALL
	SELECT '2' [ID], COUNT(TE.EquipmentID) [MissingReqdFields]
	FROM TransformEquipment TE
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON TE.EquipmentID = xwalk.EquipmentID
	WHERE
		(TE.EquipmentID LIKE 'VLV%') AND (
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
		)
	UNION ALL
	SELECT '3' [ID], COUNT(TE.EquipmentID) [MissingReqdFields]
	FROM TransformEquipment TE
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON TE.EquipmentID = xwalk.EquipmentID
			AND xwalk.[Source] = 'SourceWicm210ObjectEquipment'
	WHERE
		(TE.EquipmentID LIKE 'EQP%') AND (
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
		)
	UNION ALL
	SELECT '4' [ID], COUNT(TE.EquipmentID) [MissingReqdFields]
	FROM TransformEquipment TE
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON TE.EquipmentID = xwalk.EquipmentID
	WHERE
		(TE.EquipmentID LIKE 'GS%') AND (
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
		)
	UNION ALL
	SELECT '5' [ID], COUNT(TE.EquipmentID) [MissingReqdFields]
	FROM TransformEquipment TE
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON TE.EquipmentID = xwalk.EquipmentID
			AND xwalk.[Source] = 'SourceWicm210ObjectProject'
	WHERE
		((TE.EquipmentID LIKE 'EQP%') OR (TE.EquipmentID LIKE 'PRJ%'))
		AND (
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
		)
	UNION ALL
	SELECT '6' [ID], COUNT(TC.AssetID) [MissingReqdFields]
	FROM TransformComponent TC
	WHERE
		(ISNULL(TC.[Control], '') = ''
			OR ISNULL(TC.AssetID, '') = ''
			OR ISNULL(TC.[Description], '') = ''
			OR ISNULL(TC.ModelYear, '') = ''
			OR ISNULL(TC.ManufacturerID, '') = ''
			OR ISNULL(TC.ModelID, '') = ''
			OR ISNULL(TC.EquipmentType, '') = ''
			OR ISNULL(TC.PMProgramType, '') = ''
			OR ISNULL(TC.MeterTypesClass, '') = ''
			OR ISNULL(TC.Maintenance, '') = ''
			OR ISNULL(TC.PMClass, '') = ''
			OR ISNULL(TC.Standards, '') = ''
			OR ISNULL(TC.RentalRates, '') = ''
			OR ISNULL(TC.Resources, '') = ''
			OR ISNULL(TC.AssetCategoryID, '') = ''
			OR ISNULL(TC.AssignedPM, '') = ''
			OR ISNULL(TC.AssignedRepair, '') = ''
			OR ISNULL(TC.PreferredPMShift, '') = ''
			OR ISNULL(TC.StationLocation, '') = ''
			OR ISNULL(TC.DepartmentID, '') = ''
			OR ISNULL(TC.DepartmentForPM, '') = ''
			OR ISNULL(TC.WorkOrders, '') = '')
	UNION ALL
	SELECT '7', COUNT(PartID)
	FROM TransformPart
	WHERE
		ISNULL(PartID, '') = ''
		OR ISNULL(PartSuffix, 99999) = 99999
		OR ISNULL(Keyword, '') = ''
		OR ISNULL(ShortDescription, '') = ''
		OR ISNULL(ProductCategoryID, '') = ''
		OR ISNULL(PartClassificationID, '') = ''
	UNION ALL
	-- PartLocation
	SELECT '8', COUNT(PartID)
	FROM TransformPartLocation
	WHERE
		ISNULL(PartID, '') = ''
		OR ISNULL(PartSuffix, 99999) = 99999
		OR ISNULL(InventoryLocation, '') = ''
		OR ISNULL(UnitOfMeasure, '') = ''
		OR ISNULL(Manufacturer, '') = ''
	-- PartLocationBin
	UNION ALL
	SELECT '9', COUNT(PartID)
	FROM TransformPartLocationBin
	WHERE
		ISNULL(PartID, '') = ''
		OR ISNULL(LocationID, '') = ''
		OR ISNULL(BinID, '') = ''
	UNION ALL
	SELECT '10', COUNT(PartID)
	FROM TransformPartAdjustment
	WHERE
		ISNULL(PartID, '') = ''
		OR ISNULL(LocationID, '') = ''
),
FailedValidation AS (
	SELECT '1' [ID], COUNT(DISTINCT HydNos.HYD_NO) [FailedValidation]
	FROM
		(
			(SELECT H.HYD_NO FROM SourcePups201Hydrant H
			WHERE
				LTRIM(RTRIM(H.HYD_MAKE)) NOT IN (
					SELECT LTRIM(RTRIM([SourceValue])) FROM TransformEquipmentManufacturer
				)
				AND ((H.[STATUS] IN ('A', 'I')) AND (H.HYD_SEQ# = '00'))
			)
			UNION ALL
			(
				SELECT H.HYD_NO FROM SourcePups201Hydrant H
				WHERE LTRIM(RTRIM(H.HYD_MAKE)) NOT IN (
					SELECT LTRIM(RTRIM([SourceValue]))
					FROM TransformEquipmentManufacturer
					) AND ISNULL(H.HYD_MAKE, '') <> ''
			)
			UNION ALL
			(
				SELECT LTRIM(RTRIM(H.HYD_NO)) [HYD_NO]
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
			)
		
		) HydNos
	UNION ALL
	SELECT '2' [ID], COUNT(DISTINCT ValveNos.VALVE_NO) [FailedValidation]
	FROM
		(
			(SELECT SPV.VALVE_NO
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
			)
			UNION ALL
			(
				SELECT LTRIM(RTRIM(ValveEqType.VALVE_NO)) [VALVE_NO]
				FROM (
					SELECT SPV.VALVE_NO, 
						CASE
							WHEN SPV.VALVE_NO IN ('028539', '028540') THEN 'DVL REG SURGE'
							WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'BALL' AND VLV_SIZE < 16 THEN 'DVL ISO BALL SMALL DIA'
							WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'BUTTERFLY' AND VLV_SIZE >= 16 THEN 'DVL ISO BUTTERFLY LARGE DIA'
							WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'BUTTERFLY' AND VLV_SIZE < 16 THEN 'DVL ISO BUTTERFLY SMALL DIA'
							WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'GATE' AND VLV_SIZE >= 16 THEN 'DVL ISO GATE LARGE DIA'
							WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'UNKNOWN' AND VLV_SIZE >= 16 THEN 'DVL ISO GATE LARGE DIA'
							WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'UNKNOWN' AND VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
							WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'GATE' AND VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
							WHEN SPV.VLV_FUNCTION = '03' AND SPV.VLV_TYPE = 'GATE' AND VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
							WHEN SPV.VLV_FUNCTION = '03' AND SPV.VLV_TYPE = 'UNKNOWN' AND VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
							WHEN SPV.VLV_FUNCTION = '04' AND SPV.VLV_MAKE NOT LIKE 'GIL%' AND VLV_SIZE = '02' THEN 'DBF CHECK/GATE'
							WHEN SPV.VLV_FUNCTION = '04' AND SPV.VLV_MAKE LIKE 'GIL%' AND VLV_SIZE = '02' THEN 'DBF FLSH HYD'
							WHEN SPV.VLV_FUNCTION = '04' AND VLV_SIZE > '02' THEN 'DBF DRAIN'
							WHEN SPV.VLV_FUNCTION = '05' AND SPV.VLV_TYPE = 'AIR RELEAS' THEN 'DAR AIR RELEASE AUTO'
							WHEN SPV.VLV_FUNCTION = '05' AND SPV.VLV_TYPE IN ('GATE', 'MANUAL', 'UNKNOWN') THEN 'DAR AIR RELEASE MANUAL'
							WHEN SPV.VLV_FUNCTION = '05' AND SPV.VLV_TYPE = 'COMBINATIO' THEN 'DAR COMBINATION'
							WHEN SPV.VLV_FUNCTION = '06' AND SPV.VLV_TYPE IN ('GATE', 'UNKNOWN') AND SPV.VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
							WHEN SPV.VLV_FUNCTION = '06' AND SPV.VLV_SIZE >= 16 THEN 'DVL ISO BUTTERFLY LARGE DIA'
							WHEN SPV.VLV_FUNCTION = '07' AND SPV.VLV_TYPE = 'CHECK' AND SPV.VALVE_NO NOT IN ('028539', '028540') THEN 'DVL REG CHECK'
							WHEN SPV.VLV_FUNCTION = '07' AND SPV.VLV_TYPE = 'PRV' AND SPV.VALVE_NO NOT IN ('028539', '028540') THEN 'DVL REG PRV'
							WHEN SPV.VLV_FUNCTION = '08' AND SPV.VLV_TYPE IN ('BUTTERFLY', 'GATE') AND SPV.VLV_SIZE >= 16 THEN 'DVL ISO BUTTERFLY LARGE DIA'
							WHEN SPV.VLV_FUNCTION = '08' AND SPV.VLV_TYPE = 'BUTTERFLY' AND SPV.VLV_SIZE < 16 THEN 'DVL ISO BUTTERFLY SMALL DIA'
							WHEN SPV.VLV_FUNCTION = '08' AND SPV.VLV_TYPE IN ('BUTTERFLY', 'GATE', 'UNKNOWN') AND SPV.VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
							WHEN SPV.VLV_FUNCTION = '10' AND SPV.VLV_TYPE IN ('GATE', 'UNKNOWN') AND SPV.VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
							ELSE ''
						END [EquipmentType]
					FROM SourcePups201Valve SPV
				) ValveEqType
				WHERE ValveEqType.EquipmentType = ''
			)
		) ValveNos
	UNION ALL
	SELECT '3', COUNT(DISTINCT Facs.[OBJECT_ID])
	FROM
		(
			(SELECT OE.[OBJECT_ID]
			FROM SourceWicm210ObjectEquipment OE
			-- ManufacturerID Cleansing
			WHERE
				OE.[STATUS] = 'A' AND OE.[CLASS] NOT IN ('JAPS', 'LHPL', 'RDGDMT')
				AND LEFT(LTRIM(RTRIM(OE.MFR_NAME)), 15) NOT IN (
					SELECT DISTINCT LEFT(LTRIM(RTRIM([SourceValue])), 15)
					FROM  TransformEquipmentManufacturer
					WHERE [Source] LIKE '%Facilities%')	)
			UNION ALL
			(SELECT SWOE.[OBJECT_ID]
			FROM SourceWicm210ObjectEquipment SWOE
			WHERE SWOE.[OBJECT_ID] NOT IN (
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
				AND SWOE.[STATUS] = 'A' AND SWOE.[CLASS] NOT IN ('JAPS', 'LHPL', 'RDGDMT') )
			UNION ALL
			(
				SELECT DISTINCT [OBJECT_ID]
				FROM (
					SELECT OE.[OBJECT_ID], ISNULL(LTRIM(RTRIM(modid.ModelName)), '') [EquipmentType]
					FROM SourceWicm210ObjectEquipment OE
						LEFT JOIN TransformEquipmentManufacturer midc
							ON LEFT(LTRIM(RTRIM(OE.MFR_NAME)), 15) = LEFT(LTRIM(RTRIM(midc.[SourceValue])), 15)
								AND midc.[Source] LIKE '%Facilities%'
						-- ModelID Cleansing
						LEFT JOIN TransformEquipmentManufacturerModel modid
							ON LEFT(LTRIM(RTRIM(midc.[TargetValue])), 15) = modid.CleansedManufacturerID
								AND LTRIM(RTRIM(OE.FAC_MODEL)) = LTRIM(RTRIM(modid.SourceModelID))
					WHERE
						OE.[STATUS] = 'A' AND LTRIM(RTRIM(OE.[CLASS])) NOT IN ('JAPS', 'LHPL', 'RDGDMT')
					UNION ALL
					SELECT OE.[OBJECT_ID], ISNULL(LTRIM(RTRIM(et.[EquipType])), '') [EquipmentType]
					FROM SourceWicm210ObjectEquipment OE
						LEFT JOIN TransformEquipmentFacilitiesEquipmentValueEquipmentType et
							ON LTRIM(RTRIM(OE.[Object_ID])) = LTRIM(RTRIM(et.[OBJECT_ID]))
					WHERE
						OE.[STATUS] = 'A' AND LTRIM(RTRIM(OE.[CLASS])) NOT IN ('JAPS', 'LHPL', 'RDGDMT')
						AND LTRIM(RTRIM(oe.FAC_MODEL)) = 'NA'
					UNION ALL
					SELECT OE.[OBJECT_ID], ISNULL(LTRIM(RTRIM((LTRIM(RTRIM(oe.MFR_NAME)) + LTRIM(RTRIM(oe.ASSET_TYPE))))), '') [EquipmentType]
					FROM SourceWicm210ObjectEquipment OE
					WHERE
						OE.[Object_ID] NOT IN (SELECT [OBJECT_ID] FROM TransformEquipmentFacilitiesEquipmentValueEquipmentType)
						AND LTRIM(RTRIM(oe.FAC_MODEL)) = 'NA'
					) eqtype1
				WHERE eqtype1.EquipmentType = ''
			)
		) Facs
	UNION ALL
	SELECT '4', COUNT(DISTINCT vehs.[OBJECT_ID])
	FROM
		(
			(SELECT OV.[OBJECT_ID]
			FROM SourceWicm210ObjectVehicle OV
				INNER JOIN TransformEquipmentManufacturer manid
					ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue
						AND manid.[Source] LIKE '%Vehicles%'
			WHERE
				(OV.[OBJECT_ID] IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
				AND (OV.[OBJECT_ID] NOT IN ('006658', '006659', '006660', '006661', '006662', '006663',
					'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
					'006673', '006674', '006675'))
				AND LEFT(LTRIM(RTRIM(OV.VEH_MAKE)), 15) NOT IN (
					SELECT DISTINCT LEFT(LTRIM(RTRIM([SourceValue])), 15)
					FROM  TransformEquipmentManufacturer
					WHERE [Source] LIKE '%Vehicles%')	)
			UNION ALL
			(SELECT [OBJECT_ID]
			FROM SourceWicm210ObjectVehicle
			WHERE [OBJECT_ID] NOT IN (
				SELECT OV.[OBJECT_ID]
				FROM SourceWicm210ObjectVehicle OV
					INNER JOIN TransformEquipmentManufacturer manid
						ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue
							AND manid.[Source] LIKE '%Vehicles%'
					INNER JOIN TransformEquipmentManufacturerModel modid
						ON LTRIM(RTRIM(manid.[TargetValue])) = LTRIM(RTRIM(modid.CleansedManufacturerID))
							AND LTRIM(RTRIM(OV.[VEH_MODEL])) = LTRIM(RTRIM(modid.SourceModelID))
							AND modid.[Source] = 'Vehicles'
			)
			AND ([OBJECT_ID] IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
			AND ([OBJECT_ID] NOT IN ('006658', '006659', '006660', '006661', '006662', '006663',
				'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
				'006673', '006674', '006675'))	)
		) vehs
	UNION ALL
	SELECT '5', COUNT(DISTINCT projs.[OBJECT_ID])
	FROM (
			(SELECT [OBJECT_ID]
			FROM (
				SELECT OP.[OBJECT_ID], ISNULL(lkup.EquipmentType, '') [EquipmentType]
				FROM SourceWicm210ObjectProject OP
					INNER JOIN TransformEquipmentProjectValueAssetCategory lkup ON
						ISNULL(LTRIM(RTRIM(OP.CLASS)), '') = lkup.CLASS
				WHERE
					OP.[Object_ID] NOT IN (SELECT DISTINCT [OBJECT_ID] FROM TransformEquipmentProjectValueAssetCategory)
				UNION ALL
				SELECT OP.[OBJECT_ID], ISNULL(lkup.EquipmentType, '') [EquipmentType]
				FROM SourceWicm210ObjectProject OP
					INNER JOIN TransformEquipmentProjectValueAssetCategory lkup ON
						OP.[Object_ID] = lkup.[OBJECT_ID] AND lkup.[OBJECT_ID] <> 'RSDL'
				UNION ALL
				SELECT sp.[OBJECT_ID], ISNULL(lkup.EquipmentType, '') [EquipmentType]
				FROM TransformEquipmentProjectValueAssetCategory lkup
					INNER JOIN SourceWicm210ObjectProject sp on lkup.[OBJECT_ID] = sp.[Object_ID]
				WHERE sp.[Object_ID] = 'RSDL'

				) EqType
			WHERE EqType.EquipmentType = '')
	) projs
	UNION ALL
	SELECT '6', COUNT(DISTINCT comps.[OBJECT_ID])
	FROM (
			(SELECT OV.[OBJECT_ID]
			FROM SourceWicm210ObjectVehicle OV
				INNER JOIN TransformEquipmentManufacturer manid
					ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue AND manid.[Source] LIKE '%Vehicles%'
			WHERE
				(OV.[OBJECT_ID] NOT IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
				AND (OV.[OBJECT_ID] NOT IN ('006658', '006659', '006660', '006661', '006662', '006663',
					'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
					'006673', '006674', '006675'))
						AND LEFT(LTRIM(RTRIM(OV.VEH_MAKE)), 15) NOT IN (
							SELECT DISTINCT LEFT(LTRIM(RTRIM([SourceValue])), 15)
							FROM  TransformEquipmentManufacturer
							WHERE [Source] LIKE '%Vehicles%')	)
			UNION ALL
			(SELECT [OBJECT_ID]
			FROM SourceWicm210ObjectVehicle
			WHERE [OBJECT_ID] NOT IN (
				SELECT OV.[OBJECT_ID]
				FROM SourceWicm210ObjectVehicle OV
					INNER JOIN TransformEquipmentManufacturer manid
						ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue
							AND manid.[Source] LIKE '%Vehicles%'
					INNER JOIN TransformEquipmentManufacturerModel modid
						ON LTRIM(RTRIM(manid.[TargetValue])) = LTRIM(RTRIM(modid.CleansedManufacturerID))
							AND LTRIM(RTRIM(OV.[VEH_MODEL])) = LTRIM(RTRIM(modid.SourceModelID))
							AND modid.[Source] = 'Vehicles'
			)
			AND ([OBJECT_ID] NOT IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
			AND ([OBJECT_ID] NOT IN ('006658', '006659', '006660', '006661', '006662', '006663',
				'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
				'006673', '006674', '006675'))	)
	) comps
	UNION ALL
	SELECT '7', '0'
	UNION ALL
	SELECT '8', COUNT(DISTINCT PLs.PartID)
	FROM (
		(SELECT PartID
		FROM TransformPartLocation
		WHERE ISNULL(Manufacturer, '') NOT IN (
			SELECT DISTINCT TargetValue FROM TransformPartManufacturerLookup)	)

	) PLs
	UNION ALL
	SELECT '9', '0'
	UNION ALL
	SELECT '10', COUNT(PartAdj.PartID)
	FROM (
		SELECT
			LTRIM(RTRIM(PH.PART_NO)) AS [PartID],
			ISNULL(invLook.AW_InventoryLocation,'') [LocationID],
			0 [PartSuffix],
			'ADD' [Action],
			'QTY AT A DIFFERENT PRICE' [Adjustment Type],
			PD.QTY_ONHAND [Quantity],
			PH.PART_COST [UnitPrice]
		FROM SourceWicm220PartsHeader PH
			INNER JOIN SourceWicm221PartsDetail PD
				ON dbo.TRIM(PH.PART_NO) = dbo.TRIM(PD.PART_NO)
			LEFT JOIN TransformPartInventoryLocationLookup invLook
				ON PD.LOCATION = invLook.WICM_Location
		WHERE dbo.TRIM(PH.PART_NO) IN (SELECT PartID FROM TransformPart)
			AND CAST(PD.QTY_ONHAND AS NUMERIC(18,3)) > 0 
			AND ISNULL(invLook.IncludeInLoad,1) = 1
	) PartAdj
	WHERE ISNULL(PartAdj.LocationID, '') = ''
)
SELECT
	EN.[ID], EN.ExtractName, ec.NoInExtract, ttn.TargetTableName, ttc.NoInTargetTable,
	el.ExclusionLogic, ne.Excluded, mrf.MissingReqdFields,
	fv.FailedValidation, (ec.NoInExtract - ttc.NoInTargetTable) [Discrepancy]
FROM ExtractName EN
	INNER JOIN ExtractCounts ec ON EN.ID = ec.ID
	INNER JOIN TargetTableName ttn ON ec.ID = ttn.ID
	INNER JOIN TargetTableCounts ttc ON ttn.ID = ttc.ID
	INNER JOIN ExclusionLogic el ON ttc.ID = el.ID
	INNER JOIN NoExcluded ne ON el.ID = ne.ID
	INNER JOIN MissingReqdFields mrf ON ne.ID = mrf.ID
	INNER JOIN FailedValidation fv ON mrf.ID = fv.ID
