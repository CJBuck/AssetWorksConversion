--
select *
from TransformVendorMUNISExtractComplete

select * 
from TransformVendorSourceToTargetLookup

select *
from SourceWicm310Vendor

select *
from tmp.VendorContact
where VendorID = '1'

select *
from TransformVendorContact
