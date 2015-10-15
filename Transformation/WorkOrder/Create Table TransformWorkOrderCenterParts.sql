USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderCenterParts] Script Date: 07/29/2015 10:22:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderCenterParts]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderCenterParts]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderCenterParts] Script Date: 07/29/2015 10:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderCenterParts](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [varchar](15) NULL,
	[TaskID] [varchar](12) NULL,
	[Dt] [datetime] NULL,
	[NotFromInventory] [char](1) NULL,
	[PartID] [varchar](22) NULL,
	[PartSuffix] [varchar](2) NULL,
	[Quantity] [decimal](10,2) NULL,
	[UnitPrice] [decimal](10,4) NULL,
	[PartKeywordAndShortDescription] [varchar](140) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
