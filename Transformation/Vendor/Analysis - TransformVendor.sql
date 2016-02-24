--
TRUNCATE TABLE TransformVendor
TRUNCATE TABLE TransformVendorContact
TRUNCATE TABLE TransformVendorStore

EXEC spTransformVendor

SELECT * FROM TransformVendor
SELECT * FROM TransformVendorContact
SELECT * FROM TransformVendorStore
