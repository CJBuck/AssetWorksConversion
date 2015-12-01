SELECT
	'2037' [SCREEN],
	'[KEY]' [WorkOrderLocationID], '[KEY]' [WorkOrderYear], '[KEY]' [WorkOrderNumber],
	'193:2' [TaskID], '193:3' [WorkAccomplishedCode], '193:4' [LaborDt],
	'193:5' [EmployeeID], '193:7' [LaborHours], '193:8' [TimeCode]
UNION ALL
SELECT
	[Control],
	[WorkOrderLocationID],
	CAST([WorkOrderYear] AS VARCHAR),
	[WorkOrderNumber],
	[TaskID],
	WorkAccomplishedCode,
	ISNULL((CONVERT(VARCHAR(10), CAST(LaborDt AS DATE), 101)), ''),
	EmployeeID,
	CAST(LaborHours AS VARCHAR),
	TimeCode
FROM TargetWorkOrderCenterLabor
