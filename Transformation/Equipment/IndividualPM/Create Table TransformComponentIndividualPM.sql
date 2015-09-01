USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformComponentIndividualPM]    Script Date: 09/01/2015 15:00:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformComponentIndividualPM]') AND type in (N'U'))
DROP TABLE [dbo].[TransformComponentIndividualPM]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformComponentIndividualPM]    Script Date: 09/01/2015 15:00:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformComponentIndividualPM](
	[PMKey] [varchar](20) NOT NULL,
	[PMServiceType] [varchar](12) NOT NULL,
	[NextDueDate] [date] NULL,
	[NumberOfTimeUnits] [int] NULL,
	[TimeUnit] [varchar](20) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
