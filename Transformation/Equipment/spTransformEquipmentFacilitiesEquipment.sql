-- ===============================================================================================
-- Created By:	Chris Buck
-- Create Date:	01/30/2015
-- Update Date:
--		CJB 10/15/2015 Added new logic for writing to the TransformEquipmentIndividualPM
--					   table for Condition Assessments (spec 6.2.1).
--		CJB 01/06/2016 Added population logic VehicleLocation, BuildingLocation, and OtherLocation
-- Description: Creates/modifies the spTransformEquipmentFacilitiesEquipment
--              stored procedure.
-- ===============================================================================================

-- In order to persist security settings if the SP already exists, we check if
-- it exists and do an ALTER or a CREATE if it does not.
IF OBJECT_ID('spTransformEquipmentFacilitiesEquipment') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformEquipmentFacilitiesEquipment AS SELECT 1')
GO

ALTER PROCEDURE [dbo].[spTransformEquipmentFacilitiesEquipment]
AS
BEGIN
	DECLARE
		@GoLiveDate Date = '02/08/2016', --USED FOR RESETTING PM THAT ARE ALREADY OVERDUE
		@NewID				INT,
		@RowNumInProgress	INT
	
	IF OBJECT_ID('tmp.StationLocationLkUp') IS NOT NULL
	DROP TABLE tmp.StationLocationLkUp

	CREATE TABLE tmp.StationLocationLkUp (
		[WICM_Class] [varchar] (4),
		[AW_StationLoc] [varchar] (8)
	)
	INSERT INTO tmp.StationLocationLkUp
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

	IF OBJECT_ID('tmp.StagingEquip') IS NOT NULL
	DROP TABLE tmp.StagingEquip

	CREATE TABLE tmp.StagingEquip(
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
		[VehicleLocation] [varchar](10) NULL,
		[BuildingLocation] [varchar](10) NULL,
		[OtherLocation] [varchar](10) NULL,
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
		[UserStatus1] varchar(6) NULL,
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
		[IndividualPMService] [varchar](30) NULL,
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

	INSERT INTO tmp.StagingEquip
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
		LEFT(LTRIM(RTRIM(OE.VEH_EQU_ADDR)), 10) [VehicleLocation],
		LTRIM(RTRIM(OE.[FLOOR])) [BuildingLocation],
		LTRIM(RTRIM(OE.ROOM)) [OtherLocation],
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
		NULL UserStatus1,
		OE.COND_CODE [ConditionRating],
		ISNULL(OE.NORM_UNDER_W, '') [StatusCodes],
		'Y' [WorkOrders],
		'N' [UsageTickets],
		'N' [FuelTickets],
		'WICM VENDOR ID: ' + LTRIM(RTRIM(OE.VENDOR)) [Comments],
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
			-- No or invalid Delivery date (don't populate InServiceDate) 
			WHEN ISDATE(OE.ACQ_DATE) = 0 THEN NULL 
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
		NULL [LifeMonths],
		NULL [MonthsRemaining],
		'OWNED' [Ownership],
		'' [VendorID],
		NULL [ExpirationDate],
		NULL [Meter1Expiration],
		NULL [Meter2Expiration],
		NULL [Deductible],
		'' [WarrantyType],
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
		'[12359:1;IndividualPM;1:1]' [IndividualPMService], -- Update per BA 09/01
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
	UPDATE tmp.StagingEquip
	SET
		EquipmentType = LTRIM(RTRIM(modid.ModelName)),
		ManufacturerID = ISNULL(midc.[TargetValue], ''),
		ModelID = ISNULL(modid.CleansedModelID, ''),
		Maintenance = LTRIM(RTRIM(modid.ModelName)),
		PMProgram = LTRIM(RTRIM(modid.ModelName)),
		Standards = LTRIM(RTRIM(modid.ModelName)),
		Resources = LTRIM(RTRIM(modid.ModelName))
	FROM tmp.StagingEquip FAC
		INNER JOIN SourceWicm210ObjectEquipment oe ON FAC.[Object_ID] = LTRIM(RTRIM(oe.[OBJECT_ID]))
		INNER JOIN TransformEquipmentManufacturer midc
			ON LEFT(LTRIM(RTRIM(oe.MFR_NAME)), 15) = LEFT(LTRIM(RTRIM(midc.[SourceValue])), 15)
				AND midc.[Source] LIKE '%Facilities%'
		-- ModelID Cleansing
		INNER JOIN TransformEquipmentManufacturerModel modid
			ON LEFT(LTRIM(RTRIM(midc.[TargetValue])), 15) = modid.CleansedManufacturerID
				AND LTRIM(RTRIM(oe.FAC_MODEL)) = LTRIM(RTRIM(modid.SourceModelID))
	WHERE
		LTRIM(RTRIM(oe.FAC_MODEL)) <> 'NA'

	-- (FAC_MODEL = 'NA') EquipmentType, ManufacturerID, ModelID,
	-- Maintenance, PMProgram, Standards, Resources
	UPDATE tmp.StagingEquip
	SET
		EquipmentType = et.[EquipType],
		ManufacturerID = ISNULL(midc.[TargetValue], ''),
		ModelID = ISNULL(modid.CleansedModelID, ''),
		Maintenance = et.[EquipType],
		PMProgram = et.[EquipType],
		Standards = et.[EquipType],
		Resources = et.[EquipType]
	FROM tmp.StagingEquip FAC
		INNER JOIN SourceWicm210ObjectEquipment oe ON FAC.[Object_ID] = LTRIM(RTRIM(oe.[OBJECT_ID]))
		INNER JOIN TransformEquipmentFacilitiesEquipmentValueEquipmentType et
			ON LTRIM(RTRIM(FAC.[Object_ID])) = LTRIM(RTRIM(et.[OBJECT_ID]))
		INNER JOIN TransformEquipmentManufacturer midc
			ON LEFT(LTRIM(RTRIM(oe.MFR_NAME)), 15) = LEFT(LTRIM(RTRIM(midc.[SourceValue])), 15)
				AND midc.[Source] LIKE '%Facilities%'
		-- ModelID Cleansing
		INNER JOIN TransformEquipmentManufacturerModel modid
			ON LEFT(LTRIM(RTRIM(midc.[TargetValue])), 15) = modid.CleansedManufacturerID
				AND LTRIM(RTRIM(oe.FAC_MODEL)) = LTRIM(RTRIM(modid.SourceModelID))
	WHERE
		LTRIM(RTRIM(oe.FAC_MODEL)) = 'NA'

	-- (FAC_MODEL = 'NA') and not in TransformEquipmentFacilitiesEquipmentValueEquipmentType
	UPDATE tmp.StagingEquip
	SET
		EquipmentType = LTRIM(RTRIM(oe.MFR_NAME)) + LTRIM(RTRIM(oe.ASSET_TYPE)),
		Maintenance = LTRIM(RTRIM(oe.MFR_NAME)) + LTRIM(RTRIM(oe.ASSET_TYPE)),
		PMProgram = LTRIM(RTRIM(oe.MFR_NAME)) + LTRIM(RTRIM(oe.ASSET_TYPE)),
		Standards = LTRIM(RTRIM(oe.MFR_NAME)) + LTRIM(RTRIM(oe.ASSET_TYPE)),
		Resources = LTRIM(RTRIM(oe.MFR_NAME)) + LTRIM(RTRIM(oe.ASSET_TYPE))
	FROM tmp.StagingEquip FAC
		INNER JOIN SourceWicm210ObjectEquipment oe ON FAC.[Object_ID] = LTRIM(RTRIM(oe.[OBJECT_ID]))
	WHERE
		FAC.[Object_ID] NOT IN (SELECT [OBJECT_ID] FROM TransformEquipmentFacilitiesEquipmentValueEquipmentType)
		AND LTRIM(RTRIM(oe.FAC_MODEL)) = 'NA'
		AND FAC.EquipmentType = ''

	-- StationLocation
	UPDATE tmp.StagingEquip
	SET StationLocation = statloc.AW_StationLoc
	FROM tmp.StagingEquip FACS
		INNER JOIN SourceWicm210ObjectEquipment oe
			ON FACS.[Object_ID] = LTRIM(RTRIM(oe.[OBJECT_ID]))
		INNER JOIN tmp.StationLocationLkUp statloc ON LTRIM(RTRIM(oe.CLASS )) = statloc.WICM_Class

	-- Comments
	UPDATE tmp.StagingEquip
	SET Comments = LTRIM(RTRIM(oee.[SPECL-INST1])) + ' ' + LTRIM(RTRIM(oee.[SPECL-INST2])) + ' ' + 
		LTRIM(RTRIM(oee.[SPECL-INST3])) + ' ' + LTRIM(RTRIM(oee.[SPECL-INST4]))
		 + CHAR(13) + CHAR(10) + FACS.Comments
	FROM tmp.StagingEquip FACS
		INNER JOIN SourceWicm212ObjectExtensionEquipment oee ON FACS.[Object_ID] = oee.[OBJECT_ID]

	-- Build the auto-incrementing EquipmentID
	IF OBJECT_ID('tmp.FinalResultSet') IS NOT NULL
	DROP TABLE tmp.FinalResultSet

	DECLARE Facilities_Cursor CURSOR
	FOR SELECT SP.RowNum [RowNum]
	FROM tmp.StagingEquip SP
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
					SP.[BuildingLocation],
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
					SP.UserStatus1,
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
				INTO tmp.FinalResultSet
				FROM tmp.StagingEquip SP
				WHERE SP.RowNum = @RowNumInProgress
			END
		ELSE
			BEGIN
				INSERT INTO tmp.FinalResultSet
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
					SP.[BuildingLocation],
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
					SP.UserStatus1,
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
				FROM tmp.StagingEquip SP
				WHERE SP.RowNum = @RowNumInProgress
			END

		FETCH NEXT FROM Facilities_Cursor
		INTO @RowNumInProgress
	END
	CLOSE Facilities_Cursor;
	DEALLOCATE Facilities_Cursor;

	-- CjB 9/18/15: Handling of duplicate SerialNumbers
	-- Duplicate determined by make & model from the source.
	WITH Staging AS (
		SELECT SE.EquipmentID, oe.[OBJECT_ID], oe.MFR_NAME, oe.FAC_MODEL, oe.SERIAL_NO
		FROM tmp.FinalResultSet SE
			INNER JOIN SourceWicm210ObjectEquipment oe ON SE.[Object_ID] = LTRIM(RTRIM(OE.[OBJECT_ID]))
	),
	Facs AS (
		SELECT [OBJECT_ID], MFR_NAME, FAC_MODEL, SERIAL_NO
		FROM SourceWicm210ObjectEquipment
		WHERE [STATUS] = 'A' AND LTRIM(RTRIM([CLASS])) NOT IN ('JAPS', 'LHPL', 'RDGDMT')
	)
	UPDATE tmp.FinalResultSet
	SET SerialNumber = 'NSN: ' + S.EquipmentID
	FROM Staging S
		INNER JOIN tmp.FinalResultSet frs ON S.EquipmentID = frs.EquipmentID
		INNER JOIN Facs f ON S.MFR_NAME = f.MFR_NAME
			AND S.FAC_MODEL = f.FAC_MODEL
			AND S.SERIAL_NO = f.SERIAL_NO
			AND S.[OBJECT_ID] <> f.[OBJECT_ID]
	WHERE ISNULL(S.SERIAL_NO, '') NOT IN ('NA', 'N/A', '')

	-- Copy temp table to TrannsformEquipment
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
		LifeCycleStatusCodeID, UserStatus1, ConditionRating,
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
	FROM tmp.FinalResultSet

	-- Create the cross-walk reference for this dataset.
	INSERT INTO TransformEquipmentLegacyXwalk
	SELECT
		FRS.[EquipmentID],
		'SourceWicm210ObjectEquipment' [Source],
		'OBJECT_ID' [LegacyIDSource],
		FRS.[OBJECT_ID]
	FROM tmp.FinalResultSet FRS

	-- Write to TransformEquipmentIndividualPM
	---- Original run through.
	INSERT INTO dbo.TransformEquipmentIndividualPM
	(
		PMKey,
		PMServiceType,
		NextDueDate,
		NumberOfTimeUnits,
		TimeUnit
	)
	SELECT
		x.EquipmentID AS PMKey,
		CASE
			WHEN MS.SCH_OPCODE = 'ANNU' THEN 'IY01'
			WHEN MS.SCH_OPCODE = 'SEMI' THEN 'IS01'
			ELSE MS.SCH_OPCODE
		END [PMService],
		CASE
			WHEN CAST(MS.NXT_DUE_DATE AS DATE) < @GoLiveDate THEN @GoLiveDate --For already overdue PMs reset to go live date
			ELSE CAST(MS.NXT_DUE_DATE AS DATE)
		END AS NextDueDate,
		CASE
			WHEN MS.SCH_OPCODE LIKE '%M01' THEN '1'
			WHEN MS.SCH_OPCODE LIKE '%M02' THEN '2'
			WHEN MS.SCH_OPCODE LIKE '%Q01' THEN '3'
			WHEN MS.SCH_OPCODE LIKE '%S01' THEN '6'
			WHEN MS.SCH_OPCODE = 'SEMI' THEN '6'
			WHEN MS.SCH_OPCODE LIKE '%Y01' THEN '12'
			WHEN MS.SCH_OPCODE = 'ANNU' THEN '12'
			WHEN MS.SCH_OPCODE LIKE '%Y02' THEN '24'
			WHEN MS.SCH_OPCODE LIKE '%Y03' THEN '36'
			WHEN MS.SCH_OPCODE LIKE '%Y05' THEN '60'
			WHEN MS.SCH_OPCODE LIKE '%Y10' THEN '120'
			ELSE NULL
		END [NumberOfTimeUnits],
		'MONTHS' AS TimeUnit
	FROM SourceWicm230TableLookupMaintenanceSchedules MS
		INNER JOIN TransformEquipmentLegacyXwalk x ON MS.SCH_OBJECT = x.LegacyID
	WHERE
		x.EquipmentId LIKE 'EQP%'
		AND MS.[STATUS] = 'A'
	ORDER BY x.EquipmentID

	---- Criticality/Condition run through.	CjB 10/15/2016
	INSERT INTO dbo.TransformEquipmentIndividualPM
	(
		PMKey,
		PMServiceType,
		NextDueDate,
		NumberOfTimeUnits,
		TimeUnit
	)
	SELECT
		X.EquipmentID AS PMKey,
		'FACASSESSMT' AS PMService,
		CASE
			WHEN ISDATE(oe.NXT_ASSMT_DT) = 1 THEN oe.NXT_ASSMT_DT
			ELSE NULL
		END [NextDueDate],
		CASE
			WHEN oe.CRITICALITY = '5' AND oe.COND_CODE IN ('1','2')  THEN '60'
			WHEN oe.CRITICALITY = '5' AND oe.COND_CODE IN ('3','4')  THEN '24'
			WHEN oe.CRITICALITY = '5' AND oe.COND_CODE = '5'  THEN '12'
			WHEN oe.CRITICALITY = '4' AND oe.COND_CODE = '1'  THEN '60'
			WHEN oe.CRITICALITY = '4' AND oe.COND_CODE IN ('2','3')  THEN '24'
			WHEN oe.CRITICALITY = '4' AND oe.COND_CODE IN ('4','5')  THEN '12'
			WHEN oe.CRITICALITY = '3' AND oe.COND_CODE IN ('1','2')  THEN '24'
			WHEN oe.CRITICALITY = '3' AND oe.COND_CODE IN ('3','4')  THEN '12'
			WHEN oe.CRITICALITY = '3' AND oe.COND_CODE = '5'  THEN '6'
			WHEN oe.CRITICALITY = '2' AND oe.COND_CODE = '1'  THEN '24'
			WHEN oe.CRITICALITY = '2' AND oe.COND_CODE IN ('2','3')  THEN '12'
			WHEN oe.CRITICALITY = '2' AND oe.COND_CODE = '4'  THEN '6'
			WHEN oe.CRITICALITY = '2' AND oe.COND_CODE = '5'  THEN '3'
			WHEN oe.CRITICALITY = '1' AND oe.COND_CODE IN ('1','2')  THEN '12'
			WHEN oe.CRITICALITY = '1' AND oe.COND_CODE = '3'  THEN '6'
			WHEN oe.CRITICALITY = '1' AND oe.COND_CODE IN ('4','5')  THEN '3'
			ELSE NULL
		END [NumberOfTimeUnits],
		'MONTHS' AS TimeUnit
	FROM TransformEquipmentLegacyXwalk X
		INNER JOIN SourceWicm210ObjectEquipment oe ON X.LegacyID = oe.[OBJECT_ID]
	WHERE
		X.EquipmentID LIKE 'EQP%'
	ORDER BY X.EquipmentID
END
