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

	IF OBJECT_ID('tmp.Vehicles') IS NOT NULL
		DROP TABLE tmp.Vehicles

	CREATE TABLE tmp.Vehicles(
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
		UserStatus1 varchar(6) NULL,
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

	INSERT INTO tmp.Vehicles
	SELECT
		LTRIM(RTRIM(OV.[OBJECT_ID])) [OBJECT_ID],
		'[u:1]' [Control],
		'GS' + CAST((CAST(OV.[OBJECT_ID] AS INT)) AS VARCHAR) [EquipmentID],
		'ASSET' [AssetType],
		LTRIM(RTRIM(OV.VEH_DESC)) [Description],
		'GS' + CAST((CAST(OV.[OBJECT_ID] AS INT)) AS VARCHAR) [AssetNumber],
		CASE
			WHEN ISNULL(LTRIM(RTRIM(OV.SERIAL_NO)), '') = '' THEN 'GS' + LTRIM(RTRIM(OV.[OBJECT_ID]))
			WHEN LTRIM(RTRIM(OV.SERIAL_NO)) = 'N/A' THEN 'GS' + LTRIM(RTRIM(OV.[OBJECT_ID]))
			ELSE LTRIM(RTRIM(OV.SERIAL_NO))
		END [SerialNumber],
		'' [EquipmentType],
		'BOTH' [PMProgramType],
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
		'DAY' [PreferredPMShift],
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
		NULL UserStatus1,
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
		(OV.[OBJECT_ID] IN (SELECT EQ_Equip_No FROM AW_ProductionVehicleAssets))
		AND (OV.[OBJECT_ID] NOT IN ('006658', '006659', '006660', '006661', '006662', '006663',
			'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
			'006673', '006674', '006675'))

	-- Vehicle specific updates
	UPDATE tmp.Vehicles
	SET
		ModelYear = LTRIM(RTRIM(vehdet.AW_YEAR)),
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
	FROM tmp.Vehicles OV
		INNER JOIN TransformEquipmentVehicleValueVehicleDetails vehdet
			ON OV.[Object_ID] = vehdet.[WICM_OBJID]

	-- Updates from the Special Equipment spreadsheet
	UPDATE tmp.Vehicles
	SET
		ModelYear = LTRIM(RTRIM(sedet.AW_YEAR)),
		AssetCategoryID = 'SPECIALTY',
		AssignedPM = 'VEH SHOP',
		AssignedRepair = 'VEH SHOP',
		StationLocation = sedet.AW_LOCATION,
		DepartmentID = LEFT(ISNULL(sedet.[AW_PROGRAM], ''), 10),
		DeptToNotifyForPM = LEFT(ISNULL(sedet.[AW_PROGRAM], ''), 10)
	FROM tmp.Vehicles OV
		INNER JOIN TransformEquipmentVehicleValueSpecialEquipmentDetails sedet
			ON OV.[Object_ID] = sedet.[WICM_OBJID]

	-- ManufacturerID & ModelID Cleansing
	UPDATE tmp.Vehicles
	SET
		ManufacturerID = ISNULL(manid.TargetValue, ''),
		ModelID = ISNULL(modid.CleansedModelID, '')
	FROM tmp.Vehicles vehs
		INNER JOIN SourceWicm210ObjectVehicle OV ON vehs.[Object_ID] = OV.[OBJECT_ID]
		INNER JOIN TransformEquipmentManufacturer manid
			ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue
				AND manid.[Source] LIKE '%Vehicles%'
		INNER JOIN TransformEquipmentManufacturerModel modid
			ON LTRIM(RTRIM(manid.[TargetValue])) = LTRIM(RTRIM(modid.CleansedManufacturerID))
				AND LTRIM(RTRIM(OV.[VEH_MODEL])) = LTRIM(RTRIM(modid.SourceModelID))
				AND modid.[Source] = 'Vehicles'

	-- EquipmentClass & EquimentType Cleansing
	UPDATE tmp.Vehicles
	SET
		EquipmentType = LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30),
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
		PMProgram = LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30),
		Maintenance = LEFT(LTRIM(RTRIM(vec.EquipmentClassID)), 30),
		Standards = LEFT(LTRIM(RTRIM(vec.EquipmentClassID)), 30),
		RentalRates = LEFT(LTRIM(RTRIM(vec.EquipmentClassID)), 30),
		Resources = LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30)
	FROM tmp.Vehicles vehs
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
				
	-- Special EquipmentType exceptions.
	UPDATE tmp.Vehicles
	SET
		EquipmentType = LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30)
	FROM tmp.Vehicles vehs
		INNER JOIN SourceWicm210ObjectVehicle OV ON vehs.[Object_ID] = OV.[OBJECT_ID]
		INNER JOIN (
			SELECT DISTINCT VEH_YEAR, VEH_MAKE, VEH_MODEL, EquipmentClass, EquipmentType
			FROM TransformEquipmentVehicleValueEquipmentType
			) vet
			ON vehs.ManufacturerID = vet.VEH_MAKE
				AND vehs.ModelID = vet.VEH_MODEL
				AND vehs.ModelYear = vet.VEH_YEAR
				AND vet.EquipmentClass = 'PICKUP COMPACT 4X4'
	WHERE vehs.[Object_ID] = '006533'

	UPDATE tmp.Vehicles
	SET
		EquipmentType = LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30)
	FROM tmp.Vehicles vehs
		INNER JOIN SourceWicm210ObjectVehicle OV ON vehs.[Object_ID] = OV.[OBJECT_ID]
		INNER JOIN (
			SELECT DISTINCT VEH_YEAR, VEH_MAKE, VEH_MODEL, EquipmentClass, EquipmentType
			FROM TransformEquipmentVehicleValueEquipmentType
			) vet
			ON vehs.ManufacturerID = vet.VEH_MAKE
				AND vehs.ModelID = vet.VEH_MODEL
				AND vehs.ModelYear = vet.VEH_YEAR
				AND vet.EquipmentClass = 'PICKUP COMPACT EXT CAB 4X4'
	WHERE vehs.[Object_ID] IN ('006565', '006572', '006573', '006678')

	UPDATE tmp.Vehicles
	SET
		EquipmentType = LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30)
	FROM tmp.Vehicles vehs
		INNER JOIN SourceWicm210ObjectVehicle OV ON vehs.[Object_ID] = OV.[OBJECT_ID]
		INNER JOIN (
			SELECT DISTINCT VEH_YEAR, VEH_MAKE, VEH_MODEL, EquipmentClass, EquipmentType
			FROM TransformEquipmentVehicleValueEquipmentType
			) vet
			ON vehs.ManufacturerID = vet.VEH_MAKE
				AND vehs.ModelID = vet.VEH_MODEL
				AND vehs.ModelYear = vet.VEH_YEAR
				AND vet.EquipmentClass = 'PICKUP 1/2 TON 4X4'
	WHERE vehs.[Object_ID] = '006656'

	UPDATE tmp.Vehicles
	SET
		EquipmentType = LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30)
	FROM tmp.Vehicles vehs
		INNER JOIN SourceWicm210ObjectVehicle OV ON vehs.[Object_ID] = OV.[OBJECT_ID]
		INNER JOIN (
			SELECT DISTINCT VEH_YEAR, VEH_MAKE, VEH_MODEL, EquipmentClass, EquipmentType
			FROM TransformEquipmentVehicleValueEquipmentType
			) vet
			ON vehs.ManufacturerID = vet.VEH_MAKE
				AND vehs.ModelID = vet.VEH_MODEL
				AND vehs.ModelYear = vet.VEH_YEAR
				AND vet.EquipmentClass = 'PICKUP 1/2 TON EXT CAB 4X4'
	WHERE vehs.[Object_ID] = '006657'

	-- Meter Types Class
	UPDATE tmp.Vehicles
	SET MeterTypesClass = 
		CASE
			WHEN ISNULL(mtc.MeterTypesClass, '') <> '' THEN mtc.MeterTypesClass
			ELSE 'NO METER'
		END
	FROM tmp.Vehicles V
		LEFT JOIN TransformObjectVehicleValueMeterTypesClass mtc ON V.Maintenance = mtc.EquipmentClassID

	-- EquipmentClass specific updates
	UPDATE tmp.Vehicles
	SET
		Maintenance = 'PICKUP 1/2 TON 4X4',
		Standards = 'PICKUP 1/2 TON 4X4',
		RentalRates = 'PICKUP 1/2 TON 4X4'
	WHERE [Object_ID] = '006656'

	UPDATE tmp.Vehicles
	SET
		Maintenance = 'PICKUP COMPACT 4X4',
		Standards = 'PICKUP COMPACT 4X4',
		RentalRates = 'PICKUP COMPACT 4X4'
	WHERE [Object_ID] = '006533'

	UPDATE tmp.Vehicles
	SET
		Maintenance = 'PICKUP 1/2 TON EXT CAB 4X4',
		Standards = 'PICKUP 1/2 TON EXT CAB 4X4',
		RentalRates = 'PICKUP 1/2 TON EXT CAB 4X4'
	WHERE [Object_ID] IN ('006657', '006565', '006572', '006573', '006678')

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
		UserStatus1,
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
	FROM tmp.Vehicles vehs
	ORDER BY vehs.EquipmentID

	-- Vehicles to the crosswalk table.
	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		vehs.EquipmentID [EquipmentID],
		'SourceWicm210ObjectVehicle' [Source],
		'OBJECT_ID' [LegacyIDSource],
		vehs.[Object_ID] [LegacyID]
	FROM tmp.Vehicles vehs
END
