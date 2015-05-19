-- =============================================================================
-- Created By:	Chris Buck
-- Create Date:	01/30/2015
-- Description: Creates/modifies the spTransformEquipmentDistributionValve
--              stored procedure.
-- =============================================================================

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spTransformEquipmentDistributionValve') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformEquipmentDistributionValve AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformEquipmentDistributionValve
AS
BEGIN
	INSERT INTO TransformEquipment
	SELECT
		'VLV' + RIGHT('0000000' + LTRIM(RTRIM(VALVE_NO)), 7) [EquipmentID],
		'STATIONARY' [AssetType],
		LEFT((LTRIM(RTRIM(STREET_NAME)) + ' (' + 
			LTRIM(RTRIM(XSTREET_NAME)) + '-' + 
			LTRIM(RTRIM(TO_STREET)) + ')'), 40) [Description],
		'' [AssetNumber],	-- Open Issue: populate from "Source Water Isolation Valve 
							-- Spreadsheet" - Chris Basford.
		'' [SerialNumber],
		ISNULL(lkup.EquipmentType, '') [EquipmentType],
		'CLASS' [PMProgramType],
		'' [AssetPhotoFilePath],
		'' [AssetPhotoFileDescription],
		CASE
			WHEN ISDATE(SET_DATE) = 1 THEN YEAR(CAST(SET_DATE AS DATETIME))
			ELSE NULL
		END AS [ModelYear],
		ISNULL(manid.TargetValue, '') [ManufacturerID],
		'GENERIC VALVE' [ModelID],
		'NO METER' [MeterTypesClass],
		'' [Meter1Type],
		'' [Meter2Type],
		NULL [Meter1AtDelivery],
		NULL [Meter2AtDelivery],
		NULL [LatestMeter1Reading],
		NULL [LatestMeter2Reading],
		NULL [MaxMeter1Value],
		NULL [MaxMeter2Value],
		CASE (ISNULL(aci.AssetCategoryID, ''))
			WHEN 'VALVE AIR' THEN 'DVL AIR RELEASE'
			WHEN 'VALVE BLF' THEN 'DVL BLOWOFF'
			WHEN 'VALVE ISO' THEN 'DVL ISOLATION'
			WHEN 'VALVE REQ' THEN 'DVL REGULATING'
		END [Maintenance],
		CASE
			WHEN SPV.VALVE_NO <> '017850' AND SPV.VLV_FUNCTION = '01'
				AND SPV.VLV_SYSTEM = 'T' AND SPV.MAP_PAGE = 'TRN' THEN 'DPM VALVE TRANSMISSION'
			WHEN SPV.VALVE_NO <> '017850' AND SPV.VLV_FUNCTION = '05'
				AND SPV.VLV_SYSTEM = 'T' THEN 'DPM VALVE AIR RELEASE'
			WHEN SPV.VALVE_NO <> '017850' AND SPV.VLV_FUNCTION = '01'
				AND SPV.VLV_SYSTEM = 'R' THEN 'DPM VALVE SOURCE WTR TRN'
			WHEN SPV.VALVE_NO <> '017850' AND SPV.VLV_FUNCTION = '05'
				AND SPV.VLV_SYSTEM = 'R' THEN 'DPM VALVE SOURCE WTR AIR REL'
			WHEN SPV.VALVE_NO = '017850' THEN 'DPM VALVE REGULATING'
			ELSE 'NOT APPLICABLE'
		END [PMProgram],
		CASE (ISNULL(aci.AssetCategoryID, ''))
			WHEN 'VALVE AIR' THEN 'DVL AIR RELEASE'
			WHEN 'VALVE BLF' THEN 'DVL BLOWOFF'
			WHEN 'VALVE ISO' THEN 'DVL ISOLATION'
			WHEN 'VALVE REQ' THEN 'DVL REGULATING'
		END [Standards],
		'NOT APPLICABLE' [RentalRates],
		CASE (ISNULL(aci.AssetCategoryID, ''))
			WHEN 'VALVE AIR' THEN 'DVL AIR RELEASE'
			WHEN 'VALVE BLF' THEN 'DVL BLOWOFF'
			WHEN 'VALVE ISO' THEN 'DVL ISOLATION'
			WHEN 'VALVE REQ' THEN 'DVL REGULATING'
		END [Resources],
		ISNULL(aci.AssetCategoryID, '') [AssetCategoryID],
		'VLV GROUP' AssignedPM,
		'VLV GROUP' AssignedRepair,
		'' [StoredLocation],
		LEFT((LTRIM(RTRIM(LOC_FEET)) + ' ' + 
			LTRIM(RTRIM(LOC_DIR)) + ' ' + 
			LTRIM(RTRIM(LOC_FROM))), 10) [StationLocation],	-- Verify requirement.
		'' [Jurisdiction],
		'M-F' [PreferredPMShift],	-- Open issue:  default value from AssetWorks?
		'' [VehicleLocation],
		'' [BuildingLocation],
		'' [OtherLocation],
		'413505' [DepartmentID],
		'413505' [DeptToNotifyForPM],
		'' [CompanyID],					-- Open issue
		'' [AccountIDAssignmentWO],		-- Open issue
		'' [AccountIDLaborPosting],		-- Open issue
		'' [AccountIDPartIssues],		-- Open issue
		'' [AccountIDCommercialWork],	-- Open issue
		'' [AccountIDFuelTickets],		-- Open issue
		'' [AccountIDUsageTickets],		-- Open issue
		'' [EquipmentStatus],
		CASE
			WHEN SPV.[STATUS] = 'A' THEN 'A'
			WHEN SPV.[STATUS] = 'I' THEN 'PI'
			ELSE ''
		END [LifeCycleStatusCodeID],
		'' [ConditionRating],		-- Open issue
		'' [StatusCodes],			-- Open issue
		'Y' [WorkOrders],
		'N' [UsageTickets],
		'N' [FuelTickets],
		LTRIM(RTRIM(REMARK1)) + ' ' + LTRIM(RTRIM(REMARK2)) [Comments],
		'D4' [DefaultWOPriorityID],
		NULL [ActualDeliveryDate],	-- Open issue
		CASE
			WHEN ISDATE(SET_DATE) = 1 THEN CAST(SET_DATE AS DATETIME)
			ELSE NULL
		END AS [ActualInServiceDate],	-- Open issue:  some data not of DateTime datatype.
		NULL [OriginalCost],		-- Open issue
		'' [DepreciationMethod],	-- Open issue
		1200 [LifeMonths],
		NULL [MonthsRemaining],
		'OWNED' [Ownership],
		'' [VendorID],				-- Open issue
		NULL [ExpirationDate],
		NULL [Meter1Expiration],	-- Open issue
		NULL [Meter2Expiration],	-- Open issue
		NULL [Deductible],			-- Open issue
		'' [WarrantyType],			-- Open issue
		'' [Comments2],
		NULL [EstimatedReplacementMonth],
		NULL [EstimatedReplacementYear],
		NULL [EstimatedReplacementCost],
		'' [Latitude],
		'' [Longitude],
		'' [NextPMServiceNumber],
		NULL [NextPMDueDate],
		'' [IndividualPMService],
		'' [IndividualPMDateNextDue],
		NULL [IndividualPMNumberOfTimeUnits],
		'' [IndividualPMTimeUnit],
		NULL [PlannedRetirementDate],
		NULL [RetirementDate],
		NULL [DispositionDate],
		NULL [GrossSalePrice],
		'' [DisposalReason],
		'' [DisposalMethod],
		'' [DisposalAuthority],
		'' [DisposalComments]
	FROM SourcePups201Valve SPV
		INNER JOIN TransformEquipmentDistributionValveValueEquipmentType lkup
			ON SPV.VLV_FUNCTION = lkup.VLV_FUNCTION AND SPV.VLV_TYPE = lkup.VLV_TYPE
		INNER JOIN TransformEquipmentDistributionValveValueAssetCategoryID aci
			ON SPV.VLV_FUNCTION = aci.VLV_FUNCTION
		-- ManufacturerID Cleansing
		INNER JOIN TransformEquipmentManufacturer manid
			ON LEFT(LTRIM(RTRIM(SPV.VLV_MAKE)), 15) = LEFT(LTRIM(RTRIM(manid.[SourceValue])), 15)
				AND manid.[Source] LIKE '%Valves%'
	WHERE
		(SPV.[STATUS] = 'A')
		--OR (SPV.[STATUS] = 'I'
		--		AND SPV.VALVE_SEQ# = '00'
		--		AND SPV.REMARK2 LIKE 'Proposed%')

	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		'VLV' + RIGHT('0000000' + LTRIM(RTRIM(VALVE_NO)), 7) [EquipmentID],
		'SourcePups201Valve' [Source],
		'VALVE_NO' [LegacyIDSource],
		SPV.VALVE_NO [LegacyID]
	FROM SourcePups201Valve SPV
		INNER JOIN TransformEquipmentDistributionValveValueEquipmentType lkup
			ON SPV.VLV_FUNCTION = lkup.VLV_FUNCTION AND SPV.VLV_TYPE = lkup.VLV_TYPE
		INNER JOIN TransformEquipmentDistributionValveValueAssetCategoryID aci
			ON SPV.VLV_FUNCTION = aci.VLV_FUNCTION
		INNER JOIN TransformEquipmentManufacturer manid
			ON LEFT(LTRIM(RTRIM(SPV.VLV_MAKE)), 15) = LEFT(LTRIM(RTRIM(manid.[SourceValue])), 15)
				AND manid.[Source] LIKE '%Valves%'
	WHERE
		(SPV.[STATUS] = 'A')
		OR (SPV.[STATUS] = 'I'
				AND SPV.VALVE_SEQ# = '00'
				AND SPV.REMARK2 LIKE 'Proposed%')
END
GO
