USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentClassPMClass]    Script Date: 05/21/2015 12:35:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentClassPMClass]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentClassPMClass]
GO

/****** Object:  Table [dbo].[TransformEquipmentClassPMClass]    Script Date: 05/21/2015 14:35:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformEquipmentClassPMClass](
	[Control] [varchar] (10) NOT NULL,
	[EquipmentClassID] [varchar](30) NOT NULL,
	[SlotNo] [integer] NULL,
	[PMService] [varchar] (12) NULL,
	[BlankSlot] [char] (1) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

--
INSERT INTO TransformEquipmentClassPMClass
SELECT
	'[i]',
	LEFT(LTRIM(RTRIM(PMC.EquipmentClassID)), 30),
	LTRIM(RTRIM(PMC.SlotNo)),
	LEFT(LTRIM(RTRIM(PMC.PMService)), 12),
	LEFT(LTRIM(RTRIM(PMC.BlankSlot)), 1),
	GETDATE()
FROM Staging_TransformEquipmentClassPMClass PMc
