--
select * 
from TransformEquipmentLegacyXwalk
where [Source] = 'SourceWicm210ObjectProject'

select [object_id], LOCATION, LAST_WONO 
from SourceWicm210ObjectProject
where [OBJECT_ID] = '00A0007'

select * 
from SourceWicm250WorkOrderHeaderAdmin woha
where --woha.[OBJECT_ID] = '00A0007'
	woha.WO_NUMBER = '375060'

select * 
from SourceWicm250WorkOrderHeaderProjects wohp
where wohp.WO_NUMBER = '375060'

select *
from SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair wohv
where --wohv.WO_NUMBER = '375060'
	wohv.[object_id] = '00A0007'
