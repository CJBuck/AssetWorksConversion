--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	09/03/2015
--	Updates:
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
		'Y' [FullyReceiveAllLineItems],
		NULL [ReceivedDt],
		NULL [QuantityReceived]
	FROM TransformPurchaseOrders PO
		INNER JOIN TransformPurchaseOrdersLineItems oli ON PO.PurchaseOrderID = oli.PurchaseOrderID AND oli.LineNumber = 1

	-- Update detail-specific data
	UPDATE [tmp].[PurchaseOrdersEnterprisePurchasingReceipts]
	SET
		[ReceivedDt] =
			CASE
				WHEN ISDATE(ccpd.DATERECVD) = 1 THEN
					CONVERT(DATETIME, (ccpd.DATERECVD + ' 00:01'), 101)
				ELSE NULL
			END,
		[QuantityReceived] = ISNULL(ccpd.QTYORDERED, 0.00)
	FROM [tmp].[PurchaseOrdersEnterprisePurchasingReceipts] tmp
		INNER JOIN SourceWicm305CcpDetail ccpd ON tmp.PurchaseOrderID = ccpd.CCP_NUMBER
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
