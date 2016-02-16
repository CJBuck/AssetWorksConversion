-- ===============================================================================
-- Created By:		Chris Buck
-- Create Date:		01/12/2016
-- Update Date:
--
-- Description:		Using the parameter to retrieve by (OBJECT_ID or WO_NUMBER)
--					and TestElementID, returns the test values in a table.
-- ===============================================================================

USE [AssetWorksConversion];
GO

IF OBJECT_ID(N'dbo.ufnGetTestResultsValue', N'TF') IS NOT NULL
    DROP FUNCTION dbo.ufnGetTestResultsValue;
GO

CREATE FUNCTION dbo.ufnGetTestResultsValue(
	@FindBy	VARCHAR(50),
	@TestElementID VARCHAR(20)
)
RETURNS @retTestResult TABLE
(
	QualVal		VARCHAR(30),
	CommentsVal	VARCHAR(60),
	NumVal		VARCHAR(20),
	NewNote		VARCHAR(2000)
)
AS 
-- Returns the test results value, per object and testElementId.
BEGIN

	IF @TestElementID = 'EST-BO-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'BO'
		END
	IF @TestElementID = 'EST-BO-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'BO'
		END
	IF @TestElementID = 'EST-BO-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'BO'
		END
	IF @TestElementID = 'EST-BO-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'BO'
		END
	IF @TestElementID = 'EST-BO-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'BO'
		END
	IF @TestElementID = 'EST-BO-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'BO'
		END
	IF @TestElementID = 'EST-ES-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'ES'
		END
	IF @TestElementID = 'EST-ES-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'ES'
		END
	IF @TestElementID = 'EST-ES-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'ES'
		END
	IF @TestElementID = 'EST-ES-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'ES'
		END
	IF @TestElementID = 'EST-ES-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'ES'
		END
	IF @TestElementID = 'EST-ES-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'ES'
		END
	IF @TestElementID = 'EST-HR-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'HR'
		END
	IF @TestElementID = 'EST-HR-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'HR'
		END
	IF @TestElementID = 'EST-HR-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'HR'
		END
	IF @TestElementID = 'EST-HR-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'HR'
		END
	IF @TestElementID = 'EST-HR-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'HR'
		END
	IF @TestElementID = 'EST-HR-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'HR'
		END
	IF @TestElementID = 'EST-HY-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'HY'
		END
	IF @TestElementID = 'EST-HY-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'HY'
		END
	IF @TestElementID = 'EST-HY-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'HY'
		END
	IF @TestElementID = 'EST-HY-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'HY'
		END
	IF @TestElementID = 'EST-HY-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'HY'
		END
	IF @TestElementID = 'EST-HY-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'HY'
		END
	IF @TestElementID = 'EST-LF-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'LF'
		END
	IF @TestElementID = 'EST-LF-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'LF'
		END
	IF @TestElementID = 'EST-LF-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'LF'
		END
	IF @TestElementID = 'EST-LF-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'LF'
		END
	IF @TestElementID = 'EST-LF-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'LF'
		END
	IF @TestElementID = 'EST-LF-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'LF'
		END
	IF @TestElementID = 'EST-LM-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'LM'
		END
	IF @TestElementID = 'EST-LM-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'LM'
		END
	IF @TestElementID = 'EST-LM-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'LM'
		END
	IF @TestElementID = 'EST-LM-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'LM'
		END
	IF @TestElementID = 'EST-LM-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'LM'
		END
	IF @TestElementID = 'EST-LM-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'LM'
		END
	IF @TestElementID = 'EST-MF-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'MF'
		END
	IF @TestElementID = 'EST-MF-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'MF'
		END
	IF @TestElementID = 'EST-MF-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'MF'
		END
	IF @TestElementID = 'EST-MF-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'MF'
		END
	IF @TestElementID = 'EST-MF-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'MF'
		END
	IF @TestElementID = 'EST-MF-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'MF'
		END
	IF @TestElementID = 'EST-MT-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'MT'
		END
	IF @TestElementID = 'EST-MT-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'MT'
		END
	IF @TestElementID = 'EST-MT-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'MT'
		END
	IF @TestElementID = 'EST-MT-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'MT'
		END
	IF @TestElementID = 'EST-MT-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'MT'
		END
	IF @TestElementID = 'EST-MT-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'MT'
		END
	IF @TestElementID = 'EST-OT-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'OT'
		END
	IF @TestElementID = 'EST-OT-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'OT'
		END
	IF @TestElementID = 'EST-OT-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'OT'
		END
	IF @TestElementID = 'EST-OT-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'OT'
		END
	IF @TestElementID = 'EST-OT-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'OT'
		END
	IF @TestElementID = 'EST-OT-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'OT'
		END
	IF @TestElementID = 'EST-PL-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'PL'
		END
	IF @TestElementID = 'EST-PL-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'PL'
		END
	IF @TestElementID = 'EST-PL-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'PL'
		END
	IF @TestElementID = 'EST-PL-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'PL'
		END
	IF @TestElementID = 'EST-PL-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'PL'
		END
	IF @TestElementID = 'EST-PL-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'PL'
		END
	IF @TestElementID = 'EST-PR-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'PR'
		END
	IF @TestElementID = 'EST-PR-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'PR'
		END
	IF @TestElementID = 'EST-PR-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'PR'
		END
	IF @TestElementID = 'EST-PR-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'PR'
		END
	IF @TestElementID = 'EST-PR-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'PR'
		END
	IF @TestElementID = 'EST-PR-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'PR'
		END
	IF @TestElementID = 'EST-SP-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'SP'
		END
	IF @TestElementID = 'EST-SP-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'SP'
		END
	IF @TestElementID = 'EST-SP-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'SP'
		END
	IF @TestElementID = 'EST-SP-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'SP'
		END
	IF @TestElementID = 'EST-SP-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'SP'
		END
	IF @TestElementID = 'EST-SP-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'SP'
		END
	IF @TestElementID = 'EST-SR-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'SR'
		END
	IF @TestElementID = 'EST-SR-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'SR'
		END
	IF @TestElementID = 'EST-SR-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'SR'
		END
	IF @TestElementID = 'EST-SR-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'SR'
		END
	IF @TestElementID = 'EST-SR-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'SR'
		END
	IF @TestElementID = 'EST-SR-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'SR'
		END
	IF @TestElementID = 'EST-TI-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'TI'
		END
	IF @TestElementID = 'EST-TI-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'TI'
		END
	IF @TestElementID = 'EST-TI-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'TI'
		END
	IF @TestElementID = 'EST-TI-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'TI'
		END
	IF @TestElementID = 'EST-TI-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'TI'
		END
	IF @TestElementID = 'EST-TI-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'TI'
		END
	IF @TestElementID = 'EST-VV-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-DESC], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'VV'
		END
	IF @TestElementID = 'EST-VV-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-SIZE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'VV'
		END
	IF @TestElementID = 'EST-VV-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'VV'
		END
	IF @TestElementID = 'EST-VV-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-COS], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'VV'
		END
	IF @TestElementID = 'EST-VV-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MTRL-FOR-CODE], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'VV'
		END
	IF @TestElementID = 'EST-VV-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT-QTY], '', '', '' FROM SourceWicm251WorkOrderDetailMaterialEstimates
			WHERE WO_NUMBER = @FindBy AND EST_CODE = 'VV'
		END
	IF @TestElementID = 'PRJ-001'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT PrelimRecvd, '', '', '' FROM TransformTestResultsPrelimAgreement
			WHERE (RIGHT(ProjectNo, 2) = LEFT(@FindBy, 2)) AND (LEFT(ProjectNo, 3) = RIGHT(@FindBy, 3))
		END
	IF @TestElementID = 'PRJ-002'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT JURISDICTION, '', '', ''
			FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-003'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT LEFT((LTRIM(RTRIM(BLD_PRJ_NAME)) + ' ' + LTRIM(RTRIM(BLDG_ADDR))), 30), '', '', ''
			FROM SourceWicm210ObjectProject WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-004'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT DEVELOPER, '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-005'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ENG-NAME], '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-006'
		BEGIN
			IF SUBSTRING(@FindBy, 4, 1) = 'S'
				BEGIN
					INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
					SELECT 'Y', '', '', ''
				END
		END
	--IF @TestElementID = 'PRJ-007'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-008'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [CLASS], '', '', ''
			FROM SourceWicm210ObjectProject WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-009'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PRELIM_DATE], '', '', ''
			FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-010'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [AGREE_REQ_DT], '', '', ''
			FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-011'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ENG-NAME], '', '', ''
			FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	--IF @TestElementID = 'PRJ-011'		-- Stuart asked in email.
	--	BEGIN
		-- TODO
	--	END
	IF (@TestElementID = 'PRJ-012') OR (@TestElementID = 'PRJ-013') OR (@TestElementID = 'PRJ-014')
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT '', '', '', LEFT((PrelimDesignComments + ' ' + AgmtComments), 2000)
			FROM TransformTestResultsPrelimAgreement
			WHERE (RIGHT(ProjectNo, 2) = LEFT(@FindBy, 2)) AND (LEFT(ProjectNo, 3) = RIGHT(@FindBy, 3))
		END
	--IF @TestElementID = 'PRJ-015'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-016'
	--	BEGIN
		-- TODO
	--	END
	IF (@TestElementID = 'PRJ-017') OR (@TestElementID = 'PRJ-018') OR (@TestElementID = 'PRJ-019')
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT DesignMeeting, '', '', '' FROM TransformTestResultsPrelimAgreement
			WHERE (RIGHT(ProjectNo, 2) = LEFT(@FindBy, 2)) AND (LEFT(ProjectNo, 3) = RIGHT(@FindBy, 3))
		END
	IF @TestElementID = 'PRJ-020'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT DesignComplete, '', '', '' FROM TransformTestResultsPrelimAgreement
			WHERE (RIGHT(ProjectNo, 2) = LEFT(@FindBy, 2)) AND (LEFT(ProjectNo, 3) = RIGHT(@FindBy, 3))
		END
	IF @TestElementID = 'PRJ-021'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT PrelimPickupDate, '', '', '' FROM TransformTestResultsPrelimAgreement
			WHERE (RIGHT(ProjectNo, 2) = LEFT(@FindBy, 2)) AND (LEFT(ProjectNo, 3) = RIGHT(@FindBy, 3))
		END
	IF (@TestElementID = 'PRJ-022') OR (@TestElementID = 'PRJ-023')
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT AgmtReceived, '', '', '' FROM TransformTestResultsPrelimAgreement
			WHERE (RIGHT(ProjectNo, 2) = LEFT(@FindBy, 2)) AND (LEFT(ProjectNo, 3) = RIGHT(@FindBy, 3))
		END
	-- * NEW * No Action Required
	--IF @TestElementID = 'PRJ-024'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-025'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT TakeOffComplete, '', '', '' FROM TransformTestResultsPrelimAgreement
			WHERE (RIGHT(ProjectNo, 2) = LEFT(@FindBy, 2)) AND (LEFT(ProjectNo, 3) = RIGHT(@FindBy, 3))
		END
	IF @TestElementID = 'PRJ-026'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT LEFT(LTRIM(RTRIM([PROB_DESC1])), 30), '', '', ''
			FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-027'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [TAX_ID], '', '', '' FROM SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1Contd
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-034'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-MATLS], '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-035'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-LABOR], '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-036'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-FIXED], '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-037'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-EQUIPMENT], '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-038'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-SUBLET], '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-039'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-LAB], '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-040'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-EASEMENT], '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-041'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-SPRINKS], '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-042'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-SUPV-INSP], '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-043'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-LARGE-MTR], '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	IF @TestElementID = 'PRJ-044'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EST-TOTAL], '', '', '' FROM SourceWicm250WorkOrderHeaderAdmin WHERE [OBJECT_ID] = @FindBy;
		END
	--IF @TestElementID = 'PRJ-047'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-048'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT AgmtToDirector, '', '', '' FROM TransformTestResultsPrelimAgreement
			WHERE (RIGHT(ProjectNo, 2) = LEFT(@FindBy, 2)) AND (LEFT(ProjectNo, 3) = RIGHT(@FindBy, 3))
		END
	--IF @TestElementID = 'PRJ-049'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-050'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [LETTER_DATE], '', '', '' FROM SourceWicm253WorkOrderExtensionAdminWOTapsSoilSampling WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-051'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT LEFT(LTRIM(RTRIM(AgmtExpired)), 30), '', '', '' FROM TransformTestResultsPrelimAgreement
			WHERE (RIGHT(ProjectNo, 2) = LEFT(@FindBy, 2)) AND (LEFT(ProjectNo, 3) = RIGHT(@FindBy, 3))
		END
	--IF @TestElementID = 'PRJ-052'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-053'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PYMT_RCVD_DT], '', '', '' FROM SourceWicm253WorkOrderExtensionAdminWOTapsSoilSampling WHERE [WO_NUMBER] = @FindBy;
		END
	--IF @TestElementID = 'PRJ-054'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-055'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-056'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-057'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-058'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-059'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-060'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-061'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-062'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-063'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-064'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-065'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-066'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-067'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-068'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-069'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-070'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-071'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-072'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-073'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT (LTRIM(RTRIM([DRAW_NO_1])) + ' ' + LTRIM(RTRIM(DRAW_NO_2)) + ' ' + LTRIM(RTRIM(DRAW_NO_3))), '', '', ''
			FROM SourceWicm253WorkOrderExtensionAdminWOTapsSoilSampling
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-074'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [DRAW_PKG_DT], '', '', ''
			FROM SourceWicm253WorkOrderExtensionAdminWOTapsSoilSampling
			WHERE [WO_NUMBER] = @FindBy;
		END
	--IF @TestElementID = 'PRJ-075'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-076'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [HYD_COMPL_DT], [HYD_RECS_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-077'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MAP_COMPL_DT], [MAP_RECS_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-078'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ABND_CMPL_DT], [ABND_RECS_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-079'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [DRAW_CMPL_DT], [DRAW_RECS_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-080'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [STRT_CMPL_DT], [STRT_RECS_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-081'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PNGS_CMPL_DT], [PNGS_RECS_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-082'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MAT-AFDVT_DT], [MAT-AFDVT_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-083'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MNT_BOND_DT], [MNT_BOND_ST], [MNT_BOND_AMT], ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-084'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ABSLT_DRW_DT], [ABSLT_DRW_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-085'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [COST_STMT_DT], [COST_STMT_ST], [COST_STM_AMT], ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-086'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EASMT_PLT_DT], [EASMT_PLT_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-087'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [SLV_SAMPL_DT], [SLV_SAMPL_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-088'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [INSVC_CN_DT], [INSVC_CN_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-089'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MAT-AFDVT_DT], [MAT-AFDVT_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1Contd]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-090'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MNT_BOND_DT], [MNT_BOND_ST], [MNT_BOND_AMT], ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1Contd]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-091'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ASBLT_DRW_DT], [ASBLT_DRW_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1Contd]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-092'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [COST_STMT_DT], [COST_STMT_ST], [COST_STM_AMT], ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1Contd]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-093'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EASMT_PLT_DT], [EASMT_PLT_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1Contd]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-094'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [SLV_SAMPL_DT], [SLV_SAMPL_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-095'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [INSVC_CN_DT], [INSVC_CN_ST], '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1Contd]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-096'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [AGREE_EXC_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOTapsSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-097'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PYMT_RCVD_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOTapsSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	--IF @TestElementID = 'PRJ-098'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-099'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-100'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT LEFT(LTRIM(RTRIM([XM_MODIFS])), 30), '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOTapsSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	--IF @TestElementID = 'PRJ-101'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-102'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [APPL_RCVD_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOTapsSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-103'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [FLUSH_INSPTR], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-104'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [FLUSH_INS_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-105'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [FLUSH_CONTR], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-106'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [START_DT_WW], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-107'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [START_DT_CN], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-108'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MISS_UTIL_NO], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-109'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PERMIT_NO_1], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-110'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PERMIT_NO_2], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-111'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PERMIT_NO_3], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-112'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PERMIT_NO_4], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-114'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [WAIVER_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOTapsSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	--IF @TestElementID = 'PRJ-115'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-116'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-117'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-118'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PPRWK_ENG_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-119'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [INSVC_PLC_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-120'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [INSVC_DELAY], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	--IF @TestElementID = 'PRJ-121'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-122'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-123'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-124'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [INSVC_APV_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-125'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [INSVC_ACC_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-126'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [FIN_STLMT_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-127'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT_MATLS], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-128'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT_LABOR], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-129'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT_FIXED], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-130'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT_EQUIPMT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-131'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT_SUBLET], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-132'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT_LAB], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-133'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT_EASEMT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-134'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [ACT_SPRNKLRS], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-135'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [dbo].[ufnTransformTestResultsSummaryCosts](@FindBy, 'PRJ-135'), '', '', ''
		END
	IF @TestElementID = 'PRJ-136'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [dbo].[ufnTransformTestResultsSummaryCosts](@FindBy, 'PRJ-136'), '', '', ''
		END
	--IF @TestElementID = 'PRJ-143'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-144'
	--	BEGIN
		-- TODO
	--	END
	--IF @TestElementID = 'PRJ-145'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-146'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PREFN_INS_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-147'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [FIN_INSP_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	--IF @TestElementID = 'PRJ-148'
	--	BEGIN
		-- TODO
	--	END
	IF @TestElementID = 'PRJ-149'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [DAY60_LTR_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-150'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [DO_APRV_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-151'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [CE_APRV_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-152'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [WO_OUTDATE], '', '', ''
			FROM [SourceWicm250WorkOrderHeaderAdmin]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [CL_DATE], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorination]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [CL_DATE], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorination]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [INSPECTOR], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorination]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [CL_DATE], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorination]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [CONNECT_DATE], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorination]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EQUIP_CHECK], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorination]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [FOREMAN], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorination]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-07'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [SAMPL_POINT], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorinationPoints]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-08'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [BFR_CLRESD1], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorinationPoints]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-09'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [BFR_DATE1], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorinationPoints]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-10'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [BFR_CLRESD2], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorinationPoints]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-11'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [BFR_DATE2], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorinationPoints]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-12'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [AFT_CLRESD1], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorinationPoints]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-13'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [AFT_DATE1], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorinationPoints]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-14'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [AFT_RESULT1], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorinationPoints]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-15'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [AFT_CLRESD2], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorinationPoints]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-16'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [AFT_DATE2], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorinationPoints]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-CHLOR-17'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [AFT_RESULT2], '', '', ''
			FROM [SourceWicm251WorkOrderDetailChlorinationPoints]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [CONN_NO], '', '', ''
			FROM [SourceWicm251WorkOrderDetailInitialFlushing]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [CONN_SIZE], '', '', ''
			FROM [SourceWicm251WorkOrderDetailInitialFlushing]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [CONN_TYPE], '', '', ''
			FROM [SourceWicm251WorkOrderDetailInitialFlushing]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [CONTRACTOR], '', '', ''
			FROM [SourceWicm251WorkOrderDetailInitialFlushing]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [INSPECTOR], '', '', ''
			FROM [SourceWicm251WorkOrderDetailInitialFlushing]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [FOREMAN], '', '', ''
			FROM [SourceWicm251WorkOrderDetailInitialFlushing]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-07'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [FLUSH_INS_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-08'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [FLUSH_REQ_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-09'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [REV_SUBM_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-10'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [REV_APPRV_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-11'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [REV_APPRV_BY], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-12'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [BLWFF_CHK_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-13'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [BLOWOFF_QTY], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-14'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [VALVE_CHK_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-15'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [WATER_ON_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-16'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [CLAR_TST_DT], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-FLUSH-17'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [dbo].[ufnTransformTestResultsSummaryCosts](@FindBy, 'PRJ-FLUSH-17'), '', '', ''
	END
	IF @TestElementID = 'PRJ-FLUSH-18'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT LEFT(LTRIM(RTRIM([COMMENTS])), 30), '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-PRESS-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PIPE_VOL], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-PRESS-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PT_CMPL_DT_W], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-PRESS-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PT_CMPL_DT_C], '', '', ''
			FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-PRESS-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [DONE_BY_CODE], '', '', ''
			FROM [SourceWicm251WorkOrderDetailPressureTests]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-PRESS-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PERFORM_DATE], '', '', ''
			FROM [SourceWicm251WorkOrderDetailPressureTests]
			WHERE [WO_NUMBER] = @FindBy;
		END
	--IF @TestElementID = 'PRJ-PRESS-06'
	--	BEGIN
	--		INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
	--		SELECT [TIME], '', ''			-- Couldn't find field [TIME]; ? out to Stuart
	--		FROM [SourceWicm251WorkOrderDetailPressureTests]
	--		WHERE [WO_NUMBER] = @FindBy;
	--	END
	IF @TestElementID = 'PRJ-PRESS-07'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [VALVE_CHECK], '', '', ''
			FROM [SourceWicm251WorkOrderDetailPressureTests]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-PRESS-08'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [EQUIP_CHECK], '', '', ''
			FROM [SourceWicm251WorkOrderDetailPressureTests]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-PRESS-09'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [TESTED_AT], '', '', ''
			FROM [SourceWicm251WorkOrderDetailPressureTests]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-PRESS-10'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [READING_1], '', '', ''
			FROM [SourceWicm251WorkOrderDetailPressureTests]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-PRESS-11'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [READING_2], '', '', ''
			FROM [SourceWicm251WorkOrderDetailPressureTests]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-PRESS-12'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [GAUGE], '', '', ''
			FROM [SourceWicm251WorkOrderDetailPressureTests]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-PRESS-13'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [INSPECTOR], '', '', ''
			FROM [SourceWicm251WorkOrderDetailPressureTests]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-PRESS-14'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [FOREMAN], '', '', ''
			FROM [SourceWicm251WorkOrderDetailPressureTests]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-01'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [BORE_NO], '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-02'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [BOX_READING], '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-03'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [BOX_POINTS], '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-04'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PH_READING], '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-05'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [PH_POINTS], '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-06'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [RDX_READING], '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-07'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [RDX_POINTS], '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-08'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [SLF_CHECK], '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-09'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [SLF_POINTS], '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-10'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MOIST_CODE], '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-11'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [MOIST_POINTS], '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-12'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT [TOTAL_POINTS], '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END
	IF @TestElementID = 'PRJ-SOIL-13'
		BEGIN
			INSERT INTO @retTestResult ( QualVal, CommentsVal, NumVal, NewNote )
			SELECT LTRIM(RTRIM([SOIL_DESC])), '', '', ''
			FROM [SourceWicm251WorkOrderDetailSoilSampling]
			WHERE [WO_NUMBER] = @FindBy;
		END

	RETURN;
	
END;
