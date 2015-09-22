USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkProject]    Script Date: 06/26/2015 13:52:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformWorkOrderWorkProject]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformWorkOrderWorkProject]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderWorkProject]    Script Date: 06/26/2015 13:52:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformWorkOrderWorkProject](
	[Control] [varchar](10) NOT NULL,
	[WorkProjectID] [varchar](9) NOT NULL,
	[ProjectName] [varchar](255) NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[CreatedByUserID] [varchar](50) NULL,
	[OwnedByUserID] [varchar](50) NULL,
	[NotificationTemplate] [varchar](20) NULL,
	[NotificationInstanceID] [varchar](10) NULL,
	[Goal] [varchar](2000) NULL,
	[ProjectLines] [varchar](25) NOT NULL,
	[Dependencies] [varchar](25) NOT NULL,
	[Files] [varchar](25) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO
