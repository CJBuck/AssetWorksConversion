-- ===============================================================================
-- Created By:	Chris Buck
-- Create Date:	01/30/2015
-- Description: Creates/modifies the spTransformEquipmentHydrant stored procedure.
-- ===============================================================================

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spTransformEquipmentHydrant') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformEquipmentHydrant AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformEquipmentHydrant
AS
--
BEGIN
	INSERT INTO TransformEquipment
	SELECT
		'HYD' + RIGHT('0000000' + RTRIM(LTRIM(H.HYD_NO)), 7) [EquipmentID],
		'Stationary' [AssetType],
		LEFT(LTRIM(RTRIM(H.STREET_NAME)) + ' (' + 
			LTRIM(RTRIM(H.XSTREET_NAME)) + ')', 40) [Description],	-- Truncated
		'HYDRANT' [AssetNumber],	-- Open issue: populate with something else?
		'' [SerialNumber],
		vet.EquipmentType [EquipmentType],
		'CLASS' [PMProgramType],
		'' [AssetPhotoFilePath],
		'' [AssetPhotoFileDescription],
		1901 [ModelYear],
		ISNULL(manid.TargetValue, 'Unknown') [ManufacturerID],
		ISNULL(manid.TargetValue, 'Unknown') [ModelID],
		'NO METER' [MeterTypesClass],
		'' [Meter1Type],
		'' [Meter2Type],
		NULL [Meter1AtDelivery],
		NULL [Meter2AtDelivery],
		NULL [LatestMeter1Reading],
		NULL [LatestMeter2Reading],
		NULL [MaxMeter1Value],
		NULL [MaxMeter2Value],
		'DHY HYDRANT' [Maintenance],
		CASE
			WHEN H.[HYD_NO] IN ('02516', '02517', '02518', '02590', '02591', '02592', '02814', 
				'02815', '02816', '02817', '02818', '02819', '07420', '09489', '09490',
				'09491') THEN 'DPM HYDRANT SOURCE WATER'
			WHEN H.[HYD_NO] IN ('03130', '09013', '09014') THEN 'DPM HYDRANT WW'
			ELSE 'DPM HYDRANT CONTRACTOR'
		END [PMProgram],
		'DHY HYDRANT' [Standards],
		'NOT APPLICABLE' [RentalRates],
		'DHY HYDRANT' [Resources],
		'HYDRANT' AssetCategoryID,
		'VLV GROUP' AssignedPM,
		'VLV GROUP' AssignedRepair,
		'' [StoredLocation],
		CASE LTRIM(RTRIM(H.[JURIS]))
			WHEN 'H' THEN 'JURIS HP'
			WHEN 'J' THEN 'JURIS JC'
			WHEN 'K' THEN 'JURIS NK'
			WHEN 'N' THEN 'JURIS NN'
			WHEN 'P' THEN 'JURIS PQ'
			WHEN 'W' THEN 'JURIS WB'
			WHEN 'Y' THEN 'JURIS YC'
		END [StationLocation],
		LTRIM(RTRIM(H.[JURIS])) [Jurisdiction],
		'M-F' [PreferredPMShift],
		'' [VehicleLocation],
		'' [BuildingLocation],
		'' [OtherLocation],
		'413505' [DepartmentID],
		'413505' [DeptToNotifyForPM],
		'' [CompanyID],					-- Open Issue
		'' [AccountIDAssignmentWO],		-- Open Issue
		'' [AccountIDLaborPosting],		-- Open Issue
		'' [AccountIDPartIssues],		-- Open Issue
		'' [AccountIDCommercialWork],	-- Open Issue
		'' [AccountIDFuelTickets],		-- Open Issue
		'' [AccountIDUsageTickets],		-- Open Issue
		'' [EquipmentStatus],
		'A' [LifeCycleStatusCodeID],
		'' [ConditionRating],
		'' [StatusCodes],
		'Y' [WorkOrders],
		'N' [UsageTickets],
		'N' [FuelTickets],
		LTRIM(RTRIM(H.[HYD_REMARK])) + ' ' + LTRIM(RTRIM(H.[REMARKS2])) [Comments],
		'D4' [DefaultWOPriorityID],
		NULL [ActualDeliveryDate],
		CASE
			WHEN ISDATE(H.[INSTALL_DATE]) = 1 AND H.[INSTALL_DATE] <> '00000000'
				THEN CAST(H.[INSTALL_DATE] AS DATETIME)
			ELSE NULL
		END AS [ActualInServiceDate],
		NULL [OriginalCost],
		'' [DepreciationMethod],	-- Open Issue
		NULL [LifeMonths],			-- Open Issue
		NULL [MonthsRemaining],
		'OWNED' [Ownership],
		'' [VendorID],				-- Open Issue
		NULL [ExpirationDate],
		NULL [Meter1Expiration],	-- Open Issue
		NULL [Meter2Expiration],	-- Open Issue
		NULL [Deductible],			-- Open Issue
		'' [WarrantyType],			-- Open Issue
		'' [Comments2],
		NULL [EstimatedReplacementMonth],
		CASE
			WHEN ISDATE(H.INSTALL_DATE) = 1
				THEN RIGHT('0000' + CONVERT(NVARCHAR(4), DATEPART(YEAR, CAST(H.INSTALL_DATE AS DATETIME))), 4)
			ELSE NULL
		END [EstimatedReplacementYear],
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
	FROM SourcePups201Hydrant H
		INNER JOIN TransformEquipmentHydrantValueEquipmentType vet
			ON LTRIM(RTRIM(H.[HYD_MAKE])) = LTRIM(RTRIM(vet.[HYD_MAKE]))
		LEFT JOIN TransformEquipmentManufacturer manid
			ON LTRIM(RTRIM(H.HYD_MAKE)) = manid.SourceValue
				AND manid.[Source] = 'Hydrants'
		LEFT JOIN TransformEquipmentManufacturerModel modid
			ON LTRIM(RTRIM(H.HYD_MAKE)) = modid.SourceModelID
				AND modid.[Source] = 'Hydrants'
	WHERE
		(H.[STATUS] = 'A')
		OR (H.[STATUS] = 'I' AND H.HYD_SEQ# = '00')

	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		'HYD' + RIGHT('0000000' + RTRIM(LTRIM(H.HYD_NO)), 7) [EquipmentID],
		'SourcePups201Hydrant' [Source],
		'HYD_NO' [LegacyIDSource],
		H.[HYD_NO] [LegacyID]
	FROM SourcePups201Hydrant H
		INNER JOIN TransformEquipmentHydrantValueEquipmentType vet
			ON LTRIM(RTRIM(H.[HYD_MAKE])) = LTRIM(RTRIM(vet.[HYD_MAKE]))
		LEFT JOIN TransformEquipmentManufacturer manid
			ON LTRIM(RTRIM(H.HYD_MAKE)) = manid.SourceValue
				AND manid.[Source] = 'Hydrants'
		LEFT JOIN TransformEquipmentManufacturerModel modid
			ON LTRIM(RTRIM(H.HYD_MAKE)) = modid.SourceModelID
				AND modid.[Source] = 'Hydrants'
END
