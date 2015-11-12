INSERT INTO TargetWorkOrderCenter
SELECT
	[Control], WorkOrderLocationID, WorkOrderYear, WorkOrderNumber,
	JobStatus, JobType, EquipmentID, Meter1, Meter2, PriorityID, PMService,
	PMScheduled, RepairReasonID, OutOfServiceDt, InDt, DueDt, OpenedDt, FirstLaborDt,
	ShowDowntimeBeginDt, FinishWorkOrder, FinishedDt, CloseWorkOrder, ClosedDt,
	InService, InServiceDt, AccountID, WorkClass, WarrantyWork, Complaint, Cause, Correction,
	Tasks, Labor, Parts, Commercial, GETDATE()
FROM TransformWorkOrderCenter TWO
WHERE
	ISNULL(TWO.[Control], '') <> ''
	AND ISNULL(TWO.WorkOrderLocationID, '') <> ''
	AND ISNULL(TWO.WorkOrderYear, NULL) IS NOT NULL
	AND ISNULL(TWO.WorkOrderNumber, '') <> ''
	AND ISNULL(TWO.JobStatus, '') <> ''
	AND ISNULL(TWO.JobType, '') <> ''
	AND ISNULL(TWO.EquipmentID, '') <> ''
	AND ISNULL(TWO.PriorityID, '') <> ''
	AND ISNULL(TWO.RepairReasonID, '') <> ''
	AND TWO.OutOfServiceDt IS NOT NULL
	AND TWO.InDt IS NOT NULL
	AND TWO.DueDt IS NOT NULL
	AND TWO.OpenedDt IS NOT NULL
	AND TWO.FirstLaborDt IS NOT NULL
	AND TWO.ShowDowntimeBeginDt IS NOT NULL
	AND ISNULL(TWO.FinishWorkOrder, '') <> ''
	AND TWO.FinishedDt IS NOT NULL
	AND ISNULL(TWO.CloseWorkOrder, '') <> ''
	AND TWO.ClosedDt IS NOT NULL
	AND ISNULL(TWO.InService, '') <> ''
	AND TWO.InServiceDt IS NOT NULL
	AND ISNULL(TWO.WorkClass, '') <> ''
	AND ISNULL(TWO.Tasks, '') <> ''
	AND ISNULL(TWO.Labor, '') <> ''
	AND ISNULL(TWO.Parts, '') <> ''
	AND ISNULL(TWO.Commercial, '') <> ''
