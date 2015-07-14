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
		[Object_ID] nvarchar(30) NOT NULL,
		[Control] [varchar] (10) NOT NULL,
		[EquipmentID] [varchar](20) NOT NULL,
		[AssetType] [varchar](20) NOT NULL,
		[Description] [varchar](40) NOT NULL,
		[AssetNumber] [varchar](20) NULL,
		[SerialNumber] [varchar](50) NOT NULL,
		[EquipmentType] [varchar](30) NULL,
		[PMProgramType] [varchar](10) NOT NULL,
		[ModelYear] [int] NOT NULL,
		[ManufacturerID] [varchar](15) NOT NULL,
		[ModelID] [varchar](15) NOT NULL,
		[MeterTypesClass] [varchar](30) NOT NULL,
		[LatestMeter1Reading] [int] NULL,
		[LatestMeter2Reading] [int] NULL,
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
		[LifeCycleStatusCodeID] [varchar](2) NULL,
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
		[ExpirationDate] [datetime] NULL

		--[Meter1Expiration] [int] NULL,
		--[Meter2Expiration] [int] NULL,
		--[Deductible] [decimal](22, 2) NULL,
		--[WarrantyType] [varchar](60) NULL,
		--[Comments2] [varchar](60) NULL,
		--[EstimatedReplacementMonth] [int] NULL,
		--[EstimatedReplacementYear] [int] NULL,
		--[EstimatedReplacementCost] [decimal](22, 2) NULL,
		--[PlannedRetirementDate] [datetime] NULL,
		--[RetirementDate] [datetime] NULL,
		--[DispositionDate] [datetime] NULL,
		--[GrossSalePrice] [decimal](22, 2) NULL,
		--[DisposalReason] [varchar](30) NULL,
		--[DisposalMethod] [varchar](20) NULL,
		--[DisposalAuthority] [varchar](6) NULL,
		--[DisposalComments] [varchar](60) NULL
	)

	INSERT INTO tmp.EquipSvc
	SELECT
		sl.CONNECTIONOBJECTID AS [Object_ID],
		'[i]' AS [Control],
		'SVC' + RIGHT(('0000000' + CAST((CAST(sl.CONNECTIONOBJECTID AS BIGINT)) AS VARCHAR)), 7) AS [EquipmentID], -- Needs to be changed to SAP Extract (EQUI.EQUNR) on available
		'STATIONARY' AS [AssetType],
		'' AS [Description], -- SAP EXTRACT (HOUSE_NUM1 + STREET + CITY1 + REGION)
		NULL AS [AssetNumber], -- SAP EXTRACT (EQUI.TPLNR)
		'SVC' + RIGHT(('0000000' + CAST((CAST(sl.CONNECTIONOBJECTID AS BIGINT)) AS VARCHAR)), 7) AS [SerialNumber],
		CASE l.TAPDIAMETER
			WHEN '1' THEN 'DSV 01 (5/8 INCH)'
			WHEN '2' THEN 'DSV 02 (3/4 INCH)'
			WHEN '3' THEN 'DSV 03 (1 INCH)'
			WHEN '4' THEN 'DSV 04 (1-1/2 INCH)'
			WHEN '5' THEN 'DSV 05 (2 INCH)'
			WHEN '6' THEN 'DSV 06 (3 INCH)'
			WHEN '7' THEN 'DSV 07 (4 INCH)'
			WHEN '8' THEN 'DSV 08 (6 INCH)'
			WHEN '9' THEN 'DSV 09 (8 INCH)'
			WHEN '10' THEN 'DSV 10 (10 INCH)'
			WHEN '12' THEN 'DSC 12 (12 INCH)'
		END AS [EquipmentType],
		'NONE' [PMProgramType],
		1900 AS [ModelYear], -- SAP EXTRACT (AUFK.MODEL_YEAR)
		'NA' [ManufacturerID],
		'NA' [ModelID],
		'WATER METER' [MeterTypesClass],
		NULL AS [LatestMeter1Reading], -- Needs to be provided as extract from deloitte
		NULL AS [LatestMeter2Reading], -- Needs to be provided as extract from deloitte
		'DMAINT SERVICE' [Maintenance],
		'DNA' [PMProgram],
		'DMAINT SERVICE' [Standards],
		'DNA' [RentalRates],
		'DMAINT SERVICE' [Resources],
		'SERVICE' AssetCategoryID,
		'D-INSTALL' AssignedPM,
		'D-INSTALL' AssignedRepair,
		'' AS [StationLocation], -- SAP EXTRACT (ADRC.CITY1)
		'DAY' [PreferredPMShift],
		'413505' [DepartmentID],
		'413505' [DDeptToNotifyForPM],
		NULL AS [CompanyID], -- OPEN ISSUE
		NULL AS [AccountIDWO], -- OPEN ISSUE
		NULL AS [AccountIDLabor], -- OPEN ISSUE
		NULL AS [AccountIDPart], -- OPEN ISSUE
		NULL AS [AccountIDCommercial], -- OPEN ISSUE
		NULL AS [AccountIDFuel], -- OPEN ISSUE
		NULL AS [AccountIDUsage], -- OPEN ISSUE
		NULL AS [LifeCycleStatusCodeID], -- OPEN ISSUE
		NULL AS [ConditionRating],
		NULL AS [StatusCodes],  -- Intentionally set blank per spec
		'Y' [WorkOrders],
		'N' [UsageTickets],
		'N' [FuelTickets],
		NULL  AS [Comments], -- Open Issue
		'D3' AS [DefaultWOPriorityID],
		NULL AS [ActualDeliveryDate], -- SAP Extract (AUFK.ERDAT)
		NULL AS [ActualInServiceDate], -- Open Issue
		NULL AS [OriginalCost], -- Intentionally set blank per spec
		NULL AS [DepreciationMethod], -- Open Issue
		NULL AS [LifeMonths], -- Open Issue
		'OWNED' AS [Ownership],
		NULL AS [ExpirationDate] -- Intentionally set blank per spec
	FROM srcGis.ServiceLocation sl
	INNER JOIN srcGis.Lateral l
		ON sl.SERVICELOCATIONID = l.SERVICELOCATIONID
	WHERE sl.CONNECTIONOBJECTID IS NOT NULL

	---- ManufacturerID & ModelID Cleansing
	UPDATE e
	SET
		ManufacturerID = manid.TargetValue,
		ModelID = modid.CleansedModelID
	FROM tmp.EquipSvc e
	LEFT JOIN TransformEquipmentManufacturer manid
		ON e.ManufacturerID = manid.SourceValue
		AND manid.Source = 'Facilities'
	LEFT JOIN TransformEquipmentManufacturerModel modid
		ON manid.TargetValue = modid.CleansedManufacturerID
		AND e.ModelID = modid.SourceModelID
		AND modid.Source = 'Facilities'
	
	--EquipmentId Clensing
	UPDATE e
	SET e.EquipmentType = et.EquipmentType
	FROM tmp.EquipSvc e
	LEFT JOIN TransformEquipmentTypeAdditionalStableValues et
		ON e.EquipmentType = et.EquipmentType
	WHERE et.Source = 'Distribution'
				
	--INSERT INTO TransformEquipmentService
	INSERT INTO [dbo].[TransformEquipmentService]
    (
		[Control]
        ,[EquipmentID]
        ,[AssetType]
        ,[Description]
        ,[AssetNumber]
        ,[SerialNumber]
        ,[EquipmentType]
        ,[PMProgramType]
        ,[ModelYear]
        ,[ManufacturerID]
        ,[ModelID]
        ,[MeterTypesClass]
        --,[Meter1Type]
        --,[Meter2Type]
        --,[Meter1AtDelivery]
        --,[Meter2AtDelivery]
        ,[LatestMeter1Reading]
        ,[LatestMeter2Reading]
        --,[MaxMeter1Value]
        --,[MaxMeter2Value]
        ,[Maintenance]
        ,[PMProgram]
        ,[Standards]
        ,[RentalRates]
        ,[Resources]
        ,[AssetCategoryID]
        ,[AssignedPM]
        ,[AssignedRepair]
        ,[StationLocation]
        ,[PreferredPMShift]
        ,[DepartmentID]
        ,[DeptToNotifyForPM]
        ,[CompanyID]
        ,[AccountIDAssignmentWO]
        ,[AccountIDLaborPosting]
        ,[AccountIDPartIssues]
        ,[AccountIDCommercialWork]
        ,[AccountIDFuelTickets]
        ,[AccountIDUsageTickets]
        ,[LifeCycleStatusCodeID]
        ,[ConditionRating]
        ,[StatusCodes]
        ,[WorkOrders]
        ,[UsageTickets]
        ,[FuelTickets]
        ,[Comments]
        ,[DefaultWOPriorityID]
        ,[ActualDeliveryDate]
        ,[ActualInServiceDate]
        ,[OriginalCost]
        ,[DepreciationMethod]
        ,[LifeMonths]
        ,[Ownership]
        --,[VendorID]
        ,[ExpirationDate]
        --,[Meter1Expiration]
        --,[Meter2Expiration]
        --,[Deductible]
        --,[WarrantyType]
        --,[Comments2]
        --,[EstimatedReplacementMonth]
        --,[EstimatedReplacementYear]
        --,[EstimatedReplacementCost]
        --,[PlannedRetirementDate]
        --,[RetirementDate]
        --,[DispositionDate]
        --,[GrossSalePrice]
        --,[DisposalReason]
        --,[DisposalMethod]
        --,[DisposalAuthority]
        --,[DisposalComments]
        ,[CreateDt]
	)
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
		[LatestMeter1Reading],
		[LatestMeter2Reading],
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
		[ExpirationDate],
		GETDATE()
	FROM tmp.EquipSvc ES
	ORDER BY ES.EquipmentID

	---- Components to the crosswalk table.
	--INSERT INTO TransformComponentLegacyXwalk
	--SELECT
	--	vehs.EquipmentID [EquipmentID],
	--	'SourceWicm210ObjectVehicle' [Source],
	--	'OBJECT_ID' [LegacyIDSource],
	--	vehs.[Object_ID] [LegacyID]
	--FROM tmp.EquipSvc vehs
END
