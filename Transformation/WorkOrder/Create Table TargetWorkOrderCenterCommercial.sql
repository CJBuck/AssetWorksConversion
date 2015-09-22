USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetWorkOrderCenterCommercial] Script Date: 09/22/2015 10:28:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetWorkOrderCenterCommercial]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetWorkOrderCenterCommercial]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetWorkOrderCenterCommercial] Script Date: 09/22/2015 10:28:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetWorkOrderCenterCommercial](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NOT NULL,
	[WorkOrderNumber] [int] NOT NULL,
	[TaskID] [varchar](12) NOT NULL,
	[WorkAccomplishedCode] [varchar](4) NOT NULL,
	[Dt] [datetime] NOT NULL,
	[VendorID] [varchar](15) NOT NULL,
	[LaborCost] [decimal](12,2) NOT NULL,
	[PartsCost] [decimal](12,2) NOT NULL,
	[MiscCost] [decimal](12,2) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
