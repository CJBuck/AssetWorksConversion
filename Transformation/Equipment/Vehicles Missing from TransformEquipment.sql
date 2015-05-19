select COUNT(EquipmentID) [Count], EquipmentID
from TransformEquipment
where EquipmentID like 'GS%'
group by EquipmentID
having COUNT(EquipmentID) > 1
order by COUNT(EquipmentID) DESC, EquipmentID

select * from TransformEquipment where EquipmentID like 'GS%'

SELECT OV.[OBJECT_ID], OV.VEH_MAKE, OV.VEH_MODEL, OV.VEH_YEAR, OV.[CLASS] FROM SourceWicm210ObjectVehicle OV
WHERE OV.[OBJECT_ID] = '911343'

select *
from TransformEquipmentVehicleValueSpecialEquipmentDetails vehdet
where vehdet.WICM_OBJID LIKE '911450'

select *
from TransformEquipmentManufacturer manid
where manid.SourceValue = 'POLLARD'

select *
from TransformEquipmentManufacturerModel modid
where modid.CleansedManufacturerID = 'STIHL'
	and modid.SourceModelID = 'SG20'

SELECT *--DISTINCT VEH_YEAR, VEH_MAKE, VEH_MODEL, EquipmentType
FROM TransformEquipmentVehicleValueEquipmentType
WHERE VEH_MAKE = 'POLLARD' AND VEH_MODEL = 'D 67501-100'
	AND VEH_YEAR = '2004' AND EquipmentClass = '9189'

insert into TransformEquipmentVehicleValueEquipmentType
select '2000', 'POLLARD', 'M-96', 'METAL DETECTOR', '2000 FISHER M-96 M-DETECR'

select * from TransformObjectVehicleValueEquipmentClass vec
where vec.WICM_CLASS = '9189' and WICM_VEH_MAKE = 'POLLARD' and WICM_VEH_MODEL = 'D 67501-100'

select * from TransformEquipmentClass

	FROM SourceWicm210ObjectVehicle OV
		INNER JOIN TransformEquipmentVehicleValueVehicleDetails vehdet
			ON OV.[OBJECT_ID] = vehdet.[WICM_OBJID]
		-- ManufacturerID Cleansing
		INNER JOIN TransformEquipmentManufacturer manid
			ON LTRIM(RTRIM(OV.VEH_MAKE)) = manid.SourceValue
				AND manid.[Source] LIKE '%Vehicles%'
		-- ModelID Cleansing
		INNER JOIN TransformEquipmentManufacturerModel modid
			ON LTRIM(RTRIM(manid.[TargetValue])) = LTRIM(RTRIM(modid.CleansedManufacturerID))
				AND LTRIM(RTRIM(OV.[VEH_MODEL])) = LTRIM(RTRIM(modid.SourceModelID))
				AND modid.[Source] = 'Vehicles'
		-- EquipmentType Cleansing
		INNER JOIN (
			SELECT DISTINCT VEH_YEAR, VEH_MAKE, VEH_MODEL, EquipmentType
			FROM TransformEquipmentVehicleValueEquipmentType
			) vet
			ON manid.TargetValue = 'FORD'
				AND modid.CleansedModelID = 'F-150 4X4'
				AND OV.VEH_YEAR = '2010'
		INNER JOIN TransformObjectVehicleValueEquipmentClass vec
			ON LTRIM(RTRIM(OV.CLASS)) = vec.WICM_CLASS
				AND LTRIM(RTRIM(OV.VEH_MAKE)) = vec.WICM_VEH_MAKE
				AND LTRIM(RTRIM(OV.VEH_MODEL)) = vec.WICM_VEH_MODEL
		INNER JOIN TransformEquipmentClass tec ON vec.EquipmentClassID = tec.EquipmentClassID
		
--delete TransformEquipmentManufacturerModel
--where CleansedManufacturerID = 'GMC'
--	and CleansedModelID = 'K2500 4X4'

--insert into TransformEquipmentManufacturerModel
--select '[i]', 'STIHL', 'MS362-20', 'MS-362-20', 'MS-362-20', 'Vehicles', GETDATE()

--
select OV.[OBJECT_ID], OV.[STATUS], OV.VEH_YEAR,
	OV.VEH_MAKE [WICM_VEH_MAKE], '               ' [AW_MFR],
	OV.VEH_MODEL [WICM_VEH_MODEL], '               ' [AW_MODEL],
	'                              ' [AW_EQUIP_TYPE],
	OV.[CLASS] [WICM_CLASS], '                              ' [AW_EQUIP_CLASS]
into #Vehicles
from SourceWicm210ObjectVehicle OV
where OV.[OBJECT_ID] NOT IN (
	select LegacyID from TransformEquipmentLegacyXwalk
	)
	AND ((OV.[OBJECT_ID] IN (select WICM_OBJID from TransformEquipmentVehicleValueSpecialEquipmentDetails))
		OR (OV.[OBJECT_ID] IN (select WICM_OBJID from TransformEquipmentVehicleValueVehicleDetails)))

update #Vehicles
set AW_MFR = LTRIM(RTRIM(manid.TargetValue))
from #Vehicles veh
	inner join TransformEquipmentManufacturer manid
		on ltrim(rtrim(veh.WICM_VEH_MAKE)) = manid.SourceValue and manid.[Source] = 'Vehicles'

update #Vehicles
set AW_MODEL = LTRIM(RTRIM(modid.CleansedModelID))
from #Vehicles veh
	inner join TransformEquipmentManufacturerModel modid
		on ltrim(rtrim(veh.AW_MFR)) = ltrim(rtrim(modid.CleansedManufacturerID))
			and ltrim(rtrim(veh.WICM_VEH_MODEL)) = ltrim(rtrim(modid.SourceModelID))
			and modid.[Source] = 'Vehicles'
			
update #Vehicles
set AW_EQUIP_CLASS = vec.EquipmentClassID
from #Vehicles veh
	-- EquipmentClass
	inner join TransformObjectVehicleValueEquipmentClass vec
		ON LTRIM(RTRIM(veh.WICM_CLASS)) = vec.WICM_CLASS
			AND LTRIM(RTRIM(veh.WICM_VEH_MAKE)) = vec.WICM_VEH_MAKE
			AND LTRIM(RTRIM(veh.WICM_VEH_MODEL)) = vec.WICM_VEH_MODEL

update #Vehicles
set AW_EQUIP_TYPE = vet.EquipmentType
from #Vehicles veh
	-- EquipmentType Cleansing
	INNER JOIN (
		SELECT DISTINCT VEH_YEAR, VEH_MAKE, VEH_MODEL, EquipmentClass, EquipmentType
		FROM TransformEquipmentVehicleValueEquipmentType
		) vet
		ON veh.AW_MFR = vet.VEH_MAKE
			AND veh.AW_MODEL = vet.VEH_MODEL
			AND LTRIM(RTRIM(veh.VEH_YEAR)) = vet.VEH_YEAR
			AND veh.AW_EQUIP_CLASS = vet.EquipmentClass

select * from #Vehicles
drop table #Vehicles

select *
from TransformEquipmentVehicleValueEquipmentType
where VEH_MAKE = 'MUELLER'
order by VEH_MAKE, VEH_MODEL, VEH_YEAR, EquipmentClass