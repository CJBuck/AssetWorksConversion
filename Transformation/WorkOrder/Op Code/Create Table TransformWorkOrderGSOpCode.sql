USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderGSOpCode]    Script Date: 08/12/2015 13:38:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformWorkOrderGSOpCode]') AND type in (N'U'))
DROP TABLE [dbo].[TransformWorkOrderGSOpCode]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformWorkOrderGSOpCode]    Script Date: 08/12/2015 13:38:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformWorkOrderGSOpCode](
	[OpCode] [varchar](4) NOT NULL,
	[Description] [varchar](250) NULL,
	[TaskIDAlignment] [varchar](12) NULL,
	[RepairPM] [varchar](6) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

-- Populate table from Staging_TransformWorkOrderGSOpCode
INSERT INTO TransformWorkOrderGSOpCode
SELECT
	LEFT(LTRIM(RTRIM(OP_CODE1)), 4),
	LEFT(LTRIM(RTRIM([OP_CODE Description])), 250),
	LEFT(LTRIM(RTRIM([Task ID Alignment? (see tab 2)])), 12),
	LEFT(LTRIM(RTRIM([Repair or PM?])), 6)
FROM Staging_TransformWorkOrderOpCode
