USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformLinearAssetSegment]    Script Date: 07/16/2015 10:32:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformLinearAssetSegment]') AND type in (N'U'))
DROP TABLE [dbo].[TransformLinearAssetSegment]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformLinearAssetSegment]    Script Date: 07/16/2015 10:32:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformLinearAssetSegment](
	[Control] [varchar](10) NOT NULL,
	[SegmentID] [varchar](10) NOT NULL,
	[SegmentDescription] [varchar](30) NOT NULL,
	[Length] [decimal](12, 4) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
