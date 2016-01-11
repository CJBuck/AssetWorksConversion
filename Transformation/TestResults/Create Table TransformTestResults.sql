USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformTestResults]    Script Date: 12/14/2015 13:16:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformTestResults]') AND TYPE IN(N'U'))
DROP TABLE [dbo].[TransformTestResults]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformTestResults]    Script Date: 12/14/2015 13:16:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformTestResults](
	[Control] [varchar](10) NOT NULL,
	[TestID] [varchar](9) NOT NULL,
	[EquipmentID] [varchar](20) NULL,
	[TestTypeID] [varchar](20) NULL,
	[TestDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[TestLocationID] [varchar](10) NULL,
	[EmployeeID] [varchar](9) NULL,
	[WorkOrderLocationID] [varchar](10) NULL,
	[WorkOrderYear] [int] NULL,
	[WorkOrderNumber] [varchar](15) NULL,
	[Status] [varchar](6) NULL,
	[TestResults] [varchar](25) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO
