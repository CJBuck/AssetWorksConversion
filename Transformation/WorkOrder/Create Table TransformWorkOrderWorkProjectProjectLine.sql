USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkProjectProjectLine]    Script Date: 06/26/2015 13:52:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformWorkOrderWorkProjectProjectLine]') AND type in (N'U'))
DROP TABLE [dbo].[TransformWorkOrderWorkProjectProjectLine]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkProjectProjectLine]    Script Date: 06/26/2015 13:52:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderWorkProjectProjectLine](
	[Control] [varchar](10) NOT NULL,
	[WorkProjectID] [varchar](9) NOT NULL,
	[LineNumber] [int] NULL,
	[Description] [varchar](255) NULL,
	[StartDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[RecordType] [varchar](20) NULL,
	[ServiceRequestID] [varchar](30) NULL,
	[WorkOrderLocationID] [varchar](10) NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
