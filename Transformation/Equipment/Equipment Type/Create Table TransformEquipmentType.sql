USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentType]    Script Date: 04/06/2015 13:53:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentType]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentType]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentType]    Script Date: 04/06/2015 13:53:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentType](
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
INSERT INTO TransformEquipmentType
SELECT DISTINCT
	'[i]' [Control],
	vlv.EquipmentType [Equipment Type],
	vlv.[Description] [Description],
	NULL [Year],
	'' [ManufacturerID],
	'' [ModelID],
	'' [DepartmentID],
	'' [LocationID],
	'' [EquipmentClassID],
	'Y' [Active],
	NULL [MinimumLifeMonths],
	NULL [ExpectedLifeMonths],
	NULL [ManufcturerLifeMonths],
	NULL [ExpectedReplacementCost],
	NULL [ExpectedRehabCycleMonths],
	NULL [InflationFactor],
	'' [Comments],
	'Valves' [Source],
	GETDATE() [CreateDt]
FROM TransformEquipmentDistributionValveValueEquipmentType vlv

-- Facilities Equipment Types
INSERT INTO TransformEquipmentType
SELECT DISTINCT
	'[i]' [Control],
	LEFT(LTRIM(RTRIM(fac.EquipType)), 30) [EquipmentType],
	LEFT(LTRIM(RTRIM(fac.EquipType)), 30) [Description],
	NULL [Year],
	LEFT(LTRIM(RTRIM(fac.MAKE)), 15) [ManufacturerID],
	LEFT(LTRIM(RTRIM(fac.MODEL)), 15) [ModelID],
	'' [DepartmentID],
	'' [LocationID],
	'' [EquipmentClassID],
	'Y' [Active],
	NULL [MinimumLifeMonths],
	NULL [ExpectedLifeMonths],
	NULL [ManufcturerLifeMonths],
	NULL [ExpectedReplacementCost],
	NULL [ExpectedRehabCycleMonths],
	NULL [InflationFactor],
	'' [Comments],
	'Facilities' [Source],
	GETDATE() [CreateDt]
FROM TransformEquipmentFacilitiesEquipmentValueEquipmentType fac

INSERT INTO TransformEquipmentType
SELECT DISTINCT
	'[i]' [Control],
	LTRIM(RTRIM(TEMM.ModelName)) [EquipmentType],
	LTRIM(RTRIM(TEMM.ModelName)) [Description],
	NULL [Year],
	LTRIM(RTRIM(TEMM.CleansedManufacturerID)) [ManufacturerID],
	LTRIM(RTRIM(TEMM.CleansedModelID)) [ModelID],
	'' [DepartmentID],
	'' [LocationID],
	'' [EquipmentClassID],
	'Y' [Active],
	NULL [MinimumLifeMonths],
	NULL [ExpectedLifeMonths],
	NULL [ManufcturerLifeMonths],
	NULL [ExpectedReplacementCost],
	NULL [ExpectedRehabCycleMonths],
	NULL [InflationFactor],
	'' [Comments],
	'Facilities' [Source],
	GETDATE() [CreateDt]
FROM TransformEquipmentManufacturerModel TEMM
WHERE TEMM.ModelName <> 'NOT APPLICABLE'
	AND TEMM.[Source] = 'Facilities'

-- Hydrants Equipment Type
INSERT INTO TransformEquipmentType
SELECT DISTINCT
	'[i]' [Control],
	LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30) [EquipmentType],
	LEFT(LTRIM(RTRIM(vet.EquipmentType)), 30) [Description],
	NULL [Year],
	LEFT(LTRIM(RTRIM(vet.HYD_MAKE)), 15) [ManufacturerID],
	'' [ModelID],
	'' [DepartmentID],
	'' [LocationID],
	'' [EquipmentClassID],
	'Y' [Active],
	NULL [MinimumLifeMonths],
	NULL [ExpectedLifeMonths],
	NULL [ManufcturerLifeMonths],
	NULL [ExpectedReplacementCost],
	NULL [ExpectedRehabCycleMonths],
	NULL [InflationFactor],
	'' [Comments],
	'Hydrants' [Source],
	GETDATE() [CreateDt]
FROM TransformEquipmentHydrantValueEquipmentType vet

-- Projects Equipment Type
INSERT INTO TransformEquipmentType
SELECT DISTINCT
	'[i]' [Control],
	LEFT(LTRIM(RTRIM(ac.EquipmentType)), 30) [EquipmentType],
	LEFT(LTRIM(RTRIM(ac.EquipmentType)), 30) [Description],
	NULL [Year],
	'' [ManufacturerID],
	'' [ModelID],
	'' [DepartmentID],
	'' [LocationID],
	'' [EquipmentClassID],
	'Y' [Active],
	NULL [MinimumLifeMonths],
	NULL [ExpectedLifeMonths],
	NULL [ManufcturerLifeMonths],
	NULL [ExpectedReplacementCost],
	NULL [ExpectedRehabCycleMonths],
	NULL [InflationFactor],
	'' [Comments],
	'Projects' [Source],
	GETDATE() [CreateDt]
FROM TransformEquipmentProjectValueAssetCategory ac

-- Vehicles Equipment Type
INSERT INTO TransformEquipmentType
SELECT DISTINCT
	'[i]' [Control],
	vet.EquipmentType [EquipmentType],
	vet.EquipmentType [Description],
	vet.VEH_YEAR [Year],
	vet.VEH_MAKE [ManufacturerID],
	vet.VEH_MODEL [ModelID],
	'' [DepartmentID],
	'' [LocationID],
	vet.EquipmentClass [EquipmentClassID],
	'Y' [Active],
	NULL [MinimumLifeMonths],
	NULL [ExpectedLifeMonths],
	NULL [ManufcturerLifeMonths],
	NULL [ExpectedReplacementCost],
	NULL [ExpectedRehabCycleMonths],
	NULL [InflationFactor],
	'' [Comments],
	'Vehicles' [Source],
	GETDATE() [CreateDt]
FROM TransformEquipmentVehicleValueEquipmentType vet

-- Stable Equipment Types
INSERT INTO TransformEquipmentType
SELECT DISTINCT
	'[i]' [Control],
	asv.[Equipment Type] [EquipmentType],
	asv.[Description] [Description],
	NULL [Year],
	'' [ManufacturerID],
	'' [ModelID],
	'' [DepartmentID],
	'' [LocationID],
	'' [EquipmentClassID],
	'Y' [Active],
	ISNULL(asv.[Minimum life months], NULL) [MinimumLifeMonths],
	ISNULL(asv.[Expected life months], NULL) [ExpectedLifeMonths],
	ISNULL(asv.[Manufacturer life months], NULL) [ManufcturerLifeMonths],
	ISNULL(asv.[Expected replacement cost], NULL) [ExpectedReplacementCost],
	ISNULL(asv.[Expected rehab cycle months], NULL) [ExpectedRehabCycleMonths],
	ISNULL(asv.[Inflation factor], NULL) [InflationFactor],
	'' [Comments],
	asv.[Source] [Source],
	GETDATE() [CreateDt]
FROM TransformEquipmentTypeAdditionalStableValues asv
