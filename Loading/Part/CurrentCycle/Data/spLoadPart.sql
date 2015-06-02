USE AssetWorksConversion
GO

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spLoadPart') IS NULL
	EXEC ('CREATE PROCEDURE dbo.spLoadPart AS SELECT 1')
GO

ALTER PROCEDURE dbo.spLoadPart
-- =================================================================================================
-- Created By:	Gerald Davis (Marathon Consulting)
-- Create Date:	06/02/2015
-- 
-- Description: Loads data into parts target tables:
--              TargetPart, TargetPartAdjustment, TargetPartLocation, TargetPartLocationBin
--				These tables match the structure, datatypes, and requirements of the loadfiles
-- =================================================================================================
AS
BEGIN
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.TargetPartAdjustment') AND type IN (N'U'))
		DROP TABLE dbo.TargetPartAdjustment

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.TargetPartLocationBin') AND type IN (N'U'))
		DROP TABLE dbo.TargetPartLocationBin

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.TargetPartLocation') AND type IN (N'U'))
		DROP TABLE dbo.TargetPartLocation

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.TargetPart') AND type IN (N'U'))
		DROP TABLE dbo.TargetPart

	CREATE TABLE dbo.TargetPart
	(
		Control nvarchar(255) NOT NULL CONSTRAINT DF_TargetPart_Control  DEFAULT ('[i]'),
		PartID NVARCHAR(128) NOT NULL,
		PartSuffix NCHAR(1) NOT NULL,
		Keyword NVARCHAR(255) NOT NULL,
		ShortDescription NVARCHAR(255) NOT NULL,
		ProductCategoryID NVARCHAR(255) NOT NULL,
		PartClassificationID NVARCHAR(255) NOT NULL,
		Tire NCHAR(1) NULL,
		Core NCHAR(1) NULL,
		ControlledSubstance NCHAR(1) NULL,
		ItemFabricatedWithoutCore NCHAR(1) NULL,
		PathAndFileName NVARCHAR(255) NULL,
		FileDescription NVARCHAR(255) NULL,
		LongDescription NVARCHAR(255) NULL,
		PurchasingDefaultAccountID NVARCHAR(255) NULL,
		Comments NVARCHAR(4000) NULL,
		MarkupPercentage NVARCHAR(255) NULL,
		NoMarkupOnPart NVARCHAR(255) NULL,
		MarkupCapAmount NVARCHAR(255) NULL,
		VRMSCode NVARCHAR(255) NULL,
		ExcludeFromInvLists NCHAR(1) NULL,
		CONSTRAINT PK_TargetPart PRIMARY KEY CLUSTERED(PartID)
	);

	CREATE TABLE dbo.TargetPartLocation(
		Control nvarchar(255) NOT NULL CONSTRAINT DF_TargetPartLocation_Control  DEFAULT ('[i]'),
		PartID nvarchar(128) NOT NULL,
		PartSuffix nchar(1) NOT NULL,
		InventoryLocation nvarchar(128) NOT NULL,
		UnitOfMeasure nvarchar(255) NOT NULL,
		Bins nvarchar(255) NOT NULL,
		InventoryMonth nvarchar(255) NOT NULL,
		StockStatus nvarchar(255) NOT NULL,
		Manufacturer nvarchar(255) NOT NULL,
		ManufacturerPartNo nvarchar(255) NOT NULL,
		ReplenishMethod nvarchar(255) NOT NULL,
		PerformMinMaxCalculation nchar(1) NOT NULL,
		MinAvailable nvarchar(255) NOT NULL,
		MaxAvailable nvarchar(255) NOT NULL,
		SafetyStock nvarchar(255) NOT NULL,
		PreferredVendorID nvarchar(255) NULL,
		DefaultReplenishmentGenerationType nvarchar(255) NULL,
		SuppliedByLocationIfTransferRequest nvarchar(128) NULL,
		Comments nvarchar(255) NULL,
		CONSTRAINT PK_TargetPartLocation PRIMARY KEY CLUSTERED(PartID, InventoryLocation),
		CONSTRAINT FK_TargetPartLocation_TargetPart FOREIGN KEY(PartID)
			REFERENCES dbo.TargetPart(PartID) ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT FK_TargetPartLocation_InventoryLocation FOREIGN KEY(InventoryLocation)
			REFERENCES dbo.TransformPartInventoryLocationLookup(AW_InventoryLocation) ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT FK_TargetPartLocation_SuppliedByLocationIfTransferRequest FOREIGN KEY(SuppliedByLocationIfTransferRequest)
			REFERENCES dbo.TransformPartInventoryLocationLookup(AW_InventoryLocation) ON UPDATE NO ACTION ON DELETE NO ACTION
	);

	CREATE TABLE dbo.TargetPartLocationBin(
		Control nvarchar(255) NOT NULL CONSTRAINT DF_TargetPartLocationBin_Control  DEFAULT ('[i]'),
		PartID nvarchar(128) NOT NULL,
		LocationId nvarchar(128) NOT NULL,
		BinID nvarchar(128) NOT NULL,
		PrimaryBin nchar(1) NOT NULL,
		NewBin nchar(1) NOT NULL,
		CONSTRAINT PK_TargetPartLocationBin PRIMARY KEY CLUSTERED(PartID, LocationId, BinID),
		CONSTRAINT FK_TargetPartLocationBin_TargetPartLocation FOREIGN KEY(PartID, LocationId)
			REFERENCES dbo.TargetPartLocation(PartID, InventoryLocation) ON UPDATE NO ACTION ON DELETE NO ACTION 
	);

	CREATE TABLE dbo.TargetPartAdjustment
	(
		Control nvarchar(255) NOT NULL CONSTRAINT DF_TargetPartAdjustment_Control  DEFAULT ('[i]'),
		PartID nvarchar(128) NOT NULL,
		LocationID nvarchar(128) NOT NULL,
		PartSuffix nchar(1) NOT NULL,
		[Action] nvarchar(255) NOT NULL,
		AdjustmentType nvarchar(255) NOT NULL,
		Quantity nvarchar(255) NOT NULL,
		UnitPrice nvarchar(255) NOT NULL,
		CONSTRAINT PK_TargetPartAdjustment PRIMARY KEY CLUSTERED(PartID, LocationId),
		CONSTRAINT FK_TargetPartAdjustment_TargetPartLocation FOREIGN KEY(PartID, LocationId)
			REFERENCES dbo.TargetPartLocation(PartID, InventoryLocation) ON UPDATE NO ACTION ON DELETE NO ACTION 
	);

	INSERT INTO dbo.TargetPart
	(
		PartID,
		PartSuffix,
		Keyword,
		ShortDescription,
		ProductCategoryID,
		PartClassificationID,
		Tire,
		Core,
		ControlledSubstance,
		ItemFabricatedWithoutCore,
		PathAndFileName,
		FileDescription,
		LongDescription,
		PurchasingDefaultAccountID,
		Comments,
		MarkupPercentage,
		NoMarkupOnPart,
		MarkupCapAmount,
		VRMSCode,
		ExcludeFromInvLists
	)
	SELECT
		tp.PartID,
		tp.PartSuffix,
		tp.Keyword,
		tp.ShortDescription,
		tp.ProductCategoryID,
		tp.PartClassificationID,
		tp.Tire,
		tp.Core,
		tp.ControlledSubstance,
		tp.ItemFabricatedWithoutCore,
		tp.PathAndFileName,
		tp.FileDescription,
		tp.LongDescription,
		tp.PurchasingDefaultAccountID,
		tp.Comments,
		tp.MarkupPercentage,
		tp.NoMarkupOnPart,
		tp.MarkupCapAmount,
		tp.VRMSCode,
		tp.ExcludeFromInvLists
	FROM dbo.TransformPart tp

	INSERT INTO dbo.TargetPartLocation
	(
		PartID,
		PartSuffix,
		InventoryLocation,
		UnitOfMeasure,
		Bins,
		InventoryMonth,
		StockStatus,
		Manufacturer,
		ManufacturerPartNo,
		ReplenishMethod,
		PerformMinMaxCalculation,
		MinAvailable,
		MaxAvailable,
		SafetyStock,
		PreferredVendorID,
		DefaultReplenishmentGenerationType,
		SuppliedByLocationIfTransferRequest,
		Comments
	)
	SELECT
		tpl.PartID,
		tpl.PartSuffix,
		tpl.InventoryLocation,
		tpl.UnitOfMeasure,
		tpl.Bins,
		tpl.InventoryMonth,
		tpl.StockStatus,
		tpl.Manufacturer,
		tpl.ManufacturerPartNo,
		tpl.ReplenishMethod,
		tpl.PerformMinMaxCalculation,
		tpl.MinAvailable,
		tpl.MaxAvailable,
		tpl.SafetyStock,
		tpl.PreferredVendorID,
		tpl.DefaultReplenishmentGenerationType,
		tpl.SuppliedByLocationIfTransferRequest,
		tpl.Comments
	FROM dbo.TransformPartLocation tpl
	WHERE tpl.InventoryLocation != '' --temporary measure to ensure unique records while location load criteria is determined

	INSERT INTO dbo.TargetPartLocationBin
	(
		PartID,
		LocationId,
		BinID,
		PrimaryBin,
		NewBin
	)
	SELECT
		tplb.PartID,
		tplb.LocationId,
		tplb.BinID,
		tplb.PrimaryBin,
		tplb.NewBin
	FROM dbo.TransformPartLocationBin tplb
	WHERE tplb.LocationId != '' --temporary measure to ensure unique records while location load criteria is determined

	INSERT INTO dbo.TargetPartAdjustment
	(
		PartID,
		LocationId,
		PartSuffix,
		[Action],
		AdjustmentType,
		Quantity,
		UnitPrice
	)
	SELECT
		tpa.PartID,
		tpa.LocationId,
		tpa.PartSuffix,
		tpa.[Action],
		tpa.AdjustmentType,
		tpa.Quantity,
		tpa.UnitPrice
	FROM dbo.TransformPartAdjustment tpa
	WHERE tpa.LocationId != '' --temporary measure to ensure unique records while location load criteria is determined

END