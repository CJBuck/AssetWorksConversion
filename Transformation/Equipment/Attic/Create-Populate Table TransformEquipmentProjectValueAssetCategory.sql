USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentProjectValueAssetCategory] Script Date: 02/09/2015 07:01:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentProjectValueAssetCategory]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentProjectValueAssetCategory]
GO

/****** Object:  Table [dbo].[TransformEquipmentProjectValueAssetCategory] Script Date: 02/09/2015 07:01:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentProjectValueAssetCategory](
	[CLASS] [varchar](6) NULL,
	[AssetCategoryID] [varchar](15) NOT NULL,
	[EquipmentType] [varchar] (30) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

-- INSERT
INSERT INTO [AssetWorksConversion].[dbo].[TransformEquipmentProjectValueAssetCategory]
           ([CLASS]
           ,[AssetCategoryID]
           ,[EquipmentType])
     VALUES
           ('CIP', 'PROJECT', 'PROJECT'),
           ('OTHER', '??', '??'),
           ('DAMS', 'DAMS', 'Dams'),
           ('GRNDS', 'GROUNDS', 'Grounds'),
           ('RSVRS', 'RSRVRS', 'Reservoirs'),
           ('PROP', 'FORESTS', 'FORESTS'),
           ('BOND', 'PROJECT', 'PROJECT'),
           ('', 'PROJECT', 'PROJECT'),
           ('QLTY', 'PROJECT', 'PROJECT'),
           ('WPO', 'PROJECT', 'PROJECT'),
           ('PLINE', 'PIPE', 'PIPE'),
           ('OPEX', 'PROJECT', 'PROJECT'),
           ('OFALL', 'OUTFALL', 'Outfall')
GO
