USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPart]    Script Date: 01/30/2015 09:50:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformPart]') AND type in (N'U'))
DROP TABLE [dbo].[TransformPart]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformPart]    Script Date: 01/30/2015 09:50:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformPart](
	[PartID] [varchar](22) NOT NULL,
	[PartSuffix] [int] NULL,
	[Keyword] [varchar](15) NULL,
	[ShortDescription] [varchar](120) NULL,
	[ProductCategoryID] [varchar](20) NULL,
	[PartClassificationID] [varchar](2) NULL,
	[Tire] [char](1) NULL,
	[Core] [char](1) NULL,
	[ControlledSubstance] [char](1) NULL,
	[ItemFabricatedWithoutCore] [char](1) NULL,
	[PathAndFileName] [varchar](255) NULL,
	[FileDescription] [varchar](60) NULL,
	[LongDescription] [varchar](240) NULL,
	[PurchasingDefaultAccountID] [varchar](30) NULL,
	[Comments] [varchar](8000) NULL,
	[MarkupPercentage] [decimal](22, 1) NULL,
	[NoMarkupOnPart] [char](1) NULL,
	[MarkupCapAmount] [decimal](22, 2) NULL,
	[VRMSCode] [varchar] (20) NULL,
	[ExcludeFromInvLists] [char] (1) NULL
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO
