USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformVendorWicmToMunisLookup]    Script Date: 10/21/2015 08:16:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformVendorWicmToMunisLookup]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformVendorWicmToMunisLookup]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformVendorWicmToMunisLookup]    Script Date: 10/21/2015 08:16:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformVendorWicmToMunisLookup](
	[WicmVendorNo] [varchar](15) NOT NULL,
	[WICMVendorName] [varchar](100) NULL,
	[MUNISVendorName] [varchar](100) NULL,
	[MUNISVendorID] [varchar](25) NULL,
	[VendorStatusID] [varchar](10) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

-- Copy data from staging to TransformVendorWicmToMunisLookup
INSERT INTO TransformVendorWicmToMunisLookup
(	WicmVendorNo, WICMVendorName, MUNISVendorName, MUNISVendorID, VendorStatusID, CreateDt	)
SELECT
	LTRIM(RTRIM(stv.[WICM Vendor # (VNUMBER)])),
	LTRIM(RTRIM(stv.[WICM Vendor Name (VNAME)])),
	LTRIM(RTRIM(stv.[Munis Vendor Name (Name)])),
	LTRIM(RTRIM(stv.[Munis Vendor Number (Vendor ID)])),
	LTRIM(RTRIM(stv.[Vendor Status ID])),
	GETDATE()
FROM Staging_VendorWicmToMunisLookup stv
