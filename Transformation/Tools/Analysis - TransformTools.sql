--
TRUNCATE TABLE TransformToolsUsageTicket
TRUNCATE TABLE TransformToolsTickets

EXEC spTransformTools

SELECT * FROM TransformToolsUsageTicket
SELECT * FROM TransformToolsTickets
