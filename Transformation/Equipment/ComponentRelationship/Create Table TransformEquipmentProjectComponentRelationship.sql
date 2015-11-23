USE [AssetWorksConversion]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentProjectComponentRelationship]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentProjectComponentRelationship]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentProjectComponentRelationship]    Script Date: 11/23/2015 13:57:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentProjectComponentRelationship](
	[Control] [varchar] (10) NOT NULL,
	[EquipmentID] [varchar](20) NOT NULL,
	[ComponentID] [varchar](20) NOT NULL
) ON [PRIMARY]

GO
