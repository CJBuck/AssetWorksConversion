--
select *
from TargetEquipmentManufacturer
where ManufacturerID LIKE 'NA%'

select * 
from TransformEquipmentType
where --EquipmentType = '1151GP6S22M3B2'
	ManufacturerID LIKE 'NA%'
	
--delete TransformEquipmentType
--where ManufacturerID = 'MERIAM'

update TransformEquipmentType
set ManufacturerID = 'FUJI ELECTRIC'
where ManufacturerID LIKE 'FUJI%'

select *
FROM TransformEquipmentManufacturer
where TargetValue LIKE 'ANNS%'
	[Source] = 'Hydrants'

select *
FROM TransformEquipmentManufacturerModel
where CleansedManufacturerID LIKE 'ANNS%'

update TransformEquipmentManufacturerModel
set CleansedManufacturerID = 'ANNS'
where CleansedManufacturerID = 'ROSEMOUNT'
	and [Source] = 'Facilities'

select *
from TransformEquipmentFacilitiesEquipmentValueEquipmentType
where [MAKE] LIKE 'NA%'

update TransformEquipmentFacilitiesEquipmentValueEquipmentType
set MAKE = 'FUJI ELCTRIC'
where [MAKE] LIKE 'FUJI%'

--delete TransformEquipmentFacilitiesEquipmentValueEquipmentType
--where OBJECT_ID = 'FI6301'

select *
from TransformEquipmentHydrantValueEquipmentType

select *
from SourceWicm210ObjectEquipment
where [object_id] = '2154410001'
