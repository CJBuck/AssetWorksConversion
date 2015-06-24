USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentService]    Script Date: 06/23/2015 13:52:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentService]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentService]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentService]    Script Date: 06/23/2015 13:52:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentService](
	[Control] [varchar] (10) NOT NULL,
	[EquipmentID] [varchar](20) NOT NULL,
	[AssetType] [varchar](20) NULL,
	[Description] [varchar](40) NULL,
	[AssetNumber] [varchar](20) NULL,
	[SerialNumber] [varchar](50) NULL,
	[EquipmentType] [varchar](30) NULL,
	[PMProgramType] [varchar](10) NULL,
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
	[StationLocation] [varchar](10) NULL,
	[PreferredPMShift] [varchar](10) NULL,
	[DepartmentID] [varchar](10) NULL,
	[DeptToNotifyForPM] [varchar](10) NULL,
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
