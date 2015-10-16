--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	08/20/2015
--	Update Date:
--		CjB 10/16/2015 Setting the VendorID to constant value for all records.  Added the new
--						Comments column.
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
		[MiscCost] [decimal](12,2) NULL,
		[Comments] [varchar](60) NULL,
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
		'HISTORIC VENDOR' [VendorID],
		CONVERT(DECIMAL(12,2), DS.SUBLET_COST) [LaborCost],
		NULL [PartsCost],				-- TBD
		NULL [MiscCost],					-- TBD
		'WICM VENDOR: ' + LTRIM(RTRIM(DS.VENDOR_ID)) + ', WICM REF DOC: ' + LTRIM(RTRIM(DS.REF_DOC)) [Comments]
	FROM SourceWicm251WorkOrderDetailSublets DS
		INNER JOIN SourceWicm250WorkOrderHeaderAdmin ha ON DS.WO_NUMBER = ha.WO_NUMBER
			AND DS.LOCATION = ha.LOCATION
		INNER JOIN TransformWorkOrderCenter woc ON DS.WO_NUMBER = woc.WorkOrderNumber
			AND DS.LOCATION = woc.Location
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
		'HISTORIC VENDOR' [VendorID],
		CONVERT(DECIMAL(12,2), DS.SUBLET_COST) [LaborCost],
		NULL [PartsCost],				-- TBD
		NULL [MiscCost],					-- TBD
		'WICM VENDOR: ' + LTRIM(RTRIM(DS.VENDOR_ID)) + ', WICM REF DOC: ' + LTRIM(RTRIM(DS.REF_DOC)) [Comments]
	FROM SourceWicm251WorkOrderDetailSublets DS
		INNER JOIN SourceWicm250WorkOrderHeaderProjects hp ON DS.WO_NUMBER = hp.WO_NUMBER
			AND DS.LOCATION = hp.LOCATION
		INNER JOIN TransformWorkOrderCenter woc ON DS.WO_NUMBER = woc.WorkOrderNumber
			AND DS.LOCATION = woc.Location
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
		'HISTORIC VENDOR' [VendorID],
		CONVERT(DECIMAL(12,2), DS.SUBLET_COST) [LaborCost],
		NULL [PartsCost],				-- TBD
		NULL [MiscCost],					-- TBD
		'WICM VENDOR: ' + LTRIM(RTRIM(DS.VENDOR_ID)) + ', WICM REF DOC: ' + LTRIM(RTRIM(DS.REF_DOC)) [Comments]
	FROM SourceWicm251WorkOrderDetailSublets DS
		INNER JOIN SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair hv ON DS.WO_NUMBER = hv.WO_NUMBER
			AND DS.LOCATION = hv.LOCATION
		INNER JOIN TransformWorkOrderCenter woc ON DS.WO_NUMBER = woc.WorkOrderNumber
			AND DS.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderDistOpCode doc ON DS.OPER_CODE = doc.OpCode
	WHERE ISNULL(DS.OPER_CODE, '') <> ''
		AND hv.LOCATION = '04'
		AND hv.OP_CODE1 <> '1000'

	-- WORKORDERPLANT
	INSERT INTO [tmp].[WorkOrderCenterCommercial]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		CASE
			WHEN DS.OPER_CODE IN ('ANNU', 'EM01', 'EQ01', 'ES01', 'EY01', 'EY02', 'IM01', 'IM02', 'IQ01',
				'IS01', 'IY01', 'MM01', 'MM02', 'MQ01', 'MS01', 'MY01', 'MY02', 'MY03', 'MY05', 'SEMI') THEN
					CASE
						WHEN DS.OPER_CODE = 'ANNU' THEN 'IY01'
						WHEN DS.OPER_CODE = 'SEMI' THEN 'IS01'
						ELSE DS.OPER_CODE
					END
			ELSE 'FGR'
		END [TaskID],
		hp.WO_STAGE [WorkAccomplishedCode],
		DS.DATE_BACK [Dt],
		'HISTORIC VENDOR' [VendorID],
		CONVERT(DECIMAL(12,2), DS.SUBLET_COST) [LaborCost],
		NULL [PartsCost],		-- TBD
		NULL [MiscCost],		-- TBD
		'WICM VENDOR: ' + LTRIM(RTRIM(DS.VENDOR_ID)) + ', WICM REF DOC: ' + LTRIM(RTRIM(DS.REF_DOC)) [Comments]
	FROM SourceWicm251WorkOrderDetailSublets DS
		INNER JOIN SourceWicm250WorkOrderHeaderPlant hp ON DS.WO_NUMBER = hp.WO_NUMBER
			AND DS.LOCATION = hp.LOCATION
		INNER JOIN TransformWorkOrderCenter woc ON DS.WO_NUMBER = woc.WorkOrderNumber
			AND DS.LOCATION = woc.Location
	WHERE ISNULL(DS.OPER_CODE, '') <> ''

	-- WORKORDERVEHICLESNEWSVCINSTALLREPAIR: Location = '01'
	INSERT INTO [tmp].[WorkOrderCenterCommercial]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		gsoc.TaskIDAlignment,
		CASE
			WHEN hv.[STATUS] IN ('C','D','U','I') THEN 'WICM'
			ELSE ''
		END [WorkAccomplishedCode],
		DS.DATE_BACK [Dt],
		'HISTORIC VENDOR' [VendorID],
		CONVERT(DECIMAL(12,2), DS.SUBLET_COST) [LaborCost],
		NULL [PartsCost],				-- TBD
		NULL [MiscCost],					-- TBD
		'WICM VENDOR: ' + LTRIM(RTRIM(DS.VENDOR_ID)) + ', WICM REF DOC: ' + LTRIM(RTRIM(DS.REF_DOC)) [Comments]
	FROM SourceWicm251WorkOrderDetailSublets DS
		INNER JOIN SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair hv ON DS.WO_NUMBER = hv.WO_NUMBER
			AND DS.LOCATION = hv.LOCATION
		INNER JOIN TransformWorkOrderCenter woc ON DS.WO_NUMBER = woc.WorkOrderNumber
			AND DS.LOCATION = woc.Location
		INNER JOIN TransformWorkOrderGSOpCode gsoc ON DS.OPER_CODE = gsoc.OpCode
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
		tmp.Comments,
		GETDATE()
	FROM [tmp].[WorkOrderCenterCommercial] tmp
END
