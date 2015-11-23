--

select EquipmentType, LEN(EquipmentType) [<-- Length],
	REPLACE(EquipmentType, 'CHEVY', 'CHEVROLET') [New EquipmentType],
	LEN(REPLACE(EquipmentType, 'CHEVY', 'CHEVROLET')) [<-- New Length]
from TransformEquipmentType
where EquipmentType like '%CHEVY%'

-- Location = '04'
SELECT DISTINCT LTRIM(RTRIM(OP.[OBJECT_ID])) [OBJECT_ID], LTRIM(RTRIM(OP.LOCATION)) [LOCATION]
FROM SourceWicm210ObjectProject OP
	INNER JOIN SourceWicm250WorkOrderHeaderAdmin woa
		ON OP.[OBJECT_ID] = woa.[OBJECT_ID] AND woa.[STATUS] IN ('A','P')
WHERE
	OP.[OBJECT_ID] NOT IN ('FRST', 'OTHR', 'SAFE')
	AND OP.LOCATION = '04'
	AND OP.[STATUS] = 'A'
	AND LTRIM(RTRIM(OP.[CLASS])) NOT IN ('LHTP', 'WRKSTA')
	--AND OP.[OBJECT_ID] like '%-2'
ORDER BY LTRIM(RTRIM(OP.[OBJECT_ID]))

	select * from tmp.ProjectFinalResultSet
	where AssetNumber like '07A0044%'
	
	select * from tmp.StagingProjects
	where
		Location = '04'
		and [Object_ID] not like '%-2'
--	[Object_ID] like '07A0044%'

select pfrs.EquipmentID, SP.[Object_ID]
from tmp.StagingProjects SP
	inner join tmp.ProjectFinalResultSet pfrs on left(SP.[Object_ID], 7) = left(pfrs.AssetNumber, 7)
where 
	Location = '04'
	and [Object_ID] like '%-2'
	and pfrs.AssetNumber not like '%-2'

select * from tmp.ProjectTracking
where AssetNumber like '07A0044%'

select distinct left([Object_ID], 2) 
from tmp.StagingProjects
where
	Location = '04'

select * from TransformEquipmentProjectComponentRelationship
order by EquipmentID
