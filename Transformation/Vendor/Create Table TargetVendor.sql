USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetVendor]    Script Date: 09/02/2015 08:17:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetVendor]') AND type in (N'U'))
DROP TABLE [dbo].[TargetVendor]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetVendor]    Script Date: 09/02/2015 08:17:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetVendor](
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

-- Copy data from transform to TransformVendor
INSERT INTO TargetVendor
(	[Control], VendorID, WICMVendorName, MUNISVendorName, MUNISVendorID, VendorStatusID, CreateDt	)
SELECT 
	'[i]',
	tv.VendorID,
	tv.WICMVendorName,
	tv.MunisVendorName,
	tv.MunisVendorID,
	tv.VendorStatusID,
	GETDATE()
FROM TransformVendor tv
