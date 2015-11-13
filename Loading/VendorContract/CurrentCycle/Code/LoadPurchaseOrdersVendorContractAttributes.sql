SELECT
	'2072' [SCREEN], '[KEY]' [VendorContractID],
	'9063:3' [VendorContractAttributeID],
	'9063:5' [TextValue], '9063:6' [NumericValue],
	'9063:7' [Comments], '9063:8' [PathAndFileName]
UNION ALL
SELECT
	[Control], VendorContractID,
	[VendorContractAttributeID],
	ISNULL([TextValue], '') [TextValue],
	CAST([NumericValue] AS VARCHAR) [NumericValue],
	ISNULL([Comments], '') [Comments],
	ISNULL([PathAndFileName], '') [PathAndFileName]
FROM TargetPurchaseOrdersVendorContractAttributes
