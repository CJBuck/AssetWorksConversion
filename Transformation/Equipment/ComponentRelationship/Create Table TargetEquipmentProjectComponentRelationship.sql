USE [AssetWorksConversion]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetEquipmentProjectComponentRelationship]') AND type in (N'U'))
DROP TABLE [dbo].[TargetEquipmentProjectComponentRelationship]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetEquipmentProjectComponentRelationship]    Script Date: 11/23/2015 14:00:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetEquipmentProjectComponentRelationship](
	[Control] [varchar] (10) NOT NULL,
	[EquipmentID] [varchar](20) NOT NULL,
	[ComponentID] [varchar](20) NOT NULL
) ON [PRIMARY]

GO
