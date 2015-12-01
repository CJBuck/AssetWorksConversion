SELECT
	'2037' [SCREEN],
	'[KEY]' [WorkOrderLocationID], '[KEY]' [WorkOrderYear], '[KEY]' [WorkOrderNumber],
	'1670:3' [JobStatus]
UNION ALL
SELECT
	[Control],
	[WorkOrderLocationID],
	CAST([WorkOrderYear] AS VARCHAR), [WorkOrderNumber],
	[StandardJobID]
FROM TargetWorkOrderCenterStandardJobs
