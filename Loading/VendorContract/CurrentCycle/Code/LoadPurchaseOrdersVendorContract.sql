SELECT
	'2072' [VEN.CONTRACT], '287:2' [VendorContractID], '288:17' [Description],
	'288:2' [VendorID], '288:5' [Fax], '288:7' [BeginDate], '288:9' [EndDt],
	'288:11' [PurchasingLimit], '288:21' [NotificationPct],
	'288:23' [PartSalesTax], '288:25' [PartShipping],
	'288:27' [CommercialSalesTax], '289:2' [AdjustmentMultiplier],
	'289:3' [PerformPriceAdjustment], '7522:2' [Comment],
	'3302:3' [TermsDescPathAndFileName], '3302:5' [TermsDescription],
	'3302:1' [TermsDescriptionComments], '[GROUPROW]' [ContractLines],
	'[GROUPROW]' [Files], '[GROUPROW]' [Attributes]
UNION ALL
SELECT
	[Control], VendorContractID, [Description], [VendorID], [Fax],
	ISNULL((CONVERT(VARCHAR(10), CAST(BeginDate AS DATE), 101)), '') [BegindDt],
	ISNULL((CONVERT(VARCHAR(10), CAST(EndDate AS DATE), 101)), '') [EndDt],
	CAST(PurchasingLimit AS VARCHAR) [PurchasingLimit],
	CAST(NotificationPct AS VARCHAR) [NotificationPct],
	[PartSalesTax], [PartShipping], CommercialSalesTax,
	CAST(AdjustmentMultiplier AS VARCHAR) [AdjustmentMultiplier],
	PerformPriceAdjustment, [Comment], TermsDescPathAndFileName,
	TermsDescription, TermsDescriptionComments, ContractLines, Files,
	Attributes
FROM TargetPurchaseOrdersVendorContract
