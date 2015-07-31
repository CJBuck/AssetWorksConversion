--	=================================================================================================
--	Created By:	Chris Buck
--	Create Date:	07/29/2015
--	Breaking Updates:
-- 
--	Description: Creates/modifies the spTransformWorkOrder stored procedure.  Populates
--				 the ... tables.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformWorkOrder') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformWorkOrder AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformWorkOrder
AS
BEGIN
--	=================================================================================================
--	Build dbo.TransformPart
--	=================================================================================================
	IF OBJECT_ID('tmp.WorkOrderCenter') IS NOT NULL
		DROP TABLE tmp.WorkOrderCenter

	CREATE TABLE [tmp].[WorkOrderCenter](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[Object_ID] [varchar](25) NULL,
		[WorkOrderLocationID] [varchar](10) NOT NULL,
		[WorkOrderYear] [int] NULL,
		[WorkOrderNumber] [int] NULL,
		[JobStatus] [varchar](20) NULL,
		[JobType] [varchar](8) NULL,
		[EquipmentID] [varchar](20) NULL,
		[Meter1] [int] NULL,
		[Meter2] [int] NULL,
		[PriorityID] [varchar](2) NULL,
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
		[Tasks] [varchar](30) NULL,
		[Labor] [varchar](30) NULL,
		[Parts] [varchar](30) NULL,
		[Commercial] [varchar](30) NULL
	)

	-- Distribution - in TransformEquipmentLegacyXwalk
	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		xwalk.LegacyID [Object_ID],
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
		NULL [Meter1],		-- TBD
		NULL [Meter2],		-- TBD
		'D4' [PriorityID],
		'' [PMService],
		'04' [RepairReasonID],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN NULL		-- TBD
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
		'1' [WorkClass],
		'' [WarrantyWork],	-- TBD
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
		'D-INSTALL' [WorkOrderLocationID],
		YEAR(HP.WO_INDATE) [WorkOrderYear],
		CASE
			WHEN HP.[STATUS] = 'A' THEN 'OPEN'
			WHEN HP.[STATUS] = 'P' THEN 'PENDING'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		'REPAIR' [JobType],
		xwalk.EquipmentID,
		NULL [Meter1],		-- TBD
		NULL [Meter2],		-- TBD
		'D4' [PriorityID],
		'' [PMService],
		'04' [RepairReasonID],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL		-- TBD
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
		'1' [WorkClass],
		'' [WarrantyWork],	-- TBD
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
		CASE
			WHEN HV.[LOCATION] = '04' AND HV.WO_TYPE = 'X2' THEN 'D-INSTALL'
			WHEN HV.[LOCATION] = '04' AND HV.WO_TYPE = 'X6' THEN 'D-REPAIR'
			ELSE ''
		END [WorkOrderLocationID],
		YEAR(HV.WO_INDATE) [WorkOrderYear],
		CASE
			WHEN HV.[STATUS] = 'A' THEN 'OPEN'
			WHEN HV.[STATUS] = 'P' THEN 'PENDING'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		'REPAIR' [JobType],
		xwalk.EquipmentID,
		NULL [Meter1],		-- TBD
		NULL [Meter2],		-- TBD
		'D4' [PriorityID],
		'' [PMService],
		'04' [RepairReasonID],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL		-- TBD
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
		'1' [WorkClass],
		'' [WarrantyWork],	-- TBD
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
		INNER JOIN TransformEquipmentLegacyXwalk xwalk ON HV.[OBJECT_ID] = xwalk.LegacyID
			AND [Source] = 'SourceWicm210ObjectProject'
	WHERE HV.[OBJECT_ID] NOT LIKE 'LV%'
		AND HV.LOCATION = '04'

	-- Distribution - NOT in TransformEquipmentLegacyXwalk
	INSERT INTO [tmp].[WorkOrderCenter]
	SELECT
		HA.[OBJECT_ID] [Object_ID],
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
		NULL [Meter1],		-- TBD
		NULL [Meter2],		-- TBD
		'D4' [PriorityID],
		'' [PMService],
		'04' [RepairReasonID],
		CONVERT(DATETIME, (HA.WO_INDATE + ' ' + LEFT(HA.TIME_IN, 2) + ':' + SUBSTRING(HA.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CASE
			WHEN HA.[STATUS] IN ('A','P') THEN NULL		-- TBD
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
		'1' [WorkClass],
		'' [WarrantyWork],	-- TBD
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
		'D-INSTALL' [WorkOrderLocationID],
		YEAR(HP.WO_INDATE) [WorkOrderYear],
		CASE
			WHEN HP.[STATUS] = 'A' THEN 'OPEN'
			WHEN HP.[STATUS] = 'P' THEN 'PENDING'
			WHEN HP.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		'REPAIR' [JobType],
		'' [EquipmentID],
		NULL [Meter1],		-- TBD
		NULL [Meter2],		-- TBD
		'D4' [PriorityID],
		'' [PMService],
		'04' [RepairReasonID],
		CONVERT(DATETIME, (HP.WO_INDATE + ' ' + LEFT(HP.TIME_IN, 2) + ':' + SUBSTRING(HP.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CASE
			WHEN HP.[STATUS] IN ('A','P') THEN NULL		-- TBD
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
		'1' [WorkClass],
		'' [WarrantyWork],	-- TBD
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
		CASE
			WHEN HV.[LOCATION] = '04' AND HV.WO_TYPE = 'X2' THEN 'D-INSTALL'
			WHEN HV.[LOCATION] = '04' AND HV.WO_TYPE = 'X6' THEN 'D-REPAIR'
			ELSE ''
		END [WorkOrderLocationID],
		YEAR(HV.WO_INDATE) [WorkOrderYear],
		CASE
			WHEN HV.[STATUS] = 'A' THEN 'OPEN'
			WHEN HV.[STATUS] = 'P' THEN 'PENDING'
			WHEN HV.[STATUS] IN ('C','D','U','I') THEN 'CLOSED'
		END [JobStatus],
		'REPAIR' [JobType],
		'' [EquipmentID],
		NULL [Meter1],		-- TBD
		NULL [Meter2],		-- TBD
		'D4' [PriorityID],
		'' [PMService],
		'04' [RepairReasonID],
		CONVERT(DATETIME, (HV.WO_INDATE + ' ' + LEFT(HV.TIME_IN, 2) + ':' + SUBSTRING(HV.TIME_IN, 3, 2)), 101) [OutOfServiceDt],
		CASE
			WHEN HV.[STATUS] IN ('A','P') THEN NULL		-- TBD
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
		'1' [WorkClass],
		'' [WarrantyWork],	-- TBD
		'[191:1;TASKS;1-3:1-3]' [Tasks],
		'[193:1;LABOR;1-3:1-3]' [Labor],
		'[194:1;PARTS;1-3:1-3]' [Parts],
		'[195:1;COMMERCIAL;1-3:1-3]' [Commercial]
	FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
	WHERE
		HV.[OBJECT_ID] NOT IN (SELECT LegacyID FROM TransformEquipmentLegacyXwalk WHERE [Source] = 'SourceWicm210ObjectProject')
		AND HV.[OBJECT_ID] NOT LIKE 'LV%'
		AND HV.[STATUS] = 'A'
		AND HV.LOCATION = '04'

END