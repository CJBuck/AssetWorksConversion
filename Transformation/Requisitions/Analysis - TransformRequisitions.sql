--
TRUNCATE TABLE TransformRequisitions
TRUNCATE TABLE TransformRequisitionsLineItems
TRUNCATE TABLE TransformRequisitionsRelatedWorkOrders
TRUNCATE TABLE TransformRequisitionsAttributes

EXEC spTransformRequisitions
EXEC spTransformRequisitionsLineItems
--EXEC spTransformRequisitionsRelatedWorkOrders		-- Not in use.
EXEC spTransformRequisitionsAttributes

SELECT * FROM TransformRequisitions
SELECT * FROM TransformRequisitionsLineItems
SELECT * FROM TransformRequisitionsRelatedWorkOrders
SELECT * FROM TransformRequisitionsAttributes
