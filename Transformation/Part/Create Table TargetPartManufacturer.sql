USE [AssetWorksConversion]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TargetPartManufacturer_CreateDt]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TargetPartManufacturer] DROP CONSTRAINT [DF_TargetPartManufacturer_CreateDt]
END

GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPartManufacturer]    Script Date: 04/13/2015 10:25:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetPartManufacturer]') AND type in (N'U'))
DROP TABLE [dbo].[TargetPartManufacturer]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPartManufacturer]    Script Date: 04/13/2015 10:25:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetPartManufacturer](
	[Control] nvarchar(255) NOT NULL,
	[PartManufacturerID] nvarchar(255) NOT NULL,
	[Name] nvarchar(255) NOT NULL,
	[PartCatalog] nvarchar(255) NULL,
	[Active] nvarchar(255) NOT NULL
) ON [PRIMARY]

GO

