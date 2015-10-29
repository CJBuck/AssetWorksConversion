USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformRequisitionsRelatedWorkOrders]    Script Date: 10/27/2015 21:12:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformRequisitionsRelatedWorkOrders]') AND type in (N'U'))
DROP TABLE [dbo].[TransformRequisitionsRelatedWorkOrders]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformRequisitionsRelatedWorkOrders]    Script Date: 10/27/2015 21:12:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformRequisitionsRelatedWorkOrders](
	[Control] [varchar](10) NOT NULL,
	[RequisitionID] [varchar](30) NOT NULL,
	[LineNumber] [int] NOT NULL,
	[WorkOrderLocationID] [varchar](10) NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[Quantity] [decimal](10,2) NULL,
	[TaskID] [varchar](12) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
