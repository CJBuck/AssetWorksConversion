SELECT
	'2037' [SCREEN],
	'[KEY]' [WorkOrderLocationID], '[KEY]' [WorkOrderYear], '[KEY]' [WorkOrderNumber],
	'191:3' [TaskID], '191:4' [WorkAccomplishedCode], '191:13' [UpdatePMSchedule],
	'191:14' [Comments]
UNION ALL
SELECT
	[Control],
	[WorkOrderLocationID],
	CAST([WorkOrderYear] AS VARCHAR),
	[WorkOrderNumber],
	[TaskID],
	WorkAccomplishedCode,
	UpdatePMSchedule,
	Comments
FROM TargetWorkOrderCenterTasks
