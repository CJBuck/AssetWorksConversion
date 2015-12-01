USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderCenterStandardJobs] Script Date: 11/30/2015 13:21:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderCenterStandardJobs]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderCenterStandardJobs]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderCenterStandardJobs] Script Date: 11/30/2015 13:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderCenterStandardJobs](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [varchar](15) NULL,
	[StandardJobID] [varchar](30) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
