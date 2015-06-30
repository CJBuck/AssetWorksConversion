USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderPlanning]    Script Date: 06/26/2015 14:55:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderPlanning]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderPlanning]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderPlanning]    Script Date: 06/26/2015 14:55:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderPlanning](
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
	[PMScheduledDt] [datetime] NULL,
	[RepairReasonID] [varchar](4) NULL,
	[WorkClass] [char](1) NULL,
	[WarrantyWork] [varchar](15) NULL,
	[OutOfServiceDt] [datetime] NULL,
	[InDt] [datetime] NULL,
	[DueDt] [datetime] NULL,
	[RepairSite] [varchar](2) NULL,
	[JobStatus] [varchar](15) NULL,
	[Tasks] [varchar](30) NOT NULL,
	[Labor] [varchar](30) NOT NULL,
	[Parts] [varchar](30) NOT NULL,
	[Commercial] [varchar](30) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
