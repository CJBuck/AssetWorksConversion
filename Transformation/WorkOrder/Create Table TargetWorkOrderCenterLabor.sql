USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetWorkOrderCenterLabor] Script Date: 09/22/2015 10:04:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetWorkOrderCenterLabor]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetWorkOrderCenterLabor]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetWorkOrderCenterLabor] Script Date: 09/22/2015 10:04:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TargetWorkOrderCenterLabor](
	[Control] [varchar](10) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NOT NULL,
	[WorkOrderNumber] [varchar](15) NOT NULL,
	[TaskID] [varchar](12) NOT NULL,
	[WorkAccomplishedCode] [varchar](4) NOT NULL,
	[LaborDt] [datetime] NOT NULL,
	[EmployeeID] [varchar](9) NOT NULL,
	[LaborHours] [decimal](5,2) NOT NULL,
	[TimeCode] [varchar](8) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
