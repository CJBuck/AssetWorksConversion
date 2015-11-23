-- =================================================================================
-- Created By : Chris Buck
-- Create Date:	11/20/2015
-- Update Date:
-- Description: Creates/modifies the
--				spWorkOrderCenterPartsRequiredFieldsValidationReport stored
--				procedure.
-- =================================================================================

IF OBJECT_ID('spWorkOrderCenterPartsRequiredFieldsValidationReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spWorkOrderCenterPartsRequiredFieldsValidationReport AS SELECT 1')
GO

ALTER PROCEDURE dbo.spWorkOrderCenterPartsRequiredFieldsValidationReport
AS
BEGIN
	SELECT DISTINCT
		ISNULL(tmp.WorkOrderLocationID, '') [WorkOrderLocationID],
		ISNULL(CAST(tmp.WorkOrderYear AS VARCHAR), '') [WorkOrderYear],
		ISNULL(CAST(tmp.WorkOrderNumber AS VARCHAR), '') [WorkOrderNumber],
		ISNULL(tmp.TaskID, '') [TaskID],
		ISNULL((CONVERT(VARCHAR(10), CAST(Dt AS DATE), 101)), '') [Dt],
		ISNULL(tmp.NotFromInventory, '') [NotFromInventory],
		ISNULL(tmp.PartID, '') [PartID],
		ISNULL(tmp.PartSuffix, '') [PartSuffix],
		ISNULL(CAST(tmp.Quantity AS VARCHAR), '') [Quantity],
		ISNULL(CAST(tmp.UnitPrice AS VARCHAR), '') [UnitPrice],
		ISNULL(tmp.PartKeywordAndShortDescription, '') [PartKeywordAndShortDescription]
	FROM dbo.TransformWorkOrderCenterParts tmp
	WHERE
		(ISNULL(tmp.WorkOrderLocationID, '') = '')
		OR (ISNULL(tmp.WorkOrderYear, '') = '')
		OR (ISNULL(tmp.WorkOrderNumber, '') = '')
		OR (ISNULL(tmp.TaskID, '') = '')
		OR ISNULL((CONVERT(VARCHAR(10), CAST(Dt AS DATE), 101)), '') = ''
		OR ISNULL(tmp.NotFromInventory, '') = ''
		OR (ISNULL(tmp.PartID, '') = '')
		OR ISNULL(tmp.PartSuffix, '') = ''
		OR (ISNULL(CAST(tmp.Quantity AS VARCHAR), '') = '')
		OR (ISNULL(CAST(tmp.UnitPrice AS VARCHAR), '') = '')
		OR (ISNULL(tmp.PartKeywordAndShortDescription, '') = '')
END
