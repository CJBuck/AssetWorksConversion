USE [AssetWorksConversion]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TargetEquipmentProjectComponentRelationship_CreateDt]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TargetEquipmentProjectComponentRelationship] DROP CONSTRAINT [DF_TargetEquipmentProjectComponentRelationship_CreateDt]
END

GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetEquipmentProjectComponentRelationship]    Script Date: 11/24/2015 08:14:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetEquipmentProjectComponentRelationship]') AND type in (N'U'))
DROP TABLE [dbo].[TargetEquipmentProjectComponentRelationship]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetEquipmentProjectComponentRelationship]    Script Date: 11/24/2015 08:14:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetEquipmentProjectComponentRelationship](
	[Control] [varchar](10) NOT NULL,
	[EquipmentID] [varchar](20) NOT NULL,
	[ComponentID] [varchar](20) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TargetEquipmentProjectComponentRelationship] ADD  CONSTRAINT [DF_TargetEquipmentProjectComponentRelationship_CreateDt]  DEFAULT (getdate()) FOR [CreateDt]
GO


