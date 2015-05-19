select * from TransformEquipmentLegacyXwalk where EquipmentID = 'EQP0001003'

select OE.[OBJECT_ID], OE.OB_EQUIP_D, OE.FAC_MODEL, OE.MFR_NAME, OE.ASSET_TYPE
from SourceWicm210ObjectEquipment OE
		--INNER JOIN TransformEquipmentFacilitiesEquipmentValueEquipmentType et
		--	ON LTRIM(RTRIM(OE.[Object_ID])) = LTRIM(RTRIM(et.[OBJECT_ID]))
where OE.[OBJECT_ID] = '3570010012'

select distinct OE.FAC_MODEL
from SourceWicm210ObjectEquipment OE
order by OE.FAC_MODEL

select *
from TransformEquipmentFacilitiesEquipmentValueEquipmentType
where [Object_ID] = '3570010012'

select *
from TransformComponent TC
where TC.Maintenance LIKE 'TAP MACH%'

select *
from TransformEquipmentVehicleValueSpecialEquipmentDetails

select *
from TransformObjectVehicleValueEquipmentClass
where EquipmentClassID like 'TAP MACH%'
--	EquipmentClassID = 'NO METER'
	