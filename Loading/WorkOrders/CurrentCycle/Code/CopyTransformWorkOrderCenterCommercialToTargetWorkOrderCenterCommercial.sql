INSERT INTO TargetWorkOrderCenterCommercial
SELECT
	[Control], WorkOrderLocationID, WorkOrderYear, WorkOrderNumber,
	TaskID, WorkAccomplishedCode, Dt, VendorID,
	LaborCost, PartsCost, MiscCost, Comments,
	GETDATE()
FROM TransformWorkOrderCenterCommercial WOCC
WHERE
	ISNULL(WOCC.[Control], '') <> ''
	AND ISNULL(WOCC.WorkOrderLocationID, '') <> ''
	AND ISNULL(WOCC.WorkOrderYear, NULL) IS NOT NULL
	AND ISNULL(WOCC.WorkOrderNumber, '') <> ''
	AND ISNULL(WOCC.TaskID, '') <> ''
	AND ISNULL(WOCC.WorkAccomplishedCode, '') <> ''
	AND WOCC.Dt IS NOT NULL
	AND ISNULL(WOCC.VendorID, '') <> ''
	AND WOCC.LaborCost IS NOT NULL
