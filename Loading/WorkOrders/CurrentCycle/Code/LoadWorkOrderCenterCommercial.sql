SELECT
	'2037' [SCREEN],
	'[KEY]' [WorkOrderLocationID], '[KEY]' [WorkOrderYear], '[KEY]' [WorkOrderNumber],
	'195:2' [TaskID], '195:3' [WorkAccomplishedCode], '195:4' [Dt],
	'195:5' [VendorID], '195:6' [LaborCost], '195:10' [PartsCost],
	'195:37' [MiscellaneousCost], '195:81' [Comments]
UNION ALL
SELECT
	[Control],
	[WorkOrderLocationID],
	CAST([WorkOrderYear] AS VARCHAR),
	[WorkOrderNumber],
	[TaskID],
	WorkAccomplishedCode,
	ISNULL((CONVERT(VARCHAR(10), CAST(Dt AS DATE), 101)), ''),
	VendorID,
	CAST(LaborCost AS VARCHAR),
	CAST(PartsCost AS VARCHAR),
	CAST(MiscCost AS VARCHAR),
	Comments
FROM TargetWorkOrderCenterCommercial
