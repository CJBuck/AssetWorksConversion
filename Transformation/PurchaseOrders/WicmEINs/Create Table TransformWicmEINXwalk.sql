USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWicmEINXwalk]    Script Date: 09/02/2015 14:26:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformWicmEINXwalk]') AND type in (N'U'))
DROP TABLE [dbo].[TransformWicmEINXwalk]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWicmEINXwalk]    Script Date: 09/02/2015 14:26:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformWicmEINXwalk](
	[BuyerID] [varchar](50) NULL,
	[EmployeeID] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

INSERT INTO TransformWicmEINXwalk
SELECT * FROM Staging_TransformWicmEINXwalk

