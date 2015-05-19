USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentFacilitiesEquipmentValueEquipmentType]    Script Date: 02/06/2015 09:01:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentFacilitiesEquipmentValueEquipmentType]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentFacilitiesEquipmentValueEquipmentType]
GO

/****** Object:  Table [dbo].[TransformEquipmentFacilitiesEquipmentValueEquipmentType]    Script Date: 02/06/2015 09:01:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentFacilitiesEquipmentValueEquipmentType](
	[FAC_MODEL] [varchar](30) NOT NULL,
	[OBJECT_ID] [varchar](10) NOT NULL,
	[EquipmentType] [varchar](30) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

-- INSERT
INSERT INTO [AssetWorksConversion].[dbo].[TransformEquipmentFacilitiesEquipmentValueEquipmentType]
           ([VLV_FUNCTION]
           ,[VLV_TYPE]
           ,[EquipmentType])
     VALUES
           ('01', 'BALL', 'VALVE ISO BALL'),
           ('01', 'BUTTERFLY', 'VALVE ISO BTTRFLY'),
           ('01', 'GATE', 'VALVE ISO GATE'),
           ('01', 'UNKNOWN', 'VALVE ISO GATE'),
           ('03', 'GATE', 'VALVE ISO GATE'),
           ('03', 'UNKNOWN', 'VALVE ISO GATE'),
           ('04', 'BALL', 'VALVE BLWOFF'),
           ('04', 'BUTTERFLY', 'VALVE BLWOFF'),
           ('04', 'GATE', 'VALVE BLWOFF'),
           ('04', 'UNKNOWN', 'VALVE BLWOFF'),
           ('05', 'AIR RELEAS', 'VALVE AIR AIR RELEASE'),
           ('05', 'COMBINATIO', 'VALVE AIR COMBINATION'),
           ('05', 'GATE', 'VALVE AIR AIR RELEASE'),
           ('05', 'MANUAL', 'VALVE AIR AIR RELEASE'),
           ('05', 'UNKNOWN', 'VALVE AIR AIR RELEASE'),
           ('06', 'GATE', 'VALVE ISO GATE'),
           ('06', 'UNKNOWN', 'VALVE ISO GATE'),
           ('07', 'CHECK', 'VALVE REG CHECK'),
           ('07', 'PRV', 'VALVE REG PRV'),
           ('08', 'BUTTERFLY', 'VALVE ISO BTTRFLY'),
           ('08', 'GATE', 'VALVE ISO GATE'),
           ('08', 'UNKNOWN', 'VALVE ISO GATE'),
           ('09', 'BUTTERFLY', 'VALVE ISO BTTRFLY'),
           ('09', 'GATE', 'VALVE ISO GATE'),
           ('10', 'BUTTERFLY', 'VALVE ISO BTTRFLY'),
           ('10', 'GATE', 'VALVE ISO GATE'),
           ('10', 'UNKNOWN', 'VALVE ISO GATE')
GO
