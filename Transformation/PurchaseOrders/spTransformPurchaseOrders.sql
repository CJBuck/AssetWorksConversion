--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	08/26/2015
--	Updates:
--	Description:	Creates/modifies the spTransformPurchaseOrders stored procedure.  Populates
--					the TransportWorkOrderCenter table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformPurchaseOrders') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformPurchaseOrders AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformPurchaseOrders
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformPurchaseOrders
--	=================================================================================================
	IF OBJECT_ID('tmp.WorkOrderCenter') IS NOT NULL
		DROP TABLE tmp.WorkOrderCenter

	CREATE TABLE [tmp].[PurchaseOrders](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[Object_ID] [varchar](25) NULL,
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
END
