USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentManufacturerModel]    Script Date: 03/05/2015 10:41:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentManufacturerModel]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentManufacturerModel]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentManufacturerModel]    Script Date: 03/05/2015 10:41:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformEquipmentManufacturerModel](
		[Control] [varchar] (10) NOT NULL,
		[CleansedManufacturerID] [varchar](15) NOT NULL,
		[CleansedModelID] [varchar](15) NOT NULL,
		[ModelName] [varchar] (30) NOT NULL,
		[Source] [varchar] (50) NOT NULL,
		[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
