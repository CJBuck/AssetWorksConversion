USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetVendorStore]    Script Date: 02/18/2015 17:16:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetVendorStore]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetVendorStore]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetVendorStore]    Script Date: 02/18/2015 17:16:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetVendorStore](
	[Control] [varchar](10) NOT NULL,
	[VendorID] [varchar](15) NOT NULL,
	[StoreID] [varchar](20) NULL,
	[ContactName] [varchar](35) NULL,
	[Phone] [varchar](30) NULL,
	[Fax] [varchar](30) NULL,
	[Mobile] [varchar](30) NULL,
	[AddressLine1] [varchar](30) NULL,
	[AddressLine2] [varchar](30) NULL,
	[AddressLine3] [varchar](30) NULL,
	[AddressLine4] [varchar](30) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
