USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderPlanningTasks]    Script Date: 06/26/2015 14:55:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderPlanningTasks]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderPlanningTasks]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderPlanningTasks]    Script Date: 06/26/2015 14:55:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderPlanningTasks](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[TaskID] [varchar](12) NULL,
	[EstimatedHours] [int] NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
