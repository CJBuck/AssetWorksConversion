USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderCenter] Script Date: 07/29/2015 12:50:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderCenter]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderCenter]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderCenter] Script Date: 07/29/2015 12:50:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderCenter](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [varchar](15) NULL,
	[JobStatus] [varchar](20) NULL,
	[JobType] [varchar](8) NULL,
	[EquipmentID] [varchar](20) NULL,
	[Meter1] [int] NULL,
	[Meter2] [int] NULL,
	[PriorityID] [varchar](2) NULL,
	[PMService] [varchar](12) NULL,
	[RepairReasonID] [varchar](4) NULL,
	[OutOfServiceDt] [datetime] NULL,
	[InDt] [datetime] NULL,
	[DueDt] [datetime] NULL,
	[OpenedDt] [datetime] NULL,
	[FirstLaborDt] [datetime] NULL,
	[ShowDowntimeBeginDt] [datetime] NULL,
	[FinishWorkOrder] [char](1) NULL,
	[FinishedDt] [datetime] NULL,
	[CloseWorkOrder] [char](1) NULL,
	[ClosedDt] [datetime] NULL,
	[InService] [char](1) NULL,
	[InServiceDt] [datetime] NULL,
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
