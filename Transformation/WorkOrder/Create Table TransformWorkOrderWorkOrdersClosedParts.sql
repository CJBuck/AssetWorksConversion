USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkOrdersClosedParts] Script Date: 06/29/2015 10:22:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderWorkOrdersClosedParts]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderWorkOrdersClosedParts]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkOrdersClosedParts] Script Date: 06/29/2015 10:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderWorkOrdersClosedParts](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[TaskID] [varchar](12) NULL,
	[Date] [datetime] NULL,
	[NotFromInventory] [char](1) NULL,
	[PartID] [varchar](22) NULL,
	[Quantity] [decimal](10,2) NULL,
	[UnitPrice] [decimal](10,4) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
