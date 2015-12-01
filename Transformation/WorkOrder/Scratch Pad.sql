--
WITH StandardJobs AS (
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber, HA.[OBJECT_ID],
		CASE
			WHEN HA.[OBJECT_ID] LIKE '__A0%' THEN 'PROJECT-AGMT'
			WHEN HA.[OBJECT_ID] LIKE '__AN%' THEN 'PROJECT-MOU'
			WHEN HA.[OBJECT_ID] LIKE '__AH%' THEN 'PROJECT-MOU'
			WHEN HA.[OBJECT_ID] LIKE '__D%' THEN 'PROJECT-DSI'
			WHEN HA.[OBJECT_ID] LIKE '__M%' THEN 'PROJECT-MAINT'
			WHEN HA.[OBJECT_ID] LIKE '__S0%' THEN 'PROJECT-STATE'
			ELSE '** ERROR **'
		END [StandardJobID]
	FROM SourceWicm250WorkOrderHeaderAdmin HA
		INNER JOIN TransformWorkOrderCenter woc ON HA.WO_NUMBER = woc.WorkOrderNumber
			AND HA.LOCATION = woc.Location
	WHERE HA.LOCATION = '04'
)
SELECT * FROM StandardJobs WHERE StandardJobID = '** ERROR **'

