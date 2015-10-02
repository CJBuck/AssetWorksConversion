SELECT
	'2325' [SCREEN],
	'8846:2' [PurchaseOrderID], '8853:2' [LocationID], '8853:5' [Description],
	'8853:7' [VendorID], '8853:10' [Status], '8853:12' [PurchaseTypeID],
	'8853:15' [CurrencyID], '8853:18' [AccountID], '8853:27' [RequestedDt],
	'8853:29' [OrderedDt], '8853:33' [ExpectedDeliveryDt], '8870:6' [OrderedByEmployeeID],
	'[GROUPROW]' [LineItems], '[GROUPROW]' [RelatedWorkOrders], '8903:2' [Comments]
UNION ALL
SELECT
	[Control], PurchaseOrderID, LocationID,
	[Description], VendorID, [Status],
	PurchaseTypeID, CurrencyID, AccountID,
	ISNULL((CONVERT(VARCHAR(10), CAST(RequestedDt AS DATE), 101)), '') [RequestedDt],
	ISNULL((CONVERT(VARCHAR(10), CAST(OrderedDt AS DATE), 101)), '') [OrderedDt],
	ISNULL((CONVERT(VARCHAR(10), CAST(ExpectedDeliveryDt AS DATE), 101)), '') [ExpectedDeliveryDt],
	OrderedByEmployeeID, LineItems, RelatedWorkOrders, Comments
FROM TargetPurchaseOrders
