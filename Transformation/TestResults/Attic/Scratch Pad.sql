--
select *
from TransformWorkOrderCenterStandardJobs
where WorkOrderNumber = '601099'

select * from SourceWicm250WorkOrderHeaderAdmin
where WO_NUMBER = '601099'

select * from TransformWorkOrderCenter
where --RepairReasonID = 'PT' 
	[OBJECT_ID] = '01D0099'
order by [Object_ID]

select [OBJECT_ID], WO_NUMBER, JURISDICTION, WO_INDATE, TIME_IN
from SourceWicm250WorkOrderHeaderAdmin
where WO_NUMBER = '601099'

select * from TransformEquipmentLegacyXwalk order by LegacyID where LegacyID = '01D0099'
select * from TransformComponentLegacyXwalk where LegacyID = '01D0099'

select *
from Staging_TransformTestResultsMappingLookup --where [Logic] is not null
where [OBJECT_ID] <> 'All'
	and [OBJECT_ID] like '%or like%'
	
select *
from Staging_TransformTestResultsMappingLookup
where CHARINDEX('D%', [OBJECT_ID]) > 0 or [OBJECT_ID] = 'All'


-- Mock Up
EXEC spTransformTestResults

select * from [tmp].TestResultsComboWorkTbl

select distinct [Test Element ID] 
from TransformTestResultsMappingLookup where [Source Table] = '250WorkOrderHeaderAdmin'
--where [Test Element ID] = 'EST-BO-01'

select
	[Test Element ID], [Source Column mapped to Qualitative Field],
	[Source Column mapped to Comments Field], [Source Column mapped to Numeric Field]
from TransformTestResultsMappingLookup where [Source Table] = '250WorkOrderHeaderAdmin'

select distinct LkUp_SourceTable
from [tmp].TestResultsComboWorkTbl
--where [Object_ID] = '01D0099'

select distinct LkUp_SourceColumnMappedToQualitativeField
from [tmp].TestResultsComboWorkTbl
where [Object_ID] = '01D0099'
	and LkUp_SourceTable = '250WorkOrderHeaderAdmin'

select *
from [tmp].TestResultsComboWorkTbl
where [Object_ID] = '01D0099'

select dbo.ufnGetTestResultsValue('01D0099', 'PRJ-002')

exec dbo.spTransformTestResults

select * from tmp.TestResults
select * from tmp.TestResultsDetails
--delete tmp.TestResultsDetails

select * from SourceWicm251WorkOrderDetailMaterialEstimates where WO_NUMBER = '601099'

select WO_NUMBER, OBJ_TYPE_1, ACT_COST_1, OBJ_TYPE_2, ACT_COST_2 
from [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2] where ACT_COST_1 <> '0' and ACT_COST_2 <> '0'

select WO_NUMBER, OBJ_TYPE_1, ACT_COST_1, OBJ_TYPE_2, ACT_COST_2,
	(CONVERT(decimal, act_cost_1) + CONVERT(decimal, act_cost_2)) [Sum]
from [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2] where WO_NUMBER = '602166'

SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1Contd where WO_NUMBER = '601099'
