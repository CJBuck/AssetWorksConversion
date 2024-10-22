--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	08/20/2015
--	Updates:
--	Description:	Creates/modifies the spTransformWorkOrderCenterCommercial stored procedure.
--					Populates the TransformWorkOrderCenterCommercial table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformWorkOrderCenterCommercial') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformWorkOrderCenterCommercial AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformWorkOrderCenterCommercial
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformWorkOrderCenterCommercial
--	=================================================================================================
	IF OBJECT_ID('tmp.WorkOrderCenterCommercial') IS NOT NULL
		DROP TABLE tmp.WorkOrderCenterCommercial

	CREATE TABLE [tmp].[WorkOrderCenterCommercial](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[WorkOrderLocationID] [varchar](10) NOT NULL,
		[WorkOrderYear] [int] NULL,
		[WorkOrderNumber] [varchar](15) NULL,
		[TaskID] [varchar](12) NULL,
		[WorkAccomplishedCode] [varchar](4) NULL,
		[Dt] [datetime] NULL,
		[VendorID] [varchar](15) NULL,
		[LaborCost] [decimal](12,2) NULL,
		[PartsCost] [decimal](12,2) NULL,
		[MiscCost] [decimal](12,2) NULL
	)

	-- WORKORDERADMIN
	INSERT INTO [tmp].[WorkOrderCenterCommercial]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		doc.TaskIDAlignment,
		CASE
			WHEN ha.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		DS.DATE_BACK [Dt],
		DS.VENDOR_ID [VendorID],		-- TBD
		CONVERT(DECIMAL(12,2), DS.SUBLET_COST) [LaborCost],
		NULL [PartsCost],				-- TBD
		NULL [MiscCost]					-- TBD
	FROM SourceWicm251WorkOrderDetailSublets DS
		INNER JOIN SourceWicm250WorkOrderHeaderAdmin ha ON DS.WO_NUMBER = ha.WO_NUMBER
		INNER JOIN TransformWorkOrderCenter woc ON DS.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN TransformWorkOrderDistOpCode doc ON DS.OPER_CODE = doc.OpCode
	WHERE ISNULL(DS.OPER_CODE, '') <> ''

	-- WORKORDERPROJECTS
	INSERT INTO [tmp].[WorkOrderCenterCommercial]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		doc.TaskIDAlignment,
		CASE
			WHEN hp.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		DS.DATE_BACK [Dt],
		DS.VENDOR_ID [VendorID],		-- TBD
		CONVERT(DECIMAL(12,2), DS.SUBLET_COST) [LaborCost],
		NULL [PartsCost],				-- TBD
		NULL [MiscCost]					-- TBD
	FROM SourceWicm251WorkOrderDetailSublets DS
		INNER JOIN SourceWicm250WorkOrderHeaderProjects hp ON DS.WO_NUMBER = hp.WO_NUMBER
		INNER JOIN TransformWorkOrderCenter woc ON DS.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN TransformWorkOrderDistOpCode doc ON DS.OPER_CODE = doc.OpCode
	WHERE ISNULL(DS.OPER_CODE, '') <> ''

	-- WORKORDERVEHICLESNEWSVCINSTALLREPAIR: Location = '04'
	INSERT INTO [tmp].[WorkOrderCenterCommercial]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		doc.TaskIDAlignment,
		CASE
			WHEN hv.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		DS.DATE_BACK [Dt],
		DS.VENDOR_ID [VendorID],		-- TBD
		CONVERT(DECIMAL(12,2), DS.SUBLET_COST) [LaborCost],
		NULL [PartsCost],				-- TBD
		NULL [MiscCost]					-- TBD
	FROM SourceWicm251WorkOrderDetailSublets DS
		INNER JOIN SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair hv ON DS.WO_NUMBER = hv.WO_NUMBER
		INNER JOIN TransformWorkOrderCenter woc ON DS.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN TransformWorkOrderDistOpCode doc ON DS.OPER_CODE = doc.OpCode
	WHERE ISNULL(DS.OPER_CODE, '') <> ''
		AND hv.LOCATION = '04'
		AND hv.OP_CODE1 <> '1000'

	-- WORKORDERPLANT
	INSERT INTO [tmp].[WorkOrderCenterCommercial]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		doc.TaskIDAlignment,
		hp.WO_STAGE [WorkAccomplishedCode],
		DS.DATE_BACK [Dt],
		DS.VENDOR_ID [VendorID],		-- TBD
		CONVERT(DECIMAL(12,2), DS.SUBLET_COST) [LaborCost],
		NULL [PartsCost],				-- TBD
		NULL [MiscCost]					-- TBD
	FROM SourceWicm251WorkOrderDetailSublets DS
		INNER JOIN SourceWicm250WorkOrderHeaderPlant hp ON DS.WO_NUMBER = hp.WO_NUMBER
		INNER JOIN TransformWorkOrderCenter woc ON DS.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN TransformWorkOrderDistOpCode doc ON DS.OPER_CODE = doc.OpCode
	WHERE ISNULL(DS.OPER_CODE, '') <> ''

	-- WORKORDERVEHICLESNEWSVCINSTALLREPAIR: Location = '01'
	INSERT INTO [tmp].[WorkOrderCenterCommercial]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		doc.TaskIDAlignment,
		CASE
			WHEN hv.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		DS.DATE_BACK [Dt],
		DS.VENDOR_ID [VendorID],		-- TBD
		CONVERT(DECIMAL(12,2), DS.SUBLET_COST) [LaborCost],
		NULL [PartsCost],				-- TBD
		NULL [MiscCost]					-- TBD
	FROM SourceWicm251WorkOrderDetailSublets DS
		INNER JOIN SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair hv ON DS.WO_NUMBER = hv.WO_NUMBER
		INNER JOIN TransformWorkOrderCenter woc ON DS.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN TransformWorkOrderDistOpCode doc ON DS.OPER_CODE = doc.OpCode
	WHERE ISNULL(DS.OPER_CODE, '') <> ''
		AND hv.LOCATION = '01'
	
	-- Copy temp to TransformWorkOrderCenterCommercial
	INSERT INTO TransformWorkOrderCenterCommercial
	SELECT DISTINCT
		'[i]' [Control],
		tmp.WorkOrderLocationID,
		tmp.WorkOrderYear,
		tmp.WorkOrderNumber,
		tmp.TaskID,
		tmp.WorkAccomplishedCode,
		tmp.Dt,
		tmp.VendorID,
		tmp.LaborCost,
		tmp.PartsCost,
		tmp.MiscCost,
		GETDATE()
	FROM [tmp].[WorkOrderCenterCommercial] tmp
END
