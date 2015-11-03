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
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[PurchasingLimit] [decimal](12,2) NULL,
	[NotificationPct] [decimal](5,2) NULL,
	[Comment] [varchar](1000) NULL,
	[ContractLines] [varchar](50) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
