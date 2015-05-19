USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformAssetCategory]    Script Date: 04/28/2015 10:41:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformAssetCategory]') AND type in (N'U'))
DROP TABLE [dbo].[TransformAssetCategory]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformAssetCategory]    Script Date: 04/28/2015 10:41:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformAssetCategory](
		[Control] [varchar] (10) NOT NULL,
		[AssetCategoryID] [varchar](15) NOT NULL,
		[Description] [varchar] (30) NOT NULL,
		[Source] [varchar] (50) NOT NULL,
		[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
