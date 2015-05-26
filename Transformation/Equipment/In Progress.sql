--

select *
from AW_ProductionVehicleAssets PVA
where (PVA.[EQ_Equip_No] IN ('006658', '006659', '006660', '006661', '006662', '006663',
			'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
			'006673', '006674', '006675'))

select * from SourceWicm210ObjectVehicle
where [OBJECT_ID] = '700029'

--******************************************************************************************************************
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
		(OV.[OBJECT_ID] NOT IN ('006658', '006659', '006660', '006661', '006662', '006663',
			'006664', '006665', '006666', '006667', '006668', '006669', '006670', '006672',
			'006673', '006674', '006675'))

select *
from #Vehicles
where [Object_ID] IN (
	select WICM_OBJID from TransformEquipmentVehicleValueSpecialEquipmentDetails
	)
