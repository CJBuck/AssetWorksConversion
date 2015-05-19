USE [AssetWorksConversion]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformComponent_MeterTypesClass]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformComponent] DROP CONSTRAINT [DF_TransformComponent_MeterTypesClass]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformComponent_Resources]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformComponent] DROP CONSTRAINT [DF_TransformComponent_Resources]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformComponent_PreferredPMShift]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformComponent] DROP CONSTRAINT [DF_TransformComponent_PreferredPMShift]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformComponent_LifeCycleStatusCodeID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformComponent] DROP CONSTRAINT [DF_TransformComponent_LifeCycleStatusCodeID]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformComponent_WorkOrders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformComponent] DROP CONSTRAINT [DF_TransformComponent_WorkOrders]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformComponent_UsageTickets]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformComponent] DROP CONSTRAINT [DF_TransformComponent_UsageTickets]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformComponent_FuelTickets]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformComponent] DROP CONSTRAINT [DF_TransformComponent_FuelTickets]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformComponent_DefaultWOPriorityID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformComponent] DROP CONSTRAINT [DF_TransformComponent_DefaultWOPriorityID]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformComponent_Ownership]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformComponent] DROP CONSTRAINT [DF_TransformComponent_Ownership]
END

GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformComponent]    Script Date: 01/28/2015 13:12:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformComponent]') AND type in (N'U'))
DROP TABLE [dbo].[TransformComponent]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformComponent]    Script Date: 01/28/2015 13:12:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformComponent](
	[Control] [varchar] (10) NOT NULL,
	[AssetID] [varchar](20) NOT NULL,
	[Description] [varchar](40) NULL,
	[ModelYear] [int] NULL,
	[ManufacturerID] [varchar](15) NULL,
	[ModelID] [varchar](15) NULL,
	[EquipmentType] [varchar](30) NULL,
	[SerialNumber] [varchar](50) NULL,
	[PMProgramType] [varchar](10) NULL,
	[AssetNumber] [varchar](20) NULL,
	[MeterTypesClass] [varchar](30) NULL,
	[Meter1Type] [varchar](10) NULL,
	[Meter1AtDelivery] [int] NULL,
	[LatestMeter1Reading] [int] NULL,
	[MaxMeter1Value] [int] NULL,
	[Meter2Type] [varchar](10) NULL,
	[Meter2AtDelivery] [int] NULL,
	[MaxMeter2Value] [int] NULL,
	[Maintenance] [varchar](30) NULL,
	[PMClass] [varchar](30) NULL,
	[Standards] [varchar](30) NULL,
	[RentalRates] [varchar](30) NULL,
	[Resources] [varchar](30) NULL,
	[AssetCategoryID] [varchar](15) NULL,
	[AssignedPM] [varchar] (10) NULL,
	[AssignedRepair] [varchar] (10) NULL,
	[StoredLocation] [varchar](10) NULL,
	[PreferredPMShift] [varchar](10) NULL,
	[StationLocation] [varchar](10) NULL,
	[DepartmentID] [varchar](10) NULL,
	[DepartmentForPM] [varchar](10) NULL,
	[AccountIDWO] [varchar](10) NULL,
	[AccountIDLabor] [varchar](10) NULL,
	[AccountIDPart] [varchar](10) NULL,
	[AccountIDCommercial] [varchar](10) NULL,
	[AccountIDFuel] [varchar](10) NULL,
	[AccountIDUsage] [varchar](10) NULL,
	[LifeCycleStatusCodeID] [varchar](10) NULL,
	[ConditionRating] [varchar](20) NULL,
	[WorkOrders] [char](1) NULL,
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

ALTER TABLE [dbo].[TransformComponent] ADD  CONSTRAINT [DF_TransformComponent_MeterTypesClass]  DEFAULT ('NO METER') FOR [MeterTypesClass]
GO

ALTER TABLE [dbo].[TransformComponent] ADD  CONSTRAINT [DF_TransformComponent_Resources]  DEFAULT ('Y') FOR [Resources]
GO

ALTER TABLE [dbo].[TransformComponent] ADD  CONSTRAINT [DF_TransformComponent_PreferredPMShift]  DEFAULT ('FACM58') FOR [PreferredPMShift]
GO

ALTER TABLE [dbo].[TransformComponent] ADD  CONSTRAINT [DF_TransformComponent_LifeCycleStatusCodeID]  DEFAULT ('A') FOR [LifeCycleStatusCodeID]
GO

ALTER TABLE [dbo].[TransformComponent] ADD  CONSTRAINT [DF_TransformComponent_WorkOrders]  DEFAULT ('Y') FOR [WorkOrders]
GO

ALTER TABLE [dbo].[TransformComponent] ADD  CONSTRAINT [DF_TransformComponent_UsageTickets]  DEFAULT ('N') FOR [UsageTickets]
GO

ALTER TABLE [dbo].[TransformComponent] ADD  CONSTRAINT [DF_TransformComponent_FuelTickets]  DEFAULT ('N') FOR [FuelTickets]
GO

ALTER TABLE [dbo].[TransformComponent] ADD  CONSTRAINT [DF_TransformComponent_DefaultWOPriorityID]  DEFAULT ('F5') FOR [DefaultWOPriorityID]
GO

ALTER TABLE [dbo].[TransformComponent] ADD  CONSTRAINT [DF_TransformComponent_Ownership]  DEFAULT ('Owned') FOR [Ownership]
GO
