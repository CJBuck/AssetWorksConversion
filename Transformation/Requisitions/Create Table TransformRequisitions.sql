USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformRequisitions]    Script Date: 10/27/2015 21:12:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformRequisitions]') AND type in (N'U'))
DROP TABLE [dbo].[TransformRequisitions]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformRequisitions]    Script Date: 10/27/2015 21:12:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformRequisitions](
	[Control] [varchar] (10) NOT NULL,
	[RequisitionID] [varchar](30) NOT NULL,
	[LocationID] [varchar](10) NULL,
	[Description] [varchar](30) NULL,
	[VendorID] [varchar](15) NULL,
	[Status] [varchar](20) NULL,
	[PurchaseTypeID] [varchar](20) NULL,
	[CurrencyID] [varchar](3) NULL,
	[AccountID] [varchar](30) NULL,
	[Approval] [varchar](20) NULL,
	[ApprovalEmployeeID] [varchar](9) NULL,
	[RequestedDt] [datetime] NULL,
	[OrderedDt] [datetime] NULL,
	[ExpectedDeliveryDt] [datetime] NULL,
	[OrderedByEmployeeID] [varchar](9) NULL,
	[LineItems] [varchar](50) NULL,
	[RelatedWorkOrders] [varchar](50) NULL,
	[Attributes] [varchar](50) NULL,
	[Comments] [varchar](2000) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
