-- ===============================================================================
-- Created By:		Chris Buck
-- Create Date:		01/08/2016
-- Update Date:
--
-- Description:		Using the Object_ID and TestElementID, returns the test value.
-- ===============================================================================

USE [AssetWorksConversion];
GO

IF OBJECT_ID(N'dbo.ufnGetTestResultsValue', N'TF') IS NOT NULL
    DROP FUNCTION dbo.ufnGetTestResultsValue;
GO

CREATE FUNCTION dbo.ufnGetTestResultsValue(
	@ObjID	VARCHAR(50),
	@TestElementID VARCHAR(20)
)
RETURNS VARCHAR(MAX)
AS 
-- Returns the test results value, per object and testElementId.
BEGIN
    DECLARE 
        @TestResultValue VARCHAR(MAX);
        
	BEGIN
		SET @TestResultValue =
			CASE
				WHEN @TestElementID = 'EST-BO-01' THEN (
					SELECT [MTRL-DESC] FROM SourceWicm251WorkOrderDetailMaterialEstimates
					WHERE WO_NUMBER = @ObjID AND EST_CODE = 'BO'
				)
				WHEN @TestElementID = 'PRJ-002' THEN
					(SELECT JURISDICTION FROM SourceWicm250WorkOrderHeaderAdmin WHERE OBJECT_ID = @ObjID)
				ELSE ''
			END

	END

	RETURN @TestResultValue;
END