-- ===============================================================================
-- Created By:		Chris Buck
-- Create Date:		02/19/2016
-- Update Date:
--
-- Description:		Creates/modifies the spTransformVendor stored procedure.
-- ===============================================================================

IF OBJECT_ID('spTransformVendor') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformVendor AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformVendor
AS

BEGIN
	IF OBJECT_ID('tmp.VendorsToLoad') IS NOT NULL
	DROP TABLE tmp.VendorsToLoad
	
	CREATE TABLE tmp.VendorsToLoad (
		[WICMVendorNumber] [VARCHAR](15),
		[VendorName] [VARCHAR](35)
	)

	IF OBJECT_ID('tmp.Vendor') IS NOT NULL
	DROP TABLE tmp.Vendor

	CREATE TABLE tmp.Vendor (
		[Control] [varchar](10) NOT NULL,
		[VendorID] [varchar](15) NOT NULL,
		[VendorName] [varchar](35) NOT NULL,
		[ContactName] [varchar](35) NULL,
		[AddressLine1] [varchar](30) NULL,
		[AddressLine2] [varchar](30) NULL,
		[AddressLine3] [varchar](30) NULL,
		[AddressLine4] [varchar](30) NULL,
		[Phone] [varchar](30) NULL,
		[Fax] [varchar](30) NULL,
		[EmailAddress] [varchar](200) NULL,
		[SalesTaxRate] [decimal](22, 4) NULL,
		[FederalTaxID] [varchar](30) NULL,
		[Active] [char](1) NOT NULL,
		[MinorityOwned] [char](1) NULL,
		[WomenOwned] [char](1) NULL,
		[SmallBusiness] [char](1) NULL,
		[VendorTypeID] [varchar](20) NULL,
		[VendorStatusID] [varchar](20) NULL,
		[VendorProvidesEquipment] [char](1) NULL,
		[EquipmentAndComponentWarranties] [char](1) NULL,
		[EquipmentRepairAndPM] [char](1) NULL,
		[Parts] [char](1) NULL,
		[PartsWarranties] [char](1) NULL,
		[PartsRepairAndRebuild] [char](1) NULL,
		[Fuel] [char](1) NULL,
		[Testing] [char](1) NULL,
		[CurrencyID] [varchar](3) NOT NULL,
		[MinimumOrderValInVendorCurrency] [decimal](22, 2) NULL,
		[Contacts] [varchar](25) NOT NULL,
		[SupportsAllLocations] [char](1) NULL,
		[TrackEnterprisePurchasesReceiptsByStoreLocation] [char](1) NULL,
		[StoreLocations] [varchar](25) NOT NULL,
		[CreateDt] [datetime] NOT NULL
	)

	IF OBJECT_ID('tmp.VendorContact') IS NOT NULL
	DROP TABLE tmp.VendorContact

	CREATE TABLE tmp.VendorContact (
		[Control] [varchar](10) NOT NULL,
		[VendorID] [varchar](15) NOT NULL,
		[ContactTypeID] [varchar](20) NULL,
		[LocationID] [varchar](10) NULL,
		[StoreID] [int] IDENTITY(1,1) NOT NULL,
		[ContactName] [varchar](35) NULL,
		[Phone] [varchar](30) NULL,
		[Fax] [varchar](30) NULL,
		[Mobile] [varchar](30) NULL,
		[AddressLine1] [varchar](30) NULL,
		[AddressLine2] [varchar](30) NULL,
		[AddressLine3] [varchar](30) NULL,
		[AddressLine4] [varchar](30) NULL,
		[EmailAddress] [varchar](200) NULL,
		[Comments] [varchar](60) NULL,
		[CreateDt] [datetime] NOT NULL
	)

	IF OBJECT_ID('tmp.VendorStore') IS NOT NULL
		DROP TABLE tmp.VendorStore

	CREATE TABLE tmp.VendorStore(
		[Control] [varchar](10) NOT NULL,
		[VendorID] [varchar](15) NOT NULL,
		[StoreID] [varchar](20) NULL,
		[ContactName] [varchar](35) NULL,
		[Phone] [varchar](30) NULL,
		[Fax] [varchar](30) NULL,
		[Mobile] [varchar](30) NULL,
		[AddressLine1] [varchar](30) NULL,
		[AddressLine2] [varchar](30) NULL,
		[AddressLine3] [varchar](30) NULL,
		[AddressLine4] [varchar](30) NULL,
		[CreateDt] [datetime] NOT NULL
	)
	
	-- Pull the WICM Vendor IDs to migrate.
	;WITH vcd AS (
	  SELECT DISTINCT VNUMBER, VNAME 
	  FROM SourceWicm310Vendor ven
			INNER JOIN SourceWicm220PartsHeader parts ON ven.VNUMBER = parts.VENDOR_CD 
	  ),
	vcd2 AS (
		  SELECT DISTINCT VNUMBER, VNAME 
		  FROM SourceWicm310Vendor ven
				INNER JOIN SourceWicm220PartsHeader parts ON ven.VNUMBER = parts.VENDOR_CD2
		  ),
	vcd3 AS (
		  SELECT DISTINCT VNUMBER, VNAME 
		  FROM SourceWicm310Vendor ven
				INNER JOIN SourceWicm220PartsHeader parts ON ven.VNUMBER = parts.VENDOR_CD3
		  ),
	vcd4 AS (
		  SELECT DISTINCT VNUMBER, VNAME 
		  FROM SourceWicm310Vendor ven
				INNER JOIN SourceWicm220PartsHeader parts ON ven.VNUMBER = parts.VENDOR_CD4
		  ),
	vcd5 AS (
		  SELECT DISTINCT VNUMBER, VNAME 
		  FROM SourceWicm310Vendor ven
				INNER JOIN SourceWicm220PartsHeader parts ON ven.VNUMBER = parts.VENDOR_CD5
		  ),
	vcd6 AS (
		  SELECT DISTINCT VNUMBER, VNAME 
		  FROM SourceWicm310VENDOR ven
				INNER JOIN SourceWicm223PartsHistory parts ON ven.VNUMBER = parts.VENDOR_CODE
		  ),      
	vensummary AS (   
		  SELECT * FROM vcd
		  UNION ALL
		  SELECT * FROM vcd2
		  UNION ALL
		  SELECT * FROM vcd3
		  UNION ALL
		  SELECT * FROM vcd4
		  UNION ALL
		  SELECT * FROM vcd5
		  UNION ALL
		  SELECT * FROM vcd6
	)
	INSERT INTO tmp.VendorsToLoad
	SELECT DISTINCT VNUMBER, VNAME
	FROM vensummary

	-- Populate tmp.Vendor :: MUNIS Vendor Types
	INSERT INTO tmp.Vendor
	SELECT DISTINCT
		'[i]' [Control],
		LU.TargetVendorID [VendorID],
		LEFT(LTRIM(RTRIM(munis.NAME)), 35) [VendorName],
		LEFT(LTRIM(RTRIM(munis.CONTACT1_NAME)), 35) [ContactName],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.ADDR1)), 30)
			ELSE ''
		END [Address1],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.ADDR2)), 30)
			ELSE ''
		END [Address2],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.CITY)), 30)
			ELSE ''
		END [Address3],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.ST)) + ' ' + LTRIM(RTRIM(munis.ZIP)), 30)
			ELSE ''
		END [Address4],
		'' [Phone],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.FAX)), 30)
			ELSE ''
		END [Fax],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.EMAIL)), 200)
			ELSE ''
		END [EmailAddress],
		NULL [SalesTaxRate],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.FID)), 30)
			ELSE ''
		END [FederalTaxID],
		'Y' [Active],
		CASE
			WHEN munis.REMIT = 'N' AND munis.[TYPE] = 'M-MINORITY BUSINESS ENTERPRISE' THEN 'Y'
			ELSE 'N'
		END [MinorityOwned],
		CASE
			WHEN munis.REMIT = 'N' AND munis.[TYPE] = 'W-WOMAN BUSINESS ENTERPRISE' THEN 'Y'
			ELSE 'N'
		END [WomenOwned],
		CASE
			WHEN munis.REMIT = 'N' AND munis.[TYPE] = 'S-SMALL BUSINESS ENTERPRISE' THEN 'Y'
			ELSE 'N'
		END [SmallBusiness],
		LU.VendorTypeID [VendorTypeID],
		CASE
			WHEN munis.[TYPE] = 'O-OTHER' THEN 'OTHER'
			WHEN munis.[TYPE] = 'S-SMALL BUSINESS ENTERPRISE' THEN 'SBE'
			WHEN munis.[TYPE] = 'M-MINORITY BUSINESS ENTERPRISE' THEN 'MBE'
			WHEN munis.[TYPE] = 'XXR-REVIEWED BY FINANCE' THEN 'REVIEWED'
			WHEN munis.[TYPE] = 'W-WOMAN BUSINESS ENTERPRISE' THEN 'WBE'
			WHEN munis.[TYPE] = 'XSW-SHELTERED WORKSHOP' THEN 'SHELTERED'
			WHEN munis.[TYPE] = 'XGG-GOV''T TO GOV''T' THEN 'GOVT TO GOVT'
			WHEN munis.[TYPE] = 'XXP-PENDING FINANCE REVIEW' THEN 'PENDING'
			WHEN munis.[TYPE] = 'XFC-FOSTER CARE' THEN 'FOST CARE'
			WHEN munis.[TYPE] = 'XHSV-HUMAN SERVICES VENDOR' THEN 'HUMAN SERV'
			WHEN munis.[TYPE] = 'XDHS-HUMAN SVCS- COMPANION PROVIDER' THEN 'HUMAN SVCS'
			WHEN munis.[TYPE] = 'XSYE-SUMMER YOUTH EMPLOYEE PROGRAM' THEN 'SUMMER YOU'
			WHEN munis.[TYPE] = 'STEP-STEP PROGRAM' THEN 'STEP PROGR'
			WHEN (munis.[TYPE] = 'I-INCORPORATED') OR (munis.[TYPE] = 'INCORPORATED')  THEN 'INCORPORATED'
			WHEN (munis.[TYPE] = 'M-MEDICAL') OR (munis.[TYPE] = 'MEDICAL')  THEN 'MEDICAL'
			WHEN (munis.[TYPE] = 'N-NON-PROFIT') OR (munis.[TYPE] = 'NON-PROFIT') THEN 'NON-PROFIT'
			WHEN (munis.[TYPE] = 'P-PARTNERSHIP') OR (munis.[TYPE] = 'PARTNERSHIP') THEN 'PARTNERSHIP'
			WHEN (munis.[TYPE] = 'S-SOLE PROPRIETOR') OR (munis.[TYPE] = 'SOLE PROPRIETOR') THEN 'SOLE PROPRIETOR'
			ELSE ''
		END [VendorStatusID],
		'Y' [VendorProvidesEquipment],
		'Y' [EquipmentAndComponentWarranties],
		'Y' [EquipmentRepairAndPM],
		'Y' [Parts],
		'Y' [PartsWarranties],
		'Y' [PartsRepairAndRebuild],
		'Y' [Fuel],
		'Y' [Testing],
		'USD' [CurrencyID],
		NULL [MinimumOrderValInVendorCurrency],
		'[9066:1;Contact;1:1]' [Contacts],
		'Y' [SupportsAllLocations],
		'N' [TrackEnterprisePurchasesReceiptsByStoreLocation],
		'[9083:3;Store;1:1]' [StoreLocations],
		GETDATE()
	FROM TransformVendorSourceToTargetLookup LU
		INNER JOIN TransformVendorMUNISExtractComplete munis ON LU.TargetVendorID = munis.VDR_NUM
	WHERE
		LU.WICMVendorNumber IN (SELECT WICMVendorNumber FROM tmp.VendorsToLoad)
		AND LU.VendorTypeID = 'Munis'

	-- Populate tmp.Vendor :: CC Vendor Types
	INSERT INTO tmp.Vendor
	SELECT DISTINCT
		'[i]' [Control],
		LU.TargetVendorID [VendorID],
		LEFT(LTRIM(RTRIM(src.VNAME)), 35) [VendorName],
		LEFT(LTRIM(RTRIM(src.CONTACTNAME)), 35) [ContactName],
		LEFT(LTRIM(RTRIM(src.ADDRESS1)), 30) [Address1],
		LEFT(LTRIM(RTRIM(src.ADDRESS2)), 30) [Address2],
		LEFT(LTRIM(RTRIM(src.CITY)), 30) [Address3],
		LEFT(LTRIM(RTRIM(src.STATE)) + '-' + LTRIM(RTRIM(src.ZIP9)), 30) [Address4],
		LEFT(LTRIM(RTRIM(src.VNPHONE)), 30) [Phone],
		LEFT(LTRIM(RTRIM(src.FAXNUMBER)), 30)  [Fax],
		LEFT(LTRIM(RTRIM(src.INTERNETEMAIL)), 200) [EmailAddress],
		NULL [SalesTaxRate],
		LTRIM(RTRIM(src.TID1)) + LTRIM(RTRIM(src.TID2)) + LTRIM(RTRIM(src.TID3)) [FederalTaxID],
		'Y' [Active],
		CASE
			WHEN src.MINORITYSTATUS IN ('A', 'B', 'C', 'D', 'E', 'F', 'M') THEN 'Y'
			ELSE 'N'
		END [MinorityOwned],
		CASE
			WHEN src.MINORITYSTATUS = 'W' THEN 'Y'
			ELSE 'N'
		END [WomenOwned],
		CASE
			WHEN src.MINORITYSTATUS = 'S' THEN 'Y'
			ELSE 'N'
		END [SmallBusiness],
		LU.VendorTypeID [VendorTypeID],
		CASE
			WHEN (src.[VNTAXSTATUS] = 'I') THEN 'Incorporated'
			WHEN (src.[VNTAXSTATUS] = 'M') THEN 'Medical'
			WHEN (src.[VNTAXSTATUS] = 'N') THEN 'Non-Profit'
			WHEN (src.[VNTAXSTATUS] = 'P') THEN 'Partnership'
			WHEN (src.[VNTAXSTATUS] = 'S') THEN 'Sole Proprietor'
			ELSE ''
		END [VendorStatusID],
		'Y' [VendorProvidesEquipment],
		'Y' [EquipmentAndComponentWarranties],
		'Y' [EquipmentRepairAndPM],
		'Y' [Parts],
		'Y' [PartsWarranties],
		'Y' [PartsRepairAndRebuild],
		'Y' [Fuel],
		'Y' [Testing],
		'USD' [CurrencyID],
		NULL [MinimumOrderValInVendorCurrency],
		'[9066:1;Contact;1:1]' [Contacts],
		'Y' [SupportsAllLocations],
		'N' [TrackEnterprisePurchasesReceiptsByStoreLocation],
		'[9083:3;Store;1:1]' [StoreLocations],
		GETDATE()
	FROM TransformVendorSourceToTargetLookup LU
		INNER JOIN tmp.VendorsToLoad vtl ON LU.WICMVendorNumber = vtl.WICMVendorNumber
		INNER JOIN SourceWicm310Vendor src ON LU.WICMVendorNumber = src.VNUMBER
	WHERE
		LU.VendorTypeID = 'CC'

	-- Populate tmp.VendorContact :: MUNIS Vendor Types
	INSERT INTO tmp.VendorContact
	SELECT DISTINCT
		'[i]' [Control],
		LU.TargetVendorID [VendorID],
		'' [ContactTypeID],
		'STOREROOM' [LocationID],
		LEFT(LTRIM(RTRIM(munis.CONTACT1_NAME)), 35) [ContactName],
		'' [Phone],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.FAX)), 30)
			ELSE ''
		END [Fax],
		'' [Mobile],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.ADDR1)), 30)
			ELSE ''
		END [Address1],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.ADDR2)), 30)
			ELSE ''
		END [Address2],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.CITY)), 30)
			ELSE ''
		END [Address3],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.ST)) + ' ' + LTRIM(RTRIM(munis.ZIP)), 30)
			ELSE ''
		END [Address4],
		CASE
			WHEN munis.REMIT = 'N' THEN LEFT(LTRIM(RTRIM(munis.EMAIL)), 200)
			ELSE ''
		END [EmailAddress],
		'' [Comments],
		GETDATE()
	FROM TransformVendorSourceToTargetLookup LU
		INNER JOIN TransformVendorMUNISExtractComplete munis ON LU.TargetVendorID = munis.VDR_NUM
	WHERE
		LU.WICMVendorNumber IN (SELECT WICMVendorNumber FROM tmp.VendorsToLoad)
		AND LU.VendorTypeID = 'Munis'

	-- Populate tmp.VendorContact :: CC Vendor Types
	INSERT INTO tmp.VendorContact
	SELECT DISTINCT
		'[i]' [Control],
		LU.TargetVendorID [VendorID],
		'' [ContactTypeID],
		'STOREROOM' [LocationID],
		LEFT(LTRIM(RTRIM(src.CONTACTNAME)), 35) [ContactName],
		LEFT(LTRIM(RTRIM(src.VNPHONE)), 30) [Phone],
		LEFT(LTRIM(RTRIM(src.FAXNUMBER)), 30)  [Fax],
		'' [Mobile],
		LEFT(LTRIM(RTRIM(src.ADDRESS1)), 30) [Address1],
		LEFT(LTRIM(RTRIM(src.ADDRESS2)), 30) [Address2],
		LEFT(LTRIM(RTRIM(src.CITY)), 30) [Address3],
		LEFT(LTRIM(RTRIM(src.STATE)) + '-' + LTRIM(RTRIM(src.ZIP9)), 30) [Address4],
		LEFT(LTRIM(RTRIM(src.INTERNETEMAIL)), 200) [EmailAddress],
		'' [Comments],
		GETDATE()
	FROM TransformVendorSourceToTargetLookup LU
		INNER JOIN tmp.VendorsToLoad vtl ON LU.WICMVendorNumber = vtl.WICMVendorNumber
		INNER JOIN SourceWicm310Vendor src ON LU.WICMVendorNumber = src.VNUMBER
	WHERE
		LU.VendorTypeID = 'CC'

	-- Populate tmp.VendorStore
	INSERT INTO tmp.VendorStore
	SELECT DISTINCT
		'[i]' [Control],
		LU.TargetVendorID [VendorID],
		VC.StoreID,
		LEFT(LTRIM(RTRIM(src.CONTACTNAME)), 35) [ContactName],
		LEFT(LTRIM(RTRIM(src.VNPHONE)), 30) [Phone],
		LEFT(LTRIM(RTRIM(src.FAXNUMBER)), 30)  [Fax],
		'' [Mobile],
		LEFT(LTRIM(RTRIM(src.ADDRESS1)), 30) [AddressLine1],
		LEFT(LTRIM(RTRIM(src.ADDRESS2)), 30) [AddressLine2],
		LEFT(LTRIM(RTRIM(src.CITY)), 30) [AddressLine3],
		LEFT(LTRIM(RTRIM(src.STATE)) + '-' + LTRIM(RTRIM(src.ZIP9)), 30) [AddressLine4],
		GETDATE()
	FROM tmp.VendorContact VC
		INNER JOIN TransformVendorSourceToTargetLookup lu ON VC.VendorID = lu.TargetVendorID
		INNER JOIN SourceWicm310Vendor src ON lu.WICMVendorNumber = src.VNUMBER

	-- Copy tmp.Vendor to TransformVendor
	INSERT INTO TransformVendor
	SELECT V.*
	FROM tmp.Vendor V
	
	-- Copy tmp.VendorContact to TransformVendorContact
	INSERT INTO TransformVendorContact
	SELECT VC.*
	FROM tmp.VendorContact VC
	
	-- Copy tmp.VendorStore to TransformVendorStore
	INSERT INTO TransformVendorStore
	SELECT VS.*
	FROM tmp.VendorStore VS
END
