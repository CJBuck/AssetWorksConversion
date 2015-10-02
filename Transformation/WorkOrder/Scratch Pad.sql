--
SELECT distinct A.TaskID
FROM TransformWorkOrderCenterParts A
INNER JOIN TransformWorkOrderCenter B on a.WorkOrderNumber = b.WorkOrderNumber
where b.EquipmentID like 'GS%'
AND TaskID like 'D%'

select * from TransformWorkOrderCenter WHERE EquipmentID = 'GS910428' and WorkOrderNumber = '027329'

SELECT A.WorkOrderNumber, A.TaskID
FROM TransformWorkOrderCenterParts A
	INNER JOIN TransformWorkOrderCenter B on a.WorkOrderNumber = b.WorkOrderNumber
where b.EquipmentID like 'GS%'
	AND TaskID = 'DSV'

SELECT A.WorkOrderNumber,B.EquipmentID, A.TaskID
FROM TransformWorkOrderCenterTasks A
	INNER JOIN TransformWorkOrderCenter B on a.WorkOrderNumber = b.WorkOrderNumber
where b.EquipmentID like 'GS%'
	AND A.TaskID = 'DSV'
	
select * from TransformWorkOrderCenterTasks where WorkOrderNumber = '027329'

select *
from TransformWorkOrderGSOpCode
where TaskIDAlignment = 'DSV'

select * from TransformComponentLegacyXwalk
where AssetID = 'GS910428'

select * from SourceWicm250WorkOrderHeaderProjects
where WO_NUMBER = '027329'
