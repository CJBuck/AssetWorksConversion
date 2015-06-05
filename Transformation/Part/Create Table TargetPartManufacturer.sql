USE AssetWorksConversion
GO

/****** Object:  Table dbo.TargetPartManufacturer    Script Date: 04/13/2015 10:25:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.TargetPartManufacturer') AND type in (N'U'))
DROP TABLE dbo.TargetPartManufacturer
GO

USE AssetWorksConversion
GO

/****** Object:  Table dbo.TargetPartManufacturer    Script Date: 04/13/2015 10:25:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.TargetPartManufacturer
(
	Control nvarchar(255) NOT NULL CONSTRAINT DF_TargetPartManufacturer_Control  DEFAULT ('[i]'),
	PartManufacturerID nvarchar(15) NOT NULL,
	Name nvarchar(30) NOT NULL,
	PartCatalog nchar(1) NULL CONSTRAINT CHK_TargetPartManufacturer_PartCatalog CHECK(PartCatalog IN ('Y','N')),
	Active nchar(1) NOT NULL CONSTRAINT CHK_TargetPartManufacturer_Active CHECK(Active IN ('Y','N')),
	CONSTRAINT PK_TargetPartManufacturer PRIMARY KEY CLUSTERED(PartManufacturerID),
)

