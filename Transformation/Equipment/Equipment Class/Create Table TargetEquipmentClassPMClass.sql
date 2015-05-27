USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetEquipmentClassPMClass]    Script Date: 05/22/2015 06:53:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetEquipmentClassPMClass]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetEquipmentClassPMClass]
GO

/****** Object:  Table [dbo].[TargetEquipmentClassPMClass]    Script Date: 05/22/2015 06:53:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetEquipmentClassPMClass](
	[Control] [varchar] (10) NOT NULL,
	[EquipmentClassID] [varchar](30) NOT NULL,
	[SlotNo] [integer] NULL,
	[PMService] [varchar] (12) NULL,
	[BlankSlot] [char] (1) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
