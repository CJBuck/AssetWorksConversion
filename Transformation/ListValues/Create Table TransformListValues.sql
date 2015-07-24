USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformListValues]    Script Date: 07/24/2015 12:16:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformListValues]') AND type in (N'U'))
DROP TABLE [dbo].[TransformListValues]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformListValues]    Script Date: 07/24/2015 12:16:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformListValues](
	[Control] [varchar](5) NOT NULL,
	[ListTypeID] [varchar](20) NULL,
	[ListValue] [varchar](60) NULL,
	[Description] [varchar](80) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
