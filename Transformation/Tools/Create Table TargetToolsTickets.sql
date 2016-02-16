USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetToolsTickets]    Script Date: 02/09/2015 16:07:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetToolsTickets]') AND TYPE IN(N'U'))
DROP TABLE [dbo].[TargetToolsTickets]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetToolsTickets]    Script Date: 02/09/2015 16:07:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetToolsTickets](
	[Control] [varchar](10) NOT NULL,
	[EquipmentID] [varchar](20) NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[DepartmentID] [varchar](10) NOT NULL,
	[OperatorID] [varchar](50) NULL,
	[HoursUsed] [int] NOT NULL,
	[PoolLocationID] [varchar](10) NULL,
	[WorkOrderLocation] [varchar](10) NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [int] NULL,
	[TaskID] [varchar] NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO
