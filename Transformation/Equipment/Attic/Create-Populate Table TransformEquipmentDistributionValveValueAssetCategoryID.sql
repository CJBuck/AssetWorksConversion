USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentDistributionValveValueAssetCategoryID]    Script Date: 02/06/2015 09:01:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentDistributionValveValueAssetCategoryID]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentDistributionValveValueAssetCategoryID]
GO

/****** Object:  Table [dbo].[TransformEquipmentDistributionValveValueAssetCategoryID]    Script Date: 02/06/2015 09:01:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentDistributionValveValueAssetCategoryID](
	[VLV_FUNCTION] [varchar](2) NOT NULL,
	[AssetCategoryID] [varchar](15) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

-- INSERT
INSERT INTO [AssetWorksConversion].[dbo].[TransformEquipmentDistributionValveValueAssetCategoryID]
           ([VLV_FUNCTION]
           ,[AssetCategoryID])
     VALUES
           ('01', 'VALVE ISO'),
           ('02', 'VALVE ISO'),
           ('03', 'VALVE ISO'),
           ('04', 'VALVE BLF'),
           ('05', 'VALVE AIR'),
           ('06', 'VALVE ISO'),
           ('07', 'VALVE REG'),
           ('08', 'VALVE ISO'),
           ('09', 'VALVE ISO'),
           ('10', 'VALVE ISO')
GO
