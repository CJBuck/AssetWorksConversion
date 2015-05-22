USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetEquipmentClassPMIndividual]    Script Date: 05/21/2015 12:35:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetEquipmentClassPMIndividual]') AND type in (N'U'))
DROP TABLE [dbo].[TargetEquipmentClassPMIndividual]
GO

/****** Object:  Table [dbo].[TargetEquipmentClassPMIndividual]    Script Date: 05/21/2015 14:35:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetEquipmentClassPMIndividual](
	[Control] [varchar] (10) NOT NULL,
	[EquipmentClassID] [varchar](30) NOT NULL,
	[PMService] [varchar] (12) NULL,
	[Meter1Override] [varchar] (6) NULL,
	[Meter2Override] [varchar] (6) NULL,
	[NumberOfTimeUnits] [varchar] (2) NULL,
	[TimeUnits] [varchar] (15) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
