USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformLinearAssetMarker]    Script Date: 07/16/2015 10:32:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformLinearAssetMarker]') AND type in (N'U'))
DROP TABLE [dbo].[TransformLinearAssetMarker]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformLinearAssetMarker]    Script Date: 07/16/2015 10:32:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformLinearAssetMarker](
	[Control] [varchar](10) NOT NULL,
	[MarkerID] [varchar](20) NOT NULL,
	[MarkerDescription] [varchar](30) NOT NULL,
	[SegmentID] [varchar](10) NOT NULL,
	[OffsetFromSegmentStart] [decimal] (14,4) NOT NULL,
	[Latitude] [varchar] (20) NOT NULL,
	[Longitude] [varchar] (20) NOT NULL,
	[MarkerType] [varchar] (9) NOT NULL,
	[Active] [char](1) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
