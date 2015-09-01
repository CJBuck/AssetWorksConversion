USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformComponentGSPMTasks]    Script Date: 09/01/2015 14:20:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformComponentGSPMTasks]') AND type in (N'U'))
DROP TABLE [dbo].[TransformComponentGSPMTasks]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformComponentGSPMTasks]    Script Date: 09/01/2015 14:20:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformComponentGSPMTasks](
	[EquipmentType] [varchar](30) NOT NULL,
	[PMService] [varchar](12) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


