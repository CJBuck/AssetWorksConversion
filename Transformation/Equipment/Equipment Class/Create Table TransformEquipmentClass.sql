USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentClass]    Script Date: 04/07/2015 14:35:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentClass]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentClass]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentClass]    Script Date: 04/07/2015 14:35:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformEquipmentClass](
		[Control] [varchar] (10) NOT NULL,
		[EquipmentClassID] [varchar](30) NOT NULL,
		[Description] [varchar](30) NOT NULL,
		[ClassType] [varchar] (2) NULL,
		[OverheadAmount] [decimal] (22, 2) NULL,
		[Meter1Type] [varchar] (10) NULL,
		[Meter2Type] [varchar] (10) NULL,
		[Meter1EditRange] [int] NULL,
		[Meter2EditRange] [int] NULL,
		[Meter1MaxValue] [int] NOT NULL,
		[Meter2MaxValue] [int] NOT NULL,
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
		[MeterTypes] [char] (1) NOT NULL,
		[Maintenance] [char] (1) NOT NULL,
		[PMProgram] [char] (1) NOT NULL,
		[Standards] [char] (1) NOT NULL,
		[RentalRates] [char] (1) NOT NULL,
		[Resources] [char] (1) NOT NULL,
		[Source] [varchar] (100) NULL,
		[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

INSERT INTO TransformEquipmentClass
SELECT
	'[i]' [Control],
	LEFT(LTRIM(RTRIM(csv.EquipmentClassID)), 30) [EquipmentClassID],
	LEFT(LTRIM(RTRIM(csv.[Description])), 30) [Description],
	LEFT(LTRIM(RTRIM(csv.ClassType)), 2) [ClassType],
	ISNULL(csv.OverheadAmount, NULL) [OverheadAmount],
	LEFT(LTRIM(RTRIM(csv.Meter1Type)), 10) [Meter1Type],
	LEFT(LTRIM(RTRIM(csv.Meter2Type)), 10) [Meter2Type],
	ISNULL(csv.Meter1EditRange, NULL) [Meter1EditRange],
	ISNULL(csv.Meter2EditRange, NULL) [Meter2EditRange],
	0 [Meter1MaxValue],
	0 [Meter2MaxValue],
	ISNULL(csv.ComebackRange, NULL) [ComebackRange],
	ISNULL(csv.PMSoonDue, NULL) [PMSoonDue],
	ISNULL(csv.PMFuelQuantityOverride, NULL) [PMFuelQuantityOverride],
	ISNULL(csv.PMServicesInOneCycle, NULL) [PMServicesInOneCycle],
	ISNULL(csv.PMQuantityOfTimeUnits, NULL) [PMQuantityOfTimeUnits],
	LEFT(LTRIM(RTRIM(csv.PMTimeUnit)), 15) [PMTimeUnit],
	'[64:15;Meter;1:1]' [MeterSoonDue],
	'[76:6;PMClass;1:1]' [ClassPMCycles],
	'[231:1;PMDetail;1:1]' [PMDetails],
	'[2960:1;PMIndividual;1:1]' [IndividualPM],
	'' [ValueDepreciationID],
	LEFT(LTRIM(RTRIM(csv.[MeterTypes])), 1) [MeterTypes],
	LEFT(LTRIM(RTRIM(csv.Maintenance)), 1) [Maintenance],
	LEFT(LTRIM(RTRIM(csv.PMProgram)), 1) [PMProgram],
	LEFT(LTRIM(RTRIM(csv.Standards)), 1) [Standards],
	LEFT(LTRIM(RTRIM(csv.RentalRates)), 1) [RentalRates],
	LEFT(LTRIM(RTRIM(csv.Resources)), 1) [Resources],
	LEFT(LTRIM(RTRIM(csv.[Source])), 100) [Source],
	GETDATE()
FROM TransformEquipmentClassStableValues csv

-- Vehicles Equipment Class
INSERT INTO TransformEquipmentClass
SELECT DISTINCT
	'[i]' [Control],
	LEFT(LTRIM(RTRIM(et.EquipmentType)), 30) [EquipmentClassID],
	LEFT(LTRIM(RTRIM(et.EquipmentType)), 30) [Description],
	'Y' [ClassType],
	NULL [OverheadAmount],
	'None' [Meter1Type],
	'None' [Meter2Type],
	NULL [Meter1EditRange],
	NULL [Meter2EditRange],
	0 [Meter1MaxValue],
	0 [Meter2MaxValue],
	10 [ComebackRange],
	5 [PMSoonDue],
	NULL [PMFuelQuantityOverride],
	NULL [PMServicesInOneCycle],
	NULL [PMQuantityOfTimeUnits],
	'' [PMTimeUnit],
	'[64:15;Meter;1:1]' [MeterSoonDue],
	'[76:6;PMClass;1:1]' [ClassPMCycles],
	'[231:1;PMDetail;1:1]' [PMDetails],
	'[2960:1;PMIndividual;1:1]' [IndividualPM],
	'' [ValueDepreciationID],
	'N' [MeterTypes],
	'N' [Maintenance],
	'Y' [PMProgram],
	'N' [Standards],
	'N' [RentalRates],
	'N' [Resources],
	'Vehicles' [Source],
	GETDATE()
FROM TransformEquipmentType et
WHERE et.[Source] = 'Vehicles'

-- Facilities Equipment Class
INSERT INTO TransformEquipmentClass
SELECT DISTINCT
	'[i]' [Control],
	LEFT(LTRIM(RTRIM(et.EquipmentType)), 30) [EquipmentClassID],
	LEFT(LTRIM(RTRIM(et.EquipmentType)), 30) [Description],
	'' [ClassType],
	NULL [OverheadAmount],
	'None' [Meter1Type],
	'None' [Meter2Type],
	NULL [Meter1EditRange],
	NULL [Meter2EditRange],
	0 [Meter1MaxValue],
	0 [Meter2MaxValue],
	10 [ComebackRange],
	5 [PMSoonDue],
	NULL [PMFuelQuantityOverride],
	NULL [PMServicesInOneCycle],
	NULL [PMQuantityOfTimeUnits],
	'' [PMTimeUnit],
	'[64:15;Meter;1:1]' [MeterSoonDue],
	'[76:6;PMClass;1:1]' [ClassPMCycles],
	'[231:1;PMDetail;1:1]' [PMDetails],
	'[2960:1;PMIndividual;1:1]' [IndividualPM],
	'' [ValueDepreciationID],
	'N' [MeterTypes],
	'Y' [Maintenance],
	'Y' [PMProgram],
	'Y' [Standards],
	'N' [RentalRates],
	'Y' [Resources],
	'Facilities' [Source],
	GETDATE()
FROM TransformEquipmentType et
WHERE et.[Source] = 'Facilities'
