USE [AssetWorksConversion]
GO

/****** Object:  StoredProcedure [dbo].[spTransformPart]    Script Date: 9/4/2015 11:55:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spTransformAssetHeirarchy]
AS
BEGIN
	INSERT INTO dbo.TransformAssetHierarchyRelationship
	SELECT *
	FROM dbo.SourceAssetHierarchyRelationship

	UPDATE t
		SET ComponentId = x.EquipmentID
	FROM TransformAssetHierarchyRelationship t
	INNER JOIN dbo.TransformEquipmentLegacyXwalk x
		ON t.ComponentWICMId = x.LegacyID

	INSERT INTO [dbo].[TransformEquipment]
	(
		[Control]
		,[EquipmentID]
		,[AssetType]
		,[Description]
		,[AssetNumber]
		,[SerialNumber]
		,[EquipmentType]
		,[PMProgramType]
		,[ModelYear]
		,[ManufacturerID]
		,[ModelID]
		,[MeterTypesClass]
		,[Maintenance]
		,[PMProgram]
		,[Standards]
		,[RentalRates]
		,[Resources]
		,[AssetCategoryID]
		,[AssignedRepair]
		,[StoredLocation]
		,[AssignedPM]
		,[PreferredPMShift]
		,[StationLocation]
		,[VehicleLocation]
		,[BuildingLocation]
		,[OtherLocation]
		,[DepartmentID]
		,[DeptToNotifyForPM]
		,[AccountIDAssignmentWO]
		,[AccountIDLaborPosting]
		,[AccountIDPartIssues]
		,[AccountIDCommercialWork]
		,[AccountIDFuelTickets]
		,[AccountIDUsageTickets]
		,[EquipmentStatus]
		,[LifeCycleStatusCodeID]
		,[ConditionRating]
		,[WorkOrders]
		,[UsageTickets]
		,[DefaultWOPriorityID]
		,[ActualDeliveryDate]
		,[ActualInServiceDate]
		,[OriginalCost]
		,[DepreciationMethod]
		,[LifeMonths]
		,[MonthsRemaining]
		,[Ownership]
		,[EstimatedReplacementMonth]
		,[EstimatedReplacementYear]
		,[EstimatedReplacementCost]
		,[Latitude]
		,[Longitude]
		,[NextPMServiceNumber]
		,[NextPMDueDate]
		,[IndividualPMService]
		,[IndividualPMDateNextDue]
		,[IndividualPMNumberofTimeUnits]
		,[IndividualPMTimeUnit]
	)
	SELECT 
		[Control]
		,[EquipmentId]
		,[AssetType]
		,[Description]
		,[AssetNumber]
		,[SerialNumber]
		,[EquipmentType]
		,[PMProgramType]
		,[ModelYear]
		,[ManufacturerID]
		,[ModelID]
		,[MeterTypesClass]
		,[Maintenance]
		,[PMProgram]
		,[Standards]
		,[RentalRates]
		,[Resources]
		,[AssetCategoryID]
		,[AssignedRepair]
		,[StoredLocation]
		,[AssignedPM]
		,[PreferredPMShift]
		,[StationLocation]
		,[VehicleLocation]
		,[BuildingLocation]
		,[OtherLocation]
		,[DepartmentID]
		,[DeptToNotifyForPM]
		,[AccountIDAssignmentWO]
		,[AccountIDLaborPosting]
		,[AccountIDPartIssues]
		,[AccountIDCommercialWork]
		,[AccountIDFuelTickets]
		,[AccountIDUsageTickets]
		,[EquipmentStatus]
		,[LifeCycleStatusCodeID]
		,[ConditionRating]
		,[WorkOrders]
		,[UsageTickets]
		,[DefaultWOPriorityID]
		,[ActualDeliveryDate]
		,[ActualInServiceDate]
		,[OriginalCost]
		,[DepreciationMethod]
		,[LifeMonths]
		,[MonthsRemaining]
		,[Ownership]
		,[EstimatedReplacementMonth]
		,[EstimatedReplacementYear]
		,[EstimatedReplacementCost]
		,[Latitude]
		,[Longitude]
		,[NextPMServiceNumber]
		,[NextPMDueDate]
		,[IndividualPMService]
		,[IndividualPMDateNextDue]
		,[IndividualPMNumberofTimeUnits]
		,[IndividualPMTimeUnit]
	  FROM [dbo].[SourceAssetHierarchyFacility]
END

GO


