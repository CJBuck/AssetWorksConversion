--
select * from TransformTestResults
where WorkOrderNumber = '601027'

select * from TransformTestResultsDetails
where TestID in (select TestID from TransformTestResults
where WorkOrderNumber = '601027')
order by TestElementID

select * 
from TransformWorkOrderCenter
where WorkOrderNumber = '601027' and RepairReasonID = 'PT'

select TCO.*
from [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2] TCO
	inner join TransformWorkOrderCenter woc on TCO.WO_NUMBER = woc.WorkOrderNumber
where TCO.HYD_RECS_ST <> '' and woc.RepairReasonID = 'PT'

SELECT CAST([dbo].[ufnTransformTestResultsSummaryCosts](@FindBy, 'PRJ-FLUSH-17') AS VARCHAR), '', '', ''

SELECT[dbo].[ufnTransformTestResultsSummaryCosts]('601032','PRJ-FLUSH-17')

SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
WHERE WO_NUMBER = '601032'

