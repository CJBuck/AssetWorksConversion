USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetTestResults]    Script Date: 12/15/2015 12:38:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetTestResults]') AND TYPE IN(N'U'))
DROP TABLE [dbo].[TargetTestResults]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetTestResults]    Script Date: 12/15/2015 12:38:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetTestResults](
	[Control] [varchar](10) NOT NULL,
	[TestID] [varchar](9) NOT NULL,
	[EquipmentID] [varchar](20) NOT NULL,
	[TestTypeID] [varchar](20) NOT NULL,
	[TestDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[TestLocationID] [varchar](10) NOT NULL,
	[EmployeeID] [varchar](9) NOT NULL,
	[WorkOrderLocationID] [varchar](10) NOT NULL,
	[WorkOrderYear] [int] NOT NULL,
	[WorkOrderNumber] [varchar](15) NOT NULL,
	[Status] [varchar](6) NOT NULL,
	[TestResults] [varchar](25) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO
