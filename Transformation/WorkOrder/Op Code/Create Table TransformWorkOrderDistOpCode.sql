USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderDistOpCode]    Script Date: 08/18/2015 06:38:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformWorkOrderDistOpCode]') AND type in (N'U'))
DROP TABLE [dbo].[TransformWorkOrderDistOpCode]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderDistOpCode]    Script Date: 08/18/2015 06:38:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformWorkOrderDistOpCode](
	[OpCode] [varchar](4) NOT NULL,
	[Description] [varchar](250) NULL,
	[TaskIDAlignment] [varchar](12) NULL,
	[RepairPM] [varchar](6) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

-- Populate table from Staging_TransformWorkOrderDistOpCode
INSERT INTO TransformWorkOrderDistOpCode
SELECT
	LEFT(LTRIM(RTRIM(OpCODE)), 4),
	LEFT(LTRIM(RTRIM([Description])), 250),
	LEFT(LTRIM(RTRIM([TaskIDAlignment])), 12),
	LEFT(LTRIM(RTRIM([RepairPM])), 6)
FROM Staging_TransformWorkOrderDistOpCode
