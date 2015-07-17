USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetLinearAssetSegmentMarkerUpdate]    Script Date: 07/16/2015 10:32:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetLinearAssetSegmentMarkerUpdate]') AND type in (N'U'))
DROP TABLE [dbo].[TargetLinearAssetSegmentMarkerUpdate]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetLinearAssetSegmentMarkerUpdate]    Script Date: 07/16/2015 10:32:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetLinearAssetSegmentMarkerUpdate](
	[Control] [varchar](10) NOT NULL,
	[SegmentToUpdate] [varchar](10) NOT NULL,
	[BeginningMarkerID] [varchar](20) NOT NULL,
	[EndingMarkerID] [varchar](20) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
