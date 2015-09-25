USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPurchaseOrdersVendorContract] Script Date: 09/04/2015 09:58:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetPurchaseOrdersVendorContract]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetPurchaseOrdersVendorContract]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPurchaseOrdersVendorContract] Script Date: 09/04/2015 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetPurchaseOrdersVendorContract](
	[Control] [varchar](10) NOT NULL,
	[VendorContractID] [varchar](30) NOT NULL,
	[Description] [varchar](60) NULL,
	[VendorID] [varchar](15) NOT NULL,
	[BeginDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[PurchasingLimit] [decimal](12,2) NOT NULL,
	[NotificationPct] [decimal](5,2) NOT NULL,
	[Comment] [varchar](1000) NOT NULL,
	[ContractLines] [varchar](50) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
