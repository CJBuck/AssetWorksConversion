USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkOrdersClosedCommercial] Script Date: 06/29/2015 10:22:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderWorkOrdersClosedCommercial]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderWorkOrdersClosedCommercial]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkOrdersClosedCommercial] Script Date: 06/29/2015 10:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderWorkOrdersClosedCommercial](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[TaskID] [varchar](12) NULL,
	[WorkAccomplishedCode] [varchar](4) NULL,
	[Date] [datetime] NULL,
	[VendorID] [varchar](15) NULL,
	[LaborCost] [decimal](12,2) NULL,
	[PartsCost] [decimal](12,2) NULL,
	[MiscCost] [decimal](12,2) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
