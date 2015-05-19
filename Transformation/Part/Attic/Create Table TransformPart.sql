USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPart]    Script Date: 01/30/2015 09:50:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformPart]') AND type in (N'U'))
DROP TABLE [dbo].[TransformPart]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPart]    Script Date: 01/30/2015 09:50:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformPart](
	[PartID] [varchar](22) NOT NULL,
	[PartSuffix] [int] NULL,
	[Keyword] [varchar](15) NULL,
	[PartShortDescription] [varchar](120) NULL,
	[ProductCategoryID] [varchar](20) NULL,
	[PartClassificationID] [varchar](2) NULL,
	[Tire] [char](1) NULL,
	[Core] [char](1) NULL,
	[ControlledSubstance] [char](1) NULL,
	[ItemFabricatedWithoutCore] [char](1) NULL,
	[PathAndFileName] [varchar](255) NULL,
	[FileDescription] [varchar](60) NULL,
	[PartLongDescription] [varchar](240) NULL,
	[PurchasingDefaultAccountID] [varchar](30) NULL,
	[Comments2] [varchar](600) NULL,
	[MarkupPercentage] [decimal](22, 1) NULL,
	[NoMarkupOnPart] [char](1) NULL,
	[MarkupCapAmount] [decimal](22, 2) NULL,
	[InventoryLocationID] [varchar](10) NULL,
	[UnitOfMeasure] [varchar](10) NULL,
	[BinID] [varchar](20) NULL,
	[Description] [varchar](30) NULL,
	[PrimaryBin] [char](1) NULL,
	[Comments43] [varchar](60) NULL,
	[InventoryMonth] [varchar](50) NULL,
	[StockStatus] [varchar](30) NULL,
	[Manufacturer] [varchar](15) NULL,
	[ManufacturerPartNumber] [varchar](22) NULL,
	[PreferredVendorID] [varchar](15) NULL,
	[ReplinishmentMethod] [varchar](10) NULL,
	[MinimumAvailableQuantity] [decimal](22, 2) NULL,
	[MaximumAvailableQuantity] [decimal](22, 2) NULL,
	[DefaultReplenishmentGenerationType] [varchar](20) NULL,
	[SuppliedByLocationIfTransferRequest] [varchar](10) NULL,
	[Comments1] [varchar](600) NULL
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO
