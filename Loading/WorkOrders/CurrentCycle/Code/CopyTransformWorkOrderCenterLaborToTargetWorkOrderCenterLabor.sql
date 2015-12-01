INSERT INTO TargetWorkOrderCenterLabor
SELECT
	[Control], WorkOrderLocationID, WorkOrderYear, WorkOrderNumber,
	TaskID, WorkAccomplishedCode, LaborDt, EmployeeID, LaborHours,
	TimeCode, GETDATE()
FROM TransformWorkOrderCenterLabor WOL
WHERE
	ISNULL(WOL.[Control], '') <> ''
	AND ISNULL(WOL.WorkOrderLocationID, '') <> ''
	AND ISNULL(WOL.WorkOrderYear, NULL) IS NOT NULL
	AND ISNULL(WOL.WorkOrderNumber, '') <> ''
	AND ISNULL(WOL.TaskID, '') <> ''
	AND ISNULL(WOL.WorkAccomplishedCode, '') <> ''
	AND WOL.LaborDt IS NOT NULL
	AND ISNULL(WOL.EmployeeID, '') <> ''
	AND WOL.LaborHours IS NOT NULL
	AND ISNULL(WOL.TimeCode, '') <> ''
