--
select *
from TransformEquipmentType TET
where TET.[EquipmentType] = ''

select * from TransformEquipmentManufacturerModel
where CleansedManufacturerID = 'FUJI ELECTRIC'
	and CleansedModelID = '0412'
	
update TransformEquipmentManufacturerModel
set ModelName = '8750WA32EST1A1FPSE160CA1N0'
where CleansedManufacturerID = 'ROSEMOUNT ANALY'
	and CleansedModelID = '8750WA32..CA1N0'


8750WA32..CA1N0
