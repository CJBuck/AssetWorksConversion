USE [AssetWorksConversion]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TargetComponent_MeterTypesClass]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TargetComponent] DROP CONSTRAINT [DF_TargetComponent_MeterTypesClass]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TargetComponent_Resources]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TargetComponent] DROP CONSTRAINT [DF_TargetComponent_Resources]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TargetComponent_PreferredPMShift]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TargetComponent] DROP CONSTRAINT [DF_TargetComponent_PreferredPMShift]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TargetComponent_LifeCycleStatusCodeID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TargetComponent] DROP CONSTRAINT [DF_TargetComponent_LifeCycleStatusCodeID]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TargetComponent_WorkOrders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TargetComponent] DROP CONSTRAINT [DF_TargetComponent_WorkOrders]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TargetComponent_UsageTickets]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TargetComponent] DROP CONSTRAINT [DF_TargetComponent_UsageTickets]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TargetComponent_FuelTickets]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TargetComponent] DROP CONSTRAINT [DF_TargetComponent_FuelTickets]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TargetComponent_DefaultWOPriorityID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TargetComponent] DROP CONSTRAINT [DF_TargetComponent_DefaultWOPriorityID]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TargetComponent_Ownership]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TargetComponent] DROP CONSTRAINT [DF_TargetComponent_Ownership]
END

GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetComponent]    Script Date: 01/28/2015 13:12:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetComponent]') AND type in (N'U'))
DROP TABLE [dbo].[TargetComponent]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetComponent]    Script Date: 01/28/2015 13:12:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetComponent](
	[Control] [varchar] (10) NOT NULL,
	[AssetID] [varchar](20) NOT NULL,
	[Description] [varchar](40) NOT NULL,
	[ModelYear] [int] NOT NULL,
	[ManufacturerID] [varchar](15) NOT NULL,
	[ModelID] [varchar](15) NOT NULL,
	[EquipmentType] [varchar](30) NOT NULL,
	[SerialNumber] [varchar](50) NULL,
	[PMProgramType] [varchar](10) NOT NULL,
	[AssetNumber] [varchar](20) NULL,
	[MeterTypesClass] [varchar](30) NOT NULL,
	[Meter1Type] [varchar](10) NULL,
	[Meter1AtDelivery] [int] NULL,
	[LatestMeter1Reading] [int] NULL,
	[MaxMeter1Value] [int] NULL,
	[Meter2Type] [varchar](10) NULL,
	[Meter2AtDelivery] [int] NULL,
	[MaxMeter2Value] [int] NULL,
	[Maintenance] [varchar](30) NOT NULL,
	[PMClass] [varchar](30) NOT NULL,
	[Standards] [varchar](30) NOT NULL,
	[RentalRates] [varchar](30) NOT NULL,
	[Resources] [varchar](30) NOT NULL,
	[AssetCategoryID] [varchar](15) NOT NULL,
	[AssignedPM] [varchar] (10) NOT NULL,
	[AssignedRepair] [varchar] (10) NOT NULL,
	[StoredLocation] [varchar](10) NULL,
	[PreferredPMShift] [varchar](10) NOT NULL,
	[StationLocation] [varchar](10) NOT NULL,
	[DepartmentID] [varchar](10) NOT NULL,
	[DepartmentForPM] [varchar](10) NOT NULL,
	[AccountIDWO] [varchar](10) NULL,
	[AccountIDLabor] [varchar](10) NULL,
	[AccountIDPart] [varchar](10) NULL,
	[AccountIDCommercial] [varchar](10) NULL,
	[AccountIDFuel] [varchar](10) NULL,
	[AccountIDUsage] [varchar](10) NULL,
	[LifeCycleStatusCodeID] [varchar](10) NULL,
	[ConditionRating] [varchar](20) NULL,
	[WorkOrders] [char](1) NOT NULL,
	[UsageTickets] [char](1) NULL,
	[FuelTickets] [char](1) NULL,
	[FuelCardID] [varchar] (12) NULL,
	[NextPMServiceNumber] [int] NULL,
	[NextPMDueDate] [datetime] NULL,
	[DefaultWOPriorityID] [varchar](2) NULL,
	[ActualDeliveryDate] [datetime] NULL,
	[ActualInServiceDate] [datetime] NULL,
	[OriginalCost] [decimal](22, 2) NULL,
	[DepreciationMethod] [varchar] (25) NULL,
	[LifeMonths] [int] NULL,
	[Ownership] [varchar](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TargetComponent] ADD  CONSTRAINT [DF_TargetComponent_MeterTypesClass]  DEFAULT ('NO METER') FOR [MeterTypesClass]
GO

ALTER TABLE [dbo].[TargetComponent] ADD  CONSTRAINT [DF_TargetComponent_Resources]  DEFAULT ('Y') FOR [Resources]
GO

ALTER TABLE [dbo].[TargetComponent] ADD  CONSTRAINT [DF_TargetComponent_PreferredPMShift]  DEFAULT ('FACM58') FOR [PreferredPMShift]
GO

ALTER TABLE [dbo].[TargetComponent] ADD  CONSTRAINT [DF_TargetComponent_LifeCycleStatusCodeID]  DEFAULT ('A') FOR [LifeCycleStatusCodeID]
GO

ALTER TABLE [dbo].[TargetComponent] ADD  CONSTRAINT [DF_TargetComponent_WorkOrders]  DEFAULT ('Y') FOR [WorkOrders]
GO

ALTER TABLE [dbo].[TargetComponent] ADD  CONSTRAINT [DF_TargetComponent_UsageTickets]  DEFAULT ('N') FOR [UsageTickets]
GO

ALTER TABLE [dbo].[TargetComponent] ADD  CONSTRAINT [DF_TargetComponent_FuelTickets]  DEFAULT ('N') FOR [FuelTickets]
GO

ALTER TABLE [dbo].[TargetComponent] ADD  CONSTRAINT [DF_TargetComponent_DefaultWOPriorityID]  DEFAULT ('F5') FOR [DefaultWOPriorityID]
GO

ALTER TABLE [dbo].[TargetComponent] ADD  CONSTRAINT [DF_TargetComponent_Ownership]  DEFAULT ('Owned') FOR [Ownership]
GO
