--
select * 
from TransformEquipmentLegacyXwalk
where [Source] = 'SourceWicm210ObjectVehicle'

select *
from TransformComponentLegacyXwalk
where [Source] = 'SourceWicm210ObjectVehicle'

select * from SourceWicm210ObjectVehicle where [OBJECT_ID] = '004001'

select [object_id], LOCATION, LAST_WONO 
from SourceWicm210ObjectProject
where [OBJECT_ID] = '00A0007'

select * 
from SourceWicm250WorkOrderHeaderAdmin woha
where --woha.[OBJECT_ID] = '00A0007'
	woha.WO_NUMBER = '375060'

select distinct wohp.LOCATION
from SourceWicm250WorkOrderHeaderProjects wohp
where wohp.WO_NUMBER = '375060'

select *
from SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair wohv
where --wohv.WO_NUMBER = '375060'
	wohv.[object_id] = '00A0007'

select *
from SourceWicm250WorkOrderHeaderPlant HP
	INNER JOIN TransformEquipmentLegacyXwalk xwalk ON HP.[OBJECT_ID] = xwalk.LegacyID
		AND [Source] = 'SourceWicm210ObjectEquipment'
where HP.[OBJECT_ID] NOT LIKE 'LV%'

with Facilities as (
	select distinct HV.[OBJECT_ID],
		CASE
			WHEN HV.[OBJECT_ID] LIKE '006%' THEN 'VEH SHOP'
			WHEN HV.[OBJECT_ID] LIKE '91%' THEN 'SE SHOP'
			ELSE ''
		END [WorkOrderLocationID]
	from SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
	WHERE
		HV.[LOCATION] = '01'
		and (HV.[OBJECT_ID] IN (SELECT LegacyID FROM TransformComponentLegacyXwalk where AssetID like 'GS%' ) OR HV.[OBJECT_ID] IN (SELECT LegacyID FROM TransformEquipmentLegacyXwalk where EquipmentID like 'GS%'))
		AND HV.WO_NUMBER NOT IN (SELECT WorkOrderNumber FROM [tmp].[WorkOrderCenter])
)
select * from Facilities
where ISNULL(WorkOrderLocationID, '') = ''
