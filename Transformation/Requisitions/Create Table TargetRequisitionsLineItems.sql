USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetRequisitionsLineItems]    Script Date: 10/29/2015 15:42:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetRequisitionsLineItems]') AND type in (N'U'))
DROP TABLE [dbo].[TargetRequisitionsLineItems]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetRequisitionsLineItems]    Script Date: 10/29/2015 15:42:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetRequisitionsLineItems](
	[Control] [varchar] (10) NOT NULL,
	[RequisitionID] [varchar](30) NOT NULL,
	[LineNumber] [int] NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[LineItemType] [varchar](20) NOT NULL,
	[PartID] [varchar](22) NOT NULL,
	[PartSuffix] [int] NOT NULL,
	[PartDecsription] [varchar](40) NULL,
	[OtherID] [varchar](30) NOT NULL,
	[Description] [varchar](30) NOT NULL,
	[Quantity] [decimal](10,2) NOT NULL,
	[UnitPrice] [decimal](10,4) NOT NULL,
	[LocationID] [varchar](10) NOT NULL,
	[OrderedDt] [datetime] NOT NULL,
	[ExpectedDeliveryDt] [datetime] NOT NULL,
	[SentToVendorDt] [datetime] NOT NULL,
	[VendorContractID] [varchar](15) NULL,
	[UnitOfMeasure] [varchar](4) NOT NULL,
	[AccountID] [varchar](30) NOT NULL,
	[Action] [varchar](20) NOT NULL,
	[AddToPurchasingID] [varchar](30) NOT NULL,
	[Comments] [varchar](60) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
