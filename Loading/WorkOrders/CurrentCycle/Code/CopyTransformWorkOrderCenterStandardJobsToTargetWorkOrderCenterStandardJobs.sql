INSERT INTO TargetWorkOrderCenterStandardJobs
SELECT
	[Control], WorkOrderLocationID, WorkOrderYear, WorkOrderNumber, StandardJobID, GETDATE()
FROM TransformWorkOrderCenterStandardJobs SJ
WHERE
	ISNULL(SJ.[Control], '') <> ''
	AND ISNULL(SJ.WorkOrderLocationID, '') <> ''
	AND ISNULL(SJ.WorkOrderYear, NULL) IS NOT NULL
	AND ISNULL(SJ.WorkOrderNumber, '') <> ''
	AND ISNULL(SJ.StandardJobID, '') <> ''
