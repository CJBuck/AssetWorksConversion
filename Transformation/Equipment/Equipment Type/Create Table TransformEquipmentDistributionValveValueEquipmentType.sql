USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentDistributionValveValueEquipmentType]    Script Date: 05/27/2015 10:27:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentDistributionValveValueEquipmentType]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentDistributionValveValueEquipmentType]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentDistributionValveValueEquipmentType]    Script Date: 05/27/2015 10:27:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentDistributionValveValueEquipmentType](
	[VLV_FUNCTION] [varchar](3) NOT NULL,
	[VLV_TYPE] [varchar](10) NOT NULL,
	[VLV_MAKE] [varchar] (12) NULL,
	[VLV_SIZE] [varchar] (2) NULL,
	[VALVE_NO] [varchar] (6) NULL,
	[EquipmentType] [varchar](30) NOT NULL,
	[Description] [varchar](50) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

INSERT INTO TransformEquipmentDistributionValveValueEquipmentType
SELECT
	LEFT(LTRIM(RTRIM(VLV_FUNCTION)), 3),
	LEFT(LTRIM(RTRIM(VLV_TYPE)), 10),
	LEFT(LTRIM(RTRIM(VLV_MAKE)), 12),
	LEFT(LTRIM(RTRIM(VLV_SIZE)), 2),
	LEFT(LTRIM(RTRIM(VALVE_NO)), 6),
	LEFT(LTRIM(RTRIM(EquipmentType)), 30),
	LEFT(LTRIM(RTRIM([Description])), 50)
FROM Staging_TransformEquipmentDistributionValveValueEquipmentType
