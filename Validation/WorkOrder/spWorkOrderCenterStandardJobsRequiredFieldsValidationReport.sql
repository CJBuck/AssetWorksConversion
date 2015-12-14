-- =================================================================================
-- Created By : Chris Buck
-- Create Date:	12/14/2015
-- Update Date:
-- Description: Creates/modifies the
--				spWorkOrderCenterStandardJobsRequiredFieldsValidationReport stored
--				procedure.
-- =================================================================================

IF OBJECT_ID('spWorkOrderCenterStandardJobsRequiredFieldsValidationReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spWorkOrderCenterStandardJobsRequiredFieldsValidationReport AS SELECT 1')
GO

ALTER PROCEDURE dbo.spWorkOrderCenterStandardJobsRequiredFieldsValidationReport
AS
BEGIN
	SELECT DISTINCT
		ISNULL(tmp.WorkOrderLocationID, '') [WorkOrderLocationID],
		ISNULL(tmp.WorkOrderYear, '') [WorkOrderYear],
		ISNULL(tmp.WorkOrderNumber, '') [WorkOrderNumber],
		ISNULL(tmp.StandardJobID, '') [StandardJobID]
	FROM dbo.TransformWorkOrderCenterStandardJobs tmp
	WHERE
		(ISNULL(tmp.WorkOrderLocationID, '') = '')
		OR (ISNULL(tmp.WorkOrderYear, '') = '')
		OR (ISNULL(tmp.WorkOrderNumber, '') = '')
		OR (ISNULL(tmp.StandardJobID, '') = '')
END
