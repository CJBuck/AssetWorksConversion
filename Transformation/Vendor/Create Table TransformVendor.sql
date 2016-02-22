USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformVendor]    Script Date: 02/17/2015 17:16:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformVendor]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformVendor]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformVendor]    Script Date: 02/17/2015 17:16:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformVendor](
	[Control] [varchar](10) NOT NULL,
	[VendorID] [varchar](15) NOT NULL,
	[VendorName] [varchar](35) NOT NULL,
	[ContactName] [varchar](35) NULL,
	[AddressLine1] [varchar](30) NULL,
	[AddressLine2] [varchar](30) NULL,
	[AddressLine3] [varchar](30) NULL,
	[AddressLine4] [varchar](30) NULL,
	[Phone] [varchar](30) NULL,
	[Fax] [varchar](30) NULL,
	[EmailAddress] [varchar](200) NULL,
	[SalesTaxRate] [decimal](22,4) NULL,
	[FederalTaxID] [varchar](30) NULL,
	[Active] [char](1) NOT NULL,
	[MinorityOwned] [char](1) NULL,
	[WomenOwned] [char](1) NULL,
	[SmallBusiness] [char](1) NULL,
	[VendorTypeID] [varchar](20) NULL,
	[VendorStatusID] [varchar](20) NULL,
	[VendorProvidesEquipment] [char](1) NULL,
	[EquipmentAndComponentWarranties] [char](1) NULL,
	[EquipmentRepairAndPM] [char](1) NULL,
	[Parts] [char](1) NULL,
	[PartsWarranties] [char](1) NULL,
	[PartsRepairAndRebuild] [char](1) NULL,
	[Fuel] [char](1) NULL,
	[Testing] [char](1) NULL,
	[CurrencyID] [char](1) NOT NULL,
	[MinimumOrderValInVendorCurrency] [decimal](22,2),
	[Contacts] [varchar](25) NOT NULL,
	[SupportsAllLocations] [char](1) NULL,
	[TrackEnterprisePurchasesReceiptsByStoreLocation] [char](1) NULL,
	[StoreLocations] [varchar](25) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
