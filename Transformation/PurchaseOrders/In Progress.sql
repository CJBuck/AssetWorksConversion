--
SELECT LI.*
FROM [tmp].[PurchaseOrdersLineItems] LI
	INNER JOIN SourceWicm305CcpDetail ccpd ON LI.PurchaseOrderID = ccpd.CCP_NUMBER
	INNER JOIN SourceWicm300CcpHeader ccph ON LI.PurchaseOrderID = ccph.PONUMBER
WHERE Quantity IS NULL

select * from TransformPurchaseOrders
where PurchaseOrderID = 'C00014'

select * from TransformPurchaseOrdersLineItems
where PurchaseOrderID = 'C00014'

select *
from SourceWicm305CcpDetail
where CCP_NUMBER = 'C00014'

select *
from SourceWicm300CcpHeader
where PONUMBER = 'C00014'

-- Stuart:  none
select *
from SourceWicm305CcpDetail
where CCP_NUMBER IN (SELECT PONUMBER FROM SourceWicm300CcpHeader)
