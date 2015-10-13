USE [AssetWorksConversion]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipmentSubsystem_SubsystemProperty]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipmentSubsystem] DROP CONSTRAINT [DF_TransformEquipmentSubsystem_SubsystemProperty]
END

GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentSubsystem]    Script Date: 07/22/2015 14:12:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentSubsystem]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentSubsystem]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentSubsystem]    Script Date: 07/22/2015 14:12:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentSubsystem](
	[Control] [nvarchar] (10) NOT NULL,
	[SubsystemID] [nvarchar](20) NOT NULL,
	[SubsystemProperty] [nvarchar](20) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TransformEquipmentSubsystem] ADD  CONSTRAINT [DF_TransformEquipmentSubsystem_SubsystemProperty]  DEFAULT ('[538:2;Subsystem;1:1]') FOR [SubsystemProperty]
GO
