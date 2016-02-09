--
TRUNCATE TABLE TransformTestResults
TRUNCATE TABLE TransformTestResultsDetails

EXEC spTransformTestResults

SELECT * FROM TransformTestResults
SELECT * FROM TransformTestResultsDetails
