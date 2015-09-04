USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[SourceAssetHierarchyFacility]    Script Date: 9/4/2015 12:08:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SourceAssetHierarchyFacility](
	[Control] [varchar](10) NOT NULL,
	[EquipmentId] [varchar](20) NOT NULL,
	[AssetType] [varchar](20) NOT NULL,
	[Description] [varchar](40) NOT NULL,
	[AssetNumber] [varchar](20) NULL,
	[SerialNumber] [varchar](50) NULL,
	[EquipmentType] [varchar](30) NOT NULL,
	[PMProgramType] [varchar](10) NOT NULL,
	[ModelYear] [int] NOT NULL,
	[ManufacturerID] [varchar](15) NOT NULL,
	[ModelID] [varchar](15) NOT NULL,
	[MeterTypesClass] [varchar](30) NOT NULL,
	[Maintenance] [varchar](30) NOT NULL,
	[PMProgram] [varchar](30) NOT NULL,
	[Standards] [varchar](30) NOT NULL,
	[RentalRates] [varchar](30) NOT NULL,
	[Resources] [varchar](30) NOT NULL,
	[AssetCategoryID] [varchar](15) NOT NULL,
	[AssignedRepair] [varchar](10) NOT NULL,
	[StoredLocation] [varchar](10) NULL,
	[AssignedPM] [varchar](10) NOT NULL,
	[PreferredPMShift] [varchar](10) NOT NULL,
	[StationLocation] [varchar](10) NOT NULL,
	[VehicleLocation] [varchar](20) NULL,
	[BuildingLocation] [varchar](20) NULL,
	[OtherLocation] [varchar](20) NULL,
	[DepartmentID] [varchar](10) NOT NULL,
	[DeptToNotifyForPM] [varchar](10) NOT NULL,
	[AccountIDAssignmentWO] [varchar](10) NULL,
	[AccountIDLaborPosting] [varchar](10) NULL,
	[AccountIDPartIssues] [varchar](10) NULL,
	[AccountIDCommercialWork] [varchar](10) NULL,
	[AccountIDFuelTickets] [varchar](10) NULL,
	[AccountIDUsageTickets] [varchar](10) NULL,
	[EquipmentStatus] [varchar](10) NULL,
	[LifeCycleStatusCodeID] [varchar](2) NULL,
	[ConditionRating] [varchar](20) NULL,
	[WorkOrders] [char](1) NOT NULL,
	[UsageTickets] [char](1) NULL,
	[DefaultWOPriorityID] [varchar](2) NULL,
	[ActualDeliveryDate] [datetime] NULL,
	[ActualInServiceDate] [datetime] NULL,
	[OriginalCost] [decimal](22, 2) NULL,
	[DepreciationMethod] [varchar](25) NULL,
	[LifeMonths] [int] NULL,
	[MonthsRemaining] [decimal](22, 2) NULL,
	[Ownership] [varchar](8) NULL,
	[EstimatedReplacementMonth] [int] NULL,
	[EstimatedReplacementYear] [int] NULL,
	[EstimatedReplacementCost] [decimal](22, 2) NULL,
	[Latitude] [varchar](10) NULL,
	[Longitude] [varchar](10) NULL,
	[NextPMServiceNumber] [int] NULL,
	[NextPMDueDate] [datetime] NULL,
	[IndividualPMService] [varchar](30) NULL,
	[IndividualPMDateNextDue] [datetime] NULL,
	[IndividualPMNumberofTimeUnits] [int] NULL,
	[IndividualPMTimeUnit] [varchar](10) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


