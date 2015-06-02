USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPartLocation]    Script Date: 03/17/2015 09:50:45 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformPartLocation]') AND type IN (N'U'))
	DROP TABLE [dbo].[TransformPartLocation]

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
	[InventoryLocation] [varchar](255) NOT NULL,
	[UnitOfMeasure] [varchar](255) NOT NULL,
	[Bins] [varchar](255) NOT NULL,
	[InventoryMonth] [varchar](255) NOT NULL,
	[StockStatus] [varchar](255) NOT NULL,
	[Manufacturer] [varchar](255) NOT NULL,
	[ManufacturerPartNo] [varchar](255) NOT NULL,
	[ReplenishMethod] [varchar](255) NOT NULL,
	[PerformMinMaxCalculation] [char](1) NOT NULL,
	[MinAvailable] [decimal](22, 2) NOT NULL,
	[MaxAvailable] [decimal](22, 2) NOT NULL,
	[SafetyStock] [decimal](22, 2) NOT NULL,
	[PreferredVendorID] [varchar](255) NULL,
	[DefaultReplenishmentGenerationType] [varchar](255) NULL,
	[SuppliedByLocationIfTransferRequest] [varchar](255) NULL,
	[Comments] [varchar](255) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
