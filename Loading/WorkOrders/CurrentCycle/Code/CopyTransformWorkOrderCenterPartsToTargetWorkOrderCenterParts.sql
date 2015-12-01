INSERT INTO TargetWorkOrderCenterParts
SELECT
	[Control], WorkOrderLocationID, WorkOrderYear, WorkOrderNumber,
	TaskID, Dt, NotFromInventory, PartID, PartSuffix, Quantity,
	UnitPrice, PartKeywordAndShortDescription,
	GETDATE()
FROM TransformWorkOrderCenterParts WOP
WHERE
	ISNULL(WOP.[Control], '') <> ''
	AND ISNULL(WOP.WorkOrderLocationID, '') <> ''
	AND ISNULL(WOP.WorkOrderYear, NULL) IS NOT NULL
	AND ISNULL(WOP.WorkOrderNumber, '') <> ''
	AND ISNULL(WOP.TaskID, '') <> ''
	AND WOP.Dt IS NOT NULL
	AND ISNULL(WOP.NotFromInventory, '') <> ''
	AND ISNULL(WOP.PartID, '') <> ''
	AND ISNULL(WOP.PartSuffix, '') <> ''
	AND WOP.Quantity IS NOT NULL
	AND WOP.UnitPrice IS NOT NULL
	AND ISNULL(WOP.PartKeywordAndShortDescription, '') <> ''
