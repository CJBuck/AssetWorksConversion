SELECT
	'2072' [SCREEN], '[KEY]' [VendorContractID],
	'13264:3' [PathAndFileName], '13264:4' [FileDescription]
UNION ALL
SELECT
	[Control], VendorContractID,
	[PathAndFileName], [FileDescription]
FROM TargetPurchaseOrdersVendorContractFiles
