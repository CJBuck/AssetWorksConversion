--

select *
from AW_ProductionVehicleAssets PVA
where (PVA.[EQ_Equip_No] IN ('006656', '006533', '006657', '006565', '006572', '006573', '006678'))

select * from SourceWicm210ObjectEquipment
where [OBJECT_ID] = '0340010001'

select * from TransformEquipmentClass

select *
from TransformObjectVehicleValueMeterTypesClass
where EquipmentClassID = 'PICKUP 1/2 TON EXT CAB 4X4'

INSERT INTO TransformObjectVehicleValueMeterTypesClass
SELECT 'TRACTOR', 'HOURS'


select *
from TransformComponent
where isnull(EquipmentType, '') = ''

AIR COMPRESSOR	HOURS
FORKLIFT	HOURS
TRACTOR	HOURS
