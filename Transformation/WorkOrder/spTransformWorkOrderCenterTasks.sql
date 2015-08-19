--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	08/13/2015
--	Updates:
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
		[Comments] [varchar](1000) NULL
	)

	-- WORKORDERADMIN
	-- WorkOrderAdmin - OP_CODE1
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		CASE
			WHEN HA.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN HA.OP_CODE1 = 'ANNU' THEN 'IY01'
						WHEN HA.OP_CODE1 = 'SEMI' THEN 'IS01'
						ELSE HA.OP_CODE1
					END
			ELSE 'FGR'
		END [TaskID],
		CASE
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'WICM OP_CODE: ' + HA.OP_CODE1 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderAdmin HA
		INNER JOIN TransformWorkOrderCenter woc ON HA.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON HA.OP_CODE1 = lkup.OP_CODE
	WHERE ISNULL(HA.OP_CODE1, '') <> ''

	-- WorkOrderAdmin - OP_CODE2
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		CASE
			WHEN HA.OP_CODE2 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN HA.OP_CODE2 = 'ANNU' THEN 'IY01'
						WHEN HA.OP_CODE2 = 'SEMI' THEN 'IS01'
						ELSE HA.OP_CODE2
					END
			ELSE 'FGR'
		END [TaskID],
		CASE
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'WICM OP_CODE: ' + HA.OP_CODE2 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderAdmin HA
		INNER JOIN TransformWorkOrderCenter woc ON HA.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON HA.OP_CODE2 = lkup.OP_CODE
	WHERE ISNULL(HA.OP_CODE2, '') <> ''

	-- WorkOrderAdmin - OP_CODE3
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		CASE
			WHEN HA.OP_CODE3 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN HA.OP_CODE3 = 'ANNU' THEN 'IY01'
						WHEN HA.OP_CODE3 = 'SEMI' THEN 'IS01'
						ELSE HA.OP_CODE3
					END
			ELSE 'FGR'
		END [TaskID],
		CASE
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'WICM OP_CODE: ' + HA.OP_CODE3 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderAdmin HA
		INNER JOIN TransformWorkOrderCenter woc ON HA.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON HA.OP_CODE3 = lkup.OP_CODE
	WHERE ISNULL(HA.OP_CODE3, '') <> ''

	-- WORKORDERPROJECTS
	-- WorkOrderProjects - OP_CODE1
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
		CASE
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'WICM OP_CODE: ' + HP.OP_CODE1 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderProjects HP
		INNER JOIN TransformWorkOrderCenter woc ON HP.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON HP.OP_CODE1 = lkup.OP_CODE
	WHERE ISNULL(HP.OP_CODE1, '') <> ''

	-- WorkOrderProjects - OP_CODE2
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
		CASE
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'WICM OP_CODE: ' + HP.OP_CODE2 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderProjects HP
		INNER JOIN TransformWorkOrderCenter woc ON HP.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON HP.OP_CODE2 = lkup.OP_CODE
	WHERE ISNULL(HP.OP_CODE2, '') <> ''

	-- WorkOrderProjects - OP_CODE3
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
		CASE
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		'WICM OP_CODE: ' + HP.OP_CODE3 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderProjects HP
		INNER JOIN TransformWorkOrderCenter woc ON HP.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON HP.OP_CODE3 = lkup.OP_CODE
	WHERE ISNULL(HP.OP_CODE3, '') <> ''

	-- WORKORDERVEHICLESNEWSVCINSTALLREPAIR
	-- WorkOrderVehiclesNewSvcInstallRepair - OP_CODE1
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		CASE
			WHEN HV.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN HV.OP_CODE1 = 'ANNU' THEN 'IY01'
						WHEN HV.OP_CODE1 = 'SEMI' THEN 'IS01'
						ELSE HV.OP_CODE1
					END
			ELSE 'FGR'
		END [TaskID],
		CASE
			WHEN opc.RepairPM = 'PM' THEN 'PM'
			WHEN opc.RepairPM = 'REPAIR' THEN 'REPR'
		END [WorkAccomplishedCode],
		'WICM OP_CODE: ' + HV.OP_CODE1 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformWorkOrderCenter woc ON HV.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON HV.OP_CODE1 = lkup.OP_CODE
		INNER JOIN TransformWorkOrderGSOpCode opc ON HV.OP_CODE1 = opc.OpCode
	WHERE ISNULL(HV.OP_CODE1, '') <> ''

	-- WorkOrderVehiclesNewSvcInstallRepair - OP_CODE2
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		CASE
			WHEN HV.OP_CODE2 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN HV.OP_CODE2 = 'ANNU' THEN 'IY01'
						WHEN HV.OP_CODE2 = 'SEMI' THEN 'IS01'
						ELSE HV.OP_CODE2
					END
			ELSE 'FGR'
		END [TaskID],
		CASE
			WHEN opc.RepairPM = 'PM' THEN 'PM'
			WHEN opc.RepairPM = 'REPAIR' THEN 'REPR'
		END [WorkAccomplishedCode],
		'WICM OP_CODE: ' + HV.OP_CODE2 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformWorkOrderCenter woc ON HV.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON HV.OP_CODE2 = lkup.OP_CODE
		INNER JOIN TransformWorkOrderGSOpCode opc ON HV.OP_CODE2 = opc.OpCode
	WHERE ISNULL(HV.OP_CODE2, '') <> ''

	-- WorkOrderVehiclesNewSvcInstallRepair - OP_CODE3
	INSERT INTO [tmp].[WorkOrderCenterTasks]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		CASE
			WHEN HV.OP_CODE3 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN HV.OP_CODE3 = 'ANNU' THEN 'IY01'
						WHEN HV.OP_CODE3 = 'SEMI' THEN 'IS01'
						ELSE HV.OP_CODE3
					END
			ELSE 'FGR'
		END [TaskID],
		CASE
			WHEN opc.RepairPM = 'PM' THEN 'PM'
			WHEN opc.RepairPM = 'REPAIR' THEN 'REPR'
		END [WorkAccomplishedCode],
		'WICM OP_CODE: ' + HV.OP_CODE3 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformWorkOrderCenter woc ON HV.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON HV.OP_CODE3 = lkup.OP_CODE
		INNER JOIN TransformWorkOrderGSOpCode opc ON HV.OP_CODE3 = opc.OpCode
	WHERE ISNULL(HV.OP_CODE3, '') <> ''

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
		'WICM OP_CODE: ' + HP.OP_CODE1 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderPlant HP
		INNER JOIN TransformWorkOrderCenter woc ON HP.WO_NUMBER = woc.WorkOrderNumber
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
		'WICM OP_CODE: ' + HP.OP_CODE2 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderPlant HP
		INNER JOIN TransformWorkOrderCenter woc ON HP.WO_NUMBER = woc.WorkOrderNumber
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
		'WICM OP_CODE: ' + HP.OP_CODE3 + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm250WorkOrderHeaderPlant HP
		INNER JOIN TransformWorkOrderCenter woc ON HP.WO_NUMBER = woc.WorkOrderNumber
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
		HP.WO_STAGE,
		'WICM OP_CODE: ' + DLP.OPER_CODE + ' - ' + lkup.[DESCRIPTION] [Description]
	FROM SourceWicm251WorkOrderDetailLaborCharges DLP
		INNER JOIN SourceWicm250WorkOrderHeaderPlant hp ON DLP.WO_NUMBER = hp.WO_NUMBER
		INNER JOIN TransformWorkOrderCenter woc ON DLP.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN SourceWicm230TableLookupOperationCodes lkup ON DLP.OPER_CODE = lkup.OP_CODE
	ORDER BY woc.WorkOrderNumber
	
	-- Copy temp to TransformWorkOrderCenterTasks
	INSERT INTO TransformWorkOrderCenterTasks
	SELECT
		'[i]' [Control],
		tmp.WorkOrderLocationID,
		tmp.WorkOrderYear,
		tmp.WorkOrderNumber,
		tmp.TaskID,
		tmp.WorkAccomplishedCode,
		tmp.Comments,
		GETDATE()
	FROM tmp.WorkOrderCenterTasks tmp
END
