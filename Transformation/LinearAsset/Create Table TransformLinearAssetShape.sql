USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformLinearAssetShape]    Script Date: 07/16/2015 10:32:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformLinearAssetShape]') AND type in (N'U'))
DROP TABLE [dbo].[TransformLinearAssetShape]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformLinearAssetShape]    Script Date: 07/16/2015 10:32:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformLinearAssetShape](
	[Control] [varchar](10) NOT NULL,
	[ShapeID] [varchar](30) NOT NULL,
	[GroupRow] [varchar](25) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
