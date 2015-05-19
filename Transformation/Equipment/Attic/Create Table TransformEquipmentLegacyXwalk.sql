USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentLegacyXwalk]    Script Date: 02/19/2015 09:37:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentLegacyXwalk]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentLegacyXwalk]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentLegacyXwalk]    Script Date: 02/19/2015 09:37:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentLegacyXwalk](
	[EquipmentID] [varchar](20) NOT NULL,
	[Source] [varchar](50) NOT NULL,
	[LegacyIDSource] [varchar](25) NOT NULL,
	[LegacyID] [varchar](25) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


