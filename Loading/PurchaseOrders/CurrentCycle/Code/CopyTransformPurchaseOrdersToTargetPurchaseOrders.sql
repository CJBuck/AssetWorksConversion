INSERT INTO TargetPurchaseOrders
SELECT *
FROM TransformPurchaseOrders TPO
WHERE
	ISNULL(TPO.[Control], '') <> ''
	AND ISNULL(TPO.PurchaseOrderID, '') <> ''
	AND ISNULL(TPO.LocationID, '') <> ''
	AND ISNULL(TPO.[Description], '') <> ''
	AND ISNULL(TPO.VendorID, '') <> ''
	AND ISNULL(TPO.[Status], '') <> ''
	AND ISNULL(TPO.PurchaseTypeID, '') <> ''
	AND ISNULL(TPO.CurrencyID, '') <> ''
	AND ISNULL(TPO.AccountID, '') <> ''
	AND TPO.RequestedDt IS NOT NULL
	AND TPO.OrderedDt IS NOT NULL
	AND TPO.ExpectedDeliveryDt IS NOT NULL
	AND ISNULL(TPO.OrderedByEmployeeID, '') <> ''
	AND ISNULL(TPO.LineItems, '') <> ''
	AND TPO.RelatedWorkOrders IS NOT NULL
