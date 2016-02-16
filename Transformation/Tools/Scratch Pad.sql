--

select *
from SourceWicm251WorkOrderDetailTools DT
	inner join tmp.EquipmentTools ET ON DT.TOOL_ID = ET.EquipmentID

select * --distinct LOCATION
from SourceWicm251WorkOrderDetailTools
where TOOL_ID = 'DZRS'

select distinct TOOL_ID
from SourceWicm251WorkOrderDetailTools T
where T.TOOL_ID not in (select TOOL_ID from SourceWicm230TableLookupToolIDs)

select distinct TOOL_ID
from SourceWicm230TableLookupToolIDs T
where T.TOOL_ID not in (select TOOL_ID from SourceWicm251WorkOrderDetailTools)

select *
from SourceWicm230TableLookupToolIDs

select * from TransformWorkOrderCenter
where WorkOrderNumber in ('300353','300402','300451','300500', '00535')

select * from TransformToolsPMLookup

select * from tmp.EquipmentTools
select * from tmp.ToolsUsageTicket
select * from tmp.ToolsTickets

