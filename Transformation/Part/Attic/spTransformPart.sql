-- ===============================================================================
-- Created By:	Chris Buck
-- Create Date:	01/30/2014
-- Description: Creates/modifies the spTransformPart stored procedure.
-- ===============================================================================

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spTransformPart') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformPart AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformPart
AS
BEGIN
	INSERT INTO TransformPart
	SELECT
		LTRIM(RTRIM(PH.PART_NO)) [PartID],
		0 [PartSuffix],
		LTRIM(RTRIM(xls.Keyword)) [Keyword],
		LTRIM(RTRIM(xls.[New Description])) [PartShortDescription],
		LTRIM(RTRIM(xls.Cat)) [ProductCategoryID],
		'' [PartClassificationID],				-- Open issue: coming from General Services
		CASE
			WHEN PH.PART_CAT = '9560' THEN 'Y'
			ELSE 'N'
		END [Tire],
		'' [Core],		-- Open issue: coming from General Services
		'N' [ControlledSubstance],
		'N' [ItemFabricatedWithoutCore],
		'' [PathAndFileName],		-- Open issue
		'' [FileDescription],		-- Open issue
		LTRIM(RTRIM(xls.[Current Discription])) [PartLongDescription],
		'6000-0000-145300-000000-00000' [PurchasingDefaultAccountID],
		LTRIM(RTRIM(pn.PART_NOTE1)) + ' ' + LTRIM(RTRIM(pn.PART_NOTE2)) + ' ' + 
			LTRIM(RTRIM(pn.PART_NOTE3)) + ' ' + LTRIM(RTRIM(pn.PART_NOTE4)) + ' ' + 
			LTRIM(RTRIM(pn.PART_NOTE5)) + ' ' + LTRIM(RTRIM(pn.PART_NOTE6)) [Comments2],
		000.0 [MarkupPercentage],
		'Y' [NoMarkupOnPart],
		000.0 [MarkupCapAmount],
		LTRIM(RTRIM(pd.LOCATION)) [InventoryLocationID],
		xls.[U/I] [UnitOfMeasure],
		'[335:35;Bin;1:1]' [BinID],
		'' [Description],					-- Open issue
		CASE (ISNULL(LTRIM(RTRIM(xls.[Bin 1])), ''))
			WHEN '' THEN ''
			ELSE 'Y'
		END [PrimaryBin],
		'' [Comments43],			-- Open issue
		'APRIL' [InventoryMonth],
		'' [StockStatus],	-- Open issue
		ISNULL(LEFT(LTRIM(RTRIM(tpm.TargetValue)), 15), '') [Manufacturer],
		ISNULL(LEFT(LTRIM(RTRIM(xls.[New Mfg #])), 15), '') [ManufacturerPartNumber],
		'' [PreferredVendorID],		-- Open issue
		'Min-Max' [ReplenishmentMethod],
		ISNULL(pd.LOW_LIM, NULL) [MinimumAvailableQuantity],
		ISNULL(pd.HIGH_LIM, NULL) [MaximumAvailableQuantity],
		'REQUISITION' [DefaultReplenishmentGenerationType],
		'STOREROOM' [SuppliedByLocationIfTransferRequest],	-- Open issue
		'' [Comments1]
	FROM SourceWicm220PartsHeader PH
		LEFT JOIN SourceWicm222PartNotepad pn ON PH.PART_NO = pn.PART_NO
		LEFT JOIN SourceWicm221PartsDetail pd ON PH.PART_NO = pd.PART_NO
		INNER JOIN ShawnsXLS xls ON LTRIM(RTRIM(PH.PART_NO)) = LTRIM(RTRIM(xls.[Part #]))
		INNER JOIN TargetPartManufacturer tpm ON xls.[New Mfg] = tpm.SourceValue
	WHERE
		PH.[STATUS] = 'A'
END
