USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPartManufacturerLookup]    Script Date: 04/13/2015 09:31:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformPartManufacturerLookup]') AND type in (N'U'))
DROP TABLE [dbo].[TransformPartManufacturerLookup]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPartManufacturerLookup]    Script Date: 04/13/2015 09:31:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformPartManufacturerLookup](
	[SourceValue] [nvarchar](30) NULL,
	[TargetValue] [nvarchar](15) NULL,
	[CreateDt] [datetime] NULL
) ON [PRIMARY]

GO
