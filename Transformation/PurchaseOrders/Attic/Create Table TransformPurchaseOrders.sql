USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPurchaseOrders] Script Date: 06/29/2015 14:54:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformPurchaseOrders]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformPurchaseOrders]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPurchaseOrders] Script Date: 06/29/2015 14:54:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformPurchaseOrders](
	[Control] [varchar](10) NOT NULL,
	[PurchaseOrderID] [varchar](30) NOT NULL,
	[LocationID] [varchar](10) NULL,
	[Description] [varchar](30) NULL,
	[VendorID] [varchar](15) NULL,
	[Status] [varchar](20) NULL,
	[PurchaseTypeID] [varchar](20) NULL,
	[CurrencyID] [varchar](3) NULL,
	[AccountID] [varchar](30) NULL,
	[RequestedDt] [datetime] NULL,
	[OrderedDt] [datetime] NULL,
	[ExpectedDeliveryDt] [datetime] NULL,
	[OrderedByEmployeeID] [varchar](9) NULL,
	[LineItems] [varchar](30) NULL,
	[RelatedWorkOrders] [varchar](30) NULL,
	[Comments] [varchar](2000) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
