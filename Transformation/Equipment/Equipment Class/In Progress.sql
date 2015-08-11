--
select * from Staging_TransformEquipmentClassStableValues

truncate table Staging_TransformEquipmentClassStableValues

delete TransformEquipmentClassStableValues where [Source] = 'Distribution'

select *
from TransformEquipmentClassStableValues
where EquipmentClassID = 'DPM FLUSH AUTO'
