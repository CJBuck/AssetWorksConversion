SELECT
	'2325' [SCREEN],
	'[KEY]' [PurchaseOrderID], '8904:3' [LineNumber], '8904:4' [WorkOrderLocationID],
	'8904:5' [WorkOrderYear], '8904:6' [WorkOrderNumber],
	'8904:7' [Quantity], '8904:8' [TaskID]
UNION ALL
SELECT
	[Control], PurchaseOrderID, CAST(LineNumber AS VARCHAR),
	WorkOrderLocationID, CAST(WorkOrderYear AS VARCHAR),
	CAST(WorkOrderNumber AS VARCHAR),
	CAST(Quantity AS VARCHAR), TaskID
FROM TargetPurchaseOrdersRelatedWorkOrders
