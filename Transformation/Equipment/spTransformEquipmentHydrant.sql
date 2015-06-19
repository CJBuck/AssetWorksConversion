-- ===============================================================================
-- Created By:	Chris Buck
-- Create Date:	01/30/2015
-- Description: Creates/modifies the spTransformEquipmentHydrant stored procedure.
-- ===============================================================================

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spTransformEquipmentHydrant') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformEquipmentHydrant AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformEquipmentHydrant
AS
--
BEGIN
	CREATE TABLE #Hydrants(
		[Hyd_No] [varchar] (5) NOT NULL,
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

	INSERT INTO #Hydrants
	SELECT
		LTRIM(RTRIM(H.[HYD_NO])) [Hyd_No],
		'[i]' [Control],
		'HYD' + RIGHT('0000000' + RTRIM(LTRIM(H.HYD_NO)), 7) [EquipmentID],
		'STATIONARY' [AssetType],
		LEFT(dbo.fnCompressWhiteSpace(H.STREET_NAME) + ' (' + 
			dbo.fnCompressWhiteSpace(H.XSTREET_NAME) + ')', 40) [Description],	-- Truncated
		'HYDRANT' [AssetNumber],
		'HYD' + RIGHT('0000000' + RTRIM(LTRIM(H.HYD_NO)), 7) [SerialNumber],
		'' [EquipmentType],
		'CLASS' [PMProgramType],
		'' [AssetPhotoFilePath],
		'' [AssetPhotoFileDescription],
		CASE
			WHEN (ISDATE(H.INSTALL_DATE) = 1) THEN YEAR(H.INSTALL_DATE)
			ELSE NULL
		END [ModelYear],
		'' [ManufacturerID],
		'' [ModelID],
		'DMT' [MeterTypesClass],
		'' [Meter1Type],
		'' [Meter2Type],
		NULL [Meter1AtDelivery],
		NULL [Meter2AtDelivery],
		NULL [LatestMeter1Reading],
		NULL [LatestMeter2Reading],
		NULL [MaxMeter1Value],
		NULL [MaxMeter2Value],
		'DMAINT HYDRANT' [Maintenance],
		CASE
			WHEN H.[HYD_NO] IN ('02516', '02517', '02518', '02590', '02591', '02592', '02814',
				'02815', '02816', '02817', '02818', '02819', '07420', '09489', '09490',
				'09491') THEN 'DPM HYDRANT SOURCE WTR'
			WHEN H.[HYD_NO] IN ('03130', '09013', '09014') THEN 'DPM HYDRANT WW'
			ELSE 'DPM HYDRANT CONTRACTOR'
		END [PMProgram],
		'DMAINT HYDRANT' [Standards],
		'DNA' [RentalRates],
		'DMAINT HYDRANT' [Resources],
		'HYDRANT' AssetCategoryID,
		'D-HYD VAL' AssignedPM,
		'D-REPAIR' AssignedRepair,
		'' [StoredLocation],
		CASE LTRIM(RTRIM(H.[JURIS]))
			WHEN 'H' THEN 'JURIS HP'
			WHEN 'J' THEN 'JURIS JC'
			WHEN 'K' THEN 'JURIS NK'
			WHEN 'N' THEN 'JURIS NN'
			WHEN 'P' THEN 'JURIS PQ'
			WHEN 'W' THEN 'JURIS WB'
			WHEN 'Y' THEN 'JURIS YC'
		END [StationLocation],
		LTRIM(RTRIM(H.[JURIS])) [Jurisdiction],
		'DAY' [PreferredPMShift],
		'' [VehicleLocation],
		'' [BuildingLocation],
		'' [OtherLocation],
		'413505' [DepartmentID],
		'413505' [DeptToNotifyForPM],
		'' [CompanyID],					-- Open Issue
		'' [AccountIDAssignmentWO],		-- Open Issue
		'' [AccountIDLaborPosting],		-- Open Issue
		'' [AccountIDPartIssues],		-- Open Issue
		'' [AccountIDCommercialWork],	-- Open Issue
		'' [AccountIDFuelTickets],		-- Open Issue
		'' [AccountIDUsageTickets],		-- Open Issue
		'IN SERVICE' [EquipmentStatus],
		'A' [LifeCycleStatusCodeID],
		'' [ConditionRating],
		'' [StatusCodes],
		'Y' [WorkOrders],
		'N' [UsageTickets],
		'N' [FuelTickets],
		LTRIM(RTRIM(H.[HYD_REMARK])) + ' ' + LTRIM(RTRIM(H.[REMARKS2])) [Comments],
		'D4' [DefaultWOPriorityID],
		NULL [ActualDeliveryDate],
		CASE
			WHEN ISDATE(H.[INSTALL_DATE]) = 1 AND H.[INSTALL_DATE] <> '00000000'
				THEN CAST(H.[INSTALL_DATE] AS DATETIME)
			ELSE NULL
		END AS [ActualInServiceDate],
		NULL [OriginalCost],
		'' [DepreciationMethod],	-- Open Issue
		NULL [LifeMonths],			-- Open Issue
		NULL [MonthsRemaining],
		'OWNED' [Ownership],
		'' [VendorID],				-- Open Issue
		NULL [ExpirationDate],
		NULL [Meter1Expiration],	-- Open Issue
		NULL [Meter2Expiration],	-- Open Issue
		NULL [Deductible],			-- Open Issue
		'' [WarrantyType],			-- Open Issue
		'' [Comments2],
		NULL [EstimatedReplacementMonth],
		NULL [EstimatedReplacementYear],
		NULL [EstimatedReplacementCost],
		'' [Latitude],
		'' [Longitude],
		'' [NextPMServiceNumber],
		NULL [NextPMDueDate],
		'' [IndividualPMService],
		'' [IndividualPMDateNextDue],
		NULL [IndividualPMNumberOfTimeUnits],
		'' [IndividualPMTimeUnit],
		NULL [PlannedRetirementDate],
		NULL [RetirementDate],
		NULL [DispositionDate],
		NULL [GrossSalePrice],
		'' [DisposalReason],
		'' [DisposalMethod],
		'' [DisposalAuthority],
		'' [DisposalComments]
	FROM SourcePups201Hydrant H
	WHERE
		(H.[STATUS] IN ('A', 'I')) AND (H.HYD_SEQ# = '00')

	UPDATE #Hydrants
	SET
		EquipmentType = vet.EquipmentType,
		ManufacturerID = ISNULL(manid.TargetValue, 'UNKNOWN'),
		ModelID =
			CASE
				WHEN ISNULL(LTRIM(RTRIM(h.HYD_MAKE)), '')
					IN ('NA', '', 'N/A', 'UNKNOWN') THEN 'UNKNOWN'
				ELSE LTRIM(RTRIM(modid.CleansedModelID))
			END
	FROM #Hydrants hyds
		INNER JOIN SourcePups201Hydrant h ON hyds.Hyd_No = h.HYD_NO
		INNER JOIN TransformEquipmentHydrantValueEquipmentType vet
			ON LTRIM(RTRIM(H.[HYD_MAKE])) = LTRIM(RTRIM(vet.[HYD_MAKE]))
		LEFT JOIN TransformEquipmentManufacturer manid
			ON LTRIM(RTRIM(H.HYD_MAKE)) = manid.SourceValue
				AND manid.[Source] = 'Hydrants'
		LEFT JOIN TransformEquipmentManufacturerModel modid
			ON manid.TargetValue = modid.CleansedManufacturerID
				AND modid.SourceModelID = LTRIM(RTRIM(H.HYD_MAKE))
				AND modid.[Source] = 'Hydrants'

	-- InServiceDate without DeliveryDate is invalid
	UPDATE #Hydrants
	SET ActualInServiceDate = NULL
	WHERE ActualDeliveryDate IS NULL

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
	FROM #Hydrants vehs
	ORDER BY vehs.EquipmentID

	-- Vehicles to the crosswalk table.
	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		H.EquipmentID [EquipmentID],
		'SourcePups201Hydrant' [Source],
		'HYD_NO' [LegacyIDSource],
		H.Hyd_No [LegacyID]
	FROM #Hydrants H
END

-- Clean up
IF OBJECT_ID('tempdb..#Hydrants') IS NOT NULL
	DROP TABLE #Hydrants
