USE [AssetWorksConversion]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipmentSubsystemPartsProperty_DisplayOnEQPrimary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipmentSubsystemPartsProperty] DROP CONSTRAINT [DF_TransformEquipmentSubsystemPartsProperty_DisplayOnEQPrimary]
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipmentSubsystemParts_Active]') AND TYPE = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipmentSubsystemPartsProperty] DROP CONSTRAINT [DF_TransformEquipmentSubsystemPartsProperty_Active]
END
GO

/****** Object:  Table [dbo].[TransformEquipmentSubsystemPartsProperty] Script Date: 07/24/2015 06:52:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentSubsystemPartsProperty]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentSubsystemPartsProperty]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentSubsystemPartsProperty] Script Date: 07/24/2015 06:52:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentSubsystemPartsProperty](
	[Control] [varchar] (10) NOT NULL,
	[EquipmentID] [varchar](50) NOT NULL,
	[SubsystemID] [varchar](20) NOT NULL,
	[PropertyID] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
	[DisplayOnEQPrimary] [char](1) NOT NULL,
	[Active] [char](1) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TransformEquipmentSubsystemPartsProperty] ADD  CONSTRAINT [DF_TransformEquipmentSubsystemPartsProperty_DisplayOnEQPrimary]  DEFAULT ('Y') FOR [DisplayOnEQPrimary]
GO
ALTER TABLE [dbo].[TransformEquipmentSubsystemPartsProperty] ADD CONSTRAINT [DF_TransformEquipmentSubsystemPartsProperty_Active] DEFAULT ('Y') FOR [Active]
GO
