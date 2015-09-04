USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPurchaseOrdersEnterprisePurchasingReceipts] Script Date: 09/03/2015 12:54:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformPurchaseOrdersEnterprisePurchasingReceipts]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformPurchaseOrdersEnterprisePurchasingReceipts]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPurchaseOrdersEnterprisePurchasingReceipts] Script Date: 09/03/2015 12:54:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformPurchaseOrdersEnterprisePurchasingReceipts](
	[Control] [varchar](10) NOT NULL,
	[PurchaseOrderID] [varchar](30) NOT NULL,
	[LineNumber] [int] NOT NULL,
	[FullyReceiveAllLineItems] [char](1) NOT NULL,
	[ReceivedDt] [datetime] NULL,
	[QuantityReceived] [decimal](22,2) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
