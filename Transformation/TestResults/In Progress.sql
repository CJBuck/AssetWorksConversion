BEGIN
	DECLARE @Findings TABLE (
		QualVal		VARCHAR(30),
		CommentsVal	VARCHAR(60),
		NumVal		VARCHAR(20),
		NewNote		VARCHAR(2000)
	)
	
	DECLARE
		@WOCRowNum		INT,
		@WOCObjectID	VARCHAR(25),
		@PrevTestTypeID	VARCHAR(20),
		
		@DetailsVal		VARCHAR(60),
		-- Table TransformTestResults variables
		@TestID			VARCHAR(9),
		@EquipmentID	VARCHAR(20),
		@TestTypeID		VARCHAR(20),
		@TestDate		DATETIME,
		@DueDate		DATETIME,
		@TestLocationID	VARCHAR(10),
		@EmployeeID		VARCHAR(9),
		@WOLocationID	VARCHAR(10),
		@WOYear			INT,
		@WONumber		VARCHAR(15),
		@Status			VARCHAR(16),
		@NewNote		VARCHAR(2000),
		@TestResults	VARCHAR(25),
		-- Table TransformTestResultsDetails variables
		@TestElementID	VARCHAR(20),
		@NotPerformed	CHAR(1),
		@Result			VARCHAR(5),
		@DetThreshold	VARCHAR(12),
		@AllowableMin	VARCHAR(12),
		@AllowableMax	VARCHAR(12),
		@UnitOfMeasure	VARCHAR(10),
		@NumFound		VARCHAR(20),
		@NumValAfterAdj	VARCHAR(20),
		@QualFinding	VARCHAR(30),
		@PrelimAgmtNotes VARCHAR(2000),
		@Comments		VARCHAR(60),
		@CondRating		VARCHAR(20),
		@Symptom		VARCHAR(20)

	IF OBJECT_ID('tmp.TestResults') IS NOT NULL
	DROP TABLE tmp.TestResults

	CREATE TABLE tmp.TestResults (
		[RowNum] [INT] IDENTITY(1,1) NOT NULL,
		[Object_ID] [VARCHAR](10) NOT NULL,
		[TestID] [VARCHAR](9) NULL,
		[EquipmentID] [VARCHAR](20) NULL,
		[TestTypeID] [VARCHAR](20) NULL,
		[TestDate] [DATETIME] NULL,
		[DueDate] [DATETIME] NULL,
		[TestLocationID] [VARCHAR](10) NULL,
		[EmployeeID] [VARCHAR](9) NULL,
		[WorkLocationID] [VARCHAR](10) NULL,
		[WorkOrderYear] [INT] NULL,
		[WorkOrderNumber] [VARCHAR](15) NULL,
		[Status] [VARCHAR](16) NULL,
		[NewNote] [VARCHAR](2000) NULL,
		[TestResults] [VARCHAR](25) NULL
	)

	IF OBJECT_ID('tmp.TestResultsDetails') IS NOT NULL
	DROP TABLE tmp.TestResultsDetails

	CREATE TABLE tmp.TestResultsDetails (
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[Object_ID] [VARCHAR](10) NOT NULL,
		[TestID] [VARCHAR](9) NULL,
		[TestElementID] [VARCHAR](20) NULL,
		[NotPerformed] [CHAR](1) NULL,
		[Result] [VARCHAR](5) NULL,
		[DetectionThreshold] [VARCHAR](12) NULL,
		[AllowableMinimum] [VARCHAR](12) NULL,
		[AllowableMaximum] [VARCHAR](12) NULL,
		[UnitOfMeasure] [VARCHAR](10) NULL,
		[NumericFound] [VARCHAR](20) NULL,
		[NumericValueAfterAdjustment] [VARCHAR](20) NULL,
		[QualitativeFinding] [VARCHAR](30) NULL,
		[Comments] [VARCHAR](60) NULL,
		[ConditionRating] [VARCHAR](20) NULL,
		[Symptom] [VARCHAR](20) NULL
	)
	
	IF OBJECT_ID('tmp.WOC') IS NOT NULL
	DROP TABLE tmp.WOC
	
	CREATE TABLE [tmp].[WOC](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[Control] [varchar](10) NULL,
		[Object_ID] [varchar](25) NULL,
		[Location] [varchar](2) NULL,
		[WorkOrderLocationID] [varchar](10) NOT NULL,
		[WorkOrderYear] [int] NULL,
		[WorkOrderNumber] [varchar](15) NULL,
		[JobStatus] [varchar](20) NULL,
		[JobType] [varchar](8) NULL,
		[EquipmentID] [varchar](20) NULL,
		[Meter1] [int] NULL,
		[Meter2] [int] NULL,
		[PriorityID] [varchar](2) NULL,
		[PMService] [varchar](12) NULL,
		[PMScheduled] [datetime] NULL,
		[RepairReasonID] [varchar](4) NULL,
		[OutOfServiceDt] [datetime] NULL,
		[InDt] [datetime] NULL,
		[DueDt] [datetime] NULL,
		[OpenedDt] [datetime] NULL,
		[FirstLaborDt] [datetime] NULL,
		[ShowDowntimeBeginDt] [datetime] NULL,
		[FinishWorkOrder] [char](1) NULL,
		[FinishedDt] [datetime] NULL,
		[CloseWorkOrder] [char](1) NULL,
		[ClosedDt] [datetime] NULL,
		[InService] [char](1) NULL,
		[InServiceDt] [datetime] NULL,
		[AccountID] [varchar](30) NULL,
		[WorkClass] [char](1) NULL,
		[WarrantyWork] [varchar](15) NULL,
		[Complaint] [varchar](1000) NULL,
		[Cause] [varchar](1000) NULL,
		[Correction] [varchar](1000) NULL,
		[Tasks] [varchar](30) NULL,
		[Labor] [varchar](30) NULL,
		[Parts] [varchar](30) NULL,
		[Commercial] [varchar](30) NULL,
		[CreateDt] [datetime] NULL
	)

	IF OBJECT_ID('tmp.TestResultsComboWorkTbl') IS NOT NULL
	DROP TABLE tmp.TestResultsComboWorkTbl

	CREATE TABLE [tmp].[TestResultsComboWorkTbl](
		[RowNum] [int] NULL,
		[Control] [varchar](10) NULL,
		[Object_ID] [varchar](25) NULL,
		[Location] [varchar](2) NULL,
		[WorkOrderLocationID] [varchar](10) NOT NULL,
		[WorkOrderYear] [int] NULL,
		[WorkOrderNumber] [varchar](15) NULL,
		[JobStatus] [varchar](20) NULL,
		[JobType] [varchar](8) NULL,
		[EquipmentID] [varchar](20) NULL,
		[Meter1] [int] NULL,
		[Meter2] [int] NULL,
		[PriorityID] [varchar](2) NULL,
		[PMService] [varchar](12) NULL,
		[PMScheduled] [datetime] NULL,
		[RepairReasonID] [varchar](4) NULL,
		[OutOfServiceDt] [datetime] NULL,
		[InDt] [datetime] NULL,
		[DueDt] [datetime] NULL,
		[OpenedDt] [datetime] NULL,
		[FirstLaborDt] [datetime] NULL,
		[ShowDowntimeBeginDt] [datetime] NULL,
		[FinishWorkOrder] [char](1) NULL,
		[FinishedDt] [datetime] NULL,
		[CloseWorkOrder] [char](1) NULL,
		[ClosedDt] [datetime] NULL,
		[InService] [char](1) NULL,
		[InServiceDt] [datetime] NULL,
		[AccountID] [varchar](30) NULL,
		[WorkClass] [char](1) NULL,
		[WarrantyWork] [varchar](15) NULL,
		[Complaint] [varchar](1000) NULL,
		[Cause] [varchar](1000) NULL,
		[Correction] [varchar](1000) NULL,
		[Tasks] [varchar](30) NULL,
		[Labor] [varchar](30) NULL,
		[Parts] [varchar](30) NULL,
		[Commercial] [varchar](30) NULL,
		[CreateDt] [datetime] NULL,
		[LkUp_OBJECT_ID] [nvarchar](255) NULL,
		[LkUp_TestTypeID] [nvarchar](255) NULL,
		[LkUp_TestElementID] [nvarchar](255) NULL,
		[LkUp_TargetTestElementDescription] [nvarchar](255) NULL,
		[LkUp_SourceTable] [nvarchar](255) NULL,
		[LkUp_SourceColumnMappedToQualitativeField] [nvarchar](255) NULL,
		[SourceColumnMappedToCommentsField] [nvarchar](255) NULL,
		[SourceColumnMappedToNumericField] [nvarchar](255) NULL,
		[Logic] [nvarchar](255) NULL
	)
	
	-- Start
	INSERT INTO [tmp].[WOC]
	SELECT *
	FROM TransformWorkOrderCenter WOC
	WHERE WOC.RepairReasonID = 'PT'

	-- Set up the cursor
	---- This cursor will cycle through all the rows in [tmp].[WOC] and make an insert into 
	---- [tmp].TestResultsComboWorkTbl with all the tests from TransformTestResultsMappingLookup
	---- that match the flavor/pattern of OBJECT_ID.
	DECLARE WOC_Cursor CURSOR FOR SELECT RowNum, [Object_ID] FROM [tmp].[WOC]

	OPEN WOC_Cursor
	FETCH NEXT FROM WOC_Cursor
	INTO @WOCRowNum, @WOCObjectID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@WOCObjectID LIKE '__D%')
			BEGIN
				INSERT INTO [tmp].TestResultsComboWorkTbl
				SELECT WOC.*, lkup.*
				FROM [tmp].[WOC] WOC, TransformTestResultsMappingLookup lkup
				WHERE
					(WOC.RowNum = @WOCRowNum)
					AND (CHARINDEX('D%', lkup.[OBJECT_ID]) > 0 OR lkup.[OBJECT_ID] = 'All')
			END
		ELSE IF (@WOCObjectID LIKE '__A0%')
			BEGIN
				INSERT INTO [tmp].TestResultsComboWorkTbl
				SELECT WOC.*, lkup.*
				FROM [tmp].[WOC] WOC, TransformTestResultsMappingLookup lkup
				WHERE
					(WOC.RowNum = @WOCRowNum)
					AND (CHARINDEX('A0%', lkup.[OBJECT_ID]) > 0 OR lkup.[OBJECT_ID] = 'All')
			END
		ELSE IF (@WOCObjectID LIKE '__AN%')
			BEGIN
				INSERT INTO [tmp].TestResultsComboWorkTbl
				SELECT WOC.*, lkup.*
				FROM [tmp].[WOC] WOC, TransformTestResultsMappingLookup lkup
				WHERE
					(WOC.RowNum = @WOCRowNum)
					AND (CHARINDEX('AN%', lkup.[OBJECT_ID]) > 0 OR lkup.[OBJECT_ID] = 'All')
			END
		ELSE IF (@WOCObjectID LIKE '__AH%')
			BEGIN
				INSERT INTO [tmp].TestResultsComboWorkTbl
				SELECT WOC.*, lkup.*
				FROM [tmp].[WOC] WOC, TransformTestResultsMappingLookup lkup
				WHERE
					(WOC.RowNum = @WOCRowNum)
					AND (CHARINDEX('AH%', lkup.[OBJECT_ID]) > 0 OR lkup.[OBJECT_ID] = 'All')
			END
		ELSE IF (@WOCObjectID LIKE '__S0%')
			BEGIN
				INSERT INTO [tmp].TestResultsComboWorkTbl
				SELECT WOC.*, lkup.*
				FROM [tmp].[WOC] WOC, TransformTestResultsMappingLookup lkup
				WHERE
					(WOC.RowNum = @WOCRowNum)
					AND (CHARINDEX('S0%', lkup.[OBJECT_ID]) > 0 OR lkup.[OBJECT_ID] = 'All')
			END
		ELSE IF (@WOCObjectID LIKE '__M%')
			BEGIN
				INSERT INTO [tmp].TestResultsComboWorkTbl
				SELECT WOC.*, lkup.*
				FROM [tmp].[WOC] WOC, TransformTestResultsMappingLookup lkup
				WHERE
					(WOC.RowNum = @WOCRowNum)
					AND (CHARINDEX('M%', lkup.[OBJECT_ID]) > 0 OR lkup.[OBJECT_ID] = 'All')
			END
		-- Grab the next row
		FETCH NEXT FROM WOC_Cursor
		INTO @WOCRowNum, @WOCObjectID
	END

	-- Clean up cursor WOC_Cursor
	CLOSE WOC_Cursor;
	DEALLOCATE WOC_Cursor;
	
	-- Set up the next cursor
	---- This cursor will cycle through all the rows in [tmp].[WOC] and make an insert into 
	---- [tmp].TestResultsComboWorkTbl with all the tests from TransformTestResultsMappingLookup
	---- that match the flavor/pattern of OBJECT_ID.
	SET @TestID = 1000		-- Want TestIDs starting at 1000
	SET @PrevTestTypeID = ''

	DECLARE MainCursor CURSOR FOR
		SELECT
			RowNum, [Object_ID], Lkup_TestElementID, EquipmentID, LkUp_TestTypeID, OpenedDt [TestDate], OpenedDt [DueDate], 'D-ADMIN' [TestLocationID],
			'LEGACY001' [EmployeeID], WorkOrderLocationID, WorkOrderYear, WorkOrderNumber, 'PERFORMED' [Status], '' [NewNote]
		FROM [tmp].TestResultsComboWorkTbl
		ORDER BY EquipmentID, LkUp_TestTypeID

	OPEN MainCursor
	FETCH NEXT FROM MainCursor
	INTO @WOCRowNum, @WOCObjectID, @TestElementID, @EquipmentID, @TestTypeID, @TestDate, @DueDate, @TestLocationID,
		@EmployeeID, @WOLocationID,
		@WOYear, @WONumber, @Status, @NewNote

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		-- Start
		-- Send OBJECT_ID to function
		SELECT (@WONumber + ', ' + @TestElementID)
		IF @TestElementID IN ('PRJ-002', 'PRJ-003', 'PRJ-004', 'PRJ-005', 'PRJ-008', 'PRJ-009', 'PRJ-010', 'PRJ-011', 
			'PRJ-012', 'PRJ-013', 'PRJ-014', 'PRJ-018', 'PRJ-019', 'PRJ-020', 'PRJ-021', 'PRJ-022', 
			'PRJ-023', 'PRJ-025', 'PRJ-026', 'PRJ-034', 'PRJ-035', 'PRJ-036', 'PRJ-037', 'PRJ-038', 'PRJ-039', 
			'PRJ-040', 'PRJ-041', 'PRJ-042', 'PRJ-043', 'PRJ-044', 'PRJ-048', 'PRJ-051')
			BEGIN
				INSERT INTO @Findings
				SELECT * FROM [ufnGetTestResultsValue](@WOCObjectID, @TestElementID)
			END
		-- Send WorkOrderNumber to function
		IF @TestElementID NOT IN ('PRJ-002', 'PRJ-003', 'PRJ-004', 'PRJ-005', 'PRJ-008', 'PRJ-009', 'PRJ-010', 'PRJ-011', 
			'PRJ-012', 'PRJ-013', 'PRJ-014', 'PRJ-018', 'PRJ-019', 'PRJ-020', 'PRJ-021', 'PRJ-022', 
			'PRJ-023', 'PRJ-025', 'PRJ-026', 'PRJ-034', 'PRJ-035', 'PRJ-036', 'PRJ-037', 'PRJ-038', 'PRJ-039', 
			'PRJ-040', 'PRJ-041', 'PRJ-042', 'PRJ-043', 'PRJ-044', 'PRJ-048', 'PRJ-051')
			BEGIN
				INSERT INTO @Findings
				SELECT * FROM [ufnGetTestResultsValue](@WONumber, @TestElementID)
			END
		
		IF @TestTypeID <> @PrevTestTypeID
			BEGIN
			SET @PrevTestTypeID = @TestTypeID
	
			-- Increment the TestID
			SET @TestID = @TestID + 1

			-- Insert to tmp.TestResults
			INSERT INTO tmp.TestResults (
				[Object_ID], [TestID], [EquipmentID], [TestTypeID], [TestDate], [DueDate], [TestLocationID], [EmployeeID],
				[WorkLocationID], [WorkOrderYear], [WorkOrderNumber], [Status], [NewNote], [TestResults]
			)
			VALUES (
				@WOCObjectID, @TestID, @EquipmentID, @TestTypeID, @TestDate, @DueDate, @TestLocationID, @EmployeeID, 
				@WOLocationID, @WOYear, @WONumber,
				@Status, @NewNote, '[1829:1;RESULTS;1:1]'
			)
		END

		DECLARE DetailsCursor CURSOR FOR
			SELECT * FROM @Findings
			
		OPEN DetailsCursor
		FETCH NEXT FROM DetailsCursor
		INTO @QualFinding, @Comments, @NumFound, @PrelimAgmtNotes
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- A new note was returned so update tmp.TestResults
			IF @PrelimAgmtNotes <> ''
			BEGIN
				UPDATE tmp.TestResults
				SET NewNote = @PrelimAgmtNotes
				WHERE TestID = @TestID
			END
		
			-- Insert to tmp.TestResultsDetails
			INSERT INTO tmp.TestResultsDetails (
				[Object_ID], [TestID], TestElementID, NotPerformed, [Result], DetectionThreshold, AllowableMinimum, AllowableMaximum,
				UnitOfMeasure, NumericFound, NumericValueAfterAdjustment, QualitativeFinding, Comments, ConditionRating, Symptom
			 )
			VALUES (
				@WOCObjectID, @TestID, @TestElementID, '', '', '', '', '', '', @NumFound, '', @QualFinding, @Comments, '', ''
			)

			FETCH NEXT FROM DetailsCursor
			INTO @QualFinding, @Comments, @NumFound, @PrelimAgmtNotes
		END
		CLOSE DetailsCursor;
		DEALLOCATE DetailsCursor;
	
		-- Null out @Findings
		DELETE @Findings
		
		-- Grab the next row
		FETCH NEXT FROM MainCursor
		INTO @WOCRowNum, @WOCObjectID, @TestElementID, @EquipmentID, @TestTypeID, @TestDate, @DueDate, @TestLocationID,
			@EmployeeID, @WOLocationID,
			@WOYear, @WONumber, @Status, @NewNote
	END

	-- Clean up cursor MainCursor
	CLOSE MainCursor;
	DEALLOCATE MainCursor;
	
	-- Copy temp table to transform tables
	INSERT INTO TransformTestResults
	SELECT
		'[I]',
		T.TestID,
		T.EquipmentID,
		T.TestTypeID,
		T.TestDate,
		T.DueDate,
		T.TestLocationID,
		T.EmployeeID,
		T.WorkLocationID,
		T.WorkOrderYear,
		T.WorkOrderNumber,
		T.[Status],
		T.NewNote,
		T.TestResults,
		GETDATE()
	FROM tmp.TestResults T
	
	INSERT INTO TransformTestResultsDetails
	SELECT
		'[I]',
		TRD.TestID,
		TRD.TestElementID,
		TRD.NotPerformed,
		TRD.Result,
		TRD.DetectionThreshold,
		TRD.AllowableMinimum,
		TRD.AllowableMaximum,
		TRD.UnitOfMeasure,
		TRD.NumericFound,
		TRD.NumericValueAfterAdjustment,
		TRD.QualitativeFinding,
		TRD.Comments,
		TRD.ConditionRating,
		TRD.Symptom,
		GETDATE()
	FROM tmp.TestResultsDetails TRD

END
