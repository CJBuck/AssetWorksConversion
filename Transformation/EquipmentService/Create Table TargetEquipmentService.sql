USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetEquipmentService]    Script Date: 06/23/2015 14:43:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetEquipmentService]') AND type in (N'U'))
DROP TABLE [dbo].[TargetEquipmentService]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetEquipmentService]    Script Date: 06/23/2015 14:43:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetEquipmentService](
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
	[DisposalComments] [varchar](60) NULL,
	[CreateDt] [datetime]
) ON [PRIMARY]
GO
