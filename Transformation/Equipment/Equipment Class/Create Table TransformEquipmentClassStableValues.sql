USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentClassStableValues]    Script Date: 05/21/2015 08:46:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentClassStableValues]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentClassStableValues]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentClassStableValues]    Script Date: 05/21/2015 08:46:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformEquipmentClassStableValues](
	[EquipmentClassID] [varchar](30) NULL,
	[Description] [varchar](30) NULL,
	[ClassType] [varchar] (2) NULL,
	[OverheadAmount] [decimal] (22, 2) NULL,
	[Meter1Type] [varchar] (10) NULL,
	[Meter2Type] [varchar] (10) NULL,
	[Meter1EditRange] [int] NULL,
	[Meter2EditRange] [int] NULL,
	[Meter1MaxValue] [int] NULL,
	[Meter2MaxValue] [int] NULL,
	[ComebackRange] [int] NULL,
	[PMSoonDue] [int] NULL,
	[PMFuelQuantityOverride] [int] NULL,
	[PMServicesInOneCycle] [int] NULL,
	[PMQuantityOfTimeUnits] [int] NULL,
	[PMTimeUnit] [varchar] (15) NULL,
	[MeterSoonDue] [varchar] (25) NULL,
	[ClassPMCycles] [varchar] (25) NULL,
	[PMDetails] [varchar] (25) NULL,
	[IndividualPM] [varchar] (25) NULL,
	[ValueDepreciationID] [varchar] (8) NULL,
	[MeterTypes] [char] (1) NULL,
	[Maintenance] [char] (1) NULL,
	[PMProgram] [char] (1) NULL,
	[Standards] [char] (1) NULL,
	[RentalRates] [char] (1) NULL,
	[Resources] [char] (1) NULL,
	[Source] [varchar] (100) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO


