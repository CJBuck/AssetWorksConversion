USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderCenterTasks] Script Date: 07/29/2015 13:05:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderCenterTasks]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderCenterTasks]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderCenterTasks] Script Date: 07/29/2015 13:05:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderCenterTasks](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[TaskID] [varchar](12) NULL,
	[WorkAccomplishedCode] [varchar](4) NULL,
	[Comments] [varchar](100) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
