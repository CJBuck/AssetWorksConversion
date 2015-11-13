INSERT INTO TargetPurchaseOrdersVendorContract
SELECT *
FROM TransformPurchaseOrdersVendorContract VC
WHERE
	VC.[Control] IS NOT NULL
	AND ISNULL(VC.VendorContractID, '') <> ''
	AND ISNULL(VC.VendorID, '') <> ''
	AND VC.BeginDate IS NOT NULL
	AND VC.EndDate IS NOT NULL
	AND VC.PurchasingLimit IS NOT NULL
	AND VC.NotificationPct IS NOT NULL
	AND ISNULL(VC.Comment, '') <> ''
	AND ISNULL(VC.ContractLines, '') <> ''
	AND ISNULL(VC.Files, '') <> ''
	AND ISNULL(VC.Attributes, '') <> ''
