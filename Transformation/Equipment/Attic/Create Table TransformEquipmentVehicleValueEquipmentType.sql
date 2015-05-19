USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentVehicleValueEquipmentType]    Script Date: 03/27/2015 13:34:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformEquipmentVehicleValueEquipmentType](
	[OBJECT_ID] [nvarchar](255) NULL,
	[EquipmentType] [nvarchar](255) NULL,
	[ModelYear] [nvarchar](255) NULL,
	[MeterTypesClass] [nvarchar](255) NULL,
	[StationLocation] [nvarchar](255) NULL,
	[Program] [nvarchar](255) NULL,
	[Make] [nvarchar](255) NULL,
	[Model] [nvarchar](255) NULL
) ON [PRIMARY]

GO


