USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPurchaseOrdersRelatedWorkOrders] Script Date: 06/30/2015 06:54:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformPurchaseOrdersRelatedWorkOrders]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformPurchaseOrdersRelatedWorkOrders]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPurchaseOrdersRelatedWorkOrders] Script Date: 06/30/2015 06:54:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformPurchaseOrdersRelatedWorkOrders](
	[Control] [varchar](10) NOT NULL,
	[PurchaseOrderID] [varchar](30) NOT NULL,
	[LineNumber] [int] NOT NULL,
	[WorkOrderLocationID] [varchar](10) NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[Quantity] [decimal](10,2) NULL,
	[TaskID] [varchar](12) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
