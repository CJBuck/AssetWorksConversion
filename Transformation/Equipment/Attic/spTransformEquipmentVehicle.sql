-- =============================================================================
-- Created By:	Chris Buck
-- Create Date:	01/30/2015
-- Description: Creates/modifies the TransformEquipmentVehicle stored procedure.
-- =============================================================================

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spTransformEquipmentVehicle') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformEquipmentVehicle AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformEquipmentVehicle
AS
BEGIN
	CREATE TABLE #Vehicles(
		[Object_ID] [varchar] (10) NOT NULL,
		[Control] [varchar] (10) NOT NULL,
		[EquipmentID] [varchar](20) NOT NULL,
		[AssetType] [varchar](20) NULL,
		[Description] [varchar](40) NULL,
		[AssetNumber] [varchar](20) NULL,
		[SerialNumber] [varchar](50) NULL,
		[EquipmentType] [varchar](30) NULL,
		[PMProgramType] [varchar](10) NULL,
		[AssetPhotoFilePath] [varchar](255) NULL,
		[AssetPhotoFileDescription] [varchar](60) NULL,
		[ModelYear] [int] NULL,
		[ManufacturerID] [varchar](15) NULL,
		[ModelID] [varchar](15) NULL,
		[MeterTypesClass] [varchar](30) NULL,
		[Meter1Type] [varchar](10) NULL,
		[Meter2Type] [varchar](10) NULL,
		[Meter1AtDelivery] [int] NULL,
		[Meter2AtDelivery] [int] NULL,
		[LatestMeter1Reading] [int] NULL,
		[LatestMeter2Reading] [int] NULL,
		[MaxMeter1Value] [int] NULL,
		[MaxMeter2Value] [int] NULL,
		[Maintenance] [varchar](30) NULL,
		[PMProgram] [varchar](30) NULL,
		[Standards] [varchar](30) NULL,
		[RentalRates] [varchar](30) NULL,
		[Resources] [varchar](30) NULL,
		[AssetCategoryID] [varchar](15) NULL,
		[AssignedPM] [varchar](10) NULL,
		[AssignedRepair] [varchar](10) NULL,
		[StoredLocation] [varchar](10) NULL,
		[StationLocation] [varchar](10) NULL,
		[Jurisdiction] [varchar](2) NULL,
		[PreferredPMShift] [varchar](10) NULL,
		[VehicleLocation] [varchar](20) NULL,
		[BuildingLocation] [varchar](20) NULL,
		[OtherLocation] [varchar](20) NULL,
		[DepartmentID] [varchar](10) NULL,
		[DeptToNotifyForPM] [varchar](10) NULL,
		[CompanyID] [varchar](10) NULL,
		[AccountIDAssignmentWO] [varchar](10) NULL,
		[AccountIDLaborPosting] [varchar](10) NULL,
		[AccountIDPartIssues] [varchar](10) NULL,
		[AccountIDCommercialWork] [varchar](10) NULL,
		[AccountIDFuelTickets] [varchar](10) NULL,
		[AccountIDUsageTickets] [varchar](10) NULL,
		[EquipmentStatus] [varchar](10) NULL,
		[LifeCycleStatusCodeID] [varchar](2) NULL,
		[ConditionRating] [varchar](20) NULL,
		[StatusCodes] [varchar](6) NULL,
		[WorkOrders] [char](1) NULL,
		[UsageTickets] [char](1) NULL,
		[FuelTickets] [char](1) NULL,
		[Comments] [varchar](1200) NULL,
		[DefaultWOPriorityID] [varchar](2) NULL,
		[ActualDeliveryDate] [datetime] NULL,
		[ActualInServiceDate] [datetime] NULL,
		[OriginalCost] [decimal](22, 2) NULL,
		[DepreciationMethod] [varchar](25) NULL,
		[LifeMonths] [int] NULL,
		[MonthsRemaining] [decimal](22, 2) NULL,
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
		[Latitude] [varchar](10) NULL,
		[Longitude] [varchar](10) NULL,
		[NextPMServiceNumber] [int] NULL,
		[NextPMDueDate] [datetime] NULL,
		[IndividualPMService] [varchar](12) NULL,
		[IndividualPMDateNextDue] [datetime] NULL,
		[IndividualPMNumberofTimeUnits] [int] NULL,
		[IndividualPMTimeUnit] [varchar](10) NULL,
		[PlannedRetirementDate] [datetime] NULL,
		[RetirementDate] [datetime] NULL,
		[DispositionDate] [datetime] NULL,
		[GrossSalePrice] [decimal](22, 2) NULL,
		[DisposalReason] [varchar](30) NULL,
		[DisposalMethod] [varchar](20) NULL,
		[DisposalAuthority] [varchar](6) NULL,
		[DisposalComments] [varchar](60) NULL
	)

	INSERT INTO #Vehicles
	SELECT
		LTRIM(RTRIM(OV.[OBJECT_ID])) [OBJECT_ID],
		'[i]' [Control],
		'GS' + CAST((CAST(OV.[OBJECT_ID] AS INT)) AS VARCHAR) [EquipmentID],
		'' [AssetType],
		LTRIM(RTRIM(OV.VEH_DESC)) [Description],
		'GS' + CAST((CAST(OV.[OBJECT_ID] AS INT)) AS VARCHAR) [AssetNumber],
		CASE
			WHEN ISNULL(LTRIM(RTRIM(OV.SERIAL_NO)), '') = '' THEN 'GS' + LTRIM(RTRIM(OV.[OBJECT_ID]))
			WHEN LTRIM(RTRIM(OV.SERIAL_NO)) = 'N/A' THEN 'GS' + LTRIM(RTRIM(OV.[OBJECT_ID]))
			ELSE LTRIM(RTRIM(OV.SERIAL_NO))
		END [SerialNumber],
		'' [EquipmentType],
		'INDIVIDUAL' [PMProgramType],		-- Open issue
		'' [AssetPhotoFilePath],
		'' [AssetPhotoFileDescription],
		NULL [ModelYear],
		'' [ManufacturerID],
		'' [ModelID],
		'' [MeterTypesClass],
		'' [Meter1Type],
		'' [Meter2Type],
		NULL [Meter1AtDelivery],
		NULL [Meter2AtDelivery],
		ISNULL(OV.MILES_CURR, NULL) [LatestMeter1Reading],
		NULL [LatestMeter2Reading],
		NULL [MaxMeter1Value],
		NULL [MaxMeter2Value],
		'' [Maintenance],
		'' [PMProgram],
		'' [Standards],
		'' [RentalRates],
		'' [Resources],
		'' AssetCategoryID,
		'' AssignedPM,
		'' AssignedRepair,
		'' [StoredLocation],
		'' [StationLocation],
		'' [Jurisdiction],
		'DAY' [PreferredPMShift],		-- Open issue
		'' [VehicleLocation],
		'' [BuildingLocation],
		'' [OtherLocation],
		'' [DepartmentID],
		'' [DepartmentToNotifyForPM],
		'' [CompanyID],
		'' [AccountIDAssignmentWO],
		'' [AccountIDLaborPosting],
		'' [AccountIDPartIssues],
		'' [AccountIDCommercialWork],
		'' [AccountIDFuelTickets],
		'' [AccountIDUsageTickets],
		'' [EquipmentStatus],
		CASE
			WHEN (OV.[DRIVER] LIKE '%SURPLUS%') THEN 'R'
			ELSE 'A'
		END [LifeCycleStatusCodeID],
		'' [ConditionRating],
		'' [StatusCodes],
		'Y' [WorkOrders],
		'N' [UsageTickets],
		'N' [FuelTickets],
		dbo.GroupConcatNotes(LTRIM(RTRIM(OV.[OBJECT_ID]))) [Comments],
		'V3' [DefaultWOPriorityID],
		CASE
			WHEN ISDATE(OV.ACQ_DATE) = 1 THEN CAST(OV.ACQ_DATE AS DATETIME)
			ELSE NULL
		END [ActualDeliveryDate],
		NULL [ActualInServiceDate],
		ISNULL(OV.ACQ_COST, NULL) [OriginalCost],
		'' [DepreciationMethod],	-- Open issue.
		ISNULL(OV.LIFE_EXP, NULL) [LifeMonths],
		NULL [MonthsRemaining],
		'OWNED' [Ownership],
		'' [VendorID],				-- Open issue
		CASE
			WHEN ISDATE(OV.OBSOL_DATE) = 1 THEN CAST(OV.OBSOL_DATE AS DATETIME)
			ELSE NULL
		END [ExpirationDate],
		NULL [Meter1Expiration],
		NULL [Meter2Expiration],
		NULL [Deductible],
		'' [WarrantyType],			-- Open issue
		'' [Comments2],
		CASE
			WHEN ISDATE(OBSOL_DATE) = 1 THEN RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH, CAST(OBSOL_DATE AS DATETIME))), 2)
			ELSE NULL
		END [EstimatedReplacementMonth],
		CASE
			WHEN ISDATE(OBSOL_DATE) = 1 THEN RIGHT('0000' + CONVERT(NVARCHAR(4), DATEPART(YEAR, CAST(OBSOL_DATE AS DATETIME))), 4)
			ELSE NULL
		END [EstimatedReplacementYear],
		NULL [EstimatedReplacementCost],
		'' [Latitude],
		'' [Longitude],
		NULL [NextPMServiceNumber],
		NULL [NextPMDueDate],
		'' [IndividualPMService],
		'' [IndividualPMDateNextDue],
		NULL [IndividualPMNumberOfTimeUnits],
		'' [IndividualPMTimeUnit],
		CASE
			WHEN ISDATE(OV.OBSOL_DATE) = 1 THEN CAST(OV.OBSOL_DATE AS DATETIME)
			ELSE NULL
		END [PlannedRetirementDate],
		CASE
			WHEN ISDATE(OV.OBSOL_DATE) = 1 THEN CAST(OV.OBSOL_DATE AS DATETIME)
			ELSE NULL
		END [RetirementDate],
		CASE
			WHEN ISDATE(OV.OBSOL_DATE) = 1 THEN CAST(OV.OBSOL_DATE AS DATETIME)
			ELSE NULL
		END [DispositionDate],
		NULL [GrossSalePrice],
		'' [DisposalReason],
		'' [DisposalMethod],
		'' [DisposalAuthority],
		'' [DisposalComments]
	FROM SourceWicm210ObjectVehicle OV
	WHERE
		(OV.[OBJECT_ID] IN (SELECT WICM_OBJID FROM TransformEquipmentVehicleValueVehicleDetails))

	-- Vehicle specific updates
	UPDATE #Vehicles
	SET
		AssetType = 'ASSET',
		ModelYear = LTRIM(RTRIM(vehdet.AW_YEAR)),
		Maintenance = LEFT(ISNULL(LTRIM(RTRIM(vehdet.AW_EQUIP_CLASS)), ''), 30),
		Standards = LEFT(ISNULL(LTRIM(RTRIM(vehdet.AW_EQUIP_CLASS)), ''), 30),
		RentalRates = LEFT(ISNULL(LTRIM(RTRIM(vehdet.AW_EQUIP_CLASS)), ''), 30),
		Resources = LEFT(ISNULL(LTRIM(RTRIM(vehdet.AW_EQUIP_CLASS)), ''), 30),
		AssetCategoryID =
			CASE
				WHEN LTRIM(RTRIM(vehdet.AW_CATID)) = 'CONSTRUCTION EQUIPMENT' THEN 'EQUIPMENT'
				WHEN LTRIM(RTRIM(vehdet.AW_CATID)) = 'TRAILERS' THEN 'TRAILER'
				WHEN LTRIM(RTRIM(vehdet.AW_CATID)) = 'VEHICLES' THEN 'VEHICLE'
			END,
		AssignedPM = 'VEH SHOP',
		AssignedRepair = 'VEH SHOP',
		StationLocation = vehdet.AW_LOCATION,
		DepartmentID = LEFT(ISNULL(vehdet.[AW_PROGRAM], ''), 10),
		DeptToNotifyForPM = LEFT(ISNULL(vehdet.[AW_PROGRAM], ''), 10)
	FROM #Vehicles OV
		INNER JOIN TransformEquipmentVehicleValueVehicleDetails vehdet
			ON OV.[Object_ID] = vehdet.[WICM_OBJID]

	-- Update all the other AssetTypes not previously assigned.
	-- Spec: 3.b.iii
	UPDATE #Vehicles
	SET AssetType = 'ASSET'
	WHERE ISNULL(AssetType, '') = ''

	-- ManufacturerID & ModelID Cleansing
	UPDATE #Vehicles
	SET
		ManufacturerID = ISNULL(manid.TargetValue, ''),
		ModelID = ISNULL(modid.CleansedModelID, '')
	FROM #Vehicles vehs
		INNER JOIN SourceWicm210ObjectVehicle OV ON vehs.[Object_ID] = OV.[OBJECT_ID]
		INNER JOIN TransformEquipmentManufacturer manid
			ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue
				AND manid.[Source] LIKE '%Vehicles%'
		INNER JOIN TransformEquipmentManufacturerModel modid
			ON LTRIM(RTRIM(manid.[TargetValue])) = LTRIM(RTRIM(modid.CleansedManufacturerID))
				AND LTRIM(RTRIM(OV.[VEH_MODEL])) = LTRIM(RTRIM(modid.SourceModelID))
				AND modid.[Source] = 'Vehicles'
					
	-- EquipmentClass & EquimentType Cleansing
	UPDATE #Vehicles
	SET
		EquipmentType = LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30),
		MeterTypesClass = 
			CASE
				WHEN tec.MeterTypes = 'Y' THEN LEFT(LTRIM(RTRIM(vec.EquipmentClassID)), 30)
				ELSE 'NO METER'
			END,
		Meter1Type = LEFT(LTRIM(RTRIM(ISNULL(tec.Meter1Type, ''))), 10),
		Meter2Type = LEFT(LTRIM(RTRIM(ISNULL(tec.Meter2Type, ''))), 10),
		PMProgram = LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30)
	FROM #Vehicles vehs
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

	INSERT INTO TransformEquipment
	SELECT
		[Control],
		EquipmentID,
		[AssetType],
		[Description],
		[AssetNumber],
		[SerialNumber],
		[EquipmentType],
		[PMProgramType],
		[AssetPhotoFilePath],
		[AssetPhotoFileDescription],
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
		[StoredLocation],
		[StationLocation],
		[Jurisdiction],
		[PreferredPMShift],
		[VehicleLocation],
		[BuildingLocation],
		[OtherLocation],
		[DepartmentID],
		[DeptToNotifyForPM],
		[CompanyID] [varchar],
		[AccountIDAssignmentWO],
		[AccountIDLaborPosting],
		[AccountIDPartIssues],
		[AccountIDCommercialWork],
		[AccountIDFuelTickets],
		[AccountIDUsageTickets],
		[EquipmentStatus],
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
		[MonthsRemaining],
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
		[Latitude],
		[Longitude],
		[NextPMServiceNumber],
		[NextPMDueDate],
		[IndividualPMService],
		[IndividualPMDateNextDue],
		[IndividualPMNumberofTimeUnits],
		[IndividualPMTimeUnit],
		[PlannedRetirementDate],
		[RetirementDate],
		[DispositionDate],
		[GrossSalePrice],
		[DisposalReason],
		[DisposalMethod],
		[DisposalAuthority],
		[DisposalComments]
	FROM #Vehicles vehs
	ORDER BY vehs.EquipmentID

	-- Vehicles to the crosswalk table.
	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		vehs.EquipmentID [EquipmentID],
		'SourceWicm210ObjectVehicle' [Source],
		'OBJECT_ID' [LegacyIDSource],
		vehs.[Object_ID] [LegacyID]
	FROM #Vehicles vehs
END

-- Clean up
IF OBJECT_ID('tempdb..#Vehicles') IS NOT NULL
	DROP TABLE #Vehicles
