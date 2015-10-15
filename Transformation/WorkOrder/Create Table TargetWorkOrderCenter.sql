USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetWorkOrderCenter] Script Date: 09/21/2015 05:50:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetWorkOrderCenter]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetWorkOrderCenter]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetWorkOrderCenter] Script Date: 09/21/2015 05:50:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetWorkOrderCenter](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NOT NULL,
	[WorkOrderNumber] [varchar](15) NOT NULL,
	[JobStatus] [varchar](20) NOT NULL,
	[JobType] [varchar](8) NOT NULL,
	[EquipmentID] [varchar](20) NOT NULL,
	[Meter1] [int] NULL,
	[Meter2] [int] NULL,
	[PriorityID] [varchar](2) NOT NULL,
	[PMService] [varchar](12) NULL,
	[PMScheduled] [datetime] NULL,
	[RepairReasonID] [varchar](4) NOT NULL,
	[OutOfServiceDt] [datetime] NOT NULL,
	[InDt] [datetime] NOT NULL,
	[DueDt] [datetime] NOT NULL,
	[OpenedDt] [datetime] NOT NULL,
	[FirstLaborDt] [datetime] NOT NULL,
	[ShowDowntimeBeginDt] [datetime] NOT NULL,
	[FinishWorkOrder] [char](1) NOT NULL,
	[FinishedDt] [datetime] NOT NULL,
	[CloseWorkOrder] [char](1) NOT NULL,
	[ClosedDt] [datetime] NOT NULL,
	[InService] [char](1) NOT NULL,
	[InServiceDt] [datetime] NOT NULL,
	[AccountID] [varchar](30) NULL,
	[WorkClass] [char](1) NOT NULL,
	[WarrantyWork] [varchar](15) NULL,
	[Complaint] [varchar](1000) NULL,
	[Cause] [varchar](1000) NULL,
	[Correction] [varchar](1000) NULL,
	[Tasks] [varchar](30) NOT NULL,
	[Labor] [varchar](30) NOT NULL,
	[Parts] [varchar](30) NOT NULL,
	[Commercial] [varchar](30) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
