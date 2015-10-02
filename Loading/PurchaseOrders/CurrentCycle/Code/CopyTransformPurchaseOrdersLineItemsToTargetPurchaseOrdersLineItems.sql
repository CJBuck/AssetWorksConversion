INSERT INTO TargetPurchaseOrdersLineItems
(
	[Control],
	[PurchaseOrderID],
	[LineNumber],
	[Status],
	[LineItemType],
	[PartID],
	[PartSuffix],
	[OtherID],
	[Description],
	[Quantity],
	[UnitPrice],
	[LocationID],
	[OrderedDt],
	[ExpectedDeliveryDt],
	[SentToVendorDt],
	[VendorContractID],
	[UnitOfMeasure],
	[AccountID],
	[CreateDt]
)
SELECT
	POLI.[Control],
	POLI.[PurchaseOrderID],
	POLI.[LineNumber],
	POLI.[Status],
	POLI.[LineItemType],
	POLI.[PartID],
	POLI.[PartSuffix],
	POLI.[OtherID],
	POLI.[Description],
	POLI.[Quantity],
	POLI.[UnitPrice],
	POLI.[LocationID],
	POLI.[OrderedDt],
	POLI.[ExpectedDeliveryDt],
	POLI.[SentToVendorDt],
	POLI.[VendorContractID],
	POLI.[UnitOfMeasure],
	POLI.[AccountID],
	GETDATE()
FROM TransformPurchaseOrdersLineItems POLI
WHERE
	ISNULL(POLI.[Control], '') <> ''
	AND ISNULL(POLI.PurchaseOrderID, '') <> ''
	AND POLI.LineNumber IS NOT NULL
	AND ISNULL(POLI.[Status], '') <> ''
	AND ISNULL(POLI.LineItemType, '') <> ''
	AND ISNULL(POLI.PartID, '') <> ''
	AND POLI.PartSuffix IS NOT NULL
	AND ISNULL(POLI.OtherID, '') <> ''
	AND ISNULL(POLI.[Description], '') <> ''
	AND POLI.Quantity IS NOT NULL
	AND POLI.UnitPrice IS NOT NULL
	AND ISNULL(POLI.LocationID, '') <> ''
	AND POLI.OrderedDt IS NOT NULL
	AND POLI.ExpectedDeliveryDt IS NOT NULL
	AND POLI.SentToVendorDt IS NOT NULL
	AND ISNULL(POLI.VendorContractID, '') <> ''
	AND ISNULL(POLI.UnitOfMeasure, '') <> ''
	AND ISNULL(POLI.AccountID, '') <> ''
