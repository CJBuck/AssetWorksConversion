SELECT
	'2037' [SCREEN],
	'188:2' [WorkOrderLocationID], '188:3' [WorkOrderYear], '188:4' [WorkOrderNumber],
	'188:8' [JobStatus], '189:2' [JobType], '189:6' [EquipmentID], '189:9' [Meter1],
	'189:11' [Meter2], '189:18' [PriorityID], '189:25' [PMService], '189:27' [PMScheduled],
	'189:31' [RepairReasonID], '189:38' [OutOfServiceDt], '189:40' [InDt], '189:42' [DueDt],
	'189:45' [OpenedDt], '189:47' [FirstLaborDt], '189:50' [ShowDowntimeBeginDt],
	'189:61' [FinishWorkOrder], '189:62' [FinishedDt], '189:64' [CloseWorkOrder],
	'189:65' [ClosedDt], '189:80' [InService], '189:81' [InServiceDt], '189:15' [AccountID],
	'189:34' [WorkClass], '189:36' [WarrantyWork], '8065:2' [Complaint], '8065:4' [Cause],
	'8065:6' [Correction], '[GROUPROW]' [Tasks], '[GROUPROW]' [Labor],
	'[GROUPROW]' [Parts], '[GROUPROW]' [Commercial]
UNION ALL
SELECT
	[Control],
	[WorkOrderLocationID], 
	CAST([WorkOrderYear] AS VARCHAR), [WorkOrderNumber],
	[JobStatus], [JobType], [EquipmentID],
	CAST([Meter1] AS VARCHAR),
	CAST([Meter2] AS VARCHAR),
	[PriorityID], [PMService],
	[PMScheduled],
	[RepairReasonID],
	ISNULL((CONVERT(VARCHAR(10), CAST(OutOfServiceDt AS DATE), 101)), '') [OutOfServiceDt],
	[InDt], [DueDt],
	[OpenedDt], [FirstLaborDt], [ShowDowntimeBeginDt],
	[FinishWorkOrder], [FinishedDt], [CloseWorkOrder],
	[ClosedDt], [InService], [InServiceDt], [AccountID],
	[WorkClass], [WarrantyWork], [Complaint], [Cause],
	'8065:6' [Correction], '[GROUPROW]' [Tasks], '[GROUPROW]' [Labor],
	'[GROUPROW]' [Parts], '[GROUPROW]' [Commercial]
FROM TargetWorkOrderCenter
