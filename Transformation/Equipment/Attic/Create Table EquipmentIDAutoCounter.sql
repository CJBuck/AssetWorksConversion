USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[EquipmentIDAutoCounter]    Script Date: 02/19/2015 12:59:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EquipmentIDAutoCounter]') AND type in (N'U'))
DROP TABLE [dbo].[EquipmentIDAutoCounter]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[EquipmentIDAutoCounter]    Script Date: 02/19/2015 12:59:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EquipmentIDAutoCounter](
	[EquipmentIDCounter] [int] IDENTITY(100,1) NOT NULL
) ON [PRIMARY]

GO


