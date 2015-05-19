USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetEquipmentType]    Script Date: 04/06/2015 13:53:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetEquipmentType]') AND type in (N'U'))
DROP TABLE [dbo].[TargetEquipmentType]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetEquipmentType]    Script Date: 04/06/2015 13:53:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetEquipmentType](
	[Control] [varchar] (10) NOT NULL,
	[EquipmentType] [varchar](30) NOT NULL,
	[Description] [varchar](30) NOT NULL,
	[Year] [int] NULL,
	[ManufacturerID] [varchar] (15) NULL,
	[ModelID] [varchar] (15) NULL,
	[DepartmentID] [varchar] (10) NULL,
	[LocationID] [varchar] (10) NULL,
	[EquipmentClassID] [varchar] (30) NULL,
	[Active] [char] (1) NULL,
	[MinimumLifeMonths] [int] NULL,
	[ExpectedLifeMonths] [int] NULL,
	[ManufacturerLifeMonths] [int] NULL,
	[ExpectedReplacementCost] [decimal] (22,2) NULL,
	[ExpectedRehabCycleMonths] [int] NULL,
	[InflationFactor] [decimal] (22,4) NULL,
	[Comments] [varchar] (60) NULL,
	[Source] [varchar] (25) NOT NULL,
	CreateDt [datetime] NOT NULL
) ON [PRIMARY]

-- Valves Equipment Types
INSERT INTO TargetEquipmentType
SELECT DISTINCT
	'[i]' [Control],
	et.EquipmentType [Equipment Type],
	et.[Description] [Description],
	et.[Year] [Year],
	et.ManufacturerID [ManufacturerID],
	et.ModelID [ModelID],
	et.DepartmentID [DepartmentID],
	et.LocationID [LocationID],
	et.EquipmentClassID [EquipmentClassID],
	et.Active [Active],
	et.MinimumLifeMonths [MinimumLifeMonths],
	et.ExpectedLifeMonths [ExpectedLifeMonths],
	et.ManufacturerLifeMonths [ManufcturerLifeMonths],
	et.ExpectedReplacementCost [ExpectedReplacementCost],
	et.ExpectedRehabCycleMonths [ExpectedRehabCycleMonths],
	et.InflationFactor [InflationFactor],
	et.Comments [Comments],
	et.[Source] [Source],
	et.CreateDt [CreateDt]
FROM TransformEquipmentType et
