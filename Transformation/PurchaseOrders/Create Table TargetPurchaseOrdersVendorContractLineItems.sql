USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPurchaseOrdersVendorContractLineItems] Script Date: 11/03/2015 09:24:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetPurchaseOrdersVendorContractLineItems]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetPurchaseOrdersVendorContractLineItems]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPurchaseOrdersVendorContractLineItems] Script Date: 11/03/2015 09:24:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetPurchaseOrdersVendorContractLineItems](
	[Control] [varchar](10) NOT NULL,
	[VendorContractID] [varchar](30) NOT NULL,
	[ContractLineID] [varchar](20) NULL,
	[LineItemDescription] [varchar](255) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
