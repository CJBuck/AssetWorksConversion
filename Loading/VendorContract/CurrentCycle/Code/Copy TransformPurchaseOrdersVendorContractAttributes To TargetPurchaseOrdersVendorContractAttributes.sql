INSERT INTO TargetPurchaseOrdersVendorContractAttributes
SELECT *
FROM TransformPurchaseOrdersVendorContractAttributes VCA
WHERE
	VCA.[Control] IS NOT NULL
	AND ISNULL(VCA.VendorContractID, '') <> ''
	AND ISNULL(VCA.VendorContractAttributeID, '') <> ''
