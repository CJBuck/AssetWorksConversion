-- =============================================================================
-- Created By:	Chris Buck
-- Create Date:	01/30/2015
-- Description: Creates/modifies the spTransformEquipmentDistributionValve
--              stored procedure.
-- =============================================================================

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spTransformEquipmentDistributionValve') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformEquipmentDistributionValve AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformEquipmentDistributionValve
AS
BEGIN
	CREATE TABLE #Valves(
		[Valve_No] [varchar] (6) NOT NULL,
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

	INSERT INTO #Valves
	SELECT
		LTRIM(RTRIM(SPV.[VALVE_NO])) [Valve_No],
		'[i]' [Control],
		'VLV' + RIGHT('0000000' + LTRIM(RTRIM(SPV.VALVE_NO)), 7) [EquipmentID],
		'STATIONARY' [AssetType],
		LEFT((LTRIM(RTRIM(STREET_NAME)) + ' (' + 
			LTRIM(RTRIM(XSTREET_NAME)) + '-' + 
			LTRIM(RTRIM(TO_STREET)) + ')'), 40) [Description],
		'' [AssetNumber],	-- Open Issue: populate from "Source Water Isolation Valve 
							-- Spreadsheet" - Chris Basford.
		'VLV' + RIGHT('0000000' + LTRIM(RTRIM(SPV.VALVE_NO)), 7) [SerialNumber],
		'' [EquipmentType],
		'CLASS' [PMProgramType],
		'' [AssetPhotoFilePath],
		'' [AssetPhotoFileDescription],
		CASE
			WHEN ISDATE(SPV.SET_DATE) = 1 THEN YEAR(CAST(SPV.SET_DATE AS DATETIME))
			ELSE NULL
		END AS [ModelYear],
		'' [ManufacturerID],
		'GENERIC VALVE' [ModelID],
		'DMT' [MeterTypesClass],
		'' [Meter1Type],
		'' [Meter2Type],
		NULL [Meter1AtDelivery],
		NULL [Meter2AtDelivery],
		NULL [LatestMeter1Reading],
		NULL [LatestMeter2Reading],
		NULL [MaxMeter1Value],
		NULL [MaxMeter2Value],
		'' [Maintenance],
		CASE
			WHEN SPV.VALVE_NO <> '017850' AND SPV.VLV_FUNCTION = '01'
				AND SPV.VLV_SYSTEM = 'T' AND SPV.MAP_PAGE = 'TRN' THEN 'DPM VALVE TRANSMISSION'
			WHEN SPV.VALVE_NO <> '017850' AND SPV.VLV_FUNCTION = '05'
				AND SPV.VLV_SYSTEM = 'T' THEN 'DPM AIR REL DIST'
			WHEN SPV.VALVE_NO <> '017850' AND SPV.VLV_FUNCTION = '01'
				AND SPV.VLV_SYSTEM = 'R' THEN 'DPM VALVE SOURCE WTR'
			WHEN SPV.VALVE_NO <> '017850' AND SPV.VLV_FUNCTION = '05'
				AND SPV.VLV_SYSTEM = 'R' THEN 'DPM AIR REL SOURCE WTR'
			WHEN SPV.VALVE_NO = '017850' THEN 'DPM VALVE REGULATING'
			ELSE 'DNA'
		END [PMProgram],
		'' [Standards],
		'DNA' [RentalRates],
		'' [Resources],
		'VALVE' AssetCategoryID,
		'D-HYD VAL' AssignedPM,
		'D-REPAIR' AssignedRepair,
		'' [StoredLocation],
		CASE LTRIM(RTRIM(SPV.JURIS))
			WHEN 'H' THEN 'JURIS HP'
			WHEN 'J' THEN 'JURIS JC'
			WHEN 'K' THEN 'JURIS NK'
			WHEN 'N' THEN 'JURIS NN'
			WHEN 'P' THEN 'JURIS PQ'
			WHEN 'W' THEN 'JURIS WB'
			WHEN 'Y' THEN 'JURIS YC'
			ELSE ''
		END [StationLocation],
		'' [Jurisdiction],
		'DAY' [PreferredPMShift],	-- Open issue:  default value from AssetWorks?
		'' [VehicleLocation],
		'' [BuildingLocation],
		'' [OtherLocation],
		'413505' [DepartmentID],
		'413505' [DeptToNotifyForPM],
		'' [CompanyID],					-- Open issue
		'' [AccountIDAssignmentWO],		-- Open issue
		'' [AccountIDLaborPosting],		-- Open issue
		'' [AccountIDPartIssues],		-- Open issue
		'' [AccountIDCommercialWork],	-- Open issue
		'' [AccountIDFuelTickets],		-- Open issue
		'' [AccountIDUsageTickets],		-- Open issue
		'IN SERVICE' [EquipmentStatus],
		CASE
			WHEN SPV.[STATUS] = 'A' THEN 'A'
			WHEN SPV.[STATUS] = 'I' THEN 'PI'
			ELSE ''
		END [LifeCycleStatusCodeID],
		'' [ConditionRating],		-- Open issue
		'' [StatusCodes],			-- Open issue
		'Y' [WorkOrders],
		'N' [UsageTickets],
		'N' [FuelTickets],
		LTRIM(RTRIM(REMARK1)) + ' ' + LTRIM(RTRIM(REMARK2)) [Comments],
		'D4' [DefaultWOPriorityID],
		NULL [ActualDeliveryDate],	-- Open issue
		CASE
			WHEN ISDATE(SET_DATE) = 1 THEN CAST(SET_DATE AS DATETIME)
			ELSE NULL
		END AS [ActualInServiceDate],	-- Open issue:  some data not of DateTime datatype.
		NULL [OriginalCost],		-- Open issue
		'' [DepreciationMethod],	-- Open issue
		1200 [LifeMonths],
		NULL [MonthsRemaining],
		'OWNED' [Ownership],
		'' [VendorID],				-- Open issue
		NULL [ExpirationDate],
		NULL [Meter1Expiration],	-- Open issue
		NULL [Meter2Expiration],	-- Open issue
		NULL [Deductible],			-- Open issue
		'' [WarrantyType],			-- Open issue
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

	UPDATE #Valves
	SET
		EquipmentType = ISNULL(lkup.EquipmentType, ''),
		ManufacturerID = ISNULL(manid.TargetValue, ''),
		Maintenance =
			CASE 
				WHEN ISNULL(lkup.EquipmentType, '') LIKE 'DVL AIR%' THEN 'DMAINT AIR RELEASE'
				WHEN ISNULL(lkup.EquipmentType, '') LIKE 'DVL BLW%' THEN 'DMAINT BLOWOFF'
				ELSE 'DMAINT VALVE'
			END,
		Standards =
			CASE 
				WHEN ISNULL(lkup.EquipmentType, '') LIKE 'DVL AIR%' THEN 'DMAINT AIR RELEASE'
				WHEN ISNULL(lkup.EquipmentType, '') LIKE 'DVL BLW%' THEN 'DMAINT BLOWOFF'
				ELSE 'DMAINT VALVE'
			END,
		Resources = 
			CASE 
				WHEN ISNULL(lkup.EquipmentType, '') LIKE 'DVL AIR%' THEN 'DMAINT AIR RELEASE'
				WHEN ISNULL(lkup.EquipmentType, '') LIKE 'DVL BLW%' THEN 'DMAINT BLOWOFF'
				ELSE 'DMAINT VALVE'
			END,
		AssetCategoryID =
			CASE
				WHEN ISNULL(lkup.EquipmentType, '') = 'DVL AIR COMBINATION' THEN 'AIR RELEASE'
				WHEN ISNULL(lkup.EquipmentType, '') = 'DVL AIR AIR RELEASE' THEN 'AIR RELEASE'
				WHEN ISNULL(lkup.EquipmentType, '') = 'DVL BLWOFF' THEN 'BLOWOFF'
				ELSE 'VALVE'
			END
	FROM #Valves vlvs
		INNER JOIN SourcePups201Valve spv ON vlvs.Valve_No = spv.VALVE_NO
		INNER JOIN TransformEquipmentDistributionValveValueEquipmentType lkup
			ON spv.VLV_FUNCTION = lkup.VLV_FUNCTION AND spv.VLV_TYPE = lkup.VLV_TYPE
		-- ManufacturerID Cleansing
		INNER JOIN TransformEquipmentManufacturer manid
			ON LEFT(LTRIM(RTRIM(spv.VLV_MAKE)), 15) = LEFT(LTRIM(RTRIM(manid.[SourceValue])), 15)
				AND manid.[Source] LIKE '%Valves%'

	-- Move data from the temp table to TransformEquipment.
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
	FROM #Valves vehs
	ORDER BY vehs.EquipmentID

	-- Vehicles to the crosswalk table.
	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		vehs.EquipmentID [EquipmentID],
		'SourcePups201Valve' [Source],
		'VALVE_NO' [LegacyIDSource],
		vehs.Valve_No [LegacyID]
	FROM #Valves vehs
END

-- Clean up
IF OBJECT_ID('tempdb..#Valves') IS NOT NULL
	DROP TABLE #Valves
