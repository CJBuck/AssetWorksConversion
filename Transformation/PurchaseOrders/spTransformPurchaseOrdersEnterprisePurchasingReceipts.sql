--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	09/03/2015
--	Updates:
--		CJB 11/04/2015 Added new exclusion logic; modified the population logic for VendorID.
--	Description:	Creates/modifies the spTransformPurchaseOrdersEnterprisePurchasingReceipts
--					stored procedure.  Populates the TransformPurchaseOrders table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformPurchaseOrdersEnterprisePurchasingReceipts') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformPurchaseOrdersEnterprisePurchasingReceipts AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformPurchaseOrdersEnterprisePurchasingReceipts
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformPurchaseOrdersEnterprisePurchasingReceipts
--	=================================================================================================
	IF OBJECT_ID('tmp.PurchaseOrdersEnterprisePurchasingReceipts') IS NOT NULL
		DROP TABLE tmp.PurchaseOrdersEnterprisePurchasingReceipts

	CREATE TABLE [tmp].[PurchaseOrdersEnterprisePurchasingReceipts](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[PurchaseOrderID] [varchar](30) NOT NULL,
		[LineNumber] [int] NOT NULL,
		[FullyReceiveAllLineItems] [char](1) NOT NULL,
		[ReceivedDt] [datetime] NULL,
		[QuantityReceived] [decimal](22,2) NULL
	)

	-- SourceWicm300CcpHeader
	INSERT INTO [tmp].[PurchaseOrdersEnterprisePurchasingReceipts]
	SELECT DISTINCT
		PO.[PurchaseOrderID],
		1 [LineNumber],
		'' [FullyReceiveAllLineItems],
		NULL [ReceivedDt],
		NULL [QuantityReceived]
	FROM TransformPurchaseOrders PO
		INNER JOIN TransformPurchaseOrdersLineItems oli ON PO.PurchaseOrderID = oli.PurchaseOrderID AND oli.LineNumber = 1
		
	-- Update FullyReceiveAllLineItems
	UPDATE [tmp].[PurchaseOrdersEnterprisePurchasingReceipts]
	SET
		FullyReceiveAllLineItems =
			CASE
				WHEN ccpd.QTYORDERED = ccpd.QTYRECVDTODT THEN 'Y'
				WHEN ccph.[STATUS] IN ('R', 'F') THEN 'Y'
				WHEN ccph.[STATUS] IN ('A', 'L', 'P') and ccpd.QTYORDERED <> ccpd.QTYRECVDTODT
					THEN ''
				ELSE ''
			END
	FROM [tmp].[PurchaseOrdersEnterprisePurchasingReceipts] tmp
		INNER JOIN SourceWicm305CcpDetail ccpd ON tmp.PurchaseOrderID = ccpd.CCP_NUMBER
		LEFT JOIN SourceWicm300CcpHeader ccph ON TMP.PurchaseOrderID = ccph.PONUMBER
	WHERE
		tmp.FullyReceiveAllLineItems = ''
	
	-- Update ReceivedDt & QuantityReceived
	UPDATE [tmp].[PurchaseOrdersEnterprisePurchasingReceipts]
	SET
		[ReceivedDt] =
			CASE
				WHEN ISDATE(ccpd.DATERECVD) = 1 THEN
					CONVERT(DATETIME, (ccpd.DATERECVD + ' 00:01'), 101)
				ELSE DATEADD(DAY, 5, li.[OrderedDt])
			END,
		[QuantityReceived] = ISNULL(ccpd.QTYORDERED, 0.00)
	FROM [tmp].[PurchaseOrdersEnterprisePurchasingReceipts] tmp
		INNER JOIN SourceWicm305CcpDetail ccpd ON tmp.PurchaseOrderID = ccpd.CCP_NUMBER
		INNER JOIN TransformPurchaseOrdersLineItems li ON tmp.PurchaseOrderID = li.PurchaseOrderID
	WHERE
		LTRIM(RTRIM(ccpd.[LINENO])) = '1'
		
	-- Copy temp to TransformPurchaseOrdersEnterprisePurchasingReceipts
	INSERT INTO [dbo].[TransformPurchaseOrdersEnterprisePurchasingReceipts]
	SELECT DISTINCT
		'[i]' [Control],
		tmp.PurchaseOrderID,
		tmp.LineNumber,
		tmp.FullyReceiveAllLineItems,
		tmp.ReceivedDt,
		tmp.QuantityReceived,
		GETDATE()
	FROM [tmp].[PurchaseOrdersEnterprisePurchasingReceipts] tmp
END
