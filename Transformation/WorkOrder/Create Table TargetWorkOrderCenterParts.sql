USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetWorkOrderCenterParts] Script Date: 09/22/2015 10:22:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetWorkOrderCenterParts]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetWorkOrderCenterParts]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetWorkOrderCenterParts] Script Date: 09/22/2015 10:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetWorkOrderCenterParts](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NOT NULL,
	[WorkOrderNumber] [varchar](15) NULL,
	[TaskID] [varchar](12) NOT NULL,
	[Dt] [datetime] NOT NULL,
	[NotFromInventory] [char](1) NOT NULL,
	[PartID] [varchar](22) NOT NULL,
	[PartSuffix] [varchar](2) NOT NULL,
	[Quantity] [decimal](10,2) NOT NULL,
	[UnitPrice] [decimal](10,4) NOT NULL,
	[PartKeywordAndShortDescription] [varchar](140) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
