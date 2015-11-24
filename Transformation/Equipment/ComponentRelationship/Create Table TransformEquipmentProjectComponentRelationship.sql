USE [AssetWorksConversion]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipmentProjectComponentRelationship_CreateDt]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipmentProjectComponentRelationship] DROP CONSTRAINT [DF_TransformEquipmentProjectComponentRelationship_CreateDt]
END

GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentProjectComponentRelationship]    Script Date: 11/24/2015 08:10:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentProjectComponentRelationship]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentProjectComponentRelationship]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentProjectComponentRelationship]    Script Date: 11/24/2015 08:10:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentProjectComponentRelationship](
	[Control] [varchar](10) NOT NULL,
	[EquipmentID] [varchar](20) NOT NULL,
	[ComponentID] [varchar](20) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TransformEquipmentProjectComponentRelationship] ADD  CONSTRAINT [DF_TransformEquipmentProjectComponentRelationship_CreateDt]  DEFAULT (getdate()) FOR [CreateDt]
GO
