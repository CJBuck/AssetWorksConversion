-- ===============================================================================
-- Created By:	Chris Buck
-- Create Date:	02/09/2015
-- Description: Creates/modifies the spTransformEquipmentProject stored procedure.
-- ===============================================================================

IF OBJECT_ID('spTransformEquipmentProject') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformEquipmentProject AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformEquipmentProject
AS

BEGIN
	DECLARE
		@NewID				INT,
		@RowNumInProgress	INT

	IF OBJECT_ID('tmp.ObjectIDs') IS NOT NULL
		DROP TABLE tmp.ObjectIDs

	-- Grab the relevant ObjectIDs
	-- Location = '04'
	SELECT DISTINCT LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID], LTRIM(RTRIM(OP.LOCATION)) [LOCATION]
	INTO tmp.ObjectIDs
	FROM SourceWicm210ObjectProject OP
		INNER JOIN SourceWicm250WorkOrderHeaderAdmin woa
			ON OP.[OBJECT_ID] = woa.[OBJECT_ID] AND woa.[STATUS] IN ('A','P')
	WHERE
		OP.[OBJECT_ID] NOT IN ('FRST', 'OTHR', 'SAFE')
		AND OP.LOCATION = '04'
		AND OP.[STATUS] = 'A'
		AND LTRIM(RTRIM(OP.[CLASS])) NOT IN ('LHTP', 'WRKSTA')

	-- Location = '05'
	INSERT INTO tmp.ObjectIDs
	SELECT DISTINCT LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID], LTRIM(RTRIM(OP.LOCATION)) [LOCATION]
	FROM SourceWicm210ObjectProject OP
	WHERE
		OP.[OBJECT_ID] NOT IN ('FRST', 'OTHR', 'SAFE')
		AND OP.LOCATION = '05'
		AND LTRIM(RTRIM(OP.[CLASS])) NOT IN ('LHTP', 'WRKSTA')

	IF OBJECT_ID('tmp.InSvcDate') IS NOT NULL
		DROP TABLE tmp.InSvcDate

	-- Populate a temp table with the ActualInServiceDate per spec.
	SELECT DISTINCT
		LTRIM(RTRIM(woifp.WO_ALT1_OB_ID)) [OBJECT_ID],
		CAST(woifp.WORK_PEND_DT AS DATETIME) [ActualInServiceDate]
	INTO tmp.InSvcDate
	FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending woifp
	WHERE
		LTRIM(RTRIM(woifp.WO_ALT1_OB_ID)) IN (SELECT [OBJECT_ID] FROM tmp.ObjectIDs)
		AND ((woifp.WORK_PEND_DT IS NOT NULL) AND (LTRIM(RTRIM(woifp.WORK_PEND_DT)) <> '0'))

	INSERT INTO tmp.InSvcDate
	SELECT LTRIM(RTRIM(woifp.WO_ALT1_OB_ID)),
		CASE
			WHEN woifp.PL_CMPL_DT_C > woifp.PL_CMPL_DT_W THEN CAST(woifp.PL_CMPL_DT_C AS DATETIME)
			WHEN woifp.PL_CMPL_DT_W > woifp.PL_CMPL_DT_C THEN CAST(woifp.PL_CMPL_DT_W AS DATETIME)
			ELSE NULL
		END [ActualInServiceDate]
	FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending woifp
	WHERE
		LTRIM(RTRIM(woifp.WO_ALT1_OB_ID)) IN (SELECT [OBJECT_ID] FROM tmp.ObjectIDs)
		AND LTRIM(RTRIM(woifp.WO_ALT1_OB_ID)) NOT IN (SELECT [OBJECT_ID] FROM tmp.InSvcDate)
		AND ((woifp.WORK_PEND_DT IS NULL) OR (LTRIM(RTRIM(woifp.WORK_PEND_DT)) = '0'))
	-- *****

	IF OBJECT_ID('tmp.StagingProjects') IS NOT NULL
	DROP TABLE tmp.StagingProjects

	CREATE TABLE tmp.StagingProjects(
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[Object_ID] [varchar] (10) NOT NULL,
		[Location] [varchar] (2) NULL,
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

	INSERT INTO tmp.StagingProjects
	SELECT
		LTRIM(RTRIM(OP.[OBJECT_ID])) [Object_ID],
		LTRIM(RTRIM(OP.LOCATION)) [Location],
		'[i]' [Control],
		'EQP' + '' [EquipmentID],
		'STATIONARY' [AssetType],
		LTRIM(RTRIM(OP.BLD_PRJ_NAME)) [Description],
		LTRIM(RTRIM(OP.[OBJECT_ID])) [AssetNumber],
		'EQP' + '' [SerialNumber],
		'' [EquipmentType],
		CASE OP.LOCATION
			WHEN '04' THEN 'NONE'
			ELSE 'BOTH'
		END [PMProgramType],
		'' [AssetPhotoFilePath],
		'' [AssetPhotoFileDescription],
		1901 [ModelYear],
		'NA' [ManufacturerID],
		'NA' [ModelID],
		'NO METER' [MeterTypesClass],
		'' [Meter1Type],
		'' [Meter2Type],
		NULL [Meter1AtDelivery],
		NULL [Meter2AtDelivery],
		NULL [LatestMeter1Reading],
		NULL [LatestMeter2Reading],
		NULL [MaxMeter1Value],
		NULL [MaxMeter2Value],
		'' [Maintenance],
		'' [PMProgram],
		'NOT APPLICABLE' [Standards],
		'NOT APPLICABLE' [RentalRates],
		'' [Resources],
		'' [AssetCategoryID],
		'' [AssignedPM],
		'' [AssignedRepair],
		'' [StoredLocation],
		CASE OP.LOCATION
			WHEN '05' THEN 'WATERSHED'
			ELSE ''
		END [StationLocation],
		LTRIM(RTRIM(OP.MAINT_SHOP)) [Jurisdiction],
		'DAY' [PreferredPMShift],
		'' [VehicleLocation],
		'' [BuildingLocation],
		'' [OtherLocation],
		CASE
			WHEN OP.LOCATION = '04' THEN '413505'
			WHEN OP.LOCATION = '05' THEN '412503'
			ELSE ''		-- Should never reach this.
		END [DepartmentID],
		CASE
			WHEN OP.LOCATION = '04' THEN '413505'
			WHEN OP.LOCATION = '05' THEN '412503'
			ELSE ''		-- Should never reach this.
		END [DeptToNotifyForPM],
		'' [CompanyID],
		'' [AccountIDAssignmentWO],
		'' [AccountIDLaborPosting],
		'' [AccountIDPartIssues],
		'' [AccountIDCommercialWork],
		'' [AccountIDFuelTickets],
		'' [AccountIDUsageTickets],
		'IN SERVICE' [EquipmentStatus],
		'A' [LifeCycleStatusCodeID],
		'' [ConditionRating],
		'' [StatusCodes],
		'Y' [WorkOrders],
		'N' [UsageTickets],
		'N' [FuelTickets],
		LTRIM(RTRIM(OP.BLDG_ADDR)) [Comments],
		CASE OP.[LOCATION]
			WHEN '04' THEN 'D4'
			WHEN '05' THEN 'N3'
			ELSE ''
		END [DefaultWOPriorityID],
		NULL  [ActualDeliveryDate],
		NULL [ActualInServiceDate],
		NULL [OriginalCost],
		'' [DepreciationMethod],
		NULL [LifeMonths],
		NULL [MonthsRemaining],
		'' [Ownership],
		'' [VendorID],
		NULL [ExpirationDate],
		NULL [Meter1Expiration],
		NULL [Meter2Expiration],
		NULL [Deductible],
		'' [WarrantyType],
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
	FROM SourceWicm210ObjectProject OP
	WHERE
		LTRIM(RTRIM(OP.[OBJECT_ID])) IN (SELECT [OBJECT_ID] FROM tmp.ObjectIDs)

	UPDATE tmp.StagingProjects
	SET ActualDeliveryDate =
		CASE
			WHEN (ISDATE(woifp.WORK_PEND_DT) = 1) THEN CAST(woifp.WORK_PEND_DT AS DATETIME)
			WHEN ((ISDATE(woifp.WORK_PEND_DT) = 0) AND (ISDATE(woifp.PL_CMPL_DT_W) = 1)
				AND (woifp.PL_CMPL_DT_W > woifp.PL_CMPL_DT_C))
					THEN CAST(woifp.PL_CMPL_DT_W AS DATETIME)
			WHEN ((ISDATE(woifp.WORK_PEND_DT) = 0) AND (ISDATE(woifp.PL_CMPL_DT_C) = 1)
				AND (woifp.PL_CMPL_DT_C > woifp.PL_CMPL_DT_W))
					THEN CAST(woifp.PL_CMPL_DT_C AS DATETIME)
			ELSE NULL
		END
	FROM tmp.StagingProjects SP
		INNER JOIN SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending woifp
			ON SP.[Object_ID] = woifp.WO_ALT1_OB_ID
	WHERE SP.Location = '04'

	-- Asset Category :: Step 1
	UPDATE tmp.StagingProjects
	SET
		EquipmentType = lkup.EquipmentType,
		Maintenance =
			CASE
				WHEN OP.LOCATION IN ('04') THEN 'NOT APPLICABLE'
				ELSE lkup.EquipmentType
			END,
		PMProgram =
			CASE
				WHEN OP.LOCATION IN ('04') THEN 'NOT APPLICABLE'
				ELSE lkup.EquipmentType
			END,
		Resources =
			CASE
				WHEN OP.LOCATION IN ('04') THEN 'NOT APPLICABLE'
				ELSE lkup.EquipmentType
			END,
		AssetCategoryID = lkup.AssetCategoryID,
		AssignedPM =
			CASE
				WHEN OP.LOCATION IN ('04') THEN 'D-ADMIN'
				ELSE 'WATERSHED'
			END,
		AssignedRepair =
			CASE
				WHEN OP.LOCATION IN ('04') THEN 'D-ADMIN'
				ELSE 'WATERSHED'
			END
	FROM tmp.StagingProjects SP
		INNER JOIN SourceWicm210ObjectProject op ON SP.[Object_ID] = LTRIM(RTRIM(op.[OBJECT_ID]))
		INNER JOIN TransformEquipmentProjectValueAssetCategory lkup ON
			ISNULL(LTRIM(RTRIM(OP.CLASS)), '') = lkup.CLASS
	WHERE
		SP.[Object_ID] NOT IN (SELECT DISTINCT [OBJECT_ID] FROM TransformEquipmentProjectValueAssetCategory)

	-- Asset Category :: Step 2
	UPDATE tmp.StagingProjects
	SET
		EquipmentType = lkup.EquipmentType,
		Maintenance =
			CASE
				WHEN OP.LOCATION IN ('04') THEN 'NOT APPLICABLE'
				ELSE lkup.EquipmentType
			END,
		PMProgram =
			CASE
				WHEN OP.LOCATION IN ('04') THEN 'NOT APPLICABLE'
				ELSE lkup.EquipmentType
			END,
		Resources =
			CASE
				WHEN OP.LOCATION IN ('04') THEN 'NOT APPLICABLE'
				ELSE lkup.EquipmentType
			END,
		AssetCategoryID = lkup.AssetCategoryID,
		AssignedPM =
			CASE
				WHEN OP.LOCATION IN ('04') THEN 'D-ADMIN'
				ELSE 'WATERSHED'
			END,
		AssignedRepair =
			CASE
				WHEN OP.LOCATION IN ('04') THEN 'D-ADMIN'
				ELSE 'WATERSHED'
			END
	FROM tmp.StagingProjects SP
		INNER JOIN SourceWicm210ObjectProject op ON SP.[Object_ID] = LTRIM(RTRIM(op.[OBJECT_ID]))
		INNER JOIN TransformEquipmentProjectValueAssetCategory lkup ON
			SP.[Object_ID] = lkup.[OBJECT_ID] AND lkup.[OBJECT_ID] <> 'RSDL'

	-- Asset Category :: Step 3
	INSERT INTO tmp.StagingProjects
	SELECT
		sp.[Object_ID],
		sp.Location,
		'[i]' [Control],
		'EQP' + '' [EquipmentID],
		'STATIONARY' [AssetType],
		sp.[Description] [Description],
		sp.[AssetNumber],
		sp.[SerialNumber],
		lkup.EquipmentType [EquipmentType],
		'BOTH' [PMProgramType],
		'' [AssetPhotoFilePath],
		'' [AssetPhotoFileDescription],
		1901 [ModelYear],
		'NA' [ManufacturerID],
		'NA' [ModelID],
		'NO METER' [MeterTypesClass],
		'' [Meter1Type],
		'' [Meter2Type],
		NULL [Meter1AtDelivery],
		NULL [Meter2AtDelivery],
		NULL [LatestMeter1Reading],
		NULL [LatestMeter2Reading],
		NULL [MaxMeter1Value],
		NULL [MaxMeter2Value],
		lkup.EquipmentType [Maintenance],
		lkup.EquipmentType [PMProgram],
		'NOT APPLICABLE' [Standards],
		'NOT APPLICABLE' [RentalRates],
		lkup.EquipmentType [Resources],
		lkup.AssetCategoryID [AssetCategoryID],
		'WATERSHED' [AssignedPM],
		'WATERSHED' [AssignedRepair],
		'' [StoredLocation],
		sp.StationLocation [StationLocation],
		sp.[Jurisdiction],
		'DAY' [PreferredPMShift],
		'' [VehicleLocation],
		'' [BuildingLocation],
		'' [OtherLocation],
		sp.[DepartmentID],
		sp.[DeptToNotifyForPM],
		'' [CompanyID],
		'' [AccountIDAssignmentWO],
		'' [AccountIDLaborPosting],
		'' [AccountIDPartIssues],
		'' [AccountIDCommercialWork],
		'' [AccountIDFuelTickets],
		'' [AccountIDUsageTickets],
		'IN SERVICE' [EquipmentStatus],
		'A' [LifeCycleStatusCodeID],
		'' [ConditionRating],
		'' [StatusCodes],
		'Y' [WorkOrders],
		'N' [UsageTickets],
		'N' [FuelTickets],
		sp.[Comments],
		sp.[DefaultWOPriorityID],
		NULL [ActualDeliveryDate],
		NULL [ActualInServiceDate],
		NULL [OriginalCost],
		'' [DepreciationMethod],
		NULL [LifeMonths],
		NULL [MonthsRemaining],
		'' [Ownership],
		'' [VendorID],
		NULL [ExpirationDate],
		NULL [Meter1Expiration],
		NULL [Meter2Expiration],
		NULL [Deductible],
		'' [WarrantyType],
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
	FROM TransformEquipmentProjectValueAssetCategory lkup
		INNER JOIN tmp.StagingProjects sp on lkup.[OBJECT_ID] = sp.[Object_ID]
	WHERE sp.[Object_ID] = 'RSDL'

	-- Asset Category :: Step 4
	DELETE tmp.StagingProjects WHERE AssetNumber = 'RSDL' AND EquipmentType = ''

	-- OriginalCost, VendorID, StationLocation
	UPDATE tmp.StagingProjects
	SET
		OriginalCost =
			CASE OP.[LOCATION]
				WHEN '04' THEN ISNULL(woa.TOTAL_COST, NULL)
				ELSE NULL
			END,
		VendorID =
			CASE OP.[LOCATION]			-- Open issue: handling truncation.
				WHEN '04' THEN ISNULL((LEFT(LTRIM(RTRIM(woa.DEVELOPER)), 15)), '')
				ELSE ''
			END,
		StationLocation =
			CASE woa.JURISDICTION
				WHEN 'H' THEN 'JURIS HP'
				WHEN 'J' THEN 'JURIS JC'
				WHEN 'N' THEN 'JURIS NN'
				WHEN 'P' THEN 'JURIS PQ'
				WHEN 'Y' THEN 'JURIS YC'
				WHEN 'W' THEN 'JURIS WB'
			END
	FROM tmp.StagingProjects SP
		INNER JOIN SourceWicm210ObjectProject op ON SP.[Object_ID] = LTRIM(RTRIM(op.[OBJECT_ID]))
		INNER JOIN (
			SELECT DISTINCT
				[OBJECT_ID], LTRIM(RTRIM(TOTAL_COST)) [TOTAL_COST],
				LTRIM(RTRIM(DEVELOPER)) [DEVELOPER], LTRIM(RTRIM(JURISDICTION)) [JURISDICTION]
			FROM SourceWicm250WorkOrderHeaderAdmin
			WHERE [OBJECT_ID] IN (SELECT [OBJECT_ID] FROM tmp.ObjectIDs)
			) woa ON LTRIM(RTRIM(SP.[Object_ID])) = LTRIM(RTRIM(woa.[OBJECT_ID]))

	-- 6/2/2015 Temporary while logic is resolved with the business units.
	--     Just commented out for now.
	--UPDATE tmp.StagingProjects
	--SET
	--	ActualInServiceDate = aisd.ActualInServiceDate
	--FROM tmp.StagingProjects SP
	--	INNER JOIN tmp.InSvcDate aisd ON SP.[Object_ID] = aisd.[OBJECT_ID]

	IF OBJECT_ID('tmp.ProjectFinalResultSet') IS NOT NULL
	DROP TABLE tmp.ProjectFinalResultSet
		
	DECLARE Projects_Cursor CURSOR
	FOR SELECT SP.RowNum [RowNum]
	FROM tmp.StagingProjects SP
	ORDER BY SP.RowNum

	OPEN Projects_Cursor
	FETCH NEXT FROM Projects_Cursor
	INTO @RowNumInProgress

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Get the next auto-number
		INSERT INTO EquipmentIDAutoCounter DEFAULT VALUES
		SET @NewID = @@IDENTITY
		
		IF @RowNumInProgress = 1
			BEGIN
				SELECT
					SP.[Control],
					CASE
						WHEN op.LOCATION = '04' THEN ('PRJ' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7))
						ELSE ('EQP' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7))
					END [EquipmentID],
					SP.[AssetType],
					SP.[Description],
					SP.[AssetNumber],
					CASE
						WHEN op.LOCATION = '04' THEN ('PRJ' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7))
						ELSE ('EQP' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7))
					END [SerialNumber],
					SP.[EquipmentType],
					SP.[PMProgramType],
					SP.[AssetPhotoFilePath],
					SP.[AssetPhotoFileDescription],
					SP.[ModelYear],
					SP.[ManufacturerID],
					SP.[ModelID],
					SP.[MeterTypesClass],
					SP.[Meter1Type],
					SP.[Meter2Type],
					SP.[Meter1AtDelivery],
					SP.[Meter2AtDelivery],
					SP.[LatestMeter1Reading],
					SP.[LatestMeter2Reading],
					SP.[MaxMeter1Value],
					SP.[MaxMeter2Value],
					SP.[Maintenance],
					SP.[PMProgram],
					SP.[Standards],
					SP.[RentalRates],
					SP.[Resources],
					SP.[AssetCategoryID],
					SP.[AssignedPM],
					SP.[AssignedRepair],
					SP.[StoredLocation],
					SP.[StationLocation],
					SP.[Jurisdiction],
					SP.[PreferredPMShift],
					SP.[VehicleLocation],
					'' [BuildingLocation],
					SP.[OtherLocation],
					SP.[DepartmentID],
					SP.[DeptToNotifyForPM],
					SP.[CompanyID],
					SP.[AccountIDAssignmentWO],
					SP.[AccountIDLaborPosting],
					SP.[AccountIDPartIssues],
					SP.[AccountIDCommercialWork],
					SP.[AccountIDFuelTickets],
					SP.[AccountIDUsageTickets],
					SP.[EquipmentStatus],
					SP.[LifeCycleStatusCodeID],
					SP.[ConditionRating],
					SP.[StatusCodes],
					SP.[WorkOrders],
					SP.[UsageTickets],
					SP.[FuelTickets],
					SP.[Comments],
					SP.[DefaultWOPriorityID],
					SP.[ActualDeliveryDate],
					SP.[ActualInServiceDate],
					SP.[OriginalCost],
					SP.[DepreciationMethod],
					SP.[LifeMonths],
					SP.[MonthsRemaining],
					SP.[Ownership],
					SP.[VendorID],
					SP.[ExpirationDate],
					SP.[Meter1Expiration],
					SP.[Meter2Expiration],
					SP.[Deductible],
					SP.[WarrantyType],
					SP.[Comments2],
					SP.[EstimatedReplacementMonth],
					SP.[EstimatedReplacementYear],
					SP.[EstimatedReplacementCost],
					SP.[Latitude],
					SP.[Longitude],
					SP.[NextPMServiceNumber],
					SP.[NextPMDueDate],
					SP.[IndividualPMService],
					SP.[IndividualPMDateNextDue],
					SP.[IndividualPMNumberOfTimeUnits],
					SP.[IndividualPMTimeUnit],
					SP.[PlannedRetirementDate],
					SP.[RetirementDate],
					SP.[DispositionDate],
					SP.[GrossSalePrice],
					SP.[DisposalReason],
					SP.[DisposalMethod],
					SP.[DisposalAuthority],
					SP.[DisposalComments]
				INTO tmp.ProjectFinalResultSet
				FROM tmp.StagingProjects SP
					INNER JOIN SourceWicm210ObjectProject op ON SP.[Object_ID] = LTRIM(RTRIM(op.[OBJECT_ID]))
				WHERE SP.RowNum = @RowNumInProgress
			END
		ELSE
			BEGIN
				INSERT INTO tmp.ProjectFinalResultSet
				SELECT
					SP.[Control],
					CASE
						WHEN op.LOCATION = '04' THEN ('PRJ' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7))
						ELSE ('EQP' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7))
					END [EquipmentID],
					SP.[AssetType],
					SP.[Description],
					SP.[AssetNumber],
					CASE
						WHEN op.LOCATION = '04' THEN ('PRJ' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7))
						ELSE ('EQP' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7))
					END [SerialNumber],
					SP.[EquipmentType],
					SP.[PMProgramType],
					SP.[AssetPhotoFilePath],
					SP.[AssetPhotoFileDescription],
					SP.[ModelYear],
					SP.[ManufacturerID],
					SP.[ModelID],
					SP.[MeterTypesClass],
					SP.[Meter1Type],
					SP.[Meter2Type],
					SP.[Meter1AtDelivery],
					SP.[Meter2AtDelivery],
					SP.[LatestMeter1Reading],
					SP.[LatestMeter2Reading],
					SP.[MaxMeter1Value],
					SP.[MaxMeter2Value],
					SP.[Maintenance],
					SP.[PMProgram],
					SP.[Standards],
					SP.[RentalRates],
					SP.[Resources],
					SP.[AssetCategoryID],
					SP.[AssignedPM],
					SP.[AssignedRepair],
					SP.[StoredLocation],
					SP.[StationLocation],
					SP.[Jurisdiction],
					SP.[PreferredPMShift],
					SP.[VehicleLocation],
					'' [BuildingLocation],
					SP.[OtherLocation],
					SP.[DepartmentID],
					SP.[DeptToNotifyForPM],
					SP.[CompanyID],
					SP.[AccountIDAssignmentWO],
					SP.[AccountIDLaborPosting],
					SP.[AccountIDPartIssues],
					SP.[AccountIDCommercialWork],
					SP.[AccountIDFuelTickets],
					SP.[AccountIDUsageTickets],
					SP.[EquipmentStatus],
					SP.[LifeCycleStatusCodeID],
					SP.[ConditionRating],
					SP.[StatusCodes],
					SP.[WorkOrders],
					SP.[UsageTickets],
					SP.[FuelTickets],
					SP.[Comments],
					SP.[DefaultWOPriorityID],
					SP.[ActualDeliveryDate],
					SP.[ActualInServiceDate],
					SP.[OriginalCost],
					SP.[DepreciationMethod],
					SP.[LifeMonths],
					SP.[MonthsRemaining],
					SP.[Ownership],
					SP.[VendorID],
					SP.[ExpirationDate],
					SP.[Meter1Expiration],
					SP.[Meter2Expiration],
					SP.[Deductible],
					SP.[WarrantyType],
					SP.[Comments2],
					SP.[EstimatedReplacementMonth],
					SP.[EstimatedReplacementYear],
					SP.[EstimatedReplacementCost],
					SP.[Latitude],
					SP.[Longitude],
					SP.[NextPMServiceNumber],
					SP.[NextPMDueDate],
					SP.[IndividualPMService],
					SP.[IndividualPMDateNextDue],
					SP.[IndividualPMNumberOfTimeUnits],
					SP.[IndividualPMTimeUnit],
					SP.[PlannedRetirementDate],
					SP.[RetirementDate],
					SP.[DispositionDate],
					SP.[GrossSalePrice],
					SP.[DisposalReason],
					SP.[DisposalMethod],
					SP.[DisposalAuthority],
					SP.[DisposalComments]
				FROM tmp.StagingProjects SP
					INNER JOIN SourceWicm210ObjectProject op ON SP.[Object_ID] = LTRIM(RTRIM(op.[OBJECT_ID]))
				WHERE SP.RowNum = @RowNumInProgress
			END

		FETCH NEXT FROM Projects_Cursor
		INTO @RowNumInProgress
	END
	CLOSE Projects_Cursor;
	DEALLOCATE Projects_Cursor;

	-- CjB 6/2/15:  special circumstance
	DELETE tmp.ProjectFinalResultSet WHERE AssetNumber = 'LCGR' AND StationLocation = ''

	INSERT INTO TransformEquipment
	SELECT DISTINCT * FROM tmp.ProjectFinalResultSet

	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		FRS.[EquipmentID],
		'SourceWicm210ObjectProject' [Source],
		'OBJECT_ID' [LegacyIDSource],
		FRS.AssetNumber [LegacyID]
	FROM tmp.ProjectFinalResultSet FRS
END

--SELECT *
--FROM SourceWicm210ObjectProject OP
--WHERE OP.[OBJECT_ID] = '00A0014'

--SELECT *
--FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending 
--WHERE WO_ALT1_OB_ID = '00A0014' --'00A0014'

--SELECT [OBJECT_ID], COUNT([OBJECT_ID]) [Count]
--FROM SourceWicm250WorkOrderHeaderAdmin
--GROUP BY [OBJECT_ID]
--HAVING COUNT([OBJECT_ID]) > 1
--ORDER BY (COUNT([OBJECT_ID])) DESC

--SELECT [OBJECT_ID], DEVELOPER
--FROM SourceWicm250WorkOrderHeaderAdmin
--WHERE [OBJECT_ID] = '09MW005   '
