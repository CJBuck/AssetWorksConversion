--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	11/05/2015
--	Description:	Creates/modifies the spTransformPurchaseOrdersVendorContractLineItems stored
--					procedure.  Populates the TransformPurchaseOrdersVendorContractLineItems table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformPurchaseOrdersVendorContractLineItems') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformPurchaseOrdersVendorContractLineItems AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformPurchaseOrdersVendorContractLineItems
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformPurchaseOrdersVendorContractLineItems
--	=================================================================================================
	IF OBJECT_ID('tmp.PurchaseOrdersVendorContractLineItems') IS NOT NULL
		DROP TABLE tmp.PurchaseOrdersVendorContractLineItems

	CREATE TABLE [tmp].[PurchaseOrdersVendorContractLineItems](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[VendorContractID] [varchar](30) NOT NULL,
		[ContractLineID] [varchar](30) NOT NULL,
		[LineItemDescription] [varchar](255) NULL
	)

	-- TransformMUNISPurchaseOrders
	INSERT INTO [tmp].[PurchaseOrdersVendorContractLineItems]
	SELECT
		LTRIM(RTRIM(CONVERT(VARCHAR, CAST(po.[Purchase Order] AS INT)))) [VendorContractID],
		ROW_NUMBER() OVER(PARTITION BY po.[Purchase Order] ORDER BY po.[PO Line Number]) [LineNumber],
		po.[PO Detail Description] [LineItemDescription]
	FROM TransformMUNISPurchaseOrders po
	WHERE po.[Record Type] = 'Detail Line'
		AND LTRIM(RTRIM(CONVERT(VARCHAR, CAST(po.[Purchase Order] AS INT)))) IN
			(	SELECT VendorContractID FROM TransformPurchaseOrdersVendorContract	)
	ORDER BY po.[Purchase Order], po.[PO Line Number]
	
	-- Copy temp to TransformPurchaseOrdersVendorContractLineItems
	INSERT INTO [dbo].[TransformPurchaseOrdersVendorContractLineItems]
	SELECT DISTINCT
		'[i]' [Control],
		tmp.VendorContractID,
		tmp.ContractLineID,
		tmp.LineItemDescription,
		GETDATE() [CreateDt]
	FROM [tmp].[PurchaseOrdersVendorContractLineItems] tmp
END
