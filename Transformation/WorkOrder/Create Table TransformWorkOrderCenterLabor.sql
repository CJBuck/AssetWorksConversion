USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderCenterLabor] Script Date: 07/29/2015 13:00:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderCenterLabor]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderCenterLabor]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderCenterLabor] Script Date: 07/29/2015 13:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderCenterLabor](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[TaskID] [varchar](12) NULL,
	[WorkAccomplishedCode] [varchar](4) NULL,
	[LaborDt] [datetime] NULL,
	[EmployeeID] [varchar](9) NULL,
	[LaborHours] [int] NULL,
	[TimeCode] [varchar](8) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
