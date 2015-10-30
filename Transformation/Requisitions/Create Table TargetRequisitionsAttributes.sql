USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetRequisitionsAttributes]    Script Date: 10/30/2015 07:12:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetRequisitionsAttributes]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TargetRequisitionsAttributes]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetRequisitionsAttributes]    Script Date: 10/30/2015 07:12:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetRequisitionsAttributes](
	[Control] [varchar] (10) NOT NULL,
	[RequisitionID] [varchar](30) NOT NULL,
	[LineNumber] [int] NOT NULL,
	[AttributeID] [varchar](20) NOT NULL,
	[TextValue] [varchar](30) NOT NULL,
	[NumericValue] [decimal](10,2) NULL,
	[Comments] [varchar](60) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
