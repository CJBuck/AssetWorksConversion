USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPart]    Script Date: 01/26/2015 09:50:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetPart]') AND type in (N'U'))
DROP TABLE [dbo].[TargetPart]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetPart]    Script Date: 01/26/2015 09:50:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetPart](
	[PartID] [varchar](22) NOT NULL,
	[PartSuffix] [int] NOT NULL,
	[Keyword] [varchar](15) NOT NULL,
	[ShortDescription] [varchar](120) NOT NULL,
	[ProductCategoryID] [varchar](20) NOT NULL,
	[PartClassificationID] [varchar](2) NOT NULL,
	[Tire] [char](1) NULL,
	[Core] [char](1) NULL,
	[ControlledSubstance] [char](1) NULL,
	[ItemFabricatedWithoutCore] [char](1) NULL,
	[PathAndFileName] [varchar](255) NULL,
	[FileDescription] [varchar](60) NULL,
	[LongDescription] [varchar](240) NULL,
	[PurchasingDefaultAccountID] [varchar](30) NULL,
	[Comments] [ntext] NULL,
	[MarkupPercentage] [decimal](22, 1) NULL,
	[NoMarkupOnPart] [char](1) NULL,
	[MarkupCapAmount] [decimal](22, 2) NULL,
	[VRMSCode] [varchar] (20) NULL,
	[ExcludeFromInvLists] [char] (1) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


