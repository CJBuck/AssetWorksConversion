USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPurchaseOrdersVendorContractFiles] Script Date: 11/03/2015 09:24:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetPurchaseOrdersVendorContractFiles]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetPurchaseOrdersVendorContractFiles]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPurchaseOrdersVendorContractFiles] Script Date: 11/03/2015 09:24:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetPurchaseOrdersVendorContractFiles](
	[Control] [varchar](10) NOT NULL,
	[VendorContractID] [varchar](30) NOT NULL,
	[PathAndFileName] [varchar](255) NULL,
	[FileDescription] [varchar](60) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
