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
	[WICMVendorName] [varchar](100) NULL,
	[MUNISVendorName] [varchar](100) NULL,
	[MUNISVendorID] [varchar](25) NULL,
	[VendorStatusID] [varchar](10) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

-- Copy data from staging to TransformVendor
INSERT INTO TransformVendor
(	[Control], VendorID, WICMVendorName, MUNISVendorName, MUNISVendorID, VendorStatusID, CreateDt	)
SELECT 
	'[i]',
	LTRIM(RTRIM(stv.VendorID)),
	LTRIM(RTRIM(stv.WICMVendorName)),
	LTRIM(RTRIM(stv.MunisVendorName)),
	LTRIM(RTRIM(stv.MunisVendorID)),
	LTRIM(RTRIM(stv.[Vendor Status ID])),
	GETDATE()
FROM Staging_TransformVendor stv
