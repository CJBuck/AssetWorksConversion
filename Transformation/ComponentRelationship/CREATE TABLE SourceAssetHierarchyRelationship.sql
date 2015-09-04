USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[SourceAssetHierarchyRelationship]    Script Date: 9/4/2015 12:06:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SourceAssetHierarchyRelationship](
	[Control] [varchar](10) NULL,
	[AssetWorksEquipmentId] [varchar](20) NULL,
	[ComponentWICMId] [varchar](10) NULL,
	[ComponentId] [varchar](20) NULL,
	[Note] [varchar](30) NULL,
	[Description] [varchar](30) NULL,
	[Make] [varchar](30) NULL,
	[Model] [varchar](30) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


