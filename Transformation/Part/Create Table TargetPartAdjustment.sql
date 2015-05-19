USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPartAdjustment]    Script Date: 03/24/2015 12:50:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetPartAdjustment]') AND type in (N'U'))
DROP TABLE [dbo].[TargetPartAdjustment]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPartAdjustment]    Script Date: 03/24/2015 12:50:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetPartAdjustment](
	[PartID] [varchar](22) NOT NULL,
	[LocationID] [varchar] (10) NOT NULL,
	[PartSuffix] [int] NOT NULL,
	[Action] [varchar] (8) NOT NULL,
	[AdjustmentType] [varchar] (25) NOT NULL,
	[Quantity] [decimal] (22, 2) NOT NULL,
	[UnitPrice] [decimal] (22, 4) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
