USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentSubsystemProperty]    Script Date: 07/22/2015 14:12:52 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentSubsystemProperty]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentSubsystemProperty]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentSubsystemProperty]    Script Date: 07/22/2015 14:12:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentSubsystemProperty](
	[Control] [nvarchar] (10) NOT NULL,
	[SubsystemID] [nvarchar](20) NOT NULL,
	[PropertyID] [nvarchar](50) NOT NULL,
	[InputType] [nvarchar](20) NULL,
	[ListTypeID] [nvarchar](20) NULL,
) ON [PRIMARY]

GO
