--
with MaxLengths as (
	select [OBJECT_ID], VEH_EQU_ADDR, MAX(LEN(VEH_EQU_ADDR)) [Length]
	from SourceWicm210ObjectEquipment
	group by [OBJECT_ID], VEH_EQU_ADDR
)
select * from MaxLengths where [Length] > 10
