--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	08/13/2015
--	Update Date:
--			CJB 10/15/2015 - Added new column and logic for 'UpdatePMSchedule'
--	Description:	Creates/modifies the spTransformWorkOrderCenterTasks stored procedure.
--					Populates the TransformWorkOrderCenterTasks table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformWorkOrderCenterTasks') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformWorkOrderCenterTasks AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformWorkOrderCenterTasks
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformWorkOrderCenterTasks
--	=================================================================================================
	IF OBJECT_ID('tmp.WorkOrderCenterTasks') IS NOT NULL
		DROP TABLE tmp.WorkOrderCenterTasks

	CREATE TABLE [tmp].[WorkOrderCenterTasks](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[WorkOrderLocationID] [varchar](10) NOT NULL,
		[WorkOrderYear] [int] NULL,
		[WorkOrderNumber] [varchar](15) NULL,
		[TaskID] [varchar](12) NULL,
		[WorkAccomplishedCode] [varchar](4) NULL,
		[UpdatePMSchedule] [varchar](4) NULL,
		[Comments] [varchar](1000) NULL
	)

	-- WORKORDERADMIN
	-- WorkOrderAdmin - OP_CODE1
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		lkup.TaskIDAlignment [TaskID],
		CASE
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HA.OP_CODE1 + ' - ' + lkup.[DESCRIPTION] [Comments]
	FROM SourceWicm250WorkOrderHeaderAdmin HA
		INNER JOIN TransformWorkOrderCenter woc ON HA.WO_NUMBER = woc.WorkOrderNumber
			AND HA.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode lkup ON HA.OP_CODE1 = lkup.OpCode
	WHERE ISNULL(HA.OP_CODE1, '') <> ''

	-- WorkOrderAdmin - OP_CODE2
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		lkup.TaskIDAlignment [TaskID],
		CASE
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HA.OP_CODE2 + ' - ' + lkup.[DESCRIPTION] [Comments]
	FROM SourceWicm250WorkOrderHeaderAdmin HA
		INNER JOIN TransformWorkOrderCenter woc ON HA.WO_NUMBER = woc.WorkOrderNumber
			AND HA.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode lkup ON HA.OP_CODE2 = lkup.OpCode
	WHERE ISNULL(HA.OP_CODE2, '') <> ''

	-- WorkOrderAdmin - OP_CODE3
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		lkup.TaskIDAlignment [TaskID],
		CASE
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HA.OP_CODE3 + ' - ' + lkup.[DESCRIPTION] [Comments]
	FROM SourceWicm250WorkOrderHeaderAdmin HA
		INNER JOIN TransformWorkOrderCenter woc ON HA.WO_NUMBER = woc.WorkOrderNumber
			AND HA.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode lkup ON HA.OP_CODE3 = lkup.OpCode
	WHERE ISNULL(HA.OP_CODE3, '') <> ''

	-- WorkOrderAdmin - LaborCharges
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		doc.TaskIDAlignment,
		CASE
			WHEN ha.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + DLP.OPER_CODE + ' - ' + doc.[Description] [Comments]
	FROM SourceWicm251WorkOrderDetailLaborCharges DLP
		INNER JOIN SourceWicm250WorkOrderHeaderAdmin ha ON DLP.WO_NUMBER = ha.WO_NUMBER AND DLP.LOCATION = ha.LOCATION
		INNER JOIN TransformWorkOrderCenter woc ON DLP.WO_NUMBER = woc.WorkOrderNumber
			AND DLP.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode doc ON DLP.OPER_CODE = doc.OpCode
	WHERE ISNULL(DLP.OPER_CODE, '') <> ''

	-- WORKORDERPROJECTS
	-- WorkOrderProjects - OP_CODE1
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		lkup.TaskIDAlignment [TaskID],
		CASE
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HP.OP_CODE1 + ' - ' + lkup.[Description] [Comments]
	FROM SourceWicm250WorkOrderHeaderProjects HP
		INNER JOIN TransformWorkOrderCenter woc ON HP.WO_NUMBER = woc.WorkOrderNumber
			AND HP.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode lkup ON HP.OP_CODE1 = lkup.OpCode
	WHERE ISNULL(HP.OP_CODE1, '') <> ''

	-- WorkOrderProjects - OP_CODE2
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		lkup.TaskIDAlignment [TaskID],
		CASE
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HP.OP_CODE2 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderProjects HP
		INNER JOIN TransformWorkOrderCenter woc ON HP.WO_NUMBER = woc.WorkOrderNumber
			AND HP.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode lkup ON HP.OP_CODE2 = lkup.OpCode
	WHERE ISNULL(HP.OP_CODE2, '') <> ''

	-- WorkOrderProjects - OP_CODE3
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		lkup.TaskIDAlignment [TaskID],
		CASE
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HP.OP_CODE3 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderProjects HP
		INNER JOIN TransformWorkOrderCenter woc ON HP.WO_NUMBER = woc.WorkOrderNumber
			AND HP.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode lkup ON HP.OP_CODE3 = lkup.OpCode
	WHERE ISNULL(HP.OP_CODE3, '') <> ''

	-- WorkOrderProjects - LaborCharges
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		doc.TaskIDAlignment,
		CASE
			WHEN hp.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + DLP.OPER_CODE + ' - ' + doc.[Description] [Comments]
	FROM SourceWicm251WorkOrderDetailLaborCharges DLP
		INNER JOIN SourceWicm250WorkOrderHeaderProjects hp ON DLP.WO_NUMBER = hp.WO_NUMBER AND DLP.LOCATION = hp.LOCATION
		INNER JOIN TransformWorkOrderCenter woc ON DLP.WO_NUMBER = woc.WorkOrderNumber
			AND DLP.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode doc ON DLP.OPER_CODE = doc.OpCode
	WHERE ISNULL(DLP.OPER_CODE, '') <> ''

	-- WORKORDERVEHICLESNEWSVCINSTALLREPAIR: Location = '04'
	-- WorkOrderVehiclesNewSvcInstallRepair - OP_CODE1
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		doc.TaskIDAlignment [TaskID],
		CASE
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HV.OP_CODE1 + ' - ' + doc.[DESCRIPTION] [Comments]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformWorkOrderCenter woc ON HV.WO_NUMBER = woc.WorkOrderNumber
			AND HV.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode doc ON HV.OP_CODE1 = doc.OpCode
	WHERE ISNULL(HV.OP_CODE1, '') <> ''
		AND HV.LOCATION = '04'
		AND HV.OP_CODE1 <> '1000'

	-- WorkOrderVehiclesNewSvcInstallRepair - OP_CODE2
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		doc.TaskIDAlignment [TaskID],
		CASE
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HV.OP_CODE2 + ' - ' + doc.[DESCRIPTION] [Comments]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformWorkOrderCenter woc ON HV.WO_NUMBER = woc.WorkOrderNumber
			AND HV.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode doc ON HV.OP_CODE2 = doc.OpCode
	WHERE ISNULL(HV.OP_CODE2, '') <> ''
		AND hv.LOCATION = '04'
		AND hv.OP_CODE1 <> '1000'

	-- WorkOrderVehiclesNewSvcInstallRepair - OP_CODE3
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		doc.TaskIDAlignment [TaskID],
		CASE
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HV.OP_CODE3 + ' - ' + doc.[DESCRIPTION] [Comments]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformWorkOrderCenter woc ON HV.WO_NUMBER = woc.WorkOrderNumber
			AND HV.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode doc ON HV.OP_CODE3 = doc.OpCode
	WHERE ISNULL(HV.OP_CODE3, '') <> ''
		AND hv.LOCATION = '04'
		AND hv.OP_CODE1 <> '1000'

	-- WorkOrderVehiclesNewSvcInstallRepair - LaborCharges
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		doc.TaskIDAlignment,
		CASE
			WHEN hv.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + DLP.OPER_CODE + ' - ' + doc.[Description] [Comments]
	FROM SourceWicm251WorkOrderDetailLaborCharges DLP
		INNER JOIN SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair hv ON DLP.WO_NUMBER = hv.WO_NUMBER
			AND DLP.LOCATION = hv.LOCATION
		INNER JOIN TransformWorkOrderCenter woc ON DLP.WO_NUMBER = woc.WorkOrderNumber
			AND DLP.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode doc ON DLP.OPER_CODE = doc.OpCode
	WHERE ISNULL(DLP.OPER_CODE, '') <> ''
		AND hv.LOCATION = '04'
		AND hv.OP_CODE1 <> '1000'

	-- WORKORDERPLANT
	-- WorkOrderPlant - OP_CODE1
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		CASE
			WHEN HP.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN HP.OP_CODE1 = 'ANNU' THEN 'IY01'
						WHEN HP.OP_CODE1 = 'SEMI' THEN 'IS01'
						ELSE HP.OP_CODE1
					END
			ELSE 'FGR'
		END [TaskID],
		HP.WO_STAGE [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HP.OP_CODE1 + ' - ' + lkup.[DESCRIPTION] [Comments]
	FROM SourceWicm250WorkOrderHeaderPlant HP
		INNER JOIN TransformWorkOrderCenter woc ON HP.WO_NUMBER = woc.WorkOrderNumber
			AND HP.LOCATION = woc.Location
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON HP.OP_CODE1 = lkup.OP_CODE
	WHERE ISNULL(HP.OP_CODE1, '') <> ''

	-- WorkOrderPlant - OP_CODE2
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		CASE
			WHEN HP.OP_CODE2 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN HP.OP_CODE2 = 'ANNU' THEN 'IY01'
						WHEN HP.OP_CODE2 = 'SEMI' THEN 'IS01'
						ELSE HP.OP_CODE2
					END
			ELSE 'FGR'
		END [TaskID],
		HP.WO_STAGE [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HP.OP_CODE2 + ' - ' + lkup.[DESCRIPTION] [Comments]
	FROM SourceWicm250WorkOrderHeaderPlant HP
		INNER JOIN TransformWorkOrderCenter woc ON HP.WO_NUMBER = woc.WorkOrderNumber
			AND HP.LOCATION = woc.Location
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON HP.OP_CODE2 = lkup.OP_CODE
	WHERE ISNULL(HP.OP_CODE2, '') <> ''

	-- WorkOrderPlant - OP_CODE3
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		CASE
			WHEN HP.OP_CODE3 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN HP.OP_CODE3 = 'ANNU' THEN 'IY01'
						WHEN HP.OP_CODE3 = 'SEMI' THEN 'IS01'
						ELSE HP.OP_CODE3
					END
			ELSE 'FGR'
		END [TaskID],
		HP.WO_STAGE [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HP.OP_CODE3 + ' - ' + lkup.[DESCRIPTION] [Comments]
	FROM SourceWicm250WorkOrderHeaderPlant HP
		INNER JOIN TransformWorkOrderCenter woc ON HP.WO_NUMBER = woc.WorkOrderNumber
			AND HP.LOCATION = woc.Location
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON HP.OP_CODE3 = lkup.OP_CODE
	WHERE ISNULL(HP.OP_CODE3, '') <> ''
	
	-- WorkOrderPlant - DetailLaborCharges
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		CASE
			WHEN DLP.OPER_CODE IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN DLP.OPER_CODE = 'ANNU' THEN 'IY01'
						WHEN DLP.OPER_CODE = 'SEMI' THEN 'IS01'
						ELSE DLP.OPER_CODE
					END
			ELSE 'FGR'
		END [TaskID],
		HP.WO_STAGE [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + DLP.OPER_CODE + ' - ' + lkup.[DESCRIPTION] [Comments]
	FROM SourceWicm251WorkOrderDetailLaborCharges DLP
		INNER JOIN SourceWicm250WorkOrderHeaderPlant hp ON DLP.WO_NUMBER = hp.WO_NUMBER
		INNER JOIN TransformWorkOrderCenter woc ON DLP.WO_NUMBER = woc.WorkOrderNumber
			AND DLP.LOCATION = woc.Location
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON DLP.OPER_CODE = lkup.OP_CODE
	ORDER BY woc.WorkOrderNumber
	
	-- WORKORDERVEHICLESNEWSVCINSTALLREPAIR: Location = '01'
	-- WorkOrderVehiclesNewSvcInstallRepair - OP_CODE1
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		gsoc.TaskIDAlignment [TaskID],
		CASE
			WHEN gsoc.RepairPM = 'PM' THEN 'PM'
			WHEN gsoc.RepairPM = 'REPAIR' THEN 'REPR'
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HV.OP_CODE1 + ' - ' + gsoc.[DESCRIPTION] [Comments]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformWorkOrderCenter woc ON HV.WO_NUMBER = woc.WorkOrderNumber
			AND HV.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderGSOpCode gsoc ON HV.OP_CODE1 = gsoc.OpCode
	WHERE ISNULL(HV.OP_CODE1, '') <> ''
		AND hv.LOCATION = '01'

	-- WorkOrderVehiclesNewSvcInstallRepair - OP_CODE2
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		gsoc.TaskIDAlignment [TaskID],
		CASE
			WHEN gsoc.RepairPM = 'PM' THEN 'PM'
			WHEN gsoc.RepairPM = 'REPAIR' THEN 'REPR'
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HV.OP_CODE1 + ' - ' + gsoc.[DESCRIPTION] [Comments]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformWorkOrderCenter woc ON HV.WO_NUMBER = woc.WorkOrderNumber
			AND HV.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderGSOpCode gsoc ON HV.OP_CODE2 = gsoc.OpCode
	WHERE ISNULL(HV.OP_CODE2, '') <> ''
		AND hv.LOCATION = '01'

	-- WorkOrderVehiclesNewSvcInstallRepair - OP_CODE3
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		gsoc.TaskIDAlignment [TaskID],
		CASE
			WHEN gsoc.RepairPM = 'PM' THEN 'PM'
			WHEN gsoc.RepairPM = 'REPAIR' THEN 'REPR'
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + HV.OP_CODE1 + ' - ' + gsoc.[DESCRIPTION] [Comments]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformWorkOrderCenter woc ON HV.WO_NUMBER = woc.WorkOrderNumber
			AND HV.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderGSOpCode gsoc ON HV.OP_CODE3 = gsoc.OpCode
	WHERE ISNULL(HV.OP_CODE3, '') <> ''
		AND hv.LOCATION = '01'

	-- WorkOrderVehiclesNewSvcInstallRepair - LaborCharges
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber, gsoc.TaskIDAlignment,
		CASE
			WHEN gsoc.RepairPM = 'PM' THEN 'PM'
			WHEN gsoc.RepairPM = 'REPAIR' THEN 'REPR'
		END [WorkAccomplishedCode],
		'NO' [UpdatePMSchedule],
		'WICM OP_CODE: ' + DLP.OPER_CODE + ' - ' + gsoc.[Description] [Comments]
	FROM SourceWicm251WorkOrderDetailLaborCharges DLP
		INNER JOIN SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair hv ON
			DLP.WO_NUMBER = hv.WO_NUMBER AND DLP.LOCATION = hv.LOCATION
		INNER JOIN TransformWorkOrderCenter woc ON DLP.WO_NUMBER = woc.WorkOrderNumber
			AND DLP.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderGSOpCode gsoc ON DLP.OPER_CODE = gsoc.OpCode
	WHERE ISNULL(DLP.OPER_CODE, '') <> ''
		AND hv.LOCATION = '01'
	ORDER BY woc.WorkOrderNumber

	-- Copy temp to TransformWorkOrderCenterTasks
	INSERT INTO TransformWorkOrderCenterTasks
	SELECT DISTINCT
		'[i]' [Control],
		tmp.WorkOrderLocationID,
		tmp.WorkOrderYear,
		tmp.WorkOrderNumber,
		tmp.TaskID,
		tmp.WorkAccomplishedCode,
		tmp.UpdatePMSchedule,
		tmp.Comments,
		GETDATE()
	FROM tmp.WorkOrderCenterTasks tmp
END
