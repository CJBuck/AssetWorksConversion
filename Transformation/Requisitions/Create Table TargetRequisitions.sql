USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetRequisitions]    Script Date: 10/29/2015 10:46:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetRequisitions]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetRequisitions]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetRequisitions]    Script Date: 10/29/2015 10:46:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetRequisitions](
	[Control] [varchar] (10) NOT NULL,
	[RequisitionID] [varchar](30) NOT NULL,
	[LocationID] [varchar](10) NOT NULL,
	[Description] [varchar](30) NOT NULL,
	[VendorID] [varchar](15) NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[PurchaseTypeID] [varchar](20) NOT NULL,
	[CurrencyID] [varchar](3) NOT NULL,
	[AccountID] [varchar](30) NOT NULL,
	[Approval] [varchar](20) NOT NULL,
	[ApprovalEmployeeID] [varchar](9) NOT NULL,
	[RequestedDt] [datetime] NOT NULL,
	[OrderedDt] [datetime] NOT NULL,
	[ExpectedDeliveryDt] [datetime] NOT NULL,
	[OrderedByEmployeeID] [varchar](9) NOT NULL,
	[LineItems] [varchar](50) NOT NULL,
	[RelatedWorkOrders] [varchar](50) NOT NULL,
	[Attributes] [varchar](50) NOT NULL,
	[Comments] [varchar](2000) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
