USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformLocation]    Script Date: 04/28/2015 11:20:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformLocation]') AND type in (N'U'))
DROP TABLE [dbo].[TransformLocation]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformLocation]    Script Date: 04/28/2015 11:20:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformLocation](
		[Control] [varchar] (10) NOT NULL,
		[LocationID] [varchar](10) NOT NULL,
		[LocationName] [varchar] (50) NOT NULL,
		[Source] [varchar] (50) NOT NULL,
		[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
