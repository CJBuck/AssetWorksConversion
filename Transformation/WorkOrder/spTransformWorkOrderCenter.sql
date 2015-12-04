--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	07/29/2015
--	Update Date:
--			CJB 10/15/2015 - Added new column and logic for 'PMScheduled'.
--			CJB 11/30/2015 - Modified the Location exclusion from
--					SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair.
--	Description:	Creates/modifies the spTransformWorkOrderCenter stored procedure.  Populates
--					the TransportWorkOrderCenter table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformWorkOrderCenter') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformWorkOrderCenter AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformWorkOrderCenter
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformWorkOrderCenter
--	=================================================================================================
	IF OBJECT_ID('tmp.WorkOrderCenter') IS NOT NULL
		DROP TABLE tmp.WorkOrderCenter

	CREATE TABLE [tmp].[WorkOrderCenter](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[Object_ID] [varchar](25) NULL,
		[Location] [varchar](2) NULL,
		[WorkOrderLocationID] [varchar](10) NOT NULL,
		[WorkOrderYear] [int] NULL,
		[WorkOrderNumber] [varchar](15) NULL,
		[JobStatus] [varchar](20) NULL,
		[JobType] [varchar](8) NULL,
		[EquipmentID] [varchar](20) NULL,
		[Meter1] [int] NULL,
		[Meter2] [int] NULL,
		[PriorityID] [varchar](2) NULL,
		[PMService] [varchar](12) NULL,
		[PMScheduled] [datetime] NULL,
		[RepairReasonID] [varchar](4) NULL,
		[OutOfServiceDt] [datetime] NULL,
		[InDt] [datetime] NULL,
		[DueDt] [datetime] NULL,
		[OpenedDt] [datetime] NULL,
		[FirstLaborDt] [datetime] NULL,
		[ShowDowntimeBeginDt] [datetime] NULL,
		[FinishWorkOrder] [char](1) NULL,
		[FinishedDt] [datetime] NULL,
		[CloseWorkOrder] [char](1) NULL,
		[ClosedDt] [datetime] NULL,
		[InService] [char](1) NULL,
		[InServiceDt] [datetime] NULL,
		[AccountID] [varchar](30) NULL,
		[WorkClass] [char](1) NULL,
		[WarrantyWork] [varchar](15) NULL,
		[Complaint] [varchar](1000) NULL,
		[Cause] [varchar](1000) NULL,
		[Correction] [varchar](1000) NULL,
		[Tasks] [varchar](30) NULL,
		[Labor] [varchar](30) NULL,
		[Parts] [varchar](30) NULL,
		[Commercial] [varchar](30) NULL
	)

	-- Distribution - in TransformEquipmentLegacyXwalk
	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		xwalk.LegacyID [Object_ID],
		HA.LOCATION,
		'D-ADMIN' [WorkOrderLocationID],
		YEAR(HA.WO_INDATE) [WorkOrderYear],
		HA.WO_NUMBER [WorkOrderNumber],
		CASE
			WHEN HA.[STATUS] = 'A' THEN 'OPEN'
			WHEN HA.[STATUS] = 'P' THEN 'PENDING'
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		'REPAIR' [JobType],
		xwalk.EquipmentID,
		NULL [Meter1],
		NULL [Meter2],
		'D8' [PriorityID],
		'' [PMService],
		NULL [PMScheduled],
		'PT' [RepairReasonID],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [InDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN NULL
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HA.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HA.WO_OUTDATE + ' ' + LEFT(HA.TIME_OUT, 2) + ':' + SUBSTRING(HA.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [OpenedDt],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [FirstLaborDt],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [ShowDowntimeBeginDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN 'N'
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN ISDATE(HA.WO_OUTDATE) = 1
				THEN CONVERT(DATETIME, (HA.WO_OUTDATE + ' ' + LEFT(HA.TIME_OUT, 2) + ':' + SUBSTRING(HA.TIME_OUT, 3, 2)), 101)
			ELSE NULL
		END [FinishedDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN 'N'
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN NULL
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HA.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HA.WO_OUTDATE + ' ' + LEFT(HA.TIME_OUT, 2) + ':' + SUBSTRING(HA.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN 'N'
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN NULL
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HA.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HA.WO_OUTDATE + ' ' + LEFT(HA.TIME_OUT, 2) + ':' + SUBSTRING(HA.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		'2' [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HA.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HA.PROB_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(HA.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HA.FIX_DESC2)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderAdmin HA
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON HA.[OBJECT_ID] = xwalk.LegacyID
			AND [Source] = 'SourceWicm210ObjectProject'
	WHERE HA.[OBJECT_ID] NOT LIKE 'LV%'
		AND HA.LOCATION = '04'

	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		xwalk.LegacyID [Object_ID],
		HP.LOCATION,
		'D-ADMIN' [WorkOrderLocationID],
		YEAR(HP.WO_INDATE) [WorkOrderYear],
		HP.WO_NUMBER [WorkOrderNumber],
		CASE
			WHEN HP.[STATUS] = 'A' THEN 'OPEN'
			WHEN HP.[STATUS] = 'P' THEN 'PENDING'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		'REPAIR' [JobType],
		xwalk.EquipmentID,
		NULL [Meter1],
		NULL [Meter2],
		'D4' [PriorityID],
		'' [PMService],
		NULL [PMScheduled],
		LTRIM(RTRIM(HP.[CLASS])) [RepairReasonID],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [InDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [OpenedDt],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [FirstLaborDt],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [ShowDowntimeBeginDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN ISDATE(HP.WO_OUTDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
			ELSE NULL
		END [FinishedDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL		-- TBD
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		'2' [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HP.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HP.PROB_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(HP.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HP.FIX_DESC2)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderProjects HP
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON HP.[OBJECT_ID] = xwalk.LegacyID
			AND [Source] = 'SourceWicm210ObjectProject'
	WHERE HP.[OBJECT_ID] NOT LIKE 'LV%'
		AND HP.LOCATION = '04'

	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		xwalk.LegacyID [Object_ID],
		HV.LOCATION,
		CASE
			WHEN HV.[LOCATION] = '04' AND HV.WO_TYPE = 'X2' THEN 'D-INSTALL'
			WHEN HV.[LOCATION] = '04' AND HV.WO_TYPE = 'X6' THEN 'D-REPAIR'
			ELSE ''
		END [WorkOrderLocationID],
		YEAR(HV.WO_INDATE) [WorkOrderYear],
		HV.WO_NUMBER [WorkOrderNumber],
		CASE
			WHEN HV.[STATUS] = 'A' THEN 'OPEN'
			WHEN HV.[STATUS] = 'P' THEN 'PENDING'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		'REPAIR' [JobType],
		xwalk.EquipmentID,
		NULL [Meter1],
		NULL [Meter2],
		'D4' [PriorityID],
		'' [PMService],
		NULL [PMScheduled],
		LTRIM(RTRIM(HV.[CLASS])) [RepairReasonID],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [InDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [OpenedDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [FirstLaborDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [ShowDowntimeBeginDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN ISDATE(HV.WO_OUTDATE) = 1
				THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
			ELSE NULL
		END [FinishedDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		'2' [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HV.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HV.PROB_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(HV.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HV.FIX_DESC2)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON HV.[OBJECT_ID] = xwalk.LegacyID
			AND [Source] = 'SourceWicm210ObjectProject'
	WHERE HV.[OBJECT_ID] NOT LIKE 'LV%'
		AND HV.LOCATION <> '04' AND HV.OP_CODE1 <> '1000'

	-- Distribution - NOT in TransformEquipmentLegacyXwalk
	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		HA.[OBJECT_ID] [Object_ID],
		HA.LOCATION,
		'D-ADMIN' [WorkOrderLocationID],
		YEAR(HA.WO_INDATE) [WorkOrderYear],
		HA.WO_NUMBER [WorkOrderNumber],
		CASE
			WHEN HA.[STATUS] = 'A' THEN 'OPEN'
			WHEN HA.[STATUS] = 'P' THEN 'PENDING'
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		'REPAIR' [JobType],
		'' [EquipmentID],	-- Fails validation per spec.
		NULL [Meter1],
		NULL [Meter2],
		'D8' [PriorityID],
		'' [PMService],
		NULL [PMScheduled],
		'PT' [RepairReasonID],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [InDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN NULL
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HA.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HA.WO_OUTDATE + ' ' + LEFT(HA.TIME_OUT, 2) + ':' + SUBSTRING(HA.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [OpenedDt],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [FirstLaborDt],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [ShowDowntimeBeginDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN 'N'
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN ISDATE(HA.WO_OUTDATE) = 1
				THEN CONVERT(DATETIME, (HA.WO_OUTDATE + ' ' + LEFT(HA.TIME_OUT, 2) + ':' + SUBSTRING(HA.TIME_OUT, 3, 2)), 101)
			ELSE NULL
		END [FinishedDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN 'N'
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN NULL
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HA.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HA.WO_OUTDATE + ' ' + LEFT(HA.TIME_OUT, 2) + ':' + SUBSTRING(HA.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN 'N'
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN NULL
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HA.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HA.WO_OUTDATE + ' ' + LEFT(HA.TIME_OUT, 2) + ':' + SUBSTRING(HA.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		'2' [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HA.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HA.PROB_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(HA.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HA.FIX_DESC2)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderAdmin HA
	WHERE
		HA.[OBJECT_ID] NOT IN (SELECT LegacyID FROM TransformEquipmentLegacyXwalk WHERE [Source] = 'SourceWicm210ObjectProject')
		AND HA.[OBJECT_ID] NOT LIKE 'LV%'
		AND HA.[STATUS] = 'A'
		AND HA.LOCATION = '04'

	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		HP.[OBJECT_ID] [Object_ID],
		HP.LOCATION,
		'D-ADMIN' [WorkOrderLocationID],
		YEAR(HP.WO_INDATE) [WorkOrderYear],
		HP.WO_NUMBER [WorkOrderNumber],
		CASE
			WHEN HP.[STATUS] = 'A' THEN 'OPEN'
			WHEN HP.[STATUS] = 'P' THEN 'PENDING'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		'REPAIR' [JobType],
		'' [EquipmentID],
		NULL [Meter1],
		NULL [Meter2],
		'D4' [PriorityID],
		'' [PMService],
		NULL [PMScheduled],
		LTRIM(RTRIM(HP.[CLASS])) [RepairReasonID],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [InDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [OpenedDt],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [FirstLaborDt],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [ShowDowntimeBeginDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN ISDATE(HP.WO_OUTDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
			ELSE NULL
		END [FinishedDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL		-- TBD
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		'2' [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HP.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HP.PROB_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(HP.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HP.FIX_DESC2)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderProjects HP
	WHERE
		HP.[OBJECT_ID] NOT IN (SELECT LegacyID FROM TransformEquipmentLegacyXwalk WHERE [Source] = 'SourceWicm210ObjectProject')
		AND HP.[OBJECT_ID] NOT LIKE 'LV%'
		AND HP.[STATUS] = 'A'
		AND HP.LOCATION = '04'

	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		HV.[OBJECT_ID] [Object_ID],
		HV.LOCATION,
		CASE
			WHEN HV.[LOCATION] = '04' AND HV.WO_TYPE = 'X2' THEN 'D-INSTALL'
			WHEN HV.[LOCATION] = '04' AND HV.WO_TYPE = 'X6' THEN 'D-REPAIR'
			ELSE ''
		END [WorkOrderLocationID],
		YEAR(HV.WO_INDATE) [WorkOrderYear],
		HV.WO_NUMBER [WorkOrderNumber],
		CASE
			WHEN HV.[STATUS] = 'A' THEN 'OPEN'
			WHEN HV.[STATUS] = 'P' THEN 'PENDING'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		'REPAIR' [JobType],
		'' [EquipmentID],
		NULL [Meter1],
		NULL [Meter2],
		'D4' [PriorityID],
		'' [PMService],
		NULL [PMScheduled],
		LTRIM(RTRIM(HV.[CLASS])) [RepairReasonID],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [InDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [OpenedDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [FirstLaborDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [ShowDowntimeBeginDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN ISDATE(HV.WO_OUTDATE) = 1
				THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
			ELSE NULL
		END [FinishedDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		'2' [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HV.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HV.PROB_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(HV.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HV.FIX_DESC2)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
	WHERE
		HV.[OBJECT_ID] NOT IN (SELECT LegacyID FROM TransformEquipmentLegacyXwalk WHERE [Source] = 'SourceWicm210ObjectProject')
		AND HV.[OBJECT_ID] NOT LIKE 'LV%'
		AND HV.[STATUS] = 'A'
		AND HV.LOCATION <> '04'
		AND HV.OP_CODE1 <> '1000'

	-- Distribution - Closed WOs
	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		HA.[OBJECT_ID] [Object_ID],
		HA.LOCATION,
		'D-ADMIN' [WorkOrderLocationID],
		YEAR(HA.WO_INDATE) [WorkOrderYear],
		HA.WO_NUMBER [WorkOrderNumber],
		'CLOSED' [JobStatus],
		'REPAIR' [JobType],
		'' [EquipmentID],	-- Fails validation per spec.
		NULL [Meter1],
		NULL [Meter2],
		'D4' [PriorityID],
		'' [PMService],
		NULL [PMScheduled],
		'NSR' [RepairReasonID],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [InDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN NULL
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HA.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HA.WO_OUTDATE + ' ' + LEFT(HA.TIME_OUT, 2) + ':' + SUBSTRING(HA.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [OpenedDt],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [FirstLaborDt],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [ShowDowntimeBeginDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN 'N'
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN ISDATE(HA.WO_OUTDATE) = 1
				THEN CONVERT(DATETIME, (HA.WO_OUTDATE + ' ' + LEFT(HA.TIME_OUT, 2) + ':' + SUBSTRING(HA.TIME_OUT, 3, 2)), 101)
			ELSE NULL
		END [FinishedDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN 'N'
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN NULL
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HA.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HA.WO_OUTDATE + ' ' + LEFT(HA.TIME_OUT, 2) + ':' + SUBSTRING(HA.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN 'N'
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN NULL
			WHEN HA.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HA.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HA.WO_OUTDATE + ' ' + LEFT(HA.TIME_OUT, 2) + ':' + SUBSTRING(HA.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		'2' [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HA.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HA.PROB_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(HA.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HA.FIX_DESC2)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderAdmin HA
	WHERE
		HA.WO_NUMBER NOT IN (SELECT WorkOrderNumber FROM [tmp].[WorkOrderCenter])
		AND HA.[OBJECT_ID] NOT LIKE 'LV%'
		AND HA.[STATUS] IN ('C', 'D', 'U', 'I')
		AND (HA.WO_INDATE > '7/1/2015' OR HA.WO_OUTDATE > '7/1/2015')

	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		HP.[OBJECT_ID] [Object_ID],
		HP.LOCATION,
		'D-ADMIN' [WorkOrderLocationID],
		YEAR(HP.WO_INDATE) [WorkOrderYear],
		HP.WO_NUMBER [WorkOrderNumber],
		'CLOSED' [JobStatus],
		'REPAIR' [JobType],
		'' [EquipmentID],	-- Fails validation per spec.
		NULL [Meter1],
		NULL [Meter2],
		'D4' [PriorityID],
		'' [PMService],
		NULL [PMScheduled],
		'NSR' [RepairReasonID],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [InDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [OpenedDt],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [FirstLaborDt],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [ShowDowntimeBeginDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN ISDATE(HP.WO_OUTDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
			ELSE NULL
		END [FinishedDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		'2' [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HP.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HP.PROB_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(HP.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HP.FIX_DESC2)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderProjects HP
	WHERE
		HP.WO_NUMBER NOT IN (SELECT WorkOrderNumber FROM [tmp].[WorkOrderCenter])
		AND HP.[OBJECT_ID] NOT LIKE 'LV%'
		AND HP.LOCATION <> '05'
		AND HP.[STATUS] IN ('C', 'D', 'U', 'I')
		AND (HP.WO_INDATE > '7/1/2015' OR HP.WO_OUTDATE > '7/1/2015')

	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		HV.[OBJECT_ID] [Object_ID],
		HV.LOCATION,
		'D-ADMIN' [WorkOrderLocationID],
		YEAR(HV.WO_INDATE) [WorkOrderYear],
		HV.WO_NUMBER [WorkOrderNumber],
		'CLOSED' [JobStatus],
		'REPAIR' [JobType],
		'' [EquipmentID],	-- Fails validation per spec.
		NULL [Meter1],
		NULL [Meter2],
		'D4' [PriorityID],
		'' [PMService],
		NULL [PMScheduled],
		'NSR' [RepairReasonID],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [InDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [OpenedDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [FirstLaborDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [ShowDowntimeBeginDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN ISDATE(HV.WO_OUTDATE) = 1
				THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
			ELSE NULL
		END [FinishedDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		'2' [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HV.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HV.PROB_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(HV.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HV.FIX_DESC2)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
	WHERE
		HV.WO_NUMBER NOT IN (SELECT WorkOrderNumber FROM [tmp].[WorkOrderCenter])
		AND HV.LOCATION <> '04' AND HV.OP_CODE1 <> '1000'
		AND HV.[OBJECT_ID] NOT LIKE 'LV%'
		AND HV.[STATUS] IN ('C', 'D', 'U', 'I')
		AND (HV.WO_INDATE > '7/1/2015' OR HV.WO_OUTDATE > '7/1/2015')

	-- Facilities
	---- w/ no Shop exceptions
	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		xwalk.LegacyID [Object_ID],
		HP.LOCATION,
		CASE
			WHEN HP.SHOP_NUMBER IN ('E', 'EE', 'EL') THEN 'FACELEC'
			WHEN HP.SHOP_NUMBER IN ('I', 'IC', 'J') THEN 'FACINST'
			WHEN HP.SHOP_NUMBER IN ('M', 'M.') THEN 'FACMECH'
			-- Exceptions 8/26
			WHEN HP.SHOP_NUMBER = 'WS' THEN 'WATERSHED'
			WHEN HP.SHOP_NUMBER = '5700' THEN 'FACELEC'
			WHEN HP.SHOP_NUMBER = '5200' THEN 'FACMECH'
			WHEN HP.SHOP_NUMBER = '7600' THEN 'FACINST'
			ELSE 'ERROR'
		END [WorkOrderLocationID],		-- How are other values handled?
		YEAR(HP.WO_INDATE) [WorkOrderYear],
		LEFT(LTRIM(RTRIM(HP.WO_NUMBER)), 15) [WorkOrderNumber],
		CASE
			WHEN HP.[STATUS] = 'A' THEN 'OPEN'
			WHEN HP.[STATUS] = 'P' THEN 'PENDING'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		CASE
			WHEN HP.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN 'PM'
			ELSE 'REPAIR'
		END [JobType],
		xwalk.EquipmentID,
		NULL [Meter1],
		NULL [Meter2],
		CASE
			WHEN ((ISNULL(HP.RA_ASSGN, '') = '') AND (ISNULL(HP.RA_REQD, '') = '')) THEN 'F5'
			WHEN ((ISNULL(HP.RA_ASSGN, '') = '1') OR (ISNULL(HP.RA_REQD, '') = '1')) THEN 'F1'
			WHEN ((ISNULL(HP.RA_ASSGN, '') = '2') OR (ISNULL(HP.RA_REQD, '') = '2')) THEN 'F2'
			WHEN ((ISNULL(HP.RA_ASSGN, '') = '3') OR (ISNULL(HP.RA_REQD, '') = '3')) THEN 'F5'
			WHEN ((ISNULL(HP.RA_ASSGN, '') = '4') OR (ISNULL(HP.RA_REQD, '') = '4')) THEN 'F7'
			WHEN ((ISNULL(HP.RA_ASSGN, '') = '5') OR (ISNULL(HP.RA_REQD, '') = '5')) THEN 'F8'
			ELSE 'F5'
		END [PriorityID],
		CASE
			WHEN HP.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN HP.OP_CODE1 = 'ANNU' THEN 'IY01'
						WHEN HP.OP_CODE1 = 'SEMI' THEN 'IS01'
						ELSE HP.OP_CODE1
					END
			ELSE 'FGR'
		END [PMService],
		CASE
			WHEN HP.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN '2016-02-08'
			ELSE NULL
		END [PMScheduled],
		CASE
			WHEN HP.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN ''
			ELSE 'NSR'
		END [RepairReasonID],
		CASE
			WHEN ISDATE(HP.WO_INDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101)
			ELSE NULL
		END [OutOfServiceDt],
		CASE
			WHEN ISDATE(HP.WO_INDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101)
			ELSE NULL
		END [InDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CASE
			WHEN ISDATE(HP.WO_INDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101)
			ELSE NULL
		END [OpenedDt],
		CASE
			WHEN ISDATE(HP.WO_INDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101)
			ELSE NULL
		END [FirstLaborDt],
		CASE
			WHEN ISDATE(HP.WO_INDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101)
			ELSE NULL
		END [ShowDowntimeBeginDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN ISDATE(HP.WO_OUTDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
			ELSE NULL
		END [FinishedDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		CASE
			WHEN HP.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN '1'
			ELSE '2'
		END [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HP.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HP.PROB_DESC2))
			+ LTRIM(RTRIM(HP.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HP.FIX_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(wocc.CLS_COMMENT_1)) + ' ' + LTRIM(RTRIM(wocc.CLS_COMMENT_2)) + ' ' + 
			LTRIM(RTRIM(wocc.CLS_COMMENT_3)) + ' ' + LTRIM(RTRIM(wocc.CLS_COMMENT_4)) + ' ' +
			LTRIM(RTRIM(wocc.CLS_COMMENT_5)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderPlant HP
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON HP.[OBJECT_ID] = xwalk.LegacyID
			AND [Source] = 'SourceWicm210ObjectEquipment'
		LEFT JOIN [SourceWicm253WorkOrderExtensionPlantWOCloseComments1-5] wocc ON HP.WO_NUMBER = wocc.WO_NUMBER
			AND HP.LOCATION = wocc.WO_LOCATION
	WHERE
		HP.[WO_NUMBER] NOT IN (SELECT WO_NUMBER FROM TransformWorkOrderShopNumberExceptions)
	
	-- Facilities
	---- w/ Shop exceptions
	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		xwalk.LegacyID [Object_ID],
		HP.LOCATION,
		sne.WorkOrderLocationID [WorkOrderLocationID],
		YEAR(HP.WO_INDATE) [WorkOrderYear],
		LEFT(LTRIM(RTRIM(HP.WO_NUMBER)), 15) [WorkOrderNumber],
		CASE
			WHEN HP.[STATUS] = 'A' THEN 'OPEN'
			WHEN HP.[STATUS] = 'P' THEN 'PENDING'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		CASE
			WHEN HP.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN 'PM'
			ELSE 'REPAIR'
		END [JobType],
		xwalk.EquipmentID,
		NULL [Meter1],
		NULL [Meter2],
		CASE
			WHEN ((ISNULL(HP.RA_ASSGN, '') = '') AND (ISNULL(HP.RA_REQD, '') = '')) THEN 'F5'
			WHEN ((ISNULL(HP.RA_ASSGN, '') = '1') OR (ISNULL(HP.RA_REQD, '') = '1')) THEN 'F1'
			WHEN ((ISNULL(HP.RA_ASSGN, '') = '2') OR (ISNULL(HP.RA_REQD, '') = '2')) THEN 'F2'
			WHEN ((ISNULL(HP.RA_ASSGN, '') = '3') OR (ISNULL(HP.RA_REQD, '') = '3')) THEN 'F5'
			WHEN ((ISNULL(HP.RA_ASSGN, '') = '4') OR (ISNULL(HP.RA_REQD, '') = '4')) THEN 'F7'
			WHEN ((ISNULL(HP.RA_ASSGN, '') = '5') OR (ISNULL(HP.RA_REQD, '') = '5')) THEN 'F8'
			ELSE 'F5'
		END [PriorityID],
		CASE
			WHEN HP.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN HP.OP_CODE1 = 'ANNU' THEN 'IY01'
						WHEN HP.OP_CODE1 = 'SEMI' THEN 'IS01'
						ELSE HP.OP_CODE1
					END
			ELSE 'FGR'
		END [PMService],
		CASE
			WHEN HP.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN '2016-02-08'
			ELSE NULL
		END [PMScheduled],
		CASE
			WHEN HP.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN ''
			ELSE 'NSR'
		END [RepairReasonID],
		CASE
			WHEN ISDATE(HP.WO_INDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101)
			ELSE NULL
		END [OutOfServiceDt],
		CASE
			WHEN ISDATE(HP.WO_INDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101)
			ELSE NULL
		END [InDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CASE
			WHEN ISDATE(HP.WO_INDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101)
			ELSE NULL
		END [OpenedDt],
		CASE
			WHEN ISDATE(HP.WO_INDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101)
			ELSE NULL
		END [FirstLaborDt],
		CASE
			WHEN ISDATE(HP.WO_INDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101)
			ELSE NULL
		END [ShowDowntimeBeginDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN ISDATE(HP.WO_OUTDATE) = 1
				THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
			ELSE NULL
		END [FinishedDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN 'N'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HP.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HP.WO_OUTDATE + ' ' + LEFT(HP.TIME_OUT, 2) + ':' + SUBSTRING(HP.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		CASE
			WHEN HP.OP_CODE1 IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN '1'
			ELSE '2'
		END [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HP.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HP.PROB_DESC2))
			+ LTRIM(RTRIM(HP.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HP.FIX_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(wocc.CLS_COMMENT_1)) + ' ' + LTRIM(RTRIM(wocc.CLS_COMMENT_2)) + ' ' + 
			LTRIM(RTRIM(wocc.CLS_COMMENT_3)) + ' ' + LTRIM(RTRIM(wocc.CLS_COMMENT_4)) + ' ' +
			LTRIM(RTRIM(wocc.CLS_COMMENT_5)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderPlant HP
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON HP.[OBJECT_ID] = xwalk.LegacyID
			AND [Source] = 'SourceWicm210ObjectEquipment'
		INNER JOIN TransformWorkOrderShopNumberExceptions sne ON HP.WO_NUMBER = sne.WO_NUMBER
			AND HP.LOCATION = sne.LOCATION
		LEFT JOIN [SourceWicm253WorkOrderExtensionPlantWOCloseComments1-5] wocc ON HP.WO_NUMBER = wocc.WO_NUMBER
			AND HP.LOCATION = wocc.WO_LOCATION
	
	-- General Services
	---- Vehicles
	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		HV.[OBJECT_ID] [Object_ID],
		HV.LOCATION,
		CASE
			WHEN HV.[OBJECT_ID] LIKE '006%' THEN 'VEH SHOP'
			WHEN HV.[OBJECT_ID] LIKE '91%' THEN 'SE SHOP'
			WHEN HV.[OBJECT_ID] IN ('000736', '000900', '001279', '001909', '004001', '700029', '999999')
				THEN 'VEH SHOP'
			WHEN HV.[OBJECT_ID] IN ('000904', '004024') THEN 'SE SHOP'
			ELSE ''
		END [WorkOrderLocationID],
		YEAR(HV.WO_INDATE) [WorkOrderYear],
		HV.WO_NUMBER [WorkOrderNumber],
		CASE
			WHEN HV.[STATUS] = 'A' THEN 'OPEN'
			WHEN HV.[STATUS] = 'P' THEN 'PENDING'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		opc.RepairPM [JobType],
		xwalk.EquipmentID [EquipmentID],
		ISNULL(HV.MILES_HOURS, NULL) [Meter1],
		NULL [Meter2],
		CASE
			WHEN HV.[OBJECT_ID] LIKE '006%' AND opc.RepairPM = 'REPAIR' THEN 'V3'
			WHEN HV.[OBJECT_ID] LIKE '006%' AND opc.RepairPM = 'PM' THEN 'V4'
			WHEN HV.[OBJECT_ID] LIKE '91%' AND opc.RepairPM = 'REPAIR' THEN 'S3'
			WHEN HV.[OBJECT_ID] LIKE '91%' AND opc.RepairPM = 'PM' THEN 'S4'
			ELSE ''
		END [PriorityID],
		CASE
			WHEN opc.RepairPM = 'PM' THEN opc.TaskIDAlignment
			ELSE ''
		END [PMService],
		CASE
			WHEN opc.RepairPM = 'PM' THEN '2016-02-08'
			ELSE NULL
		END [PMScheduled],
		CASE
			WHEN opc.RepairPM = 'REPAIR' THEN 'NSR'
			ELSE ''
		END [RepairReasonID],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [InDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [OpenedDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [FirstLaborDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [ShowDowntimeBeginDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL		-- TBD
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [FinishedDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		CASE
			WHEN opc.RepairPM = 'PM' THEN '1'
			WHEN opc.RepairPM = 'REPAIR' THEN '2'
		END [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HV.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HV.PROB_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(HV.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HV.FIX_DESC2)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformWorkOrderGSOpCode opc ON HV.OP_CODE1 = opc.OpCode
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON HV.[OBJECT_ID] = xwalk.LegacyID AND xwalk.EquipmentID LIKE 'GS%'
	WHERE
		HV.[LOCATION] = '01'
		AND HV.WO_NUMBER NOT IN (SELECT WorkOrderNumber FROM [tmp].[WorkOrderCenter])

	---- Components
	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		HV.[OBJECT_ID] [Object_ID],
		HV.LOCATION,
		CASE
			WHEN HV.[OBJECT_ID] LIKE '006%' THEN 'VEH SHOP'
			WHEN HV.[OBJECT_ID] LIKE '91%' THEN 'SE SHOP'
			WHEN HV.[OBJECT_ID] IN ('000736', '000900', '001279', '001909', '004001', '700029', '999999')
				THEN 'VEH SHOP'
			WHEN HV.[OBJECT_ID] IN ('000904', '004024') THEN 'SE SHOP'
			ELSE ''
		END [WorkOrderLocationID],
		YEAR(HV.WO_INDATE) [WorkOrderYear],
		HV.WO_NUMBER [WorkOrderNumber],
		CASE
			WHEN HV.[STATUS] = 'A' THEN 'OPEN'
			WHEN HV.[STATUS] = 'P' THEN 'PENDING'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		opc.RepairPM [JobType],
		xwalk.AssetID [EquipmentID],
		ISNULL(HV.MILES_HOURS, NULL) [Meter1],
		NULL [Meter2],
		CASE
			WHEN HV.[OBJECT_ID] LIKE '006%' AND opc.RepairPM = 'REPAIR' THEN 'V3'
			WHEN HV.[OBJECT_ID] LIKE '006%' AND opc.RepairPM = 'PM' THEN 'V4'
			WHEN HV.[OBJECT_ID] LIKE '91%' AND opc.RepairPM = 'REPAIR' THEN 'S3'
			WHEN HV.[OBJECT_ID] LIKE '91%' AND opc.RepairPM = 'PM' THEN 'S4'
			ELSE ''
		END [PriorityID],
		CASE
			WHEN opc.RepairPM = 'PM' THEN opc.TaskIDAlignment
			ELSE ''
		END [PMService],
		CASE
			WHEN opc.RepairPM = 'PM' THEN '2016-02-08'
			ELSE NULL
		END [PMScheduled],
		CASE
			WHEN opc.RepairPM = 'REPAIR' THEN 'NSR'
			ELSE ''
		END [RepairReasonID],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [InDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [DueDate],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [OpenedDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [FirstLaborDt],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [ShowDowntimeBeginDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [FinishWorkOrder],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL		-- TBD
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [FinishedDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [CloseWorkOrder],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [ClosedDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN 'N'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'Y'
		END [InService],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN
				CASE
					WHEN ISDATE(HV.WO_OUTDATE) = 1
						THEN CONVERT(DATETIME, (HV.WO_OUTDATE + ' ' + LEFT(HV.TIME_OUT, 2) + ':' + SUBSTRING(HV.TIME_OUT, 3, 2)), 101)
					ELSE NULL
				END
		END [InServiceDt],
		'' [AccountID],		-- TBD
		CASE
			WHEN opc.RepairPM = 'PM' THEN '1'
			WHEN opc.RepairPM = 'REPAIR' THEN '2'
		END [WorkClass],
		'' [WarrantyWork],	-- TBD
		LTRIM(RTRIM(HV.PROB_DESC1)) + ' ' + LTRIM(RTRIM(HV.PROB_DESC2)) [Complaint],
		'' [Cause],
		LTRIM(RTRIM(HV.FIX_DESC1)) + ' ' + LTRIM(RTRIM(HV.FIX_DESC2)) [Correction],
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformWorkOrderGSOpCode opc ON HV.OP_CODE1 = opc.OpCode
		INNER JOIN TransformComponentLegacyXwalk xwalk ON HV.[OBJECT_ID] = xwalk.LegacyID AND xwalk.AssetID LIKE 'GS%'
	WHERE
		HV.[LOCATION] = '01'
		AND HV.WO_NUMBER NOT IN (SELECT WorkOrderNumber FROM [tmp].[WorkOrderCenter])

	-- Copy temp to TransformWorkOrderCenter
	INSERT INTO TransformWorkOrderCenter
	SELECT DISTINCT
		'[i]' [Control],
		tmp.[Object_ID],
		tmp.[Location],
		tmp.WorkOrderLocationID,
		tmp.WorkOrderYear,
		tmp.WorkOrderNumber,
		tmp.JobStatus,
		tmp.JobType,
		tmp.EquipmentID,
		tmp.Meter1,
		tmp.Meter2,
		tmp.PriorityID,
		tmp.PMService,
		tmp.PMScheduled,
		tmp.RepairReasonID,
		tmp.OutOfServiceDt,
		tmp.InDt,
		tmp.DueDt,
		tmp.OpenedDt,
		tmp.FirstLaborDt,
		tmp.ShowDowntimeBeginDt,
		tmp.FinishWorkOrder,
		tmp.FinishedDt,
		tmp.CloseWorkOrder,
		tmp.ClosedDt,
		tmp.InService,
		tmp.InServiceDt,
		tmp.AccountID,
		tmp.WorkClass,
		tmp.WarrantyWork,
		tmp.Complaint,
		tmp.Cause,
		tmp.Correction,
		tmp.Tasks,
		tmp.Labor,
		tmp.Parts,
		tmp.Commercial,
		GETDATE()
	FROM tmp.WorkOrderCenter tmp
END
