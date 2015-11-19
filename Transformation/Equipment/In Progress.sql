--

select EquipmentType, LEN(EquipmentType) [<-- Length],
	REPLACE(EquipmentType, 'CHEVY', 'CHEVROLET') [New EquipmentType],
	LEN(REPLACE(EquipmentType, 'CHEVY', 'CHEVROLET')) [<-- New Length]
from TransformEquipmentType
where EquipmentType like '%CHEVY%'
