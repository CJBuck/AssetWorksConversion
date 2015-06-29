USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkOrdersOpen] Script Date: 06/29/2015 10:22:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderWorkOrdersOpen]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderWorkOrdersOpen]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkOrdersOpen] Script Date: 06/29/2015 10:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderWorkOrdersOpen](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[JobStatus] [varchar](20) NULL,
	[JobType] [varchar](8) NULL,
	[EquipmentID] [varchar](20) NULL,
	[Meter1] [int] NULL,
	[Meter2] [int] NULL,
	[PriorityID] [varchar](2) NULL,
	[RepairReasonID] [varchar](4) NULL,
	[DateTimeOutOfService] [datetime] NULL,
	[DateTimeIn] [datetime] NULL,
	[DateTimeDue] [datetime] NULL,
	[DateTimeOpened] [datetime] NULL,
	[DateTimeFirstLabor] [datetime] NULL,
	[ShowDowntimeBegin] [datetime] NULL,
	[FinishWorkOrder] [char](1) NULL,
	[DateTimeFinished] [datetime] NULL,
	[CloseWorkOrder] [char](1) NULL,
	[DateTimeClosed] [datetime] NULL,
	[InService] [char](1) NULL,
	[DateTimeInService] [datetime] NULL,
	[AccountID] [varchar](30) NULL,
	[WorkClass] [char](1) NULL,
	[WarrantyWork] [varchar](15) NULL,
	[Tasks] [varchar](30) NULL,
	[Labor] [varchar](30) NULL,
	[Parts] [varchar](30) NULL,
	[Commercial] [varchar](30) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
