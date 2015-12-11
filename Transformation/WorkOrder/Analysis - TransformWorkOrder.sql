--
TRUNCATE TABLE TransformWorkOrderCenter
TRUNCATE TABLE TransformWorkOrderCenterTasks
TRUNCATE TABLE TransformWorkOrderCenterLabor
TRUNCATE TABLE TransformWorkOrderCenterParts
TRUNCATE TABLE TransformWorkOrderCenterCommercial
TRUNCATE TABLE TransformWorkOrderCenterStandardJobs

EXEC spTransformWorkOrderCenter
EXEC spTransformWorkOrderCenterTasks
EXEC spTransformWorkOrderCenterLabor
EXEC spTransformWorkOrderCenterParts
EXEC spTransformWorkOrderCenterCommercial
EXEC spTransformWorkOrderCenterStandardJobs

SELECT * FROM TransformWorkOrderCenter
SELECT * FROM TransformWorkOrderCenterTasks
SELECT * FROM TransformWorkOrderCenterLabor
SELECT * FROM TransformWorkOrderCenterParts
SELECT * FROM TransformWorkOrderCenterCommercial
SELECT * FROM TransformWorkOrderCenterStandardJobs


-- 12/11/2015 Analysis
select *
from TransformWorkOrderCenter where [OBJECT_ID] = '006642'

SELECT *
FROM SourceWicm250WorkOrderHeaderVehiclesNewSvcInstallRepair HV
where
	HV.[OBJECT_ID] = '006642'
	AND HV.[OBJECT_ID] NOT IN (SELECT LegacyID FROM TransformEquipmentLegacyXwalk WHERE [Source] = 'SourceWicm210ObjectProject')
	AND HV.[OBJECT_ID] NOT LIKE 'LV%'
	AND HV.[STATUS] = 'A'
	AND HV.LOCATION <> '04'
	AND HV.OP_CODE1 <> '1000'
