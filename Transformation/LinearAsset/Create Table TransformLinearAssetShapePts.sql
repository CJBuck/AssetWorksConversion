USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformLinearAssetShapePts]    Script Date: 07/16/2015 10:32:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformLinearAssetShapePts]') AND type in (N'U'))
DROP TABLE [dbo].[TransformLinearAssetShapePts]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformLinearAssetShapePts]    Script Date: 07/16/2015 10:32:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformLinearAssetShapePts](
	[Control] [varchar](10) NOT NULL,
	[ShapeID] [varchar](30) NOT NULL,
	[Latitude] [varchar](20) NOT NULL,
	[Longitude] [varchar](20) NOT NULL,
	[Index] [int] NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
