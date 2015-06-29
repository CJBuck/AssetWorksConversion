USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkOrderPlanningTasks]    Script Date: 06/26/2015 14:55:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformWorkOrderWorkOrderPlanningTasks]') AND type in (N'U'))
DROP TABLE [dbo].[TransformWorkOrderWorkOrderPlanningTasks]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkOrderPlanningTasks]    Script Date: 06/26/2015 14:55:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderWorkOrderPlanningTasks](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[TaskID] [varchar](12) NULL,
	[EstimatedHours] [int] NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
