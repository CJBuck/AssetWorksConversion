--
select distinct POH.VENDORNUMBER, v.MUNISVendorID, v.MUNISVendorName
from SourceWicm330POHeader POH
	INNER JOIN TransformVendorWicmToMunisLookup v ON POH.VENDORNUMBER = v.WicmVendorNo
	
select *
from SourceWicm330POHeader POH
	inner join TransformVendor v on POH.VENDORNUMBER = v.VendorID
	
select * from TransformVendor
