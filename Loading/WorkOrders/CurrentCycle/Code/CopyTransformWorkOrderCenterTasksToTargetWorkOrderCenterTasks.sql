INSERT INTO TargetWorkOrderCenterTasks
SELECT
	[Control], WorkOrderLocationID, WorkOrderYear, WorkOrderNumber,
	TaskID, WorkAccomplishedCode, UpdatePMSchedule, Comments,
	GETDATE()
FROM TransformWorkOrderCenterTasks WOT
WHERE
	ISNULL(WOT.[Control], '') <> ''
	AND ISNULL(WOT.WorkOrderLocationID, '') <> ''
	AND ISNULL(WOT.WorkOrderYear, NULL) IS NOT NULL
	AND ISNULL(WOT.WorkOrderNumber, '') <> ''
	AND ISNULL(WOT.TaskID, '') <> ''
	AND ISNULL(WOT.WorkAccomplishedCode, '') <> ''
	AND ISNULL(WOT.UpdatePMSchedule, '') <> ''
	AND ISNULL(WOT.Comments, '') <> ''
