USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkOrdersClosedTasks] Script Date: 06/29/2015 10:22:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderWorkOrdersClosedTasks]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderWorkOrdersClosedTasks]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkOrdersClosedTasks] Script Date: 06/29/2015 10:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderWorkOrdersClosedTasks](
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
