USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPurchaseOrdersVendorContract] Script Date: 09/04/2015 09:58:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformPurchaseOrdersVendorContract]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformPurchaseOrdersVendorContract]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPurchaseOrdersVendorContract] Script Date: 09/04/2015 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformPurchaseOrdersVendorContract](
	[Control] [varchar](10) NOT NULL,
	[VendorContractID] [varchar](30) NOT NULL,
	[Description] [varchar](60) NULL,
	[VendorID] [varchar](15) NULL,
	[Fax] [varchar](30) NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[PurchasingLimit] [decimal](12,2) NULL,
	[NotificationPct] [decimal](5,2) NULL,
	[PartSalesTax] [char](1) NULL,
	[PartShipping] [char](1) NULL,
	[CommercialSalesTax] [char](1) NULL,
	[AdjustmentMultiplier] [decimal](4,3) NULL,
	[PerformPriceAdjustment] [char](1) NULL,
	[Comment] [varchar](1000) NULL,
	[TermsDescPathAndFileName] [varchar](255) NULL,
	[TermsDescription] [varchar](60) NULL,
	[TermsDescriptionComments] [varchar](1000) NULL,
	[ContractLines] [varchar](50) NOT NULL,
	[Files] [varchar](50) NOT NULL,
	[Attributes] [varchar](50) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
