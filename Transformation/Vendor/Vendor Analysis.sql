--
-- Transform WO Center Commercial - non-matches
select distinct
	'SourceWicm251WorkOrderDetailSublets' [Source Table],
	isnull(dbo.TRIM(DS.VENDOR_ID), '') [VENDOR_ID],
	'TransformVendorWicmToMunisLookup' [Lookup Table]
from SourceWicm251WorkOrderDetailSublets DS
where DS.OPER_CODE <> ''
	and isnull(dbo.TRIM(DS.VENDOR_ID), '') not in
		( select distinct ISNULL(dbo.TRIM(MUNISVendorID), '') from TransformVendorWicmToMunisLookup )
order by isnull(dbo.TRIM(DS.VENDOR_ID), '')

-- WorkOrderCenter - Matches (dupes with ID #183)
select distinct
	'SourceWicm251WorkOrderDetailSublets' [Source Table],
	isnull(dbo.TRIM(DS.VENDOR_ID), '') [VENDOR_ID],
	'TransformVendorWicmToMunisLookup' [Lookup Table],
	lkup.MUNISVendorID, lkup.MUNISVendorName
from SourceWicm251WorkOrderDetailSublets DS
	inner join TransformVendorWicmToMunisLookup lkup on isnull(dbo.TRIM(DS.VENDOR_ID), '') = ISNULL(dbo.TRIM(MUNISVendorID), '')
where DS.OPER_CODE <> ''
order by isnull(dbo.TRIM(DS.VENDOR_ID), '')

-- Transform PO {Main}
select distinct
	'SourceWicm300CCPHeader' [Source Table], isnull(dbo.TRIM(CCPH.VNUMBER), '') [VNUMBER],
	'TransformVendorWicmToMunisLookup' [Lookup Table],
	'' [WICMVendorNo], '' [MUNISVendorName]
from SourceWicm300CcpHeader CCPH
	WHERE CCPH.[STATUS] <> 'X'
		AND CCPH.[TYPE] <> 'W'
		AND (LTRIM(RTRIM(CCPH.[TYPE])) + LTRIM(RTRIM(CCPH.[SEQ-NUM]))) IN (
			SELECT DISTINCT CCP_NUMBER FROM SourceWicm305CcpDetail WHERE PART_NO NOT LIKE 'N%'
			)
		and isnull(dbo.TRIM(CCPH.VNUMBER), '') not in ( select distinct ISNULL(dbo.TRIM(WicmVendorNo), '') from TransformVendorWicmToMunisLookup )
order by isnull(dbo.TRIM(CCPH.VNUMBER), '')

-- PurchaseOrder - Matches
select distinct
	'SourceWicm300CCPHeader' [Source Table], isnull(dbo.TRIM(CCPH.VNUMBER), '') [VNUMBER],
	'TransformVendorWicmToMunisLookup' [Lookup Table],
	lkup.WicmVendorNo, lkup.WICMVendorName
from SourceWicm300CcpHeader CCPH
	inner join TransformVendorWicmToMunisLookup lkup on isnull(dbo.TRIM(CCPH.VNUMBER), '') = ISNULL(dbo.TRIM(WicmVendorNo), '')
where CCPH.[STATUS] <> 'X'
	and CCPH.[TYPE] <> 'W'
	and (LTRIM(RTRIM(CCPH.[TYPE])) + LTRIM(RTRIM(CCPH.[SEQ-NUM]))) in (
		SELECT DISTINCT CCP_NUMBER FROM SourceWicm305CcpDetail WHERE PART_NO NOT LIKE 'N%'
		)
order by isnull(dbo.TRIM(CCPH.VNUMBER), '')

-- VendorContract - NonMatches
select distinct
	'SourceWicm330POHeader' [Source Table],
	isnull(dbo.trim(POH.VENDORNUMBER), '') [VENDORNUMBER],
	'TransformVendorWicmToMunisLookup' [Lookup Table],
	'' [WICMVendorNo], '' [WICMVendorName]
from SourceWicm330POHeader POH
where POH.PONUMBER like '2016%'
	and POH.VENDORNUMBER not in ( select distinct ISNULL(dbo.TRIM(WicmVendorNo), '') from TransformVendorWicmToMunisLookup )

-- VendorContract - Matches
select distinct
	'SourceWicm330POHeader' [Source Table],
	isnull(dbo.trim(POH.VENDORNUMBER), '') [VENDORNUMBER],
	'TransformVendorWicmToMunisLookup' [Lookup Table],
	lkup.WicmVendorNo, lkup.WICMVendorName
from SourceWicm330POHeader POH
	inner join TransformVendorWicmToMunisLookup lkup ON isnull(POH.VENDORNUMBER, '') = isnull(dbo.TRIM(WicmVendorNo), '')
where POH.PONUMBER like '2016%'

-- Requisitions - NonMatches
select distinct
	'SourceWicm300CCPHeader' [Source Table], isnull(dbo.TRIM(CCPH.VNUMBER), '') [VNUMBER],
	'TransformVendorWicmToMunisLookup' [Lookup Table],
	'' [MUNISVendorID], '' [MUNISVendorName]
from SourceWicm300CcpHeader CCPH
where CCPH.[TYPE] = 'R' and CCPH.PONUMBER like '2016%'
		and isnull(dbo.TRIM(CCPH.VNUMBER), '') not in ( select distinct ISNULL(dbo.TRIM(WicmVendorNo), '') from TransformVendorWicmToMunisLookup )
order by isnull(dbo.TRIM(CCPH.VNUMBER), '')

-- Requisitions - Matches
select distinct
	'SourceWicm300CcpHeader' [Source Table],
	CCPH.VNUMBER [Source (VNUMBER)],
	'TransformVendorWicmToMunisLookup' [Lookup Table],
	tv.MUNISVendorID, tv.MUNISVendorName
from SourceWicm300CcpHeader CCPH
	inner join TransformVendorWicmToMunisLookup tv ON ISNULL(CCPH.VNUMBER, '') = isnull(dbo.TRIM(WicmVendorNo), '')
where CCPH.[TYPE] = 'R' and CCPH.PONUMBER like '2016%'

