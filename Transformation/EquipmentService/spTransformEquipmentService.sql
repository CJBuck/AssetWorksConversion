-- ===============================================================================
-- Created By:	Chris Buck
-- Create Date:	06/23/2015
-- Description: Creates/modifies the spTransformEquipmentService stored procedure.
-- ===============================================================================

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spTransformEquipmentService') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformEquipmentService AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformEquipmentService
AS
BEGIN
	IF OBJECT_ID('tmp.EquipSvc') IS NOT NULL
		DROP TABLE tmp.EquipSvc

	CREATE TABLE tmp.EquipSvc(
		[Object_ID] [varchar] (10) NOT NULL,
		[Control] [varchar] (10) NOT NULL,
		[EquipmentID] [varchar](20) NOT NULL,
		[AssetType] [varchar](20) NOT NULL,
		[Description] [varchar](40) NOT NULL,
		[AssetNumber] [varchar](20) NULL,
		[SerialNumber] [varchar](50) NOT NULL,
		[EquipmentType] [varchar](30) NOT NULL,
		[PMProgramType] [varchar](10) NOT NULL,
		[ModelYear] [int] NOT NULL,
		[ManufacturerID] [varchar](15) NOT NULL,
		[ModelID] [varchar](15) NOT NULL,
		[MeterTypesClass] [varchar](30) NOT NULL,
		[Meter1Type] [varchar](10) NULL,
		[Meter2Type] [varchar](10) NULL,
		[Meter1AtDelivery] [int] NULL,
		[Meter2AtDelivery] [int] NULL,
		[LatestMeter1Reading] [int] NULL,
		[LatestMeter2Reading] [int] NULL,
		[MaxMeter1Value] [int] NULL,
		[MaxMeter2Value] [int] NULL,
		[Maintenance] [varchar](30) NOT NULL,
		[PMProgram] [varchar](30) NOT NULL,
		[Standards] [varchar](30) NOT NULL,
		[RentalRates] [varchar](30) NOT NULL,
		[Resources] [varchar](30) NOT NULL,
		[AssetCategoryID] [varchar](15) NOT NULL,
		[AssignedPM] [varchar](10) NOT NULL,
		[AssignedRepair] [varchar](10) NOT NULL,
		[StationLocation] [varchar](10) NOT NULL,
		[PreferredPMShift] [varchar](10) NOT NULL,
		[DepartmentID] [varchar](10) NOT NULL,
		[DeptToNotifyForPM] [varchar](10) NOT NULL,
		[CompanyID] [varchar](10) NULL,
		[AccountIDAssignmentWO] [varchar](10) NULL,
		[AccountIDLaborPosting] [varchar](10) NULL,
		[AccountIDPartIssues] [varchar](10) NULL,
		[AccountIDCommercialWork] [varchar](10) NULL,
		[AccountIDFuelTickets] [varchar](10) NULL,
		[AccountIDUsageTickets] [varchar](10) NULL,
		[LifeCycleStatusCodeID] [varchar](2) NOT NULL,
		[ConditionRating] [varchar](20) NULL,
		[StatusCodes] [varchar](6) NULL,
		[WorkOrders] [char](1) NOT NULL,
		[UsageTickets] [char](1) NULL,
		[FuelTickets] [char](1) NULL,
		[Comments] [varchar](1200) NULL,
		[DefaultWOPriorityID] [varchar](2) NOT NULL,
		[ActualDeliveryDate] [datetime] NULL,
		[ActualInServiceDate] [datetime] NULL,
		[OriginalCost] [decimal](22, 2) NULL,
		[DepreciationMethod] [varchar](25) NULL,
		[LifeMonths] [int] NULL,
		[Ownership] [varchar](8) NULL,
		[VendorID] [varchar](15) NULL,
		[ExpirationDate] [datetime] NULL,
		[Meter1Expiration] [int] NULL,
		[Meter2Expiration] [int] NULL,
		[Deductible] [decimal](22, 2) NULL,
		[WarrantyType] [varchar](60) NULL,
		[Comments2] [varchar](60) NULL,
		[EstimatedReplacementMonth] [int] NULL,
		[EstimatedReplacementYear] [int] NULL,
		[EstimatedReplacementCost] [decimal](22, 2) NULL,
		[PlannedRetirementDate] [datetime] NULL,
		[RetirementDate] [datetime] NULL,
		[DispositionDate] [datetime] NULL,
		[GrossSalePrice] [decimal](22, 2) NULL,
		[DisposalReason] [varchar](30) NULL,
		[DisposalMethod] [varchar](20) NULL,
		[DisposalAuthority] [varchar](6) NULL,
		[DisposalComments] [varchar](60) NULL
	)

	INSERT INTO tmp.EquipSvc
	SELECT
		LTRIM(RTRIM(OV.[OBJECT_ID])) [OBJECT_ID],
		'[i]' [Control],
		'SVC' + RIGHT(('0000000' + CAST((CAST(OV.[OBJECT_ID] AS INT)) AS VARCHAR)), 7) [EquipmentID],
		'STATIONARY' [AssetType],
		LTRIM(RTRIM(OV.VEH_DESC)) [Description],
		'' [AssetNumber],
		'SVC' + RIGHT(('0000000' + CAST((CAST(OV.[OBJECT_ID] AS INT)) AS VARCHAR)), 7) [SerialNumber],
		'' [EquipmentType],
		'NONE' [PMProgramType],
		NULL [ModelYear],
		'' [ManufacturerID],
		'' [ModelID],
		'GS' + CAST((CAST(OV.[OBJECT_ID] AS INT)) AS VARCHAR) [AssetNumber],
		'HFC' [MeterTypesClass],
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
		(OV.[OBJECT_ID] NOT IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
		AND (OV.[OBJECT_ID] NOT IN ('006658', '006659', '006660', '006661', '006662', '006663',
			'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
			'006673', '006674', '006675'))

	-- Special Equipment specific updates
	UPDATE tmp.EquipSvc
	SET
		ModelYear = LTRIM(RTRIM(vehdet.AW_YEAR)),
		AssetCategoryID = 'SPECIALTY',
		StationLocation = vehdet.AW_LOCATION,
		DepartmentID = LEFT(ISNULL(vehdet.[AW_PROGRAM], ''), 10)
	FROM tmp.EquipSvc OV
		INNER JOIN TransformEquipmentVehicleValueSpecialEquipmentDetails vehdet
			ON OV.[Object_ID] = vehdet.[WICM_OBJID]

	UPDATE tmp.EquipSvc
	SET
		ModelYear = LTRIM(RTRIM(vehdet.AW_YEAR)),
		AssetCategoryID = 'SPECIALTY',
		StationLocation = vehdet.AW_LOCATION,
		DepartmentID = LEFT(ISNULL(vehdet.[AW_PROGRAM], ''), 10)
	FROM tmp.EquipSvc OV
		INNER JOIN TransformEquipmentVehicleValueVehicleDetails vehdet
			ON OV.[Object_ID] = vehdet.[WICM_OBJID]

	-- ManufacturerID & ModelID Cleansing
	UPDATE tmp.EquipSvc
	SET
		ManufacturerID = ISNULL(manid.TargetValue, ''),
		ModelID = ISNULL(modid.CleansedModelID, '')
	FROM tmp.EquipSvc vehs
		INNER JOIN SourceWicm210ObjectVehicle OV ON vehs.[Object_ID] = OV.[OBJECT_ID]
		INNER JOIN TransformEquipmentManufacturer manid
			ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue
				AND manid.[Source] LIKE '%Vehicles%'
		INNER JOIN TransformEquipmentManufacturerModel modid
			ON LTRIM(RTRIM(manid.[TargetValue])) = LTRIM(RTRIM(modid.CleansedManufacturerID))
				AND LTRIM(RTRIM(OV.[VEH_MODEL])) = LTRIM(RTRIM(modid.SourceModelID))
				AND modid.[Source] = 'Vehicles'
					
	-- EquipmentClass & EquimentType Cleansing
	UPDATE tmp.EquipSvc
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
		Maintenance = LEFT(LTRIM(RTRIM(vec.EquipmentClassID)), 30),
		Standards = LEFT(LTRIM(RTRIM(vec.EquipmentClassID)), 30),
		RentalRates = LEFT(LTRIM(RTRIM(vec.EquipmentClassID)), 30),
		Resources = LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30)
	FROM tmp.EquipSvc vehs
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
				
	-- Meter Types Class
	UPDATE tmp.EquipSvc
	SET MeterTypesClass = 
		CASE
			WHEN ISNULL(mtc.MeterTypesClass, '') <> '' THEN mtc.MeterTypesClass
			ELSE 'NO METER'
		END
	FROM tmp.EquipSvc C
		LEFT JOIN TransformObjectVehicleValueMeterTypesClass mtc ON C.Maintenance = mtc.EquipmentClassID

	INSERT INTO TransformEquipmentService
	SELECT
		ES.[Control],
		[EquipmentID],
		[AssetType],
		[Description],
		[AssetNumber],
		[SerialNumber],
		[EquipmentType],
		[PMProgramType],
		[ModelYear],
		[ManufacturerID],
		[ModelID],
		[MeterTypesClass],
		[Meter1Type],
		[Meter2Type],
		[Meter1AtDelivery],
		[Meter2AtDelivery],
		[LatestMeter1Reading],
		[LatestMeter2Reading],
		[MaxMeter1Value],
		[MaxMeter2Value],
		[Maintenance],
		[PMProgram],
		[Standards],
		[RentalRates],
		[Resources],
		[AssetCategoryID],
		[AssignedPM],
		[AssignedRepair],
		[StationLocation],
		[PreferredPMShift],
		[DepartmentID],
		[DeptToNotifyForPM],
		[CompanyID],
		[AccountIDAssignmentWO],
		[AccountIDLaborPosting],
		[AccountIDPartIssues],
		[AccountIDCommercialWork],
		[AccountIDFuelTickets],
		[AccountIDUsageTickets],
		[LifeCycleStatusCodeID],
		[ConditionRating],
		[StatusCodes],
		[WorkOrders],
		[UsageTickets],
		[FuelTickets],
		[Comments],
		[DefaultWOPriorityID],
		[ActualDeliveryDate],
		[ActualInServiceDate],
		[OriginalCost],
		[DepreciationMethod],
		[LifeMonths],
		[Ownership],
		[VendorID],
		[ExpirationDate],
		[Meter1Expiration],
		[Meter2Expiration],
		[Deductible],
		[WarrantyType],
		[Comments2],
		[EstimatedReplacementMonth],
		[EstimatedReplacementYear],
		[EstimatedReplacementCost],
		[PlannedRetirementDate],
		[RetirementDate],
		[DispositionDate],
		[GrossSalePrice],
		[DisposalReason],
		[DisposalMethod],
		[DisposalAuthority],
		[DisposalComments],
		GETDATE()
	FROM tmp.EquipSvc ES
	ORDER BY ES.EquipmentID

	-- Components to the crosswalk table.
	INSERT INTO TransformComponentLegacyXwalk
	SELECT
		vehs.EquipmentID [EquipmentID],
		'SourceWicm210ObjectVehicle' [Source],
		'OBJECT_ID' [LegacyIDSource],
		vehs.[Object_ID] [LegacyID]
	FROM tmp.EquipSvc vehs
END
