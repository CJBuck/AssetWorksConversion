USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPartLocation]    Script Date: 03/17/2015 09:50:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformPartLocation]') AND type in (N'U'))
DROP TABLE [dbo].[TransformPartLocation]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPartLocation]    Script Date: 03/17/2015 09:50:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformPartLocation](
	[PartID] [varchar](22) NOT NULL,
	[PartSuffix] [int] NOT NULL,
	[InventoryLocation] [varchar] (10) NOT NULL,
	[UnitOfMeasure] [varchar] (10) NOT NULL,
	[Bins] [varchar] (16) NOT NULL,
	[InventoryMonth] [varchar] (50) NOT NULL,
	[StockStatus] [varchar] (30) NOT NULL,
	[Manufacturer] [varchar] (15) NOT NULL,
	[ManufacturerPartNo] [varchar] (22) NOT NULL,
	[ReplenishMethod] [varchar] (10) NOT NULL,
	[PerformMinMaxCalculation] [char] (1) NOT NULL,
	[MinAvailable] [decimal](22, 2) NOT NULL,
	[MaxAvailable] [decimal](22, 2) NOT NULL,
	[SafetyStock] [decimal](22, 2) NOT NULL,
	[PreferredVendorID] [varchar] (15) NULL,
	[DefaultReplenishmentGenerationType] [varchar] (20) NULL,
	[SuppliedByLocationIfTransferRequest] [varchar] (10) NULL,
	[Comments] [varchar] (600) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
