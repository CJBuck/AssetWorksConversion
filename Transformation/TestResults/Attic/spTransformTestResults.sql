-- ===============================================================================
-- Created By:		Chris Buck
-- Create Date:		12/16/2015
-- Update Date:
--
-- Description:		Creates/modifies the spTransformTestResults stored procedure.
-- ===============================================================================

IF OBJECT_ID('spTransformTestResults') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformTestResults AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformTestResults
AS

BEGIN
	DECLARE 
		@WOCRowNum		INT,
		@WOCObjectID	VARCHAR(25),
		-- Table TransformTestResults variables
		@TestID			VARCHAR(9),
		@EquipmentID	VARCHAR(20),
		@TestTypeID		VARCHAR(20),
		@TestDate		DATETIME,
		@DueDate		DATETIME,
		@WOLocationID	VARCHAR(10),
		@WOYear			INT,
		@WONumber		VARCHAR(15),
		-- Table TransformTestResultsDetails variables
		@TestElementID	VARCHAR(20),
		@NumFound		VARCHAR(20),
		@QualFinding	VARCHAR(30),
		@Comments		VARCHAR(60)

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
		[Status] [VARCHAR](6) NULL,
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
	

END
