USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPurchaseOrdersEnterprisePurchasingReceipts] Script Date: 09/04/2015 14:50:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetPurchaseOrdersEnterprisePurchasingReceipts]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetPurchaseOrdersEnterprisePurchasingReceipts]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPurchaseOrdersEnterprisePurchasingReceipts] Script Date: 09/04/2015 12:50:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetPurchaseOrdersEnterprisePurchasingReceipts](
	[Control] [varchar](10) NOT NULL,
	[PurchaseOrderID] [varchar](30) NOT NULL,
	[LineNumber] [int] NOT NULL,
	[FullyReceiveAllLineItems] [char](1) NOT NULL,
	[ReceivedDt] [datetime] NOT NULL,
	[QuantityReceived] [decimal](22,2) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
