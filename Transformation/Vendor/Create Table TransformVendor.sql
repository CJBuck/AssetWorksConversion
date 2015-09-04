USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformVendor]    Script Date: 09/02/2015 08:16:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformVendor]') AND type in (N'U'))
DROP TABLE [dbo].[TransformVendor]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformVendor]    Script Date: 09/02/2015 08:16:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformVendor](
	[Control] [varchar](10) NOT NULL,
	[VendorID] [varchar](15) NOT NULL,
	[VendorName] [varchar](35) NULL,
	[VendorContactName] [varchar](35) NULL,
	[Address1] [varchar](30) NULL,
	[Address2] [varchar](30) NULL,
	[Address3] [varchar](30) NULL,
	[Address4] [varchar](30) NULL,
	[Phone] [varchar](30) NULL,
	[Fax] [varchar](30) NULL,
	[AccountingSysNo] [varchar](30) NULL,
	[Active] [char](1) NULL,
	[MinorityOwned] [char](1) NULL,
	[MinorityOwnedExp] [datetime] NULL,
	[EmailAddress] [varchar](200) NULL,
	[VendorTypeID] [varchar](20) NOT NULL,
	[IsEquipVendor] [char](1) NULL,
	[IsEquipWarrantyVendor] [char](1) NULL,
	[IsCommercialVendor] [char](1) NULL,
	[IsPartsVendor] [char](1) NULL,
	[IsPartsWarrantyVendor] [char](1) NULL,
	[IsPartsReprVendor] [char](1) NULL,
	[IsFuelVendor] [char](1) NULL,
	[IsTestVendor] [char](1) NULL,
	[CurrencyCode] [varchar](3) NULL,
	[MinOrderValue] [decimal](22, 2) NULL,
	[SettlementTerms] [varchar](60) NULL,
	[SystemWideVendor] [char](1) NULL,
	[ContactTypeID] [varchar](20) NULL,
	[LocationCode] [varchar](10) NULL,
	[ContactName] [varchar](35) NULL,
	[ContactPhone] [varchar](30) NULL,
	[ContactFax] [varchar](30) NULL,
	[ContactEmailAddr] [varchar](200) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

-- Copy data from staging to TransformVendor
INSERT INTO TransformVendor
(	[Control], VendorID, VendorName, Active, VendorTypeID, CurrencyCode, SystemWideVendor, CreateDt	)
SELECT 
	'[i]',
	stv.VendorID,
	stv.VendorName,
	'Y', '', '', '',	-- NULL handling
	GETDATE()
FROM Staging_TransformVendor stv
