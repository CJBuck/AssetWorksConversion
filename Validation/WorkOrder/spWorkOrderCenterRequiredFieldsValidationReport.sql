-- =================================================================================
-- Created By : Chris Buck
-- Create Date:	09/18/2015
-- Description: Creates/modifies the spWorkOrderCenterRequiredFieldsValidationReport
--				stored procedure.
-- =================================================================================

IF OBJECT_ID('spWorkOrderCenterRequiredFieldsValidationReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spWorkOrderCenterRequiredFieldsValidationReport AS SELECT 1')
GO

ALTER PROCEDURE dbo.spWorkOrderCenterRequiredFieldsValidationReport
AS
BEGIN
	SELECT DISTINCT
		tmp.[Object_ID],
		ISNULL(tmp.WorkOrderLocationID, '') [WorkOrderLocationID],
		ISNULL(tmp.WorkOrderYear, '') [WorkOrderYear],
		ISNULL(tmp.WorkOrderNumber, '') [WorkOrderNumber],
		ISNULL(tmp.JobStatus, '') [JobStatus],
		ISNULL(tmp.JobType, '') [JobType],
		ISNULL(tmp.EquipmentID, '') [EquipmentID],
		ISNULL(tmp.PriorityID, '') [PriorityID],
		ISNULL(tmp.RepairReasonID, '') [RepairReasonID],
		ISNULL(tmp.OutOfServiceDt, '') [OutOfServiceDt],
		ISNULL(tmp.InDt, '') [InDt],
		ISNULL(tmp.DueDt, '') [DueDt],
		ISNULL(tmp.OpenedDt, '') [OpenedDt],
		ISNULL(tmp.FirstLaborDt, '') [FirstLaborDt],
		ISNULL(tmp.ShowDowntimeBeginDt, '') [ShowDowntimeBeginDt],
		ISNULL(tmp.FinishWorkOrder, '') [FinishWorkOrder],
		ISNULL(tmp.FinishedDt, '') [FinishedDt],
		ISNULL(tmp.CloseWorkOrder, '') [CloseWorkOrder],
		ISNULL(tmp.ClosedDt, '') [ClosedDt],
		ISNULL(tmp.InService, '') [InService],
		ISNULL(tmp.InServiceDt, '') [InServiceDt],
		ISNULL(tmp.WorkClass, '') [WorkClass],
		ISNULL(tmp.Tasks, '') [Tasks],
		ISNULL(tmp.Labor, '') [Labor],
		ISNULL(tmp.Parts, '') [Parts],
		ISNULL(tmp.Commercial, '') [Commercial]
	FROM tmp.WorkOrderCenter tmp
	WHERE
		(ISNULL(tmp.WorkOrderLocationID, '') = '')
		OR (ISNULL(tmp.WorkOrderYear, '') = '')
		OR (ISNULL(tmp.WorkOrderNumber, '') = '')
		OR (ISNULL(tmp.JobStatus, '') = '')
		OR (ISNULL(tmp.JobType, '') = '')
		OR (ISNULL(tmp.EquipmentID, '') = '')
		OR (ISNULL(tmp.PriorityID, '') = '')
		OR (ISNULL(tmp.RepairReasonID, '') = '')
		OR (ISNULL(tmp.OutOfServiceDt, '') = '')
		OR (ISNULL(tmp.InDt, '') = '')
		OR (ISNULL(tmp.DueDt, '') = '')
		OR (ISNULL(tmp.OpenedDt, '') = '')
		OR (ISNULL(tmp.FirstLaborDt, '') = '')
		OR (ISNULL(tmp.ShowDowntimeBeginDt, '') = '')
		OR (ISNULL(tmp.FinishWorkOrder, '') = '')
		OR (ISNULL(tmp.FinishedDt, '') = '')
		OR (ISNULL(tmp.CloseWorkOrder, '') = '')
		OR (ISNULL(tmp.ClosedDt, '') = '')
		OR (ISNULL(tmp.InService, '') = '')
		OR (ISNULL(tmp.InServiceDt, '') = '')
		OR (ISNULL(tmp.WorkClass, '') = '')
		OR (ISNULL(tmp.Tasks, '') = '')
		OR (ISNULL(tmp.Labor, '') = '')
		OR (ISNULL(tmp.Parts, '') = '')
		OR (ISNULL(tmp.Commercial, '') = '')
END
