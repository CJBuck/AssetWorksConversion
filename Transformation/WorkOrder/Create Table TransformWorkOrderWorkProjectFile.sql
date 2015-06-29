USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkProjectFile]    Script Date: 06/26/2015 14:55:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformWorkOrderWorkProjectFile]') AND type in (N'U'))
DROP TABLE [dbo].[TransformWorkOrderWorkProjectFile]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkProjectFile]    Script Date: 06/26/2015 14:55:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderWorkProjectFile](
	[Control] [varchar](10) NOT NULL,
	[WorkProjectID] [varchar](9) NOT NULL,
	[FileType] [varchar](20) NULL,
	[PathAndFileName] [varchar](255) NULL,
	[Description] [varchar](255) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
