USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkOrderPlanning]    Script Date: 06/26/2015 14:55:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformWorkOrderWorkOrderPlanning]') AND type in (N'U'))
DROP TABLE [dbo].[TransformWorkOrderWorkOrderPlanning]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkOrderPlanning]    Script Date: 06/26/2015 14:55:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderWorkOrderPlanning](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[JobType] [varchar](8) NULL,
	[EquipmentID] [varchar](20) NULL,
	[AccountID] [varchar](30) NULL,
	[PriorityID] [varchar](2) NULL,
	[EmployeeID] [varchar](9) NULL,
	[Approved] [varchar](9) NULL,
	[PMService] [varchar](12) NULL,
	[PMScheduled] [datetime] NULL,
	[RepairReasonID] [varchar](4) NULL,
	[WorkClass] [char](1) NULL,
	[WarrantyWork] [varchar](15) NULL,
	[DateTimeOutOfService] [datetime] NULL,
	[DateTimeIn] [datetime] NULL,
	[DateTimeDue] [datetime] NULL,
	[RepairSite] [varchar](2) NULL,
	[JobStatus] [varchar](15) NULL,
	[Tasks] [varchar](30) NOT NULL,
	[Labor] [varchar](30) NOT NULL,
	[Parts] [varchar](30) NOT NULL,
	[Commercial] [varchar](30) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
