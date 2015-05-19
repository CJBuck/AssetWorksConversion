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
	
	-- Grab the relevant ObjectIDs
	-- Location = '04'
	SELECT LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID], LTRIM(RTRIM(OP.LOCATION)) [LOCATION]
	INTO #ObjectIDs
	FROM SourceWicm210ObjectProject OP
		INNER JOIN SourceWicm250WorkOrderHeaderAdmin woa
			ON OP.[OBJECT_ID] = woa.[OBJECT_ID] AND woa.[STATUS] IN ('A','P')
	WHERE
		OP.LOCATION = '04'
		AND OP.[STATUS] = 'A'
		AND LTRIM(RTRIM(OP.[CLASS])) NOT IN ('LHTP', 'WRKSTA')
		
	-- Location = '05'
	INSERT INTO #ObjectIDs
	SELECT LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID], LTRIM(RTRIM(OP.LOCATION)) [LOCATION]
	FROM SourceWicm210ObjectProject OP
	WHERE
		OP.LOCATION = '05'
		AND LTRIM(RTRIM(OP.[CLASS])) NOT IN ('LHTP', 'WRKSTA')
		
	-- Populate a temp table with the ActualInServiceDate per spec.
	SELECT
		LTRIM(RTRIM(woifp.WO_ALT1_OB_ID)) [OBJECT_ID],
		CAST(woifp.WORK_PEND_DT AS DATETIME) [ActualInServiceDate]
	INTO #InSvcDate
	FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending woifp
	WHERE
		LTRIM(RTRIM(woifp.WO_ALT1_OB_ID)) IN (SELECT [OBJECT_ID] FROM #ObjectIDs)
		AND ((woifp.WORK_PEND_DT IS NOT NULL) AND (LTRIM(RTRIM(woifp.WORK_PEND_DT)) <> '0'))
		
	INSERT INTO #InSvcDate
	SELECT LTRIM(RTRIM(woifp.WO_ALT1_OB_ID)),
		CASE
			WHEN woifp.PL_CMPL_DT_C > woifp.PL_CMPL_DT_W THEN CAST(woifp.PL_CMPL_DT_C AS DATETIME)
			WHEN woifp.PL_CMPL_DT_W > woifp.PL_CMPL_DT_C THEN CAST(woifp.PL_CMPL_DT_W AS DATETIME)
			ELSE NULL
		END [ActualInServiceDate]
	FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending woifp
	WHERE
		LTRIM(RTRIM(woifp.WO_ALT1_OB_ID)) IN (SELECT [OBJECT_ID] FROM #ObjectIDs)
		AND LTRIM(RTRIM(woifp.WO_ALT1_OB_ID)) NOT IN (SELECT [OBJECT_ID] FROM #InSvcDate)
		AND ((woifp.WORK_PEND_DT IS NULL) OR (LTRIM(RTRIM(woifp.WORK_PEND_DT)) = '0'))
	-- *****

	SELECT
		ROW_NUMBER() OVER(ORDER BY OP.[OBJECT_ID]) [RowNum],
		'EQP' + '' [EquipmentID],
		'STATIONARY' [AssetType],
		LTRIM(RTRIM(OP.BLD_PRJ_NAME)) [Description],
		LTRIM(RTRIM(OP.[OBJECT_ID])) [AssetNumber],
		'EQP' + '' [SerialNumber],
		lkup.EquipmentType [EquipmentType],
		'NONE' [PMProgramType],
		'' [AssetPhotoFilePath],
		'' [AssetPhotoFileDescription],
		1901 [ModelYear],
		'NOT APPLICABLE' [ManufacturerID],
		'NOT APPLICABLE' [ModelID],
		'NO METER' [MeterTypesClass],
		'' [Meter1Type],
		'' [Meter2Type],
		NULL [Meter1AtDelivery],
		NULL [Meter2AtDelivery],
		NULL [LatestMeter1Reading],
		NULL [LatestMeter2Reading],
		NULL [MaxMeter1Value],
		NULL [MaxMeter2Value],
		CASE
			WHEN OP.LOCATION IN ('04') THEN 'NOT APPLICABLE'
			ELSE lkup.EquipmentType
		END AS [Maintenance],
		CASE
			WHEN OP.LOCATION IN ('04') THEN 'NOT APPLICABLE'
			ELSE lkup.EquipmentType
		END AS [PMProgram],
		'NOT APPLICABLE' [Standards],
		'NOT APPLICABLE' [RentalRates],
		CASE
			WHEN OP.LOCATION IN ('04') THEN 'NOT APPLICABLE'
			ELSE lkup.EquipmentType
		END AS [Resources],
		lkup.AssetCategoryID [AssetCategoryID],
		LEFT('NOT APPLICABLE', 10) [AssignedPM],
		LEFT('NOT APPLICABLE', 10) [AssignedRepair],
		'' [StoredLocation],
		LEFT(LTRIM(RTRIM(OP.BLDG_ADDR)), 10) [StationLocation],	-- Open issue: handling truncation.
		LTRIM(RTRIM(OP.MAINT_SHOP)) [Jurisdiction],
		'M-F' [PreferredPMShift],
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
		'' [EquipmentStatus],
		'A' [LifeCycleStatusCodeID],
		'' [ConditionRating],
		'' [StatusCodes],
		'Y' [WorkOrders],
		'N' [UsageTickets],
		'N' [FuelTickets],
		'' [Comments],
		CASE OP.[LOCATION]
			WHEN '04' THEN 'D4'
			WHEN '05' THEN 'N3'
			ELSE ''
		END [DefaultWOPriorityID],
		NULL [ActualDeliveryDate],
		aisd.ActualInServiceDate [ActualInServiceDate],		-- Open issue
		CASE OP.[LOCATION]
			WHEN '04' THEN ISNULL(woa.TOTAL_COST, NULL)
			ELSE NULL
		END [OriginalCost],
		'' [DepreciationMethod],
		NULL [LifeMonths],
		NULL [MonthsRemaining],
		'' [Ownership],
		CASE OP.[LOCATION]			-- Open issue: handling truncation.
			WHEN '04' THEN ISNULL((LEFT(LTRIM(RTRIM(woa.DEVELOPER)), 15)), '')
			ELSE ''
		END [VendorID],
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
	INTO #StagingProjects
	FROM SourceWicm210ObjectProject OP
		INNER JOIN TransformEquipmentProjectValueAssetCategory lkup ON
			ISNULL(LTRIM(RTRIM(OP.CLASS)), '') = LTRIM(RTRIM(lkup.CLASS))
		LEFT JOIN (
			SELECT DISTINCT
				[OBJECT_ID], LTRIM(RTRIM(TOTAL_COST)) [TOTAL_COST], LTRIM(RTRIM(DEVELOPER)) [DEVELOPER]
			FROM SourceWicm250WorkOrderHeaderAdmin
			WHERE [OBJECT_ID] IN (SELECT [OBJECT_ID] FROM #ObjectIDs)
			) woa ON LTRIM(RTRIM(OP.[OBJECT_ID])) = LTRIM(RTRIM(woa.[OBJECT_ID]))
		LEFT JOIN #InSvcDate aisd ON OP.[OBJECT_ID] = aisd.[OBJECT_ID]
	WHERE
		LTRIM(RTRIM(OP.[OBJECT_ID])) IN (SELECT [OBJECT_ID] FROM #ObjectIDs)

	DECLARE Projects_Cursor CURSOR
	FOR SELECT SP.RowNum [RowNum]
	FROM #StagingProjects SP
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
					'EQP' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7) [EquipmentID],
					SP.[AssetType],
					SP.[Description],
					SP.[AssetNumber],
					'EQP' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7) [SerialNumber],
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
				INTO #FinalResultSet
				FROM #StagingProjects SP
				WHERE SP.RowNum = @RowNumInProgress
			END
		ELSE
			BEGIN
				INSERT INTO #FinalResultSet
				SELECT
					'EQP' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7) [EquipmentID],
					SP.[AssetType],
					SP.[Description],
					SP.[AssetNumber],
					'EQP' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7) [SerialNumber],
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
				FROM #StagingProjects SP
				WHERE SP.RowNum = @RowNumInProgress
			END
		
		FETCH NEXT FROM Projects_Cursor
		INTO @RowNumInProgress
	END
	CLOSE Projects_Cursor;
	DEALLOCATE Projects_Cursor;

	INSERT INTO TransformEquipment
	SELECT * FROM #FinalResultSet

	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		FRS.[EquipmentID],
		'SourceWicm210ObjectProject' [Source],
		'OBJECT_ID' [LegacyIDSource],
		FRS.AssetNumber [LegacyID]
	FROM #FinalResultSet FRS
END

-- Clean up
IF OBJECT_ID('tempdb..#StagingProjects') IS NOT NULL
	DROP TABLE #StagingProjects
IF OBJECT_ID('tempdb..#FinalResultSet') IS NOT NULL
	DROP TABLE #FinalResultSet
IF OBJECT_ID('tempdb..#ObjectIDs') IS NOT NULL
	DROP TABLE #ObjectIDs
IF OBJECT_ID('tempdb..#InSvcDate') IS NOT NULL
	DROP TABLE #InSvcDate

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
