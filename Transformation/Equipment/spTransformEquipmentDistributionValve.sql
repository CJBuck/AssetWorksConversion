-- =============================================================================
-- Created By:	Chris Buck
-- Create Date:	01/30/2015
-- Description: Creates/modifies the spTransformEquipmentDistributionValve
--              stored procedure.
-- Updated:		07/06/2015 Gerald Davis
--				Seperate out bypass valves as distinct entities
-- =============================================================================

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spTransformEquipmentDistributionValve') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformEquipmentDistributionValve AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformEquipmentDistributionValve
AS
BEGIN
	--Prevent duplicates if SP is run multiple times
	DELETE FROM TransformEquipment WHERE EquipmentId LIKE 'VLV%'
	DELETE FROM TransformEquipmentLegacyXwalk WHERE EquipmentId LIKE 'VLV%'

	IF OBJECT_ID('tmp.Valves') IS NOT NULL
		DROP TABLE tmp.Valves

	CREATE TABLE tmp.Valves(
		[Valve_No] [varchar] (6) NOT NULL,
		[Control] [varchar] (10) NOT NULL,
		[EquipmentID] [varchar](20) NOT NULL,
		[AssetType] [varchar](20) NULL,
		[Description] [varchar](40) NULL,
		[AssetNumber] [varchar](20) NULL,
		[SerialNumber] [varchar](50) NULL,
		[EquipmentType] [varchar](30) NULL,
		[PMProgramType] [varchar](10) NULL,
		[AssetPhotoFilePath] [varchar](255) NULL,
		[AssetPhotoFileDescription] [varchar](60) NULL,
		[ModelYear] [int] NULL,
		[ManufacturerID] [varchar](15) NULL,
		[ModelID] [varchar](15) NULL,
		[MeterTypesClass] [varchar](30) NULL,
		[Meter1Type] [varchar](10) NULL,
		[Meter2Type] [varchar](10) NULL,
		[Meter1AtDelivery] [int] NULL,
		[Meter2AtDelivery] [int] NULL,
		[LatestMeter1Reading] [int] NULL,
		[LatestMeter2Reading] [int] NULL,
		[MaxMeter1Value] [int] NULL,
		[MaxMeter2Value] [int] NULL,
		[Maintenance] [varchar](30) NULL,
		[PMProgram] [varchar](30) NULL,
		[Standards] [varchar](30) NULL,
		[RentalRates] [varchar](30) NULL,
		[Resources] [varchar](30) NULL,
		[AssetCategoryID] [varchar](15) NULL,
		[AssignedPM] [varchar](10) NULL,
		[AssignedRepair] [varchar](10) NULL,
		[StoredLocation] [varchar](10) NULL,
		[StationLocation] [varchar](10) NULL,
		[Jurisdiction] [varchar](2) NULL,
		[PreferredPMShift] [varchar](10) NULL,
		[VehicleLocation] [varchar](20) NULL,
		[BuildingLocation] [varchar](20) NULL,
		[OtherLocation] [varchar](20) NULL,
		[DepartmentID] [varchar](10) NULL,
		[DeptToNotifyForPM] [varchar](10) NULL,
		[CompanyID] [varchar](10) NULL,
		[AccountIDAssignmentWO] [varchar](10) NULL,
		[AccountIDLaborPosting] [varchar](10) NULL,
		[AccountIDPartIssues] [varchar](10) NULL,
		[AccountIDCommercialWork] [varchar](10) NULL,
		[AccountIDFuelTickets] [varchar](10) NULL,
		[AccountIDUsageTickets] [varchar](10) NULL,
		[EquipmentStatus] [varchar](10) NULL,
		[LifeCycleStatusCodeID] [varchar](2) NULL,
		[ConditionRating] [varchar](20) NULL,
		[StatusCodes] [varchar](6) NULL,
		[WorkOrders] [char](1) NULL,
		[UsageTickets] [char](1) NULL,
		[FuelTickets] [char](1) NULL,
		[Comments] [varchar](1200) NULL,
		[DefaultWOPriorityID] [varchar](2) NULL,
		[ActualDeliveryDate] [datetime] NULL,
		[ActualInServiceDate] [datetime] NULL,
		[OriginalCost] [decimal](22, 2) NULL,
		[DepreciationMethod] [varchar](25) NULL,
		[LifeMonths] [int] NULL,
		[MonthsRemaining] [decimal](22, 2) NULL,
		[Ownership] [varchar](8) NULL,
		[VendorID] [varchar](15) NULL,
		[ExpirationDate] [datetime] NULL,
		[Meter1Expiration] [int] NULL,
		[Meter2Expiration] [int] NULL,
		[Deductible] [decimal](22, 2) NULL,
		[WarrantyType] [varchar](60) NULL,
		[Comments2] [varchar](60) NULL,
		[EstimatedReplacementMonth] [int] NULL,
		[EstimatedReplacementYear] [int] NULL,
		[EstimatedReplacementCost] [decimal](22, 2) NULL,
		[Latitude] [varchar](10) NULL,
		[Longitude] [varchar](10) NULL,
		[NextPMServiceNumber] [int] NULL,
		[NextPMDueDate] [datetime] NULL,
		[IndividualPMService] [varchar](12) NULL,
		[IndividualPMDateNextDue] [datetime] NULL,
		[IndividualPMNumberofTimeUnits] [int] NULL,
		[IndividualPMTimeUnit] [varchar](10) NULL,
		[PlannedRetirementDate] [datetime] NULL,
		[RetirementDate] [datetime] NULL,
		[DispositionDate] [datetime] NULL,
		[GrossSalePrice] [decimal](22, 2) NULL,
		[DisposalReason] [varchar](30) NULL,
		[DisposalMethod] [varchar](20) NULL,
		[DisposalAuthority] [varchar](6) NULL,
		[DisposalComments] [varchar](60) NULL
	)

	INSERT INTO tmp.Valves
	SELECT
		LTRIM(RTRIM(SPV.[VALVE_NO])) [Valve_No],
		'[i]' [Control],
		'VLV' + RIGHT('0000000' + LTRIM(RTRIM(SPV.VALVE_NO)), 7) [EquipmentID],
		'STATIONARY' [AssetType],
		LEFT(LTRIM(RTRIM(STREET_NAME)) + ' (' + 
			LTRIM(RTRIM(XSTREET_NAME)) + '-' + 
			LTRIM(RTRIM(TO_STREET)), 39) + ')' [Description],
		'' [AssetNumber],	-- Open Issue: populate from "Source Water Isolation Valve
							-- Spreadsheet" - Chris Basford.
		'VLV' + RIGHT('0000000' + LTRIM(RTRIM(SPV.VALVE_NO)), 7) [SerialNumber],
		'' [EquipmentType],
		'BOTH' [PMProgramType],
		'' [AssetPhotoFilePath],
		'' [AssetPhotoFileDescription],
		CASE
			WHEN ISDATE(SPV.SET_DATE) = 1 THEN YEAR(CAST(SPV.SET_DATE AS DATETIME))
			ELSE NULL
		END AS [ModelYear],
		'' [ManufacturerID],
		'GENERIC VALVE' [ModelID],
		'DMT' [MeterTypesClass],
		'' [Meter1Type],
		'' [Meter2Type],
		NULL [Meter1AtDelivery],
		NULL [Meter2AtDelivery],
		NULL [LatestMeter1Reading],
		NULL [LatestMeter2Reading],
		NULL [MaxMeter1Value],
		NULL [MaxMeter2Value],
		'' [Maintenance],
		CASE
			WHEN SPV.VALVE_NO <> '017850' AND SPV.VLV_FUNCTION = '01'
				AND SPV.VLV_SYSTEM = 'T' AND SPV.MAP_PAGE = 'TRN' THEN 'DPM VALVE TRANSMISSION'
			WHEN SPV.VALVE_NO <> '017850' AND SPV.VLV_FUNCTION = '05'
				AND SPV.VLV_SYSTEM = 'T' THEN 'DPM AIR REL DIST'
			WHEN SPV.VALVE_NO <> '017850' AND SPV.VLV_FUNCTION = '01'
				AND SPV.VLV_SYSTEM = 'R' THEN 'DPM VALVE SOURCE WTR'
			WHEN SPV.VALVE_NO <> '017850' AND SPV.VLV_FUNCTION = '05'
				AND SPV.VLV_SYSTEM = 'R' THEN 'DPM AIR REL SOURCE WTR'
			WHEN SPV.VALVE_NO = '017850' THEN 'DPM VALVE REGULATING'
			ELSE 'DNA'
		END [PMProgram],
		'' [Standards],
		'DNA' [RentalRates],
		'' [Resources],
		'VALVE' AssetCategoryID,
		'D-HYD VAL' AssignedPM,
		'D-REPAIR' AssignedRepair,
		'' [StoredLocation],
		CASE LTRIM(RTRIM(SPV.JURIS))
			WHEN 'H' THEN 'JURIS HP'
			WHEN 'J' THEN 'JURIS JC'
			WHEN 'K' THEN 'JURIS NK'
			WHEN 'N' THEN 'JURIS NN'
			WHEN 'P' THEN 'JURIS PQ'
			WHEN 'W' THEN 'JURIS WB'
			WHEN 'Y' THEN 'JURIS YC'
			ELSE ''
		END [StationLocation],
		'' [Jurisdiction],
		'DAY' [PreferredPMShift],
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
		'IN SERVICE' [EquipmentStatus],
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
	WHERE
		(SPV.[STATUS] = 'A')
		OR ((SPV.[STATUS] = 'I') AND
			(SPV.[REMARK2] LIKE '%proposed%') OR (SPV.[REMARK2] LIKE '%not yet installed%'))
		OR (
			(SPV.BYPASS_CD = 'Y')
			AND (
				(SPV.[STATUS] = 'A')
				OR ((SPV.[STATUS] = 'I') AND 
					(SPV.[REMARK2] LIKE '%proposed%') OR (SPV.[REMARK2] LIKE '%not yet installed%'))
				)
			)

	-- EquipmentType
	UPDATE tmp.Valves
	SET
		EquipmentType =
			CASE
				WHEN SPV.VALVE_NO IN ('028539', '028540') THEN 'DVL REG SURGE'
				WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'BALL' AND VLV_SIZE < 16 THEN 'DVL ISO BALL SMALL DIA'
				WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'BUTTERFLY' AND VLV_SIZE >= 16 THEN 'DVL ISO BUTTERFLY LARGE DIA'
				WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'BUTTERFLY' AND VLV_SIZE < 16 THEN 'DVL ISO BUTTERFLY SMALL DIA'
				WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'GATE' AND VLV_SIZE >= 16 THEN 'DVL ISO GATE LARGE DIA'
				WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'UNKNOWN' AND VLV_SIZE >= 16 THEN 'DVL ISO GATE LARGE DIA'
				WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'UNKNOWN' AND VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
				WHEN SPV.VLV_FUNCTION = '01' AND SPV.VLV_TYPE = 'GATE' AND VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
				WHEN SPV.VLV_FUNCTION = '03' AND SPV.VLV_TYPE = 'GATE' AND VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
				WHEN SPV.VLV_FUNCTION = '03' AND SPV.VLV_TYPE = 'UNKNOWN' AND VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
				WHEN SPV.VLV_FUNCTION = '04' AND SPV.VLV_MAKE NOT LIKE 'GIL%' AND VLV_SIZE <= '02' THEN 'DBF CHECK/GATE'
				WHEN SPV.VLV_FUNCTION = '04' AND SPV.VLV_MAKE LIKE 'GIL%' AND VLV_SIZE = '02' THEN 'DBF FLSH HYD'
				WHEN SPV.VLV_FUNCTION = '04' AND VLV_SIZE > '02' THEN 'DBF DRAIN'
				WHEN SPV.VLV_FUNCTION = '05' AND SPV.VLV_TYPE = 'AIR RELEAS' THEN 'DAR AIR RELEASE AUTO'
				WHEN SPV.VLV_FUNCTION = '05' AND SPV.VLV_TYPE IN ('GATE', 'MANUAL', 'UNKNOWN') THEN 'DAR AIR RELEASE MANUAL'
				WHEN SPV.VLV_FUNCTION = '05' AND SPV.VLV_TYPE = 'COMBINATIO' THEN 'DAR COMBINATION'
				WHEN SPV.VLV_FUNCTION = '06' AND SPV.VLV_TYPE IN ('GATE', 'UNKNOWN') AND SPV.VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
				WHEN SPV.VLV_FUNCTION = '06' AND SPV.VLV_SIZE >= 16 THEN 'DVL ISO BUTTERFLY LARGE DIA'
				WHEN SPV.VLV_FUNCTION = '07' AND SPV.VLV_TYPE = 'CHECK' AND SPV.VALVE_NO NOT IN ('028539', '028540') THEN 'DVL REG CHECK'
				WHEN SPV.VLV_FUNCTION = '07' AND SPV.VLV_TYPE = 'PRV' AND SPV.VALVE_NO NOT IN ('028539', '028540') THEN 'DVL REG PRV'
				WHEN SPV.VLV_FUNCTION = '08' AND SPV.VLV_TYPE IN ('BUTTERFLY', 'GATE') AND SPV.VLV_SIZE >= 16 THEN 'DVL ISO BUTTERFLY LARGE DIA'
				WHEN SPV.VLV_FUNCTION = '08' AND SPV.VLV_TYPE = 'BUTTERFLY' AND SPV.VLV_SIZE < 16 THEN 'DVL ISO BUTTERFLY SMALL DIA'
				WHEN SPV.VLV_FUNCTION = '08' AND SPV.VLV_TYPE IN ('BUTTERFLY', 'GATE', 'UNKNOWN') AND SPV.VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
				WHEN SPV.VLV_FUNCTION = '10' AND SPV.VLV_TYPE IN ('GATE', 'UNKNOWN') AND SPV.VLV_SIZE < 16 THEN 'DVL ISO GATE SMALL DIA'
				ELSE 'VALVE'
			END
	FROM tmp.Valves vlvs
		INNER JOIN SourcePups201Valve spv ON vlvs.Valve_No = spv.VALVE_NO

	-- Maintenance, Standards, Resources, and AssetCategoryID
	UPDATE tmp.Valves
	SET
		Maintenance =
			CASE
				WHEN ISNULL(vlvs.EquipmentType, '') LIKE 'DAR%' THEN 'DMAINT AIR RELEASE'
				WHEN ISNULL(vlvs.EquipmentType, '') LIKE 'DBF%' THEN 'DMAINT BLOWOFF'
				ELSE 'DMAINT VALVE'
			END,
		Standards =
			CASE
				WHEN ISNULL(vlvs.EquipmentType, '') LIKE 'DAR%' THEN 'DMAINT AIR RELEASE'
				WHEN ISNULL(vlvs.EquipmentType, '') LIKE 'DBF%' THEN 'DMAINT BLOWOFF'
				ELSE 'DMAINT VALVE'
			END,
		Resources = 
			CASE
				WHEN ISNULL(vlvs.EquipmentType, '') LIKE 'DAR%' THEN 'DMAINT AIR RELEASE'
				WHEN ISNULL(vlvs.EquipmentType, '') LIKE 'DBF%' THEN 'DMAINT BLOWOFF'
				ELSE 'DMAINT VALVE'
			END,
		AssetCategoryID =
			CASE
				WHEN ISNULL(vlvs.EquipmentType, '') LIKE 'DAR%' THEN 'AIR RELEASE'
				WHEN ISNULL(vlvs.EquipmentType, '') LIKE 'DBF%' THEN 'BLOWOFF'
				ELSE 'VALVE'
			END
	FROM tmp.Valves vlvs

	-- ManufacturerID
	UPDATE tmp.Valves
	SET
		ManufacturerID = ISNULL(manid.TargetValue, '')
	FROM tmp.Valves vlvs
		INNER JOIN SourcePups201Valve spv ON vlvs.Valve_No = spv.VALVE_NO
		-- ManufacturerID Cleansing
		INNER JOIN TransformEquipmentManufacturer manid
			ON LEFT(LTRIM(RTRIM(spv.VLV_MAKE)), 15) = LEFT(LTRIM(RTRIM(manid.[SourceValue])), 15)
				AND manid.[Source] LIKE '%Valves%'

	-- 6/2/2015 Temporary while logic is resolved with the business units.
	UPDATE tmp.Valves SET ActualInServiceDate = NULL

    -- Used in Bypass valves to ensure distinct EquipmentId
	DECLARE @MaxValve int = ( SELECT MAX(Valve_No) FROM tmp.Valves)

	-- Add Bypass valves as seperate entity
	INSERT INTO tmp.Valves
	(
		Valve_No
		,Control
		,EquipmentID
		,AssetType
		,Description
		,AssetNumber
		,SerialNumber
		,EquipmentType
		,PMProgramType
		,ModelYear
		,ManufacturerID
		,ModelID
		,MeterTypesClass
		,Maintenance
		,PMProgram
		,Standards
		,RentalRates
		,Resources
		,AssetCategoryID
		,AssignedPM
		,AssignedRepair
		,StationLocation
		,PreferredPMShift
		,DepartmentID
		,DeptToNotifyForPM
		,AccountIDAssignmentWO
		,AccountIDLaborPosting
		,AccountIDPartIssues
		,AccountIDCommercialWork
		,AccountIDFuelTickets
		,AccountIDUsageTickets
		,EquipmentStatus
		,LifeCycleStatusCodeID
		,ConditionRating
		,WorkOrders
		,UsageTickets
		,FuelTickets
		,Comments
		,DefaultWOPriorityID
		,ActualDeliveryDate
		,ActualInServiceDate
		,OriginalCost
		,DepreciationMethod
		,LifeMonths
		,MonthsRemaining
		,Ownership
		,VendorID
		,ExpirationDate
		,Meter1Expiration
		,Meter2Expiration
		,Deductible
		,WarrantyType
	)
	SELECT 
		v.Valve_No AS Valve_No,
		'[i]' AS Control,
		'VLV' + RIGHT('0000000' + LTRIM(RTRIM(@MaxValve + ROW_NUMBER() OVER(ORDER BY v.Valve_No))), 7) AS EquipmentId,
		'STATIONARY' AS AssetType,
		--LEFT(v.Description, 36) + ') BP' AS Description, --TRUNCATED TO FIT FOR NOW.  Description is varchar(40)
		LEFT(LTRIM(RTRIM(s.STREET_NAME)) + ' (' + 
			LTRIM(RTRIM(s.XSTREET_NAME)) + '-' + 
			LTRIM(RTRIM(s.TO_STREET)), 36) + + ') BP' [Description],
		'BYPASS TO:' + v.EquipmentId AS AssetNumber, --SPACE REMOVED TO reduce length to fit.  AssetNumber is varchar(20)
		'VLV' + RIGHT('0000000' + LTRIM(RTRIM(@MaxValve + ROW_NUMBER() OVER(ORDER BY v.Valve_No))), 7) AS SerialNumber,
		'DVL ISO GATE SMALL DIA' AS EquipmentType,
		'BOTH' AS PMProgramType,
		v.ModelYear AS ModelYear,
		'UNKNOWN' AS ManufacturerID,
		'GENERIC VALVE' AS ModelID,
		'NO METER' AS MeterTypesClass,
		v.Maintenance AS Maintenance,
		v.PMProgram AS PMProgram,
		v.Standards AS Standards,
		'DNA' AS RentalRate,
		v.Resources AS Resources,
		'VALVE' AS AssetCategoryId,
		'D-HYD VAL' AS AssignedPM,
		'D-REPAIR' AS AssignedRepair,
		v.StationLocation AS StationLocation,
		'DAY' AS PreferredPMShift,
		'413505' AS DepartmentID,
		'413505' AS DeptToNotifyForPM,
		NULL AS AccountIDAssignmentWO, -- Open issue
		NULL AS AccountIDLaborPosting, -- Open issue
		NULL AS AccountIDPartIssues, -- Open issue
		NULL AS AccountIDCommercialWork, -- Open issue
		NULL AS AccountIDFuelTickets, -- Open issue
		NULL AS AccountIDUsageTickets, -- Open issue
		'IN SERVICE' AS EquipmentStatus,
		'A' AS LifeCycleStatusCodeID,
		NULL AS ConditionRating, -- Open issue
		'Y' AS WorkOrders,
		'N' AS UsageTickets,
		'N' AS FuelTickets,
		'' AS Comments, --Unknown source per spec
		'D4' AS DefaultWOPriorityID,
		NULL AS ActualDeliveryDate, -- Open issue
		NULL AS ActualInServiceDate, -- Open issue
		NULL AS OriginalCost, -- Open issue
		NULL AS DepreciationMethod, -- Open issue
		'1200' AS LifeMonths,
		NULL AS MonthsRemaining,
		'OWNED' AS Ownership,
		NULL AS VendorID, -- Open issue
		NULL AS ExpirationDate, -- Open issue
		NULL AS Meter1Expiration, -- Open issue
		NULL AS Meter2Expiration, -- Open issue
		NULL AS Deductible, -- Open issue
		NULL AS WarrantyType -- Open issue
	FROM dbo.SourcePups201Valve	s
	INNER JOIN tmp.Valves v
		ON s.VALVE_NO = v.Valve_No
	WHERE s.BYPASS_CD = 'Y'
	ORDER BY v.Valve_No --Required to ensure proper row_number for sequential EquipmentId

	-- Move data from the temp table to TransformEquipment.
	INSERT INTO TransformEquipment
	SELECT
		[Control],
		EquipmentID,
		[AssetType],
		[Description],
		[AssetNumber],
		[SerialNumber],
		[EquipmentType],
		[PMProgramType],
		[AssetPhotoFilePath],
		[AssetPhotoFileDescription],
		[ModelYear],
		[ManufacturerID],
		[ModelID],
		[MeterTypesClass],
		[Meter1Type],
		[Meter2Type],
		[Meter1AtDelivery],
		[Meter2AtDelivery],
		[LatestMeter1Reading],
		[LatestMeter2Reading],
		[MaxMeter1Value],
		[MaxMeter2Value],
		[Maintenance],
		[PMProgram],
		[Standards],
		[RentalRates],
		[Resources],
		[AssetCategoryID],
		[AssignedPM],
		[AssignedRepair],
		[StoredLocation],
		[StationLocation],
		[Jurisdiction],
		[PreferredPMShift],
		[VehicleLocation],
		[BuildingLocation],
		[OtherLocation],
		[DepartmentID],
		[DeptToNotifyForPM],
		[CompanyID] [varchar],
		[AccountIDAssignmentWO],
		[AccountIDLaborPosting],
		[AccountIDPartIssues],
		[AccountIDCommercialWork],
		[AccountIDFuelTickets],
		[AccountIDUsageTickets],
		[EquipmentStatus],
		[LifeCycleStatusCodeID],
		[ConditionRating],
		[StatusCodes],
		[WorkOrders],
		[UsageTickets],
		[FuelTickets],
		[Comments],
		[DefaultWOPriorityID],
		[ActualDeliveryDate],
		[ActualInServiceDate],
		[OriginalCost],
		[DepreciationMethod],
		[LifeMonths],
		[MonthsRemaining],
		[Ownership],
		[VendorID],
		[ExpirationDate],
		[Meter1Expiration],
		[Meter2Expiration],
		[Deductible],
		[WarrantyType],
		[Comments2],
		[EstimatedReplacementMonth],
		[EstimatedReplacementYear],
		[EstimatedReplacementCost],
		[Latitude],
		[Longitude],
		[NextPMServiceNumber],
		[NextPMDueDate],
		[IndividualPMService],
		[IndividualPMDateNextDue],
		[IndividualPMNumberofTimeUnits],
		[IndividualPMTimeUnit],
		[PlannedRetirementDate],
		[RetirementDate],
		[DispositionDate],
		[GrossSalePrice],
		[DisposalReason],
		[DisposalMethod],
		[DisposalAuthority],
		[DisposalComments]
	FROM tmp.Valves vehs
	ORDER BY vehs.EquipmentID

	-- Valves to the crosswalk table.
	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		v.EquipmentID [EquipmentID],
		'SourcePups201Valve' [Source],
		'VALVE_NO' [LegacyIDSource],
		v.Valve_No [LegacyID]
	FROM tmp.Valves v
END
