SELECT
	'2325' [SCREEN], '[KEY]' [PurchaseOrderID], '8874:3' [LineNumber],
	'8874:4' [Status], '8874:5' [LineItemType], '8874:6' [PartID],
	'8874:7' [PartSuffix], '8874:9' [OtherID], '8874:10' [Description],
	'8874:11' [Quantity], '8874:12' [UnitPrice], '8874:13' [LocationID],
	'8874:15' [OrderedDt], '8874:16' [ExpectedDeliveryDt],
	'8874:46' [SentToVendorDt],
	'8874:17' [VendorContractID], '8874:18' [UnitOfMeasure], '8874:20' [AccountID]
UNION ALL
SELECT
	[Control], PurchaseOrderID, CAST(LineNumber AS VARCHAR) [LineNumber],
	[Status], LineItemType, PartID,
	CAST(PartSuffix AS VARCHAR) [PartSuffix], OtherID, [Description],
	CAST(Quantity AS VARCHAR), CAST(UnitPrice AS VARCHAR), LocationID,
	ISNULL((CONVERT(VARCHAR(10), CAST(OrderedDt AS DATE), 101)), '') [OrderedDt],
	ISNULL((CONVERT(VARCHAR(10), CAST(ExpectedDeliveryDt AS DATE), 101)), '') [ExpectedDeliveryDt],
	ISNULL((CONVERT(VARCHAR(10), CAST(SentToVendorDt AS DATE), 101)), '') [SentToVendorDt],
	VendorContractID, UnitOfMeasure, AccountID
FROM TargetPurchaseOrdersLineItems
