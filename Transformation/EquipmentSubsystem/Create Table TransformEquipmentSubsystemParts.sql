USE [AssetWorksConversion]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipmentSubsystemParts_SubsystemProperty]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipmentSubsystemParts] DROP CONSTRAINT [DF_TransformEquipmentSubsystemParts_SubsystemProperty]
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TransformEquipmentSubsystemParts_PrintOnPMOrders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransformEquipmentSubsystemParts] DROP CONSTRAINT [DF_TransformEquipmentSubsystemParts_PrintOnPMOrders]
END
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentSubsystemParts]    Script Date: 07/24/2015 06:32:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentSubsystemParts]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentSubsystemParts]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentSubsystemParts]    Script Date: 07/24/2015 06:32:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentSubsystemParts](
	[Control] [varchar](10) NOT NULL,
	[EquipmentID] [varchar](50) NOT NULL,
	[SubsystemID] [varchar](20) NOT NULL,
	[PrintOnPMOrders] [char](1) NOT NULL,
	[SubsystemProperty] [varchar](50) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TransformEquipmentSubsystemParts] ADD CONSTRAINT [DF_TransformEquipmentSubsystemParts_SubsystemProperty] DEFAULT ('[541:3;SubsystemParts;1-2:1-2]') FOR [SubsystemProperty]
GO

ALTER TABLE [dbo].[TransformEquipmentSubsystemParts] ADD CONSTRAINT [DF_TransformEquipmentSubsystemParts_PrintOnPMOrders] DEFAULT ('Y') FOR [PrintOnPMOrders]
GO
