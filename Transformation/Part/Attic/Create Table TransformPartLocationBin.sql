USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPartLocationBin]    Script Date: 03/27/2015 07:55:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformPartLocationBin]') AND type in (N'U'))
DROP TABLE [dbo].[TransformPartLocationBin]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPartLocationBin]    Script Date: 03/27/2015 07:55:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformPartLocationBin](
	[PartID] [varchar](22) NOT NULL,
	[BinID] [varchar] (20) NOT NULL,
	[PrimaryBin] [char] (1) NOT NULL,
	[NewBin] [char] (1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
