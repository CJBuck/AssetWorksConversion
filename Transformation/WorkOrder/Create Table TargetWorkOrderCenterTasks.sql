USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetWorkOrderCenterTasks] Script Date: 09/22/2015 09:23:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetWorkOrderCenterTasks]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetWorkOrderCenterTasks]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetWorkOrderCenterTasks] Script Date: 09/22/2015 09:23:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetWorkOrderCenterTasks](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NOT NULL,
	[WorkOrderNumber] [varchar](15) NULL,
	[TaskID] [varchar](12) NOT NULL,
	[WorkAccomplishedCode] [varchar](4) NOT NULL,
	[UpdatePMSchedule] [varchar](4) NOT NULL,
	[Comments] [varchar](100) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
