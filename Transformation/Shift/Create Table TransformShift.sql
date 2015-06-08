USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformShift]    Script Date: 04/08/2015 10:41:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformShift]') AND type in (N'U'))
DROP TABLE [dbo].[TransformShift]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformShift]    Script Date: 06/08/2015 10:41:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformShift](
		[Control] [varchar] (10) NOT NULL,
		[ShiftID] [varchar](15) NOT NULL,
		[Description] [varchar] (30) NOT NULL,
		[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
