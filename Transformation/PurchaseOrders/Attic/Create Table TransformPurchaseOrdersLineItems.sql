USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPurchaseOrdersLineItems] Script Date: 06/30/2015 06:54:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformPurchaseOrdersLineItems]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformPurchaseOrdersLineItems]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPurchaseOrdersLineItems] Script Date: 06/30/2015 06:54:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformPurchaseOrdersLineItems](
	[Control] [varchar](10) NOT NULL,
	[PurchaseOrderID] [varchar](30) NOT NULL,
	[LineNumber] [int] NOT NULL,
	[Status] [varchar](20) NULL,
	[LineItemType] [varchar](20) NULL,
	[PartID] [varchar](22) NULL,
	[PartSuffix] [int] NULL,
	[OtherID] [varchar](30) NULL,
	[Description] [varchar](30) NULL,
	[Quantity] [decimal](10,2) NULL,
	[UnitPrice] [decimal](10,4) NULL,
	[LocationID] [varchar](10) NULL,
	[OrderedDt] [datetime] NULL,
	[ExpectedDeliveryDt] [datetime] NULL,
	[SentToVendorDt] [datetime] NULL,
	[VendorContractID] [varchar](15) NULL,
	[UnitOfMeasure] [varchar](4) NULL,
	[AccountID] [varchar](30) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
