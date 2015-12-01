SELECT
	'2037' [SCREEN],
	'[KEY]' [WorkOrderLocationID], '[KEY]' [WorkOrderYear], '[KEY]' [WorkOrderNumber],
	'194:2' [TaskID], '194:4' [Dt], '194:5' [NotFromInventory], '194:7' [PartID],
	'194:8' [PartSuffix], '194:11' [Quantity], '194:12' [UnitPrice],
	'194:15' [PartKeywordShortDescription]
UNION ALL
SELECT
	[Control],
	[WorkOrderLocationID],
	CAST([WorkOrderYear] AS VARCHAR),
	[WorkOrderNumber],
	[TaskID],
	ISNULL((CONVERT(VARCHAR(10), CAST(Dt AS DATE), 101)), ''),
	NotFromInventory,
	PartID, PartSuffix,
	CAST(Quantity AS VARCHAR),
	CAST(UnitPrice AS VARCHAR),
	PartKeywordAndShortDescription
FROM TargetWorkOrderCenterParts
