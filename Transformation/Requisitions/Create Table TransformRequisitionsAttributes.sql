USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformRequisitionsAttributes]    Script Date: 10/27/2015 21:12:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformRequisitionsAttributes]') AND type in (N'U'))
DROP TABLE [dbo].[TransformRequisitionsAttributes]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformRequisitionsAttributes]    Script Date: 10/27/2015 21:12:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformRequisitionsAttributes](
	[Control] [varchar] (10) NOT NULL,
	[RequisitionID] [varchar](30) NOT NULL,
	[LineNumber] [int] NULL,
	[AttributeID] [varchar](20) NULL,
	[TextValue] [varchar](30) NULL,
	[NumericValue] [decimal](10,2) NULL,
	[Comments] [varchar](60) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
