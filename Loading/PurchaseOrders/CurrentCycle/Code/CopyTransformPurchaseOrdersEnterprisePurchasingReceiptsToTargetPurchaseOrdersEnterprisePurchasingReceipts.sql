INSERT INTO TargetPurchaseOrdersEnterprisePurchasingReceipts
SELECT *
FROM TransformPurchaseOrdersEnterprisePurchasingReceipts EPR
WHERE
	EPR.[Control] IS NOT NULL
	AND EPR.PurchaseOrderID IS NOT NULL
	AND EPR.LineNumber IS NOT NULL
	AND EPR.FullyReceiveAllLineItems IS NOT NULL
	AND EPR.ReceivedDt IS NOT NULL
	AND EPR.QuantityReceived IS NOT NULL
