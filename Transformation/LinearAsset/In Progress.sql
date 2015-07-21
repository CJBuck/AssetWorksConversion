--
select * from SourceWicm230TableLookupOperationCodes

select * from SourceWicm250WorkOrderHeaderProjects
where WO_NUMBER in (
	select WO_number from SourceWicm250WorkOrderHeaderAdmin
	)

-- 15 Rows
select * from SourceWicm250WorkOrderHeaderProjects WOHP
where WOHP.[OBJECT_ID] not in (
	select [OBJECT_ID] from SourceWicm210ObjectProject OP
	)
	and WOHP.[STATUS] IN ('A','P')

-- 320 Rows
select * from SourceWicm210ObjectProject OP
where [OBJECT_ID] in (
	select [OBJECT_ID] from SourceWicm250WorkOrderHeaderAdmin woha
	)
	and OP.[STATUS] IN ('A','P')

-- 557 Rows
select * from SourceWicm210ObjectProject OP
where OP.[OBJECT_ID] in (
	select [OBJECT_ID] from SourceWicm250WorkOrderHeaderProjects wohp
	)
	and OP.[STATUS] IN ('A','P')

-- 44 Rows
select * from SourceWicm250WorkOrderHeaderAdmin WOHA
where WOHA.[OBJECT_ID] not in (
	select [OBJECT_ID] from SourceWicm250WorkOrderHeaderProjects wohp
	)
	and WOHA.[STATUS] IN ('A','P')

-- 358 Rows
select * from SourceWicm250WorkOrderHeaderProjects WOHP
where WOHP.[OBJECT_ID] not in (
	select [OBJECT_ID] from SourceWicm250WorkOrderHeaderAdmin woha
	)
	and WOHP.[STATUS] IN ('A','P')
