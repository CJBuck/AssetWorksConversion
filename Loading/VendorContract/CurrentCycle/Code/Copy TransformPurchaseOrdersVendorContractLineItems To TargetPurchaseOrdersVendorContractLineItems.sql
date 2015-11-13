INSERT INTO TargetPurchaseOrdersVendorContractLineItems
SELECT *
FROM TransformPurchaseOrdersVendorContractLineItems VCLI
WHERE
	VCLI.[Control] IS NOT NULL
	AND ISNULL(VCLI.VendorContractID, '') <> ''
	AND ISNULL(VCLI.ContractLineID, '') <> ''
	AND ISNULL(VCLI.LineItemDescription, '') <> ''
