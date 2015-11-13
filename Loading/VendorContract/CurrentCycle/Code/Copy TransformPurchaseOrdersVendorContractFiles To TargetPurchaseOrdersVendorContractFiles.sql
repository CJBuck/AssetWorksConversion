INSERT INTO TargetPurchaseOrdersVendorContractFiles
SELECT *
FROM TransformPurchaseOrdersVendorContractFiles VCF
WHERE
	VCF.[Control] IS NOT NULL
	AND ISNULL(VCF.VendorContractID, '') <> ''
