USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkProjectDependency]    Script Date: 06/26/2015 14:55:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderWorkProjectDependency]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderWorkProjectDependency]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkProjectDependency]    Script Date: 06/26/2015 14:55:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderWorkProjectDependency](
	[Control] [varchar](10) NOT NULL,
	[WorkProjectID] [varchar](9) NOT NULL,
	[LineNumber] [int] NULL,
	[DependsLineNumber] [int] NULL,
	[LeadDays] [int] NULL,
	[SynchronizeDates] [char](1) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
