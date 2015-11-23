-- =================================================================================
-- Created By : Chris Buck
-- Create Date:	11/20/2015
-- Update Date:
-- Description: Creates/modifies the
--				spWorkOrderCenterTasksRequiredFieldsValidationReport stored
--				procedure.
-- =================================================================================

IF OBJECT_ID('spWorkOrderCenterTasksRequiredFieldsValidationReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spWorkOrderCenterTasksRequiredFieldsValidationReport AS SELECT 1')
GO

ALTER PROCEDURE dbo.spWorkOrderCenterTasksRequiredFieldsValidationReport
AS
BEGIN
	SELECT DISTINCT
		ISNULL(tmp.WorkOrderLocationID, '') [WorkOrderLocationID],
		ISNULL(tmp.WorkOrderYear, '') [WorkOrderYear],
		ISNULL(tmp.WorkOrderNumber, '') [WorkOrderNumber],
		ISNULL(tmp.TaskID, '') [TaskID],
		ISNULL(tmp.WorkAccomplishedCode, '') [WorkAccomplishedCode],
		ISNULL(tmp.UpdatePMSchedule, '') [UpdatePMSchedule],
		ISNULL(tmp.Comments, '') [Comments]
	FROM dbo.TransformWorkOrderCenterTasks tmp
	WHERE
		(ISNULL(tmp.WorkOrderLocationID, '') = '')
		OR (ISNULL(tmp.WorkOrderYear, '') = '')
		OR (ISNULL(tmp.WorkOrderNumber, '') = '')
		OR (ISNULL(tmp.TaskID, '') = '')
		OR (ISNULL(tmp.WorkAccomplishedCode, '') = '')
		OR (ISNULL(tmp.UpdatePMSchedule, '') = '')
		OR (ISNULL(tmp.Comments, '') = '')
END
