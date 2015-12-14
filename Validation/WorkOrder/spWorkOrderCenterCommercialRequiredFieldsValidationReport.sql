-- =================================================================================
-- Created By : Chris Buck
-- Create Date:	12/11/2015
-- Update Date:
-- Description: Creates/modifies the
--				spWorkOrderCenterCommercialRequiredFieldsValidationReport stored
--				procedure.
-- =================================================================================

IF OBJECT_ID('spWorkOrderCenterCommercialRequiredFieldsValidationReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spWorkOrderCenterCommercialRequiredFieldsValidationReport AS SELECT 1')
GO

ALTER PROCEDURE dbo.spWorkOrderCenterCommercialRequiredFieldsValidationReport
AS
BEGIN
	SELECT DISTINCT
		ISNULL(tmp.WorkOrderLocationID, '') [WorkOrderLocationID],
		ISNULL(tmp.WorkOrderYear, '') [WorkOrderYear],
		ISNULL(tmp.WorkOrderNumber, '') [WorkOrderNumber],
		ISNULL(tmp.TaskID, '') [TaskID],
		ISNULL(tmp.WorkAccomplishedCode, '') [WorkAccomplishedCode],
		ISNULL((CONVERT(VARCHAR(10), CAST(Dt AS DATE), 101)), '') [Dt],
		ISNULL(tmp.VendorID, '') [VendorID],
		ISNULL(CAST(tmp.LaborCost AS VARCHAR), '') [LaborCost]
	FROM dbo.TransformWorkOrderCenterCommercial tmp
	WHERE
		(ISNULL(tmp.WorkOrderLocationID, '') = '')
		OR (ISNULL(tmp.WorkOrderYear, '') = '')
		OR (ISNULL(tmp.WorkOrderNumber, '') = '')
		OR (ISNULL(tmp.TaskID, '') = '')
		OR (ISNULL(tmp.WorkAccomplishedCode, '') = '')
		OR ISNULL((CONVERT(VARCHAR(10), CAST(Dt AS DATE), 101)), '') = ''
		OR (ISNULL(tmp.VendorID, '') = '')
		OR (ISNULL(CAST(tmp.LaborCost AS VARCHAR), '') = '')
END
