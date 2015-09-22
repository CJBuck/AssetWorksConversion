USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkProjectProjectLine] Script Date: 06/26/2015 13:52:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderWorkProjectProjectLine]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderWorkProjectProjectLine]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkProjectProjectLine] Script Date: 06/26/2015 13:52:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderWorkProjectProjectLine](
	[Control] [varchar](10) NOT NULL,
	[WorkProjectID] [varchar](9) NOT NULL,
	[LineNumber] [int] NULL,
	[Description] [varchar](255) NULL,
	[StartDt] [datetime] NULL,
	[DueDt] [datetime] NULL,
	[RecordType] [varchar](20) NULL,
	[ServiceRequestID] [varchar](30) NULL,
	[WorkOrderLocationID] [varchar](10) NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
