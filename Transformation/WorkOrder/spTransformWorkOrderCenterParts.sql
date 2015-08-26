--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	08/20/2015
--	Updates:
--	Description:	Creates/modifies the spTransformWorkOrderCenterParts stored procedure.
--					Populates the TransformWorkOrderCenterParts table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformWorkOrderCenterParts') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformWorkOrderCenterParts AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformWorkOrderCenterParts
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformWorkOrderCenterParts
--	=================================================================================================
	IF OBJECT_ID('tmp.WorkOrderCenterParts') IS NOT NULL
		DROP TABLE tmp.WorkOrderCenterParts

	CREATE TABLE [tmp].[WorkOrderCenterParts](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[WorkOrderLocationID] [varchar](10) NOT NULL,
		[WorkOrderYear] [int] NULL,
		[WorkOrderNumber] [varchar](15) NULL,
		[TaskID] [varchar](12) NULL,
		[Dt] [datetime] NULL,
		[NotFromInventory] [char](1) NULL,
		[PartID] [varchar](22) NULL,
		[Quantity] [decimal](10,2) NULL,
		[UnitPrice] [decimal](10,4) NULL
	)

	-- WorkOrderAdmin - Parts
	INSERT INTO [tmp].[WorkOrderCenterParts]
	SELECT
		woc.WorkOrderLocationID,
		woc.WorkOrderYear,
		woc.WorkOrderNumber,
		lkup.TaskIDAlignment [TaskID],
		WODP.ACTION_DATE [Dt],
		'Y' [NotFromInventory],
		WODP.PART_NUMBER [PartID],
		WODP.PART_QTY [Quantity],
		WODP.PART_COST [UnitPrice]
	FROM SourceWicm251WorkOrderDetailParts WODP
		INNER JOIN TransformWorkOrderCenter woc ON WODP.WO_NUMBER = woc.WorkOrderNumber
		INNER JOIN TransformWorkOrderDistOpCode lkup ON WODP.OPER_CODE = lkup.OpCode
	WHERE ISNULL(wodp.OPER_CODE, '') <> ''
		AND ISDATE(WODP.ACTION_DATE) = 1		-- TBD

	-- Copy temp to TransformWorkOrderCenterParts
	INSERT INTO TransformWorkOrderCenterParts
	SELECT DISTINCT
		'[i]' [Control],
		tmp.WorkOrderLocationID,
		tmp.WorkOrderYear,
		tmp.WorkOrderNumber,
		tmp.TaskID,
		tmp.Dt,
		tmp.NotFromInventory,
		tmp.PartID,
		tmp.Quantity,
		tmp.UnitPrice,
		GETDATE()
	FROM tmp.WorkOrderCenterParts tmp
END
