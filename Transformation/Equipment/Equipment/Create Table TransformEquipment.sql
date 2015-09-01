USE [AssetWorksConversion]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipment_MeterTypesClass]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipment] DROP CONSTRAINT [DF_TransformEquipment_MeterTypesClass]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipment_Resources]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipment] DROP CONSTRAINT [DF_TransformEquipment_Resources]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipment_PreferredPMShift]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipment] DROP CONSTRAINT [DF_TransformEquipment_PreferredPMShift]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipment_LifeCycleStatusCodeID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipment] DROP CONSTRAINT [DF_TransformEquipment_LifeCycleStatusCodeID]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipment_WorkOrders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipment] DROP CONSTRAINT [DF_TransformEquipment_WorkOrders]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipment_UsageTickets]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipment] DROP CONSTRAINT [DF_TransformEquipment_UsageTickets]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipment_FuelTickets]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipment] DROP CONSTRAINT [DF_TransformEquipment_FuelTickets]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipment_DefaultWOPriorityID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipment] DROP CONSTRAINT [DF_TransformEquipment_DefaultWOPriorityID]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipment_DepreciationMethod]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipment] DROP CONSTRAINT [DF_TransformEquipment_DepreciationMethod]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipment_Ownership]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipment] DROP CONSTRAINT [DF_TransformEquipment_Ownership]
END

GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipment]    Script Date: 01/28/2015 13:12:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipment]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipment]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipment]    Script Date: 01/28/2015 13:12:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipment](
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
	[StoredLocation] [varchar](10) NULL,		-- 2/18
	[StationLocation] [varchar](10) NULL,
	[Jurisdiction] [varchar] (2) NULL,
	[PreferredPMShift] [varchar](10) NULL,
	[VehicleLocation] [varchar](20) NULL,		-- 2/18
	[BuildingLocation] [varchar](20) NULL,		-- 2/18
	[OtherLocation] [varchar](20) NULL,			-- 2/18
	[DepartmentID] [varchar](10) NULL,
	[DeptToNotifyForPM] [varchar](10) NULL,
	[CompanyID] [varchar](10) NULL,
	[AccountIDAssignmentWO] [varchar](10) NULL,
	[AccountIDLaborPosting] [varchar](10) NULL,
	[AccountIDPartIssues] [varchar](10) NULL,
	[AccountIDCommercialWork] [varchar](10) NULL,
	[AccountIDFuelTickets] [varchar](10) NULL,
	[AccountIDUsageTickets] [varchar](10) NULL,
	[EquipmentStatus] [varchar](10) NULL,		-- 2/18
	[LifeCycleStatusCodeID] [varchar](2) NULL,
	[UserStatus1] varchar(6) NULL,
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
	[MonthsRemaining] [decimal](22, 2) NULL,	-- 2/18
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
	[Latitude] [varchar](10) NULL,				-- 2/18
	[Longitude] [varchar](10) NULL,				-- 2/18
	[NextPMServiceNumber] [int] NULL,			-- 2/18
	[NextPMDueDate] [datetime] NULL,			-- 2/18
	[IndividualPMService] [varchar](30) NULL,	-- Updated per BA 09/01
	[IndividualPMDateNextDue] [datetime] NULL,	-- 2/18
	[IndividualPMNumberofTimeUnits] [int] NULL,	-- 2/18
	[IndividualPMTimeUnit] [varchar](10) NULL,	-- 2/18
	[PlannedRetirementDate] [datetime] NULL,
	[RetirementDate] [datetime] NULL,
	[DispositionDate] [datetime] NULL,
	[GrossSalePrice] [decimal](22, 2) NULL,
	[DisposalReason] [varchar](30) NULL,
	[DisposalMethod] [varchar](20) NULL,
	[DisposalAuthority] [varchar](6) NULL,
	[DisposalComments] [varchar](60) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TransformEquipment] ADD  CONSTRAINT [DF_TransformEquipment_MeterTypesClass]  DEFAULT ('NO METER') FOR [MeterTypesClass]
GO

ALTER TABLE [dbo].[TransformEquipment] ADD  CONSTRAINT [DF_TransformEquipment_Resources]  DEFAULT ('Y') FOR [Resources]
GO

ALTER TABLE [dbo].[TransformEquipment] ADD  CONSTRAINT [DF_TransformEquipment_PreferredPMShift]  DEFAULT ('FACM58') FOR [PreferredPMShift]
GO

ALTER TABLE [dbo].[TransformEquipment] ADD  CONSTRAINT [DF_TransformEquipment_LifeCycleStatusCodeID]  DEFAULT ('A') FOR [LifeCycleStatusCodeID]
GO

ALTER TABLE [dbo].[TransformEquipment] ADD  CONSTRAINT [DF_TransformEquipment_WorkOrders]  DEFAULT ('Y') FOR [WorkOrders]
GO

ALTER TABLE [dbo].[TransformEquipment] ADD  CONSTRAINT [DF_TransformEquipment_UsageTickets]  DEFAULT ('N') FOR [UsageTickets]
GO

ALTER TABLE [dbo].[TransformEquipment] ADD  CONSTRAINT [DF_TransformEquipment_FuelTickets]  DEFAULT ('N') FOR [FuelTickets]
GO

ALTER TABLE [dbo].[TransformEquipment] ADD  CONSTRAINT [DF_TransformEquipment_DefaultWOPriorityID]  DEFAULT ('F5') FOR [DefaultWOPriorityID]
GO

ALTER TABLE [dbo].[TransformEquipment] ADD  CONSTRAINT [DF_TransformEquipment_DepreciationMethod]  DEFAULT ('1/2 Year Straight Line') FOR [DepreciationMethod]
GO

ALTER TABLE [dbo].[TransformEquipment] ADD  CONSTRAINT [DF_TransformEquipment_Ownership]  DEFAULT ('Owned') FOR [Ownership]
GO
