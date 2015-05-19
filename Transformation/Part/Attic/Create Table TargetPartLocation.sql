USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPartLocation]    Script Date: 03/17/2015 09:50:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetPartLocation]') AND type in (N'U'))
DROP TABLE [dbo].[TargetPartLocation]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPartLocation]    Script Date: 03/17/2015 09:50:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetPartLocation](
	[PartID] [varchar](22) NOT NULL,
	[InventoryLocation] [varchar] (10) NOT NULL,
	[UnitOfMeasure] [varchar] (10) NOT NULL,
	[Bins] [varchar] (15) NOT NULL,
	[InventoryMonth] [varchar] (50) NOT NULL,
	[StockStatus] [varchar] (30) NOT NULL,
	[Manufacturer] [varchar] (15) NOT NULL,
	[ManufacturerPartNo] [varchar] (22) NOT NULL,
	[ReplenMethod] [varchar] (10) NOT NULL,
	[PerformMin-MaxCalculation] [char] (1) NOT NULL,
	[MinAvailable] [decimal](22, 2) NOT NULL,
	[MaxAvailable] [decimal](22, 2) NOT NULL,
	[SafetyStock] [decimal](22, 2) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
