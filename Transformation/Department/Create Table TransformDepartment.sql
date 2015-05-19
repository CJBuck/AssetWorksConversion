USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformDepartment]    Script Date: 04/28/2015 11:20:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformDepartment]') AND type in (N'U'))
DROP TABLE [dbo].[TransformDepartment]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformDepartment]    Script Date: 04/28/2015 11:20:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformDepartment](
		[Control] [varchar] (10) NOT NULL,
		[DepartmentID] [varchar](10) NOT NULL,
		[DepartmentName] [varchar] (50) NOT NULL,
		[Active] [char] (1) NOT NULL,
		[Source] [varchar] (50) NOT NULL,
		[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
