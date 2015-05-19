-- =============================================================================
-- Created By:	Chris Buck
-- Create Date:	04/30/2015
-- Description: Creates/modifies the TransformComponentVehicle stored procedure.
-- =============================================================================

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spTransformComponent') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformComponent AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformComponent
AS
BEGIN
	CREATE TABLE #Components(
		[Object_ID] [varchar] (10) NOT NULL,
		[Control] [varchar] (10) NOT NULL,
		[AssetID] [varchar](20) NOT NULL,
		[Description] [varchar](40) NULL,
		[ModelYear] [int] NULL,
		[ManufacturerID] [varchar](15) NULL,
		[ModelID] [varchar](15) NULL,
		[EquipmentType] [varchar](30) NULL,
		[SerialNumber] [varchar](50) NULL,
		[PMProgramType] [varchar](10) NULL,
		[AssetNumber] [varchar](20) NULL,
		[MeterTypesClass] [varchar](30) NULL,
		[Meter1Type] [varchar](10) NULL,
		[Meter1AtDelivery] [int] NULL,
		[LatestMeter1Reading] [int] NULL,
		[MaxMeter1Value] [int] NULL,
		[Meter2Type] [varchar](10) NULL,
		[Meter2AtDelivery] [int] NULL,
		[MaxMeter2Value] [int] NULL,
		[Maintenance] [varchar](30) NULL,
		[PMClass] [varchar](30) NULL,
		[Standards] [varchar](30) NULL,
		[RentalRates] [varchar](30) NULL,
		[Resources] [varchar](30) NULL,
		[AssetCategoryID] [varchar](15) NULL,
		[AssignedPM] [varchar] (10) NOT NULL,
		[AssignedRepair] [varchar] (10) NOT NULL,
		[StoredLocation] [varchar](10) NULL,
		[PreferredPMShift] [varchar](10) NULL,
		[StationLocation] [varchar](10) NULL,
		[DepartmentID] [varchar](10) NULL,
		[DepartmentForPM] [varchar](10) NULL,
		[AccountIDWO] [varchar](10) NULL,
		[AccountIDLabor] [varchar](10) NULL,
		[AccountIDPart] [varchar](10) NULL,
		[AccountIDCommercial] [varchar](10) NULL,
		[AccountIDFuel] [varchar](10) NULL,
		[AccountIDUsage] [varchar](10) NULL,
		[LifeCycleStatusCodeID] [varchar](10) NULL,
		[ConditionRating] [varchar](20) NULL,
		[WorkOrders] [char](1) NULL,
		[UsageTickets] [char](1) NULL,
		[FuelTickets] [char](1) NULL,
		[FuelCardID] [varchar] (12) NULL,
		[NextPMServiceNumber] [int] NULL,
		[NextPMDueDate] [datetime] NULL,
		[DefaultWOPriorityID] [varchar](2) NULL,
		[ActualDeliveryDate] [datetime] NULL,
		[ActualInServiceDate] [datetime] NULL,
		[OriginalCost] [decimal](22, 2) NULL,
		[DepreciationMethod] [varchar] (25) NULL,
		[LifeMonths] [int] NULL,
		[Ownership] [varchar](8) NULL
	)

	INSERT INTO #Components
	SELECT
		LTRIM(RTRIM(OV.[OBJECT_ID])) [OBJECT_ID],
		'[i]' [Control],
		'GS' + CAST((CAST(OV.[OBJECT_ID] AS INT)) AS VARCHAR) [AssetID],
		LTRIM(RTRIM(OV.VEH_DESC)) [Description],
		NULL [ModelYear],
		'' [ManufacturerID],
		'' [ModelID],
		'' [EquipmentType],
		CASE
			WHEN ISNULL(LTRIM(RTRIM(OV.SERIAL_NO)), '') = ''
				THEN 'GS' + CAST((CAST(OV.[OBJECT_ID] AS INT)) AS VARCHAR)
			WHEN LTRIM(RTRIM(OV.SERIAL_NO)) = 'N/A'
				THEN 'GS' + CAST((CAST(OV.[OBJECT_ID] AS INT)) AS VARCHAR)
			ELSE LTRIM(RTRIM(OV.SERIAL_NO))
		END [SerialNumber],
		'CLASS' [PMProgramType],
		'GS' + CAST((CAST(OV.[OBJECT_ID] AS INT)) AS VARCHAR) [AssetNumber],
		'' [MeterTypesClass],
		'' [Meter1Type],
		NULL [Meter1AtDelivery],
		ISNULL(OV.MILES_CURR, NULL) [LatestMeter1Reading],
		NULL [MaxMeter1Value],
		'' [Meter2Type],
		NULL [Meter2AtDelivery],
		NULL [MaxMeter2Value],
		'' [Maintenance],
		'' [PMClass],
		'' [Standards],
		'' [RentalRates],
		'' [Resources],
		'SPECIALTY' AssetCategoryID,
		'SE SHOP' AssignedPM,
		'SE SHOP' AssignedRepair,
		'' [StoredLocation],
		'DAY' [PreferredPMShift],
		'' [StationLocation],
		'' [DepartmentID],
		'' [DepartmentForPM],
		'' [AccountIDWO],
		'' [AccountIDLabor],
		'' [AccountIDPart],
		'' [AccountIDCommercial],
		'' [AccountIDFuel],
		'' [AccountIDUsage],
		CASE
			WHEN (OV.[DRIVER] LIKE '%SURPLUS%') THEN 'R'
			ELSE 'A'
		END [LifeCycleStatusCodeID],
		'' [ConditionRating],
		'Y' [WorkOrders],
		'N' [UsageTickets],
		'N' [FuelTickets],
		'' [FuelCardID],
		NULL [NextPMServiceNumber],
		NULL [NextPMDueDate],
		'V3' [DefaultWOPriorityID],
		CASE
			WHEN ISDATE(OV.ACQ_DATE) = 1 THEN CAST(OV.ACQ_DATE AS DATETIME)
			ELSE NULL
		END [ActualDeliveryDate],
		NULL [ActualInServiceDate],
		ISNULL(OV.ACQ_COST, NULL) [OriginalCost],
		'' [DepreciationMethod],
		ISNULL(OV.LIFE_EXP, NULL) [LifeMonths],
		'OWNED' [Ownership]
	FROM SourceWicm210ObjectVehicle OV
	WHERE
		(OV.[OBJECT_ID] IN (SELECT WICM_OBJID FROM TransformEquipmentVehicleValueSpecialEquipmentDetails))
		AND (OV.[OBJECT_ID] NOT IN ('006658', '006659', '006660', '006661', '006662', '006663',
			'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
			'006673', '006674', '006675'))

	-- Special Equipment specific updates
	UPDATE #Components
	SET
		ModelYear = LTRIM(RTRIM(vehdet.AW_YEAR)),
		AssetCategoryID = 'SPECIALTY',
		StationLocation = vehdet.AW_LOCATION,
		DepartmentID = LEFT(ISNULL(vehdet.[AW_PROGRAM], ''), 10),
		DepartmentForPM = LEFT(ISNULL(vehdet.[AW_PROGRAM], ''), 10)
	FROM #Components OV
		INNER JOIN TransformEquipmentVehicleValueSpecialEquipmentDetails vehdet
			ON OV.[Object_ID] = vehdet.[WICM_OBJID]

	-- ManufacturerID & ModelID Cleansing
	UPDATE #Components
	SET
		ManufacturerID = ISNULL(manid.TargetValue, ''),
		ModelID = ISNULL(modid.CleansedModelID, '')
	FROM #Components vehs
		INNER JOIN SourceWicm210ObjectVehicle OV ON vehs.[Object_ID] = OV.[OBJECT_ID]
		INNER JOIN TransformEquipmentManufacturer manid
			ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue
				AND manid.[Source] LIKE '%Vehicles%'
		INNER JOIN TransformEquipmentManufacturerModel modid
			ON LTRIM(RTRIM(manid.[TargetValue])) = LTRIM(RTRIM(modid.CleansedManufacturerID))
				AND LTRIM(RTRIM(OV.[VEH_MODEL])) = LTRIM(RTRIM(modid.SourceModelID))
				AND modid.[Source] = 'Vehicles'
					
	-- EquipmentClass & EquimentType Cleansing
	UPDATE #Components
	SET
		EquipmentType = LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30),
		MeterTypesClass = 
			CASE
				WHEN tec.MeterTypes = 'Y' THEN LEFT(LTRIM(RTRIM(vec.EquipmentClassID)), 30)
				ELSE 'NO METER'
			END,
		Meter1Type = LEFT(LTRIM(RTRIM(ISNULL(tec.Meter1Type, ''))), 10),
		MaxMeter1Value =
			CASE
				WHEN LEFT(LTRIM(RTRIM(ISNULL(tec.Meter1Type, ''))), 10) = 'Miles' THEN '999999'
				WHEN LEFT(LTRIM(RTRIM(ISNULL(tec.Meter1Type, ''))), 10) = 'Hours' THEN '99999'
				ELSE NULL
			END,
		Meter2Type = LEFT(LTRIM(RTRIM(ISNULL(tec.Meter2Type, ''))), 10),
		MaxMeter2Value =
			CASE
				WHEN LEFT(LTRIM(RTRIM(ISNULL(tec.Meter2Type, ''))), 10) = 'Miles' THEN '999999'
				WHEN LEFT(LTRIM(RTRIM(ISNULL(tec.Meter2Type, ''))), 10) = 'Hours' THEN '99999'
				ELSE NULL
			END,
		PMClass = LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30),
		Maintenance = LEFT(LTRIM(RTRIM(vec.EquipmentClassID)), 30),
		Standards = LEFT(LTRIM(RTRIM(vec.EquipmentClassID)), 30),
		RentalRates = LEFT(LTRIM(RTRIM(vec.EquipmentClassID)), 30),
		Resources = LEFT(LTRIM(RTRIM(vec.EquipmentClassID)), 30)
	FROM #Components vehs
		INNER JOIN SourceWicm210ObjectVehicle OV ON vehs.[Object_ID] = OV.[OBJECT_ID]
		INNER JOIN TransformObjectVehicleValueEquipmentClass vec
			ON LTRIM(RTRIM(OV.CLASS)) = vec.WICM_CLASS
				AND LTRIM(RTRIM(OV.VEH_MAKE)) = vec.WICM_VEH_MAKE
				AND LTRIM(RTRIM(OV.VEH_MODEL)) = vec.WICM_VEH_MODEL
		INNER JOIN TransformEquipmentClass tec ON vec.EquipmentClassID = tec.EquipmentClassID
		INNER JOIN (
			SELECT DISTINCT VEH_YEAR, VEH_MAKE, VEH_MODEL, EquipmentClass, EquipmentType
			FROM TransformEquipmentVehicleValueEquipmentType
			) vet
			ON vehs.ManufacturerID = vet.VEH_MAKE
				AND vehs.ModelID = vet.VEH_MODEL
				AND vehs.ModelYear = vet.VEH_YEAR
				AND vec.EquipmentClassID = vet.EquipmentClass

	INSERT INTO TransformComponent
	SELECT
		[Control],
		[AssetID],
		[Description],
		[ModelYear],
		[ManufacturerID],
		[ModelID],
		[EquipmentType],
		[SerialNumber],
		[PMProgramType],
		[AssetNumber],
		[MeterTypesClass],
		[Meter1Type],
		[Meter1AtDelivery],
		[LatestMeter1Reading],
		[MaxMeter1Value],
		[Meter2Type],
		[Meter2AtDelivery],
		[MaxMeter2Value],
		[Maintenance],
		[PMClass],
		[Standards],
		[RentalRates],
		[Resources],
		[AssetCategoryID],
		[AssignedPM],
		[AssignedRepair],
		[StoredLocation],
		[PreferredPMShift],
		[StationLocation],
		[DepartmentID],
		[DepartmentForPM],
		[AccountIDWO],
		[AccountIDLabor],
		[AccountIDPart],
		[AccountIDCommercial],
		[AccountIDFuel],
		[AccountIDUsage],
		[LifeCycleStatusCodeID],
		[ConditionRating],
		[WorkOrders],
		[UsageTickets],
		[FuelTickets],
		[FuelCardID],
		[NextPMServiceNumber],
		[NextPMDueDate],
		[DefaultWOPriorityID],
		[ActualDeliveryDate],
		[ActualInServiceDate],
		[OriginalCost],
		[DepreciationMethod],
		[LifeMonths],
		[Ownership]
	FROM #Components vehs
	ORDER BY vehs.AssetID

	-- Vehicles to the crosswalk table.
	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		vehs.AssetID [EquipmentID],
		'SourceWicm210ObjectVehicle' [Source],
		'OBJECT_ID' [LegacyIDSource],
		vehs.[Object_ID] [LegacyID]
	FROM #Components vehs
END

-- Clean up
IF OBJECT_ID('tempdb..#Components') IS NOT NULL
	DROP TABLE #Components
