--
INSERT INTO TargetPurchaseOrdersVendorContract
SELECT *
FROM TransformPurchaseOrdersVendorContract VC
WHERE
	VC.[Control] IS NOT NULL
	AND VC.VendorContractID IS NOT NULL
	AND VC.VendorID IS NOT NULL
	AND VC.BeginDate IS NOT NULL
	AND VC.EndDate IS NOT NULL
	AND VC.PurchasingLimit IS NOT NULL
	AND VC.NotificationPct IS NOT NULL
	AND VC.Comment IS NOT NULL
	AND VC.ContractLines IS NOT NULL
