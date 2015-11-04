USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPurchaseOrdersVendorContractAttributes] Script Date: 11/03/2015 09:21:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformPurchaseOrdersVendorContractAttributes]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformPurchaseOrdersVendorContractAttributes]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPurchaseOrdersVendorContractAttributes] Script Date: 11/03/2015 09:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformPurchaseOrdersVendorContractAttributes](
	[Control] [varchar](10) NOT NULL,
	[VendorContractID] [varchar](30) NOT NULL,
	[VendorContractAttributeID] [varchar](20) NOT NULL,
	[TextValue] [varchar](30) NULL,
	[NumericValue] [decimal](12,4) NULL,
	[Comments] [varchar](60) NULL,
	[PathAndFileName] [varchar](255) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
