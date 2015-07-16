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
	[MarkerID] [varchar](15) NOT NULL,
	[MarkerDescription] [varchar](15) NOT NULL,
	[SegmentID] [varchar](12) NOT NULL,
	[OffsetFromSegmentStart] [decimal] (15,8) NOT NULL,
	[Latitude] [decimal] (9,6) NOT NULL,
	[Longitude] [decimal] (9,6) NOT NULL,
	[MarkerType] [varchar] (15) NOT NULL,
	[Active] [char](1) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
