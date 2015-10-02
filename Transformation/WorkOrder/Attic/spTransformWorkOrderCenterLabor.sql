--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	08/14/2015
--	Updates:
--	Description:	Creates/modifies the spTransformWorkOrderCenterLabor stored procedure.
--					Populates the TransformWorkOrderCenterLabor table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformWorkOrderCenterLabor') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformWorkOrderCenterLabor AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformWorkOrderCenterLabor
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformWorkOrderCenterLabor
--	=================================================================================================
	IF OBJECT_ID('tmp.WorkOrderCenterLabor') IS NOT NULL
		DROP TABLE tmp.WorkOrderCenterLabor

	CREATE TABLE [tmp].[WorkOrderCenterLabor](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[WorkOrderLocationID] [varchar](10) NOT NULL,
		[WorkOrderYear] [int] NULL,
		[WorkOrderNumber] [varchar](15) NULL,
		[TaskID] [varchar](12) NULL,
		[WorkAccomplishedCode] [varchar](4) NULL,
		[LaborDt] [datetime] NULL,
		[EmployeeID] [varchar](9) NULL,
		[LaborHours] [decimal](5,2) NULL,
		[TimeCode] [varchar](8) NULL
	)

	-- WORKORDERADMIN
	INSERT INTO [tmp].[WorkOrderCenterLabor]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		doc.TaskIDAlignment,
		CASE
			WHEN ha.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		CASE
			WHEN ISDATE(DLP.LABOR_DATE) = 0 THEN
				CAST(woc.WorkOrderYear AS VARCHAR(4)) + RIGHT(DLP.LABOR_DATE, 4)
			ELSE DLP.LABOR_DATE
		END [LaborDt],
		'' [EmployeeID],		-- TBD
		CONVERT(DECIMAL(5,2), DLP.REG_HOURS) [LaborHours],
		'' [TimeCode]			-- TBD
	FROM SourceWicm251WorkOrderDetailLaborCharges DLP
		INNER JOIN SourceWicm250WorkOrderHeaderAdmin ha ON DLP.WO_NUMBER = ha.WO_NUMBER
		INNER JOIN TransformWorkOrderCenter woc ON DLP.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN TransformWorkOrderDistOpCode doc ON DLP.OPER_CODE = doc.OpCode
	WHERE ISNULL(DLP.OPER_CODE, '') <> ''

	-- WORKORDERPROJECTS
	INSERT INTO [tmp].[WorkOrderCenterLabor]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		doc.TaskIDAlignment,
		CASE
			WHEN hp.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		CASE
			WHEN ISDATE(DLP.LABOR_DATE) = 0 THEN
				CAST(woc.WorkOrderYear AS VARCHAR(4)) + RIGHT(DLP.LABOR_DATE, 4)
			ELSE DLP.LABOR_DATE
		END [LaborDt],
		'' [EmployeeID],		-- TBD
		CONVERT(DECIMAL(5,2), DLP.REG_HOURS) [LaborHours],
		'' [TimeCode]			-- TBD
	FROM SourceWicm251WorkOrderDetailLaborCharges DLP
		INNER JOIN SourceWicm250WorkOrderHeaderProjects hp ON DLP.WO_NUMBER = hp.WO_NUMBER
		INNER JOIN TransformWorkOrderCenter woc ON DLP.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN TransformWorkOrderDistOpCode doc ON DLP.OPER_CODE = doc.OpCode
	WHERE ISNULL(DLP.OPER_CODE, '') <> ''

	-- WORKORDERVEHICLESNEWSVCINSTALLREPAIR: Location = '04'
	INSERT INTO [tmp].[WorkOrderCenterLabor]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		doc.TaskIDAlignment,
		CASE
			WHEN hv.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		CASE
			WHEN ISDATE(DLP.LABOR_DATE) = 0 THEN
				CAST(woc.WorkOrderYear AS VARCHAR(4)) + RIGHT(DLP.LABOR_DATE, 4)
			ELSE DLP.LABOR_DATE
		END [LaborDt],
		'' [EmployeeID],		-- TBD
		CONVERT(DECIMAL(5,2), DLP.REG_HOURS) [LaborHours],
		'' [TimeCode]			-- TBD
	FROM SourceWicm251WorkOrderDetailLaborCharges DLP
		INNER JOIN SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair hv ON DLP.WO_NUMBER = hv.WO_NUMBER
		INNER JOIN TransformWorkOrderCenter woc ON DLP.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN TransformWorkOrderDistOpCode doc ON DLP.OPER_CODE = doc.OpCode
	WHERE ISNULL(DLP.OPER_CODE, '') <> ''
		AND hv.LOCATION = '04'
		AND hv.OP_CODE1 <> '1000'

	-- WORKORDERPLANT
	INSERT INTO [tmp].[WorkOrderCenterLabor]
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
		hp.WO_STAGE [WorkAccomplishedCode],
		CASE
			WHEN ISDATE(DLP.LABOR_DATE) = 0 THEN
				CAST(woc.WorkOrderYear AS VARCHAR(4)) + RIGHT(DLP.LABOR_DATE, 4)
			ELSE DLP.LABOR_DATE
		END [LaborDt],
		'' [EmployeeID],		-- TBD
		CONVERT(DECIMAL(5,2), DLP.REG_HOURS) [LaborHours],
		'' [TimeCode]			-- TBD
	FROM SourceWicm251WorkOrderDetailLaborCharges DLP
		INNER JOIN SourceWicm250WorkOrderHeaderPlant hp ON DLP.WO_NUMBER = hp.WO_NUMBER
		INNER JOIN TransformWorkOrderCenter woc ON DLP.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN TransformWorkOrderDistOpCode doc ON DLP.OPER_CODE = doc.OpCode
	WHERE ISNULL(DLP.OPER_CODE, '') <> ''

	-- WORKORDERVEHICLESNEWSVCINSTALLREPAIR: Location = '01'
	INSERT INTO [tmp].[WorkOrderCenterLabor]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		gsoc.TaskIDAlignment [TaskID],
		CASE
			WHEN gsoc.RepairPM = 'PM' THEN 'PM'
			WHEN gsoc.RepairPM = 'REPAIR' THEN 'REPR'
		END [WorkAccomplishedCode],
		CASE
			WHEN ISDATE(DLP.LABOR_DATE) = 0 THEN
				CAST(woc.WorkOrderYear AS VARCHAR(4)) + RIGHT(DLP.LABOR_DATE, 4)
			ELSE DLP.LABOR_DATE
		END [LaborDt],
		'' [EmployeeID],		-- TBD
		CONVERT(DECIMAL(5,2), DLP.REG_HOURS) [LaborHours],
		'' [TimeCode]			-- TBD
	FROM SourceWicm251WorkOrderDetailLaborCharges DLP
		INNER JOIN SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair hv ON DLP.WO_NUMBER = hv.WO_NUMBER
		INNER JOIN TransformWorkOrderCenter woc ON DLP.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN TransformWorkOrderGSOpCode gsoc ON DLP.OPER_CODE = gsoc.OpCode
	WHERE ISNULL(DLP.OPER_CODE, '') <> ''
		AND hv.LOCATION = '01'
	
	-- Copy temp to TransformWorkOrderCenterLabor
	INSERT INTO TransformWorkOrderCenterLabor
	SELECT DISTINCT
		'[i]' [Control],
		tmp.WorkOrderLocationID,
		tmp.WorkOrderYear,
		tmp.WorkOrderNumber,
		tmp.TaskID,
		tmp.WorkAccomplishedCode,
		tmp.LaborDt,
		tmp.EmployeeID,
		tmp.LaborHours,
		tmp.TimeCode,
		GETDATE()
	FROM tmp.WorkOrderCenterLabor tmp
END
