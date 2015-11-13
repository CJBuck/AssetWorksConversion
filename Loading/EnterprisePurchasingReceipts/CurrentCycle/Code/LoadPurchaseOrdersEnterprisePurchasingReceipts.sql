SELECT
	'2327' [SCREEN], '8844:2' [PurchaseOrderID], '8844:6' [LineNumber],
	'8844:10' [FullyReceiveAllLineItems], '8855:63' [ReceivedDt],
	'8855:7' [QuantityReceived]
UNION ALL
SELECT
	[Control], PurchaseOrderID, CAST(LineNumber AS VARCHAR) [LineNumber],
	[FullyReceiveAllLineItems],
	ISNULL((CONVERT(VARCHAR(10), CAST(ReceivedDt AS DATE), 101)), '') [ReceivedDt],
	CAST([QuantityReceived] AS VARCHAR) [QuantityReceived]
FROM TargetPurchaseOrdersEnterprisePurchasingReceipts
