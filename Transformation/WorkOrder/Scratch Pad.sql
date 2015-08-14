--
select *
from SourceWicm250WorkOrderHeaderPlant HP
	--INNER JOIN TransformEquipmentLegacyXwalk xwalk ON HP.[OBJECT_ID] = xwalk.LegacyID
	--	AND [Source] = 'SourceWicm210ObjectEquipment'
where --HP.[OBJECT_ID] NOT LIKE 'LV%'
	WO_NUMBER = '212341'

select DLP.*
from SourceWicm251WorkOrderDetailLaborCharges DLP
	inner join SourceWicm250WorkOrderHeaderPlant hp ON DLP.WO_NUMBER = hp.WO_NUMBER AND hp.LOCATION <> '05'
where DLP.WO_NUMBER = '212341'
order by DLP.TRANS_DATE desc

select distinct woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber, DLP.OPER_CODE
from SourceWicm251WorkOrderDetailLaborCharges DLP
	inner join SourceWicm250WorkOrderHeaderPlant hp ON DLP.WO_NUMBER = hp.WO_NUMBER
	inner join TransformWorkOrderCenter woc ON DLP.WO_NUMBER = woc.WorkOrderNumber
	inner join SourceWicm230TableLookupOperationCodes lkup ON DLP.OPER_CODE = lkup.OP_CODE
where DLP.WO_NUMBER = '212341'
order by woc.WorkOrderNumber

select * from tmp.WorkOrderCenter

select * from TransformWorkOrderOpCode
where OpCode = '2000'

select * from SourceWicm230TableLookupOperationCodes
where OP_CODE = '0980'

select *
from TransformWorkOrderOpCode
where OpCode = '0980'
