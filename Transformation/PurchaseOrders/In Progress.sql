--
select PONUMBER, TOTALRELEASEDAMT, TOTALAMOUNT, (convert(decimal(12,2), TOTALAMOUNT) - convert(decimal(12,2), TOTALRELEASEDAMT)) [PurchasingLimit]
from SourceWicm330POHeader
	left join TransformVendor v ON VENDORNUMBER = v.VendorID
where PONUMBER IN (select PurchaseOrderID from TransformPurchaseOrders)
