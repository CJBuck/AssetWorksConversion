USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformRequisitionsLineItems]    Script Date: 10/27/2015 21:12:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformRequisitionsLineItems]') AND type in (N'U'))
DROP TABLE [dbo].[TransformRequisitionsLineItems]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformRequisitionsLineItems]    Script Date: 10/27/2015 21:12:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformRequisitionsLineItems](
	[Control] [varchar] (10) NOT NULL,
	[RequisitionID] [varchar](30) NOT NULL,
	[LineNumber] [int] NULL,
	[Status] [varchar](20) NULL,
	[LineItemType] [varchar](20) NULL,
	[PartID] [varchar](22) NULL,
	[PartSuffix] [int] NULL,
	[PartDescription] [varchar](40) NULL,
	[OtherID] [varchar](30) NULL,
	[Description] [varchar](30) NULL,
	[Quantity] [decimal](10,2) NULL,
	[UnitPrice] [decimal](10,4) NULL,
	[LocationID] [varchar](10) NULL,
	[OrderedDt] [datetime] NULL,
	[ExpectedDeliveryDt] [datetime] NULL,
	[SentToVendorDt] [datetime] NULL,
	[VendorContractID] [varchar](15) NULL,
	[UnitOfMeasure] [varchar](4) NULL,
	[AccountID] [varchar](30) NULL,
	[Action] [varchar](20) NULL,
	[AddToPurchasingID] [varchar](30) NULL,
	[Comments] [varchar](60) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
