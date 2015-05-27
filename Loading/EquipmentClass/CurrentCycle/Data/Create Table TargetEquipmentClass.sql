USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetEquipmentClass]    Script Date: 04/07/2015 14:35:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetEquipmentClass]') AND type in (N'U'))
DROP TABLE [dbo].[TargetEquipmentClass]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetEquipmentClass]    Script Date: 04/07/2015 14:35:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetEquipmentClass](
		[Control] [varchar] (10) NOT NULL,
		[EquipmentClassID] [varchar](30) NOT NULL,
		[Description] [varchar](30) NOT NULL,
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
		[ClassPMCycles] [varchar] (25) NULL,
		[PMDetails] [varchar] (25) NULL,
		[IndividualPM] [varchar] (25) NULL,
		[ValueDepreciation ID] [varchar] (8) NULL,
		[MeterTypes] [char] (1) NOT NULL,
		[Maintenance] [char] (1) NOT NULL,
		[PM Program] [char] (1) NOT NULL,
		[Standards] [char] (1) NOT NULL,
		[RentalRates] [char] (1) NOT NULL,
		[Resources] [char] (1) NOT NULL,
		[Source] [varchar] (100) NULL,
		[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

INSERT INTO TargetEquipmentClass
SELECT DISTINCT
	ec.[Control] [Control],
	ec.EquipmentClassID [EquipmentClassID],
	ec.[Description] [Description],
	ec.ClassType [ClassType],
	ec.OverheadAmount [OverheadAmount],
	ec.Meter1Type [Meter1Type],
	ec.Meter2Type [Meter2Type],
	ec.Meter1EditRange [Meter1EditRange],
	ec.Meter2EditRange [Meter2EditRange],
	ec.Meter1MaxValue,
	ec.Meter2MaxValue,
	ec.ComebackRange [ComebackRange],
	ec.PMSoonDue [PMSoonDue],
	ec.PMFuelQuantityOverride [PMFuelQuantityOverride],
	ec.PMServicesInOneCycle [PMServicesInOneCycle],
	ec.PMQuantityOfTimeUnits [PMQuantityOfTimeUnits],
	ec.PMTimeUnit [PMTimeUnit],
	ec.[ClassPMCycles],
	ec.[PMDetails],
	ec.[IndividualPM],
	ec.[ValueDepreciation ID] [ValueDepreciationID],
	ec.MeterTypes [MeterTypes],
	ec.Maintenance [Maintenance],
	ec.[PM Program] [PMProgram],
	ec.Standards [Standards],
	ec.RentalRates [RentalRates],
	ec.Resources [Resources],
	ec.[Source] [Source],
	GETDATE()
FROM TransformEquipmentClass ec
