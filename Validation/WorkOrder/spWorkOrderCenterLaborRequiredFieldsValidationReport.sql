-- =================================================================================
-- Created By : Chris Buck
-- Create Date:	11/20/2015
-- Update Date:
-- Description: Creates/modifies the
--				spWorkOrderCenterLaborRequiredFieldsValidationReport stored
--				procedure.
-- =================================================================================

IF OBJECT_ID('spWorkOrderCenterLaborRequiredFieldsValidationReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spWorkOrderCenterLaborRequiredFieldsValidationReport AS SELECT 1')
GO

ALTER PROCEDURE dbo.spWorkOrderCenterLaborRequiredFieldsValidationReport
AS
BEGIN
	SELECT DISTINCT
		ISNULL(tmp.WorkOrderLocationID, '') [WorkOrderLocationID],
		ISNULL(CAST(tmp.WorkOrderYear AS VARCHAR), '') [WorkOrderYear],
		ISNULL(CAST(tmp.WorkOrderNumber AS VARCHAR), '') [WorkOrderNumber],
		ISNULL(tmp.TaskID, '') [TaskID],
		ISNULL(tmp.WorkAccomplishedCode, '') [WorkAccomplishedCode],
		ISNULL((CONVERT(VARCHAR(10), CAST(LaborDt AS DATE), 101)), '') [LaborDt],
		ISNULL(tmp.EmployeeID, '') [EmployeeID],
		ISNULL(CAST(tmp.LaborHours AS VARCHAR), '') [LaborHours],
		ISNULL(tmp.TimeCode, '') [TimeCode]
	FROM dbo.TransformWorkOrderCenterLabor tmp
	WHERE
		(ISNULL(tmp.WorkOrderLocationID, '') = '')
		OR (ISNULL(tmp.WorkOrderYear, '') = '')
		OR (ISNULL(tmp.WorkOrderNumber, '') = '')
		OR (ISNULL(tmp.TaskID, '') = '')
		OR (ISNULL(tmp.WorkAccomplishedCode, '') = '')
		OR ISNULL((CONVERT(VARCHAR(10), CAST(LaborDt AS DATE), 101)), '') = ''
		OR (ISNULL(tmp.EmployeeID, '') = '')
		OR ISNULL(CAST(tmp.WorkOrderNumber AS VARCHAR), '') = ''
		OR (ISNULL(tmp.TimeCode, '') = '')
END
