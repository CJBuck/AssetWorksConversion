-- =============================================================================
-- Created By:	Chris Buck
-- Create Date:	01/30/2015
-- Description: Creates/modifies the spTransformEquipmentFacilitiesEquipment
--              stored procedure.
-- =============================================================================

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spTransformEquipmentFacilitiesEquipment') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformEquipmentFacilitiesEquipment AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformEquipmentFacilitiesEquipment
AS
BEGIN
DECLARE
	@NewID				INT,
	@RowNumInProgress	INT
	
	CREATE TABLE #StationLocationLkUp (
		[WICM_Class] [varchar] (4),
		[AW_StationLoc] [varchar] (8)
	)
	INSERT INTO #StationLocationLkUp
	( [WICM_Class], [AW_StationLoc] )
	VALUES
	('BGWF', 'FACBGWF'),
	('BUCK', 'FACBUCK'),
	('CHPS', 'FACCHPS'),
	('CPPS', 'FACCPPS'),
	('CPST', 'FACCPST'),
	('DCPS', 'FACDCPS'),
	('DSMS', 'FACDSMS'),
	('ET60', 'FACET60'),
	('FHET', 'FACFHET'),
	('HMGF', 'FACHMGF'),
	('HMP4', 'FACHMP4'),
	('KMET', 'FACKMET'),
	('LANF', 'FACLANF'),
	('LANV', 'FACLANV'),
	('LCDH', 'FACLCDH'),
	('LCPS', 'FACLCPS'),
	('LHOC', 'FACLHOC'),
	('LHTP', 'FACLHTP'),
	('MLPS', 'FACMLPS'),
	('MLST', 'FACMLST'),
	('MS60', 'FACMS60'),
	('PHET', 'FACPHET'),
	('PS60', 'FACPS60'),
	('RSDL', 'FACRSDL'),
	('SCPS', 'FACSCPS'),
	('ST60', 'FACST60'),
	('UYPS', 'FACUYPS'),
	('UYST', 'FACUYST'),
	('YCWS', 'FACYCWS')

	CREATE TABLE #StagingEquip(
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[Object_ID] [varchar] (10) NOT NULL,
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

	INSERT INTO #StagingEquip
	SELECT
		LTRIM(RTRIM(OE.[OBJECT_ID])) [Object_ID],
		'[i]' [Control],
		'EQP' + '' [EquipmentID],
		'STATIONARY' [AssetType],
		ISNULL(LTRIM(RTRIM(OE.OB_EQUIP_D)), '') [Description],
		ISNULL(LTRIM(RTRIM(OE.[OBJECT_ID])), '') [AssetNumber],
		ISNULL(LTRIM(RTRIM(OE.SERIAL_NO)), '') [SerialNumber],
		'' [EquipmentType],
		'BOTH' [PMProgramType],
		'' [AssetPhotoFilePath],
		'' [AssetPhotoFileDescription],
		ISNULL(OE.VEH_YEAR, NULL) [ModelYear],
		'' [ManufacturerID],
		'' [ModelID],
		'NO METER' [MeterTypesClass],
		'' [Meter1Type],
		'' [Meter2Type],
		NULL [Meter1AtDelivery],
		NULL [Meter2AtDelivery],
		NULL [LatestMeter1Reading],
		NULL [LatestMeter2Reading],
		NULL [MaxMeter1Value],
		NULL [MaxMeter2Value],
		'' [Maintenance],
		'' [PMProgram],
		'' [Standards],
		'NOT APPLICABLE' [RentalRates],
		'' [Resources],
		CASE
			WHEN LTRIM(RTRIM(OE.ASSET_TYPE)) = 'CRANES' THEN 'CRANE'
			WHEN LTRIM(RTRIM(OE.ASSET_TYPE)) = 'DAMS' THEN 'DAM'
			WHEN LTRIM(RTRIM(OE.ASSET_TYPE)) = 'FANS' THEN 'FAN'
			WHEN LTRIM(RTRIM(OE.ASSET_TYPE)) = 'MOTORS' THEN 'MOTOR'
			WHEN LTRIM(RTRIM(OE.ASSET_TYPE)) = 'PIPE' THEN 'FACPIPE'
			WHEN LTRIM(RTRIM(OE.ASSET_TYPE)) = 'RSRVRS' THEN 'RSRVR'
			WHEN LTRIM(RTRIM(OE.ASSET_TYPE)) = 'VALVES' THEN 'FACVALVE'
			WHEN LTRIM(RTRIM(OE.ASSET_TYPE)) = 'WELLS' THEN 'WELL'
			WHEN LTRIM(RTRIM(OE.[OBJECT_ID])) = '3541430106' THEN 'CIRBRK'
			ELSE ISNULL(LEFT(OE.ASSET_TYPE, 15), '')
		END [AssetCategoryID],
		CASE LTRIM(RTRIM(OE.MAINT_SHOP))
			WHEN 'E' THEN 'FACELEC'
			WHEN 'EL' THEN 'FACELEC'
			WHEN 'I' THEN 'FACINST'
			WHEN 'IC' THEN 'FACINST'
			WHEN 'M' THEN 'FACMECH'
		END [AssignedPM],
		CASE LTRIM(RTRIM(OE.MAINT_SHOP))
			WHEN 'E' THEN 'FACELEC'
			WHEN 'EL' THEN 'FACELEC'
			WHEN 'I' THEN 'FACINST'
			WHEN 'IC' THEN 'FACINST'
			WHEN 'M' THEN 'FACMECH'
		END [AssignedRepair],
		'' [StoredLocation],
		'' [StationLocation],
		'' [Jurisdiction],
		'FACMF58' [PreferredPMShift],
		'' [VehicleLocation],
		'' [BuildingLocation],
		'' [OtherLocation],
		CASE
			WHEN LTRIM(RTRIM(OE.MAINT_SHOP)) = 'E' THEN '413011'
			WHEN LTRIM(RTRIM(OE.MAINT_SHOP)) = 'EL' THEN '413011'
			WHEN LTRIM(RTRIM(OE.MAINT_SHOP)) = 'M' THEN '413012'
			WHEN LTRIM(RTRIM(OE.MAINT_SHOP)) = 'I' THEN '413014'
			WHEN LTRIM(RTRIM(OE.MAINT_SHOP)) = 'IC' THEN '413014'
			ELSE ''
		END [DepartmentID],
		CASE
			WHEN LTRIM(RTRIM(OE.MAINT_SHOP)) = 'E' THEN '413011'
			WHEN LTRIM(RTRIM(OE.MAINT_SHOP)) = 'EL' THEN '413011'
			WHEN LTRIM(RTRIM(OE.MAINT_SHOP)) = 'M' THEN '413012'
			WHEN LTRIM(RTRIM(OE.MAINT_SHOP)) = 'I' THEN '413014'
			WHEN LTRIM(RTRIM(OE.MAINT_SHOP)) = 'IC' THEN '413014'
			ELSE ''
		END [DeptToNotifyForPM],
		'' [CompanyID],					-- Open issue
		'' [AccountIDAssignmentWO],		-- Open issue
		'' [AccountIDLaborPosting],		-- Open issue
		'' [AccountIDPartIssues],		-- Open issue
		'' [AccountIDCommercialWork],	-- Open issue
		'' [AccountIDFuelTickets],		-- Open issue
		'' [AccountIDUsageTickets],		-- Open issue
		'IN SERVICE' [EquipmentStatus],
		'A' [LifeCycleStatusCodeID],
		'' [ConditionRating],
		ISNULL(OE.NORM_UNDER_W, '') [StatusCodes],
		'Y' [WorkOrders],
		'N' [UsageTickets],
		'N' [FuelTickets],
		'' [Comments],
		CASE OE.CRITICALITY
			WHEN '1' THEN 'F1'
			WHEN '2' THEN 'F2'
			WHEN '3' THEN 'F5'
			WHEN '4' THEN 'F7'
			WHEN '5' THEN 'F8'
			ELSE 'F5'
		END [DefaultWOPriorityID],
		CASE
			WHEN ISDATE(OE.ACQ_DATE) = 1 THEN CAST(OE.ACQ_DATE AS DATETIME)
			ELSE NULL
		END [ActualDeliveryDate],
		CASE
			-- Install Dt before Acq Date
			WHEN ((ISDATE(OE.DATE_INSTALL) = 1) AND (ISDATE(OE.ACQ_DATE) = 1))
				AND (OE.DATE_INSTALL < OE.ACQ_DATE) THEN NULL
			-- Install Dt after Acq Date
			WHEN ((ISDATE(OE.DATE_INSTALL) = 1) AND (ISDATE(OE.ACQ_DATE) = 1))
				AND (OE.DATE_INSTALL > OE.ACQ_DATE) THEN CAST(OE.DATE_INSTALL AS DATETIME)
			-- Install Dt blank, NULL, or not a date
			WHEN (ISDATE(OE.DATE_INSTALL) = 0) 
				OR (ISNULL(OE.DATE_INSTALL, '') = '')
				OR (ISNULL(OE.ACQ_DATE, '') = '') THEN NULL
			ELSE NULL
		END [ActualInServiceDate],
		ISNULL(OE.ADDON_COST, NULL) [OriginalCost],
		'1/2 YEAR STRAIGHT LINE' [DepreciationMethod],
		NULL [LifeMonths],			-- Open issue
		NULL [MonthsRemaining],
		'OWNED' [Ownership],
		'' [VendorID],				-- Open issue
		NULL [ExpirationDate],
		NULL [Meter1Expiration],
		NULL [Meter2Expiration],
		NULL [Deductible],
		'' [WarrantyType],			-- Open issue
		'' [Comments2],
		CASE
			WHEN ISDATE(OBSOL_DATE) = 1 THEN MONTH(OE.OBSOL_DATE)
			ELSE NULL
		END [EstimatedReplacementMonth],
		CASE
			WHEN ISDATE(OBSOL_DATE) = 1 THEN YEAR(OE.OBSOL_DATE)
			ELSE NULL
		END [EstimatedReplacementYear],
		ISNULL(OE.ADDON_COST, NULL) [EstimatedReplacementCost],
		'' [Latitude],
		'' [Longitude],
		'' [NextPMServiceNumber],
		NULL [NextPMDueDate],
		'' [IndividualPMService],
		'' [IndividualPMDateNextDue],
		NULL [IndividualPMNumberOfTimeUnits],
		'' [IndividualPMTimeUnit],
		CASE
			WHEN ISDATE(OE.OBSOL_DATE) = 1 THEN CAST(OE.OBSOL_DATE AS DATETIME)
			ELSE NULL
		END [PlannedRetirementDate],
		NULL [RetirementDate],
		NULL [DispositionDate],
		NULL [GrossSalePrice],
		'' [DisposalReason],
		'' [DisposalMethod],
		'' [DisposalAuthority],
		'' [DisposalComments]
	FROM SourceWicm210ObjectEquipment OE
	WHERE
		OE.[STATUS] = 'A' AND LTRIM(RTRIM(OE.[CLASS])) NOT IN ('JAPS', 'LHPL', 'RDGDMT')
		
	-- (FAC_MODEL <> 'NA') EquipmentType, ManufacturerID, ModelID, Maintenance,
	-- PMProgram, Standards, Resources
	UPDATE #StagingEquip
	SET
		EquipmentType = LTRIM(RTRIM(modid.ModelName)),
		ManufacturerID = ISNULL(midc.[TargetValue], ''),
		ModelID = ISNULL(modid.CleansedModelID, ''),
		Maintenance = LTRIM(RTRIM(modid.ModelName)),
		PMProgram = LTRIM(RTRIM(modid.ModelName)),
		Standards = LTRIM(RTRIM(modid.ModelName)),
		Resources = LTRIM(RTRIM(modid.ModelName))
	FROM #StagingEquip FAC
		INNER JOIN SourceWicm210ObjectEquipment oe ON FAC.[Object_ID] = LTRIM(RTRIM(oe.[OBJECT_ID]))
		INNER JOIN TransformEquipmentManufacturer midc
			ON LEFT(LTRIM(RTRIM(OE.MFR_NAME)), 15) = LEFT(LTRIM(RTRIM(midc.[SourceValue])), 15)
				AND midc.[Source] LIKE '%Facilities%'
		-- ModelID Cleansing
		INNER JOIN TransformEquipmentManufacturerModel modid
			ON LEFT(LTRIM(RTRIM(midc.[TargetValue])), 15) = modid.CleansedManufacturerID
				AND LTRIM(RTRIM(OE.FAC_MODEL)) = LTRIM(RTRIM(modid.SourceModelID))
	WHERE
		LTRIM(RTRIM(oe.FAC_MODEL)) <> 'NA'

	-- (FAC_MODEL = 'NA') EquipmentType, ManufacturerID, ModelID,
	-- Maintenance, PMProgram, Standards, Resources
	UPDATE #StagingEquip
	SET
		EquipmentType = et.[EquipType],
		ManufacturerID = ISNULL(midc.[TargetValue], ''),
		ModelID = ISNULL(modid.CleansedModelID, ''),
		Maintenance = et.[EquipType],
		PMProgram = et.[EquipType],
		Standards = et.[EquipType],
		Resources = et.[EquipType]
	FROM #StagingEquip FAC
		INNER JOIN SourceWicm210ObjectEquipment oe ON FAC.[Object_ID] = LTRIM(RTRIM(oe.[OBJECT_ID]))
		INNER JOIN TransformEquipmentFacilitiesEquipmentValueEquipmentType et
			ON LTRIM(RTRIM(FAC.[Object_ID])) = LTRIM(RTRIM(et.[OBJECT_ID]))
		INNER JOIN TransformEquipmentManufacturer midc
			ON LEFT(LTRIM(RTRIM(OE.MFR_NAME)), 15) = LEFT(LTRIM(RTRIM(midc.[SourceValue])), 15)
				AND midc.[Source] LIKE '%Facilities%'
		-- ModelID Cleansing
		INNER JOIN TransformEquipmentManufacturerModel modid
			ON LEFT(LTRIM(RTRIM(midc.[TargetValue])), 15) = modid.CleansedManufacturerID
				AND LTRIM(RTRIM(OE.FAC_MODEL)) = LTRIM(RTRIM(modid.SourceModelID))
	WHERE
		LTRIM(RTRIM(oe.FAC_MODEL)) = 'NA'
		
	-- (FAC_MODEL = 'NA') and not in TransformEquipmentFacilitiesEquipmentValueEquipmentType
	UPDATE #StagingEquip
	SET
		EquipmentType = LTRIM(RTRIM(oe.MFR_NAME)) + LTRIM(RTRIM(oe.ASSET_TYPE)),
		Maintenance = LTRIM(RTRIM(oe.MFR_NAME)) + LTRIM(RTRIM(oe.ASSET_TYPE)),
		PMProgram = LTRIM(RTRIM(oe.MFR_NAME)) + LTRIM(RTRIM(oe.ASSET_TYPE)),
		Standards = LTRIM(RTRIM(oe.MFR_NAME)) + LTRIM(RTRIM(oe.ASSET_TYPE)),
		Resources = LTRIM(RTRIM(oe.MFR_NAME)) + LTRIM(RTRIM(oe.ASSET_TYPE))
	FROM #StagingEquip FAC
		INNER JOIN SourceWicm210ObjectEquipment oe ON FAC.[Object_ID] = LTRIM(RTRIM(oe.[OBJECT_ID]))
	WHERE
		FAC.[Object_ID] NOT IN (SELECT [OBJECT_ID] FROM TransformEquipmentFacilitiesEquipmentValueEquipmentType)
		AND LTRIM(RTRIM(oe.FAC_MODEL)) = 'NA'
		AND FAC.EquipmentType = ''

	-- Condition Rating				
	UPDATE #StagingEquip
	SET ConditionRating = ISNULL(cr.ConditionRating, '')
	FROM #StagingEquip FACS
		INNER JOIN TransformEquipmentFacilitiesValueConditionRating cr
			ON LTRIM(RTRIM(FACS.[Object_ID])) = LTRIM(RTRIM(cr.[OBJECT_ID]))

	-- StationLocation
	UPDATE #StagingEquip
	SET StationLocation = statloc.AW_StationLoc
	FROM #StagingEquip FACS
		INNER JOIN SourceWicm210ObjectEquipment oe
			ON FACS.[Object_ID] = LTRIM(RTRIM(oe.[OBJECT_ID]))
		INNER JOIN #StationLocationLkUp statloc ON LTRIM(RTRIM(oe.CLASS )) = statloc.WICM_Class

	-- Comments
	UPDATE #StagingEquip
	SET Comments = LTRIM(RTRIM(oee.[SPECL-INST1] + ' ' + oee.[SPECL-INST2] + ' ' + oee.[SPECL-INST3] + ' ' + oee.[SPECL-INST4]))
	FROM #StagingEquip FACS
		INNER JOIN SourceWicm212ObjectExtensionEquipment oee ON FACS.[Object_ID] = oee.[OBJECT_ID]

	-- Build the auto-incrementing EquipmentID
	DECLARE Facilities_Cursor CURSOR
	FOR SELECT SP.RowNum [RowNum]
	FROM #StagingEquip SP
	ORDER BY SP.RowNum

	OPEN Facilities_Cursor
	FETCH NEXT FROM Facilities_Cursor
	INTO @RowNumInProgress

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Get the next auto-number
		INSERT INTO EquipmentIDAutoCounter DEFAULT VALUES
		SET @NewID = @@IDENTITY
		
		IF @RowNumInProgress = 1
			BEGIN
				SELECT
					SP.[Object_ID],
					[Control],
					'EQP' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7) [EquipmentID],
					SP.[AssetType],
					SP.[Description],
					SP.[AssetNumber],
					CASE
						WHEN SP.[SerialNumber] IN ('', 'NA', 'N/A')
							THEN 'NSN: ' + ('EQP' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7))
						ELSE SP.[SerialNumber]
					END [SerialNumber],
					SP.[EquipmentType],
					SP.[PMProgramType],
					SP.[AssetPhotoFilePath],
					SP.[AssetPhotoFileDescription],
					SP.[ModelYear],
					SP.[ManufacturerID],
					SP.[ModelID],
					SP.[MeterTypesClass],
					SP.[Meter1Type],
					SP.[Meter2Type],
					SP.[Meter1AtDelivery],
					SP.[Meter2AtDelivery],
					SP.[LatestMeter1Reading],
					SP.[LatestMeter2Reading],
					SP.[MaxMeter1Value],
					SP.[MaxMeter2Value],
					SP.[Maintenance],
					SP.[PMProgram],
					SP.[Standards],
					SP.[RentalRates],
					SP.[Resources],
					SP.[AssetCategoryID],
					SP.[AssignedPM],
					SP.[AssignedRepair],
					SP.[StoredLocation],
					SP.[StationLocation],
					SP.[Jurisdiction],
					SP.[PreferredPMShift],
					SP.[VehicleLocation],
					'' [BuildingLocation],
					SP.[OtherLocation],
					SP.[DepartmentID],
					SP.[DeptToNotifyForPM],
					SP.[CompanyID],
					SP.[AccountIDAssignmentWO],
					SP.[AccountIDLaborPosting],
					SP.[AccountIDPartIssues],
					SP.[AccountIDCommercialWork],
					SP.[AccountIDFuelTickets],
					SP.[AccountIDUsageTickets],
					SP.[EquipmentStatus],
					SP.[LifeCycleStatusCodeID],
					SP.[ConditionRating],
					SP.[StatusCodes],
					SP.[WorkOrders],
					SP.[UsageTickets],
					SP.[FuelTickets],
					SP.[Comments],
					SP.[DefaultWOPriorityID],
					SP.[ActualDeliveryDate],
					SP.[ActualInServiceDate],
					SP.[OriginalCost],
					SP.[DepreciationMethod],
					SP.[LifeMonths],
					SP.[MonthsRemaining],
					SP.[Ownership],
					SP.[VendorID],
					SP.[ExpirationDate],
					SP.[Meter1Expiration],
					SP.[Meter2Expiration],
					SP.[Deductible],
					SP.[WarrantyType],
					SP.[Comments2],
					SP.[EstimatedReplacementMonth],
					SP.[EstimatedReplacementYear],
					SP.[EstimatedReplacementCost],
					SP.[Latitude],
					SP.[Longitude],
					SP.[NextPMServiceNumber],
					SP.[NextPMDueDate],
					SP.[IndividualPMService],
					SP.[IndividualPMDateNextDue],
					SP.[IndividualPMNumberOfTimeUnits],
					SP.[IndividualPMTimeUnit],
					SP.[PlannedRetirementDate],
					SP.[RetirementDate],
					SP.[DispositionDate],
					SP.[GrossSalePrice],
					SP.[DisposalReason],
					SP.[DisposalMethod],
					SP.[DisposalAuthority],
					SP.[DisposalComments]
				INTO #FinalResultSet
				FROM #StagingEquip SP
				WHERE SP.RowNum = @RowNumInProgress
			END
		ELSE
			BEGIN
				INSERT INTO #FinalResultSet
				SELECT
					SP.[Object_ID],
					SP.[Control],
					'EQP' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7) [EquipmentID],
					SP.[AssetType],
					SP.[Description],
					SP.[AssetNumber],
					CASE
						WHEN SP.[SerialNumber] IN ('', 'NA', 'N/A')
							THEN 'NSN: ' + ('EQP' + RIGHT(('0000000' + CAST(@NewID AS VARCHAR)), 7))
						ELSE SP.[SerialNumber]
					END [SerialNumber],
					SP.[EquipmentType],
					SP.[PMProgramType],
					SP.[AssetPhotoFilePath],
					SP.[AssetPhotoFileDescription],
					SP.[ModelYear],
					SP.[ManufacturerID],
					SP.[ModelID],
					SP.[MeterTypesClass],
					SP.[Meter1Type],
					SP.[Meter2Type],
					SP.[Meter1AtDelivery],
					SP.[Meter2AtDelivery],
					SP.[LatestMeter1Reading],
					SP.[LatestMeter2Reading],
					SP.[MaxMeter1Value],
					SP.[MaxMeter2Value],
					SP.[Maintenance],
					SP.[PMProgram],
					SP.[Standards],
					SP.[RentalRates],
					SP.[Resources],
					SP.[AssetCategoryID],
					SP.[AssignedPM],
					SP.[AssignedRepair],
					SP.[StoredLocation],
					SP.[StationLocation],
					SP.[Jurisdiction],
					SP.[PreferredPMShift],
					SP.[VehicleLocation],
					'' [BuildingLocation],
					SP.[OtherLocation],
					SP.[DepartmentID],
					SP.[DeptToNotifyForPM],
					SP.[CompanyID],
					SP.[AccountIDAssignmentWO],
					SP.[AccountIDLaborPosting],
					SP.[AccountIDPartIssues],
					SP.[AccountIDCommercialWork],
					SP.[AccountIDFuelTickets],
					SP.[AccountIDUsageTickets],
					SP.[EquipmentStatus],
					SP.[LifeCycleStatusCodeID],
					SP.[ConditionRating],
					SP.[StatusCodes],
					SP.[WorkOrders],
					SP.[UsageTickets],
					SP.[FuelTickets],
					SP.[Comments],
					SP.[DefaultWOPriorityID],
					SP.[ActualDeliveryDate],
					SP.[ActualInServiceDate],
					SP.[OriginalCost],
					SP.[DepreciationMethod],
					SP.[LifeMonths],
					SP.[MonthsRemaining],
					SP.[Ownership],
					SP.[VendorID],
					SP.[ExpirationDate],
					SP.[Meter1Expiration],
					SP.[Meter2Expiration],
					SP.[Deductible],
					SP.[WarrantyType],
					SP.[Comments2],
					SP.[EstimatedReplacementMonth],
					SP.[EstimatedReplacementYear],
					SP.[EstimatedReplacementCost],
					SP.[Latitude],
					SP.[Longitude],
					SP.[NextPMServiceNumber],
					SP.[NextPMDueDate],
					SP.[IndividualPMService],
					SP.[IndividualPMDateNextDue],
					SP.[IndividualPMNumberOfTimeUnits],
					SP.[IndividualPMTimeUnit],
					SP.[PlannedRetirementDate],
					SP.[RetirementDate],
					SP.[DispositionDate],
					SP.[GrossSalePrice],
					SP.[DisposalReason],
					SP.[DisposalMethod],
					SP.[DisposalAuthority],
					SP.[DisposalComments]
				FROM #StagingEquip SP
				WHERE SP.RowNum = @RowNumInProgress
			END
		
		FETCH NEXT FROM Facilities_Cursor
		INTO @RowNumInProgress
	END
	CLOSE Facilities_Cursor;
	DEALLOCATE Facilities_Cursor;

	-- Handling of duplicate SerialNumbers
	SELECT FRE.SerialNumber, COUNT(FRE.SerialNumber) [DupeCount]
	INTO #DuplicateSerialNos
	FROM #FinalResultSet FRE
	GROUP BY FRE.SerialNumber
	ORDER BY COUNT(FRE.SerialNumber) DESC

	UPDATE #FinalResultSet
	SET SerialNumber = 'NSN: ' + FRE.EquipmentID
	FROM #FinalResultSet FRE
	WHERE FRE.SerialNumber IN (
		SELECT SerialNumber FROM #DuplicateSerialNos WHERE [DupeCount] > 1
		)

	INSERT INTO TransformEquipment
	SELECT
		[Control],
		EquipmentID, AssetType,
		[Description], AssetNumber,
		SerialNumber, EquipmentType,
		PMProgramType, AssetPhotoFilePath,
		AssetPhotoFileDescription, ModelYear,
		ManufacturerID, ModelID,
		MeterTypesClass, Meter1Type,
		Meter2Type, Meter1AtDelivery,
		Meter2AtDelivery, LatestMeter1Reading,
		LatestMeter2Reading, MaxMeter1Value,
		MaxMeter2Value, Maintenance,
		PMProgram, Standards,
		RentalRates, Resources,
		AssetCategoryID, AssignedPM,
		AssignedRepair, StoredLocation,
		StationLocation, Jurisdiction,
		PreferredPMShift, VehicleLocation,
		BuildingLocation, OtherLocation,
		DepartmentID, DeptToNotifyForPM,
		CompanyID, AccountIDAssignmentWO,
		AccountIDLaborPosting, AccountIDPartIssues,
		AccountIDCommercialWork, AccountIDFuelTickets,
		AccountIDUsageTickets, EquipmentStatus,
		LifeCycleStatusCodeID, ConditionRating,
		StatusCodes, WorkOrders,
		UsageTickets, FuelTickets,
		Comments, DefaultWOPriorityID,
		ActualDeliveryDate, ActualInServiceDate,
		OriginalCost, DepreciationMethod,
		LifeMonths, MonthsRemaining,
		[Ownership], VendorID,
		ExpirationDate, Meter1Expiration,
		Meter2Expiration, Deductible,
		WarrantyType, Comments2,
		EstimatedReplacementMonth, EstimatedReplacementYear,
		EstimatedReplacementCost, Latitude,
		Longitude, NextPMServiceNumber,
		NextPMDueDate, IndividualPMService,
		IndividualPMDateNextDue, IndividualPMNumberOfTimeUnits,
		IndividualPMTimeUnit, PlannedRetirementDate,
		RetirementDate, DispositionDate,
		GrossSalePrice, DisposalReason,
		DisposalMethod, DisposalAuthority,
		DisposalComments
	FROM #FinalResultSet

	-- Create the cross-walk reference for this dataset.
	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		FRS.[EquipmentID],
		'SourceWicm210ObjectEquipment' [Source],
		'OBJECT_ID' [LegacyIDSource],
		FRS.[OBJECT_ID]
	FROM #FinalResultSet FRS
END

-- Clean up
IF OBJECT_ID('tempdb..#StagingEquip') IS NOT NULL
	DROP TABLE #StagingEquip
IF OBJECT_ID('tempdb..#FinalResultSet') IS NOT NULL
	DROP TABLE #FinalResultSet
IF OBJECT_ID('tempdb..#StationLocationLkUp') IS NOT NULL
	DROP TABLE #StationLocationLkUp
IF OBJECT_ID('tempdb..#DuplicateSerialNos') IS NOT NULL
	DROP TABLE #DuplicateSerialNos
