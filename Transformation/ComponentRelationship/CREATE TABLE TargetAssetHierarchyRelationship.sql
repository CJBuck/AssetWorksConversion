USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetAssetHierarchyRelationship]    Script Date: 9/4/2015 12:05:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetAssetHierarchyRelationship](
	[Control] [nvarchar](10) NOT NULL,
	[AssetWorksEquipmentId] [nvarchar](20) NOT NULL,
	[ComponentId] [nvarchar](20) NOT NULL
) ON [PRIMARY]

GO


