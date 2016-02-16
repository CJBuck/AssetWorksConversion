-- ===============================================================================
-- Created By:		Chris Buck
-- Create Date:		02/11/2016
-- Update Date:
--
-- Description:		Creates/modifies the spTransformTools stored procedure.
-- ===============================================================================

IF OBJECT_ID('spTransformTools') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformTools AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformTools
AS

BEGIN
	IF OBJECT_ID('tmp.ToolsUsageTicket') IS NOT NULL
	DROP TABLE tmp.ToolsUsageTicket

	CREATE TABLE tmp.ToolsUsageTicket (
		[Control] [varchar] (10) NOT NULL,
		[EquipmentID] [VARCHAR](20) NOT NULL,
		[Tickets] [VARCHAR](25) NOT NULL,
		[CreateDt] [DATETIME] NOT NULL
	)

	IF OBJECT_ID('tmp.ToolsTickets') IS NOT NULL
	DROP TABLE tmp.ToolsTickets

	CREATE TABLE tmp.ToolsTickets (
		[Control] [varchar] (10) NOT NULL,
		[EquipmentID] [VARCHAR](20) NOT NULL,
		[TransactionDate] [DATETIME] NOT NULL,
		[DepartmentID] [VARCHAR](10) NOT NULL,
		[OperatorID] [VARCHAR](50) NULL,
		[HoursUsed] [INT] NOT NULL,
		[PoolLocationID] [VARCHAR](10) NULL,
		[WorkOrderLocation] [VARCHAR](10) NULL,
		[WorkOrderYear] [INT] NULL,
		[WorkOrderNumber] [VARCHAR](15) NULL,
		[TaskID] [VARCHAR](1) NULL,
		[CreateDt] [DATETIME] NOT NULL
	)

	IF OBJECT_ID('tmp.EquipmentTools') IS NOT NULL
		DROP TABLE tmp.EquipmentTools

	CREATE TABLE tmp.EquipmentTools(
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
		[UserStatus1] [varchar](6) NULL,
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

	-- Populate tmp.EquipmentTools
	INSERT INTO tmp.EquipmentTools
	SELECT
		LTRIM(RTRIM(T.TOOL_ID)) [Object_ID],
		'[i]' [Control],
		LTRIM(RTRIM(T.TOOL_ID)) [EquipmentID],
		'ASSET' [AssetType],
		T.TOOL_DESCRIP [Description],
		LTRIM(RTRIM(T.TOOL_ID)) [AssetNumber],
		LTRIM(RTRIM(T.TOOL_ID)) [SerialNumber],
		LTRIM(RTRIM(T.TOOL_ID)) [EquipmentType],
		'None' [PMProgramType],
		'' [AssetPhotoFilePath],
		'' [AssetPhotoFileDescription],
		1901 [ModelYear],
		'NA' [ManufacturerID],
		'NA' [ModelID],
		'NO METER' AS [MeterTypesClass],
		'' [Meter1Type],
		'' [Meter2Type],
		NULL [Meter1AtDelivery],
		NULL [Meter2AtDelivery],
		NULL [LatestMeter1Reading],
		NULL [LatestMeter2Reading],
		NULL [MaxMeter1Value],
		NULL [MaxMeter2Value],
		'DNA' [Maintenance],
		'DNA' [PMProgram],
		'DNA' [Standards],
		LTRIM(RTRIM(T.TOOL_ID)) [RentalRates],
		LTRIM(RTRIM(T.TOOL_ID)) [Resources],
		'NNWW TOOLS' AssetCategoryID,
		tpml.PM AssignedPM,
		tpml.PM AssignedRepair,
		'' [StoredLocation],
		tpml.PM [StationLocation],
		'' [Jurisdiction],
		'DAY' [PreferredPMShift],
		'' [VehicleLocation],
		'' [BuildingLocation],
		'' [OtherLocation],
		CASE
			WHEN tpml.PM = 'VEH SHOP' THEN '414005'
			WHEN tpml.PM = 'SE SHOP' THEN '414006'
			ELSE ''
		END [DepartmentID],
		CASE
			WHEN tpml.PM = 'VEH SHOP' THEN '414005'
			WHEN tpml.PM = 'SE SHOP' THEN '414006'
			ELSE ''
		END [DepartmentToNotifyForPM],
		'' [CompanyID],
		'' [AccountIDAssignmentWO],		-- TBD
		'' [AccountIDLaborPosting],		-- TBD
		'' [AccountIDPartIssues],		-- TBD
		'' [AccountIDCommercialWork],	-- TBD
		'' [AccountIDFuelTickets],		-- TBD
		'' [AccountIDUsageTickets],		-- TBD
		'IN SERVICE' [EquipmentStatus],
		'A' [LifeCycleStatusCodeID],
		NULL [UserStatus1],
		'' [ConditionRating],
		'' [StatusCodes],
		'Y' [WorkOrders],
		'Y' [UsageTickets],
		'N' [FuelTickets],
		'' [Comments],
		'PM' [DefaultWOPriorityID],		-- Work out with Tanni
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
		NULL [NextPMServiceNumber],
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
	FROM SourceWicm230TableLookupToolIDs T
		INNER JOIN TransformToolsPMLookup tpml ON T.TOOL_ID = tpml.TOOL_ID
		
	-- Populate tmp.ToolsUsageTicket
	INSERT INTO tmp.ToolsUsageTicket
	SELECT DISTINCT
		'[i]' [Control],
		EquipmentID,
		'[244:1;TICKETS;1:1]' [Tickets],
		GETDATE()
	FROM tmp.EquipmentTools
	
	-- Populate tmp.ToolsTickets
	INSERT INTO tmp.ToolsTickets
	SELECT
		'[i]' [Control],
		tut.EquipmentID,
		WODT.TRANS_DATE [TransactionDate],
		et.DepartmentID,
		'' [OperatorID],
		CONVERT(DECIMAL, WODT.TOOL_HOURS) [HoursUsed],
		'' [PoolLocationID],
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		'' [TaskID],
		GETDATE() [CreateDt]
	FROM SourceWicm251WorkOrderDetailTools WODT
		INNER JOIN tmp.ToolsUsageTicket tut ON WODT.TOOL_ID = tut.EquipmentID
		INNER JOIN dbo.TransformWorkOrderCenter woc ON WODT.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN tmp.EquipmentTools et ON tut.EquipmentID = et.EquipmentID
	WHERE
		WODT.[STATUS] <> 'D'

	-- Copy tmp.EquipmentTools to TransformEquipment
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
		[UserStatus1],
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
	FROM tmp.EquipmentTools ET
	ORDER BY ET.EquipmentID
	
	-- Copy tmp.ToolsUsageTicket to TransformToolsUsageTicket
	INSERT INTO TransformToolsUsageTicket
	SELECT
		tmp.[Control],
		tmp.EquipmentID,
		tmp.Tickets,
		tmp.CreateDt
	FROM tmp.ToolsUsageTicket tmp

	-- Copy tmp.ToolsTickets to TransformToolsTickets
	INSERT INTO TransformToolsTickets
	SELECT *
	FROM tmp.ToolsTickets TT
	
	-- Populate TransformEquipmentLegacyXwalk
	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		EquipmentID,
		'SourceWicm230TableLookupToolIDs' [Source],
		'TOOL_ID' [LegacyIDSource],
		EquipmentID [LegacyID]
	FROM TransformToolsUsageTicket

END
