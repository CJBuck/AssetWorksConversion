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
	[Control] [varchar] (10) NOT NULL,
	[ManufacturerID] [varchar](15) NOT NULL,
	[ManufacturerName] [varchar](30) NOT NULL,
	[PartCatalog] [char] (1) NULL,
	[Active] [char] (1) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TargetPartManufacturer] ADD  CONSTRAINT [DF_TargetPartManufacturer_CreateDt]  DEFAULT (getdate()) FOR [CreateDt]
GO
