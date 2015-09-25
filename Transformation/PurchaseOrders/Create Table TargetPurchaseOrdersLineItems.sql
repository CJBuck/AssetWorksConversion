USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPurchaseOrdersLineItems] Script Date: 09/04/2015 14:53:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetPurchaseOrdersLineItems]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetPurchaseOrdersLineItems]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPurchaseOrdersLineItems] Script Date: 09/04/2015 14:53:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetPurchaseOrdersLineItems](
	[Control] [varchar](10) NOT NULL,
	[PurchaseOrderID] [varchar](30) NOT NULL,
	[LineNumber] [int] NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[LineItemType] [varchar](20) NOT NULL,
	[PartID] [varchar](22) NOT NULL,
	[PartSuffix] [int] NOT NULL,
	[OtherID] [varchar](30) NOT NULL,
	[Description] [varchar](30) NOT NULL,
	[Quantity] [decimal](10,2) NOT NULL,
	[UnitPrice] [decimal](10,4) NOT NULL,
	[LocationID] [varchar](10) NOT NULL,
	[OrderedDt] [datetime] NOT NULL,
	[ExpectedDeliveryDt] [datetime] NOT NULL,
	[SentToVendorDt] [datetime] NOT NULL,
	[VendorContractID] [varchar](15) NOT NULL,
	[UnitOfMeasure] [varchar](4) NOT NULL,
	[AccountID] [varchar](30) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
