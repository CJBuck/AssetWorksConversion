--
TRUNCATE TABLE TransformPurchaseOrders
TRUNCATE TABLE TransformPurchaseOrdersLineItems
TRUNCATE TABLE TransformPurchaseOrdersEnterprisePurchasingReceipts
TRUNCATE TABLE TransformPurchaseOrdersVendorContract

EXEC spTransformPurchaseOrders
EXEC spTransformPurchaseOrdersLineItems
EXEC spTransformPurchaseOrdersEnterprisePurchasingReceipts
EXEC spTransformPurchaseOrdersVendorContract

SELECT * FROM TransformPurchaseOrders
SELECT * FROM TransformPurchaseOrdersLineItems
SELECT * FROM TransformPurchaseOrdersEnterprisePurchasingReceipts
SELECT * FROM TransformPurchaseOrdersVendorContract
