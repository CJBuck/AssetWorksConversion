USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetWorkOrderCenterStandardJobs] Script Date: 11/30/2015 13:21:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetWorkOrderCenterStandardJobs]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetWorkOrderCenterStandardJobs]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetWorkOrderCenterStandardJobs] Script Date: 11/30/2015 13:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetWorkOrderCenterStandardJobs](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NOT NULL,
	[WorkOrderNumber] [varchar](15) NOT NULL,
	[StandardJobID] [varchar](30) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
