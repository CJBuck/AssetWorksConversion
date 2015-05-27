USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentClassMeter]    Script Date: 04/07/2015 14:35:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentClassMeter]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentClassMeter]
GO

/****** Object:  Table [dbo].[TransformEquipmentClassMeter]    Script Date: 04/07/2015 14:35:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformEquipmentClassMeter](
	[Control] [varchar] (10) NOT NULL,
	[EquipmentClassID] [varchar](30) NOT NULL,
	[MeterType] [varchar] (10) NULL,
	[PMMeterOverride] [int] NULL,
	[SoonDueRange] [int] NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

--
INSERT INTO TransformEquipmentClassMeter
SELECT
	'[i]',
	LEFT(LTRIM(RTRIM(TECM.EquipmentClassID)), 30),
	LEFT(LTRIM(RTRIM(TECM.MeterType)), 10),
	LTRIM(RTRIM(TECM.PMMeterOverride)),
	LTRIM(RTRIM(TECM.SoonDueRange)),
	GETDATE()
FROM Staging_TransformEquipmentClassMeter TECM
