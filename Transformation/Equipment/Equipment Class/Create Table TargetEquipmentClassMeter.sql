USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetEquipmentClassMeter]    Script Date: 05/22/2015 06:35:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetEquipmentClassMeter]') AND type in (N'U'))
DROP TABLE [dbo].[TargetEquipmentClassMeter]
GO

/****** Object:  Table [dbo].[TargetEquipmentClassMeter]    Script Date: 05/22/2015 06:35:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetEquipmentClassMeter](
	[Control] [varchar] (10) NOT NULL,
	[EquipmentClassID] [varchar](30) NOT NULL,
	[MeterType] [varchar] (10) NULL,
	[PMMeterOverride] [int] NULL,
	[SoonDueRange] [int] NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
