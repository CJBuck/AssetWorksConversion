USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformComponentLegacyXwalk]    Script Date: 06/04/2015 09:37:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformComponentLegacyXwalk]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformComponentLegacyXwalk]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformComponentLegacyXwalk]    Script Date: 06/04/2015 09:37:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformComponentLegacyXwalk](
	[AssetID] [varchar](20) NOT NULL,
	[Source] [varchar](50) NOT NULL,
	[LegacyIDSource] [varchar](25) NOT NULL,
	[LegacyID] [varchar](25) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
