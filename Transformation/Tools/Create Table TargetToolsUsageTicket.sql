USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetToolsUsageTicket]    Script Date: 02/09/2015 12:15:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TargetToolsUsageTicket]') AND TYPE IN(N'U'))
DROP TABLE [dbo].[TargetToolsUsageTicket]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TargetToolsUsageTicket]    Script Date: 02/09/2015 12:15:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TargetToolsUsageTicket](
	[Control] [varchar](10) NOT NULL,
	[EquipmentID] [varchar](20) NOT NULL,
	[Tickets] [varchar](25) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO
