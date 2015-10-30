--
select *
from SourceWicm300CcpHeader CCPH
where CCPH.[TYPE] = 'R'
	and CCPH.PONUMBER like '2016%'
	
select * from TransformVendor
	
select * from TransformVendorWicmToMunisLookup
