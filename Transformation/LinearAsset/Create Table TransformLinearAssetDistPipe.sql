USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformLinearAssetDistPipe]    Script Date: 07/16/2015 10:32:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TransformLinearAssetDistPipe]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformLinearAssetDistPipe]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformLinearAssetDistPipe]    Script Date: 07/16/2015 10:32:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformLinearAssetDistPipe](
	[Control] [varchar](10) NOT NULL,
	[EquipmentID] [varchar](20) NOT NULL,
	[AssetType] [varchar](20) NULL,
	[EquipmentType] [varchar](30) NULL,
	[PMProgramType] [varchar](10) NULL,
	[Description] [varchar](20) NULL,
	[Year] [int] NULL,
	[Manufacturer] [varchar](15) NULL,
	[Model] [varchar](15) NULL,
	[EquipmentClassForUsage] [varchar](5) NULL,
	[MaintenanceClass] [varchar](30) NULL,
	[PMProgram2] [varchar](30) NULL,
	[Standards] [varchar](30) NULL,
	[RentalRates] [varchar](30) NULL,
	[Resources] [varchar](30) NULL,
	[AssetCategoryID] [varchar](15) NULL,
	[PMLocation] [varchar](10) NULL,
	[RepairLocation] [varchar](10) NULL,
	[DepartmentID] [varchar](10) NULL,
	[DeptToNotifyForPM] [varchar](10) NULL,
	[DefaultPriorityCode] [varchar](2) NULL,
	[EquipmentStatus] [varchar](10) NULL,
	[LifeCycleStatusCodeID] [varchar](2) NULL,
	[ReadyForDisposition] [char](1) NOT NULL,
	[WorkOrdersOK] [char](1) NOT NULL,
	[DepreciationMethod] [varchar](25) NULL,
	[Ownership] [varchar](8) NULL,
	[FromMarker] [varchar](15) NULL,
	[ToMarker] [varchar](15) NULL,
	[FromOffset] [decimal](15,8) NULL,
	[ToOffset] [decimal](15,8) NULL,
	[FromSegment] [varchar](12) NULL,
	[ToSegment] [varchar](12) NULL,
	[ShapeID] [varchar](12) NOT NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
