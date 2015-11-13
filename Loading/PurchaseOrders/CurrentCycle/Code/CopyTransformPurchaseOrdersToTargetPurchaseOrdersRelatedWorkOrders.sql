INSERT INTO TargetPurchaseOrdersRelatedWorkOrders
SELECT *
FROM TransformPurchaseOrdersRelatedWorkOrders RWO
WHERE
	ISNULL(RWO.[Control], '') <> ''
	AND ISNULL(RWO.PurchaseOrderID, '') <> ''
	AND RWO.LineNumber IS NOT NULL
