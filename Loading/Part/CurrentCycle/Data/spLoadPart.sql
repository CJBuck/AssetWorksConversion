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
	--Need to drop tables in order of most dependent to least dependent to prevent referential integrity errors
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
		PartID NVARCHAR(22) NOT NULL,
		PartSuffix NCHAR(1) NOT NULL, -- check w/ S. Spec says NVARCHAR(22)
		Keyword NVARCHAR(15) NOT NULL,
		ShortDescription NVARCHAR(120) NOT NULL,
		ProductCategoryID NVARCHAR(20) NOT NULL,
		PartClassificationID NVARCHAR(2) NOT NULL, CONSTRAINT CHK_TargetPart_PartClassificationID CHECK (PartClassificationID IN ('CS', 'FB', 'RR', 'ST','SW','WA','WC')),
		Tire NCHAR(1) NULL CONSTRAINT CHK_TargetPart_Tire CHECK(Tire IN ('Y','N')),
		Core NCHAR(1) NULL CONSTRAINT CHK_TargetPart_Core CHECK(Core IN ('Y','N')),
		ControlledSubstance NCHAR(1) NULL CONSTRAINT CHK_TargetPart_ControlledSubstance CHECK(ControlledSubstance IN ('Y','N')),
		ItemFabricatedWithoutCore NCHAR(1) NULL CONSTRAINT CHK_TargetPart_ItemFabricatedWithoutCore CHECK(ItemFabricatedWithoutCore IN ('Y','N')),
		PathAndFileName NVARCHAR(255) NULL,
		FileDescription NVARCHAR(60) NULL,
		LongDescription NVARCHAR(240) NULL,
		PurchasingDefaultAccountID NVARCHAR(30) NULL,
		Comments NVARCHAR(600) NULL,
		MarkupPercentage NVARCHAR(22) NULL,
		NoMarkupOnPart NVARCHAR(1) NULL,
		MarkupCapAmount NVARCHAR(4) NULL, -- check w/ S. Spec says NCHAR(1)
		VRMSCode NVARCHAR(20) NULL,
		ExcludeFromInvLists NCHAR(1) NULL,
		CONSTRAINT PK_TargetPart PRIMARY KEY CLUSTERED(PartID),
		CONSTRAINT FK_TargetPart_Keyword FOREIGN KEY(Keyword)
			REFERENCES dbo.Staging_KeywordLookup(Keyword)
	);

	CREATE TABLE dbo.TargetPartLocation
	(
		Control nvarchar(255) NOT NULL CONSTRAINT DF_TargetPartLocation_Control  DEFAULT ('[i]'),
		PartID nvarchar(22) NOT NULL,
		PartSuffix nchar(1) NOT NULL,
		InventoryLocation nvarchar(10) NOT NULL,
		UnitOfMeasure nvarchar(10) NOT NULL,
		Bins nvarchar(255) NOT NULL,
		InventoryMonth nvarchar(50) NOT NULL,
		StockStatus nvarchar(30) NOT NULL,
		Manufacturer nvarchar(15) NULL,
		ManufacturerPartNo nvarchar(22) NULL,
		ReplenishMethod nvarchar(10) NOT NULL,
		PerformMinMaxCalculation nchar(1) NOT NULL,
		MinAvailable nvarchar(22) NOT NULL,
		MaxAvailable nvarchar(22) NOT NULL,
		SafetyStock nvarchar(22) NOT NULL,
		PreferredVendorID nvarchar(15) NULL,
		DefaultReplenishmentGenerationType nvarchar(20) NULL,
		SuppliedByLocationIfTransferRequest nvarchar(10) NULL,
		Comments nvarchar(600) NULL,
		-- Check Constraints
		CONSTRAINT CHK_TargetPartLocation_PartSuffix CHECK (PartSuffix IN ('0', '1', '2')),
		CONSTRAINT CHK_TargetPartLocation_StockStatus CHECK (StockStatus IN ('STOCKED', 'ON DEMAND - PROMOTABLE', 'ON DEMAND - NOT PROMOTABLE', 'PROHIBITED')),
		-- Primary Keys
		CONSTRAINT PK_TargetPartLocation PRIMARY KEY CLUSTERED(PartID, InventoryLocation),
		-- Foreign Keys
		CONSTRAINT FK_TargetPartLocation_TargetPart FOREIGN KEY(PartID)
			REFERENCES dbo.TargetPart(PartID),
		CONSTRAINT FK_TargetPartLocation_InventoryLocation FOREIGN KEY(InventoryLocation)
			REFERENCES dbo.TransformPartInventoryLocationLookup(AW_InventoryLocation),
		CONSTRAINT FK_TargetPartLocation_SuppliedByLocationIfTransferRequest FOREIGN KEY(SuppliedByLocationIfTransferRequest)
			REFERENCES dbo.TransformPartInventoryLocationLookup(AW_InventoryLocation),
		CONSTRAINT FK_TargetPartLocation_Manufacturer FOREIGN KEY(Manufacturer)
			REFERENCES dbo.TargetPartManufacturer(PartManufacturerID)
	);

	CREATE TABLE dbo.TargetPartLocationBin
	(
		Control nvarchar(255) NOT NULL CONSTRAINT DF_TargetPartLocationBin_Control  DEFAULT ('[i]'),
		PartID nvarchar(22) NOT NULL,
		LocationId nvarchar(10) NOT NULL,
		BinID nvarchar(20) NOT NULL,
		PrimaryBin nchar(1) NOT NULL,
		NewBin nchar(1) NOT NULL,
		CONSTRAINT PK_TargetPartLocationBin PRIMARY KEY CLUSTERED(PartID, LocationId, BinID),
		CONSTRAINT FK_TargetPartLocationBin_TargetPartLocation FOREIGN KEY(PartID, LocationId)
			REFERENCES dbo.TargetPartLocation(PartID, InventoryLocation) ON UPDATE NO ACTION ON DELETE NO ACTION 
	);

	CREATE TABLE dbo.TargetPartAdjustment
	(
		Control nvarchar(255) NOT NULL CONSTRAINT DF_TargetPartAdjustment_Control  DEFAULT ('[i]'),
		PartID nvarchar(22) NOT NULL,
		LocationID nvarchar(10) NOT NULL,
		PartSuffix nchar(1) NOT NULL,
		[Action] nvarchar(8) NOT NULL,
		AdjustmentType nvarchar(25) NOT NULL,
		Quantity nvarchar(22) NOT NULL,
		UnitPrice nvarchar(22) NOT NULL,
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
	INNER JOIN dbo.Staging_KeywordLookup AS skl
		ON tp.Keyword = skl.Keyword
	WHERE tp.PartClassificationID IN ('CS', 'FB', 'RR', 'ST','SW','WA','WC')


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
	INNER JOIN dbo.TransformPartInventoryLocationLookup invLook
		ON tpl.InventoryLocation = invLook.AW_InventoryLocation
	WHERE tpl.InventoryLocation IS NOT NULL
		AND tpl.UnitOfMeasure IS NOT NULL
		AND UPPER(tpl.StockStatus) IN ('STOCKED', 'ON DEMAND - PROMOTABLE', 'ON DEMAND - NOT PROMOTABLE', 'PROHIBITED')
		AND invLook.IncludeInLoad = 1


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
	INNER JOIN dbo.TargetPartLocation AS tpl --exclude form load records which have no parent
		ON tplb.PartID = tpl.PartID
		AND tplb.LocationId = tpl.InventoryLocation
	INNER JOIN dbo.TransformPartInventoryLocationLookup invLook -- exclude records without valid location
		ON tpl.InventoryLocation = invLook.AW_InventoryLocation
	WHERE invLook.IncludeInLoad = 1 -- exclude locations explicitly excluded by spec (IncludeInLoad = 0)

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
	INNER JOIN dbo.TargetPartLocation AS tpl
		ON tpa.PartID = tpl.PartID
		AND tpa.LocationId = tpl.InventoryLocation
	WHERE tpa.LocationId IS NOT NULL

END