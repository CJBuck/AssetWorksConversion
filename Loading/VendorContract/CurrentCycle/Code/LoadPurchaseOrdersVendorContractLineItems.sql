SELECT
	'2072' [SCREEN], '[KEY]' [VendorContractID],
	'12548:3' [ContractLineID], '12548:4' [LineItemDescription]
UNION ALL
SELECT
	[Control], VendorContractID,
	[ContractLineID], [LineItemDescription]
FROM TargetPurchaseOrdersVendorContractLineItems
