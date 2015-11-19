--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	11/06/2015
--	Updates:
--		CJB 11/19/2015 Fixed where clause to only include those VendorContractIDs that exist in the
--			TransformPurchaseOrdersVendorContract table.
--	Description:	Creates/modifies the spTransformPurchaseOrdersVendorContractAttributes stored
--					procedure.  Populates the TransformPurchaseOrdersVendorContractAttributes table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformPurchaseOrdersVendorContractAttributes') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformPurchaseOrdersVendorContractAttributes AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformPurchaseOrdersVendorContractAttributes
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformPurchaseOrdersVendorContractAttributes
--	=================================================================================================
	IF OBJECT_ID('tmp.PurchaseOrdersVendorContractAttributes') IS NOT NULL
		DROP TABLE tmp.PurchaseOrdersVendorContractAttributes

	CREATE TABLE [tmp].[PurchaseOrdersVendorContractAttributes](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[VendorContractID] [varchar](30) NOT NULL,
		[VendorContractAttributeID] [varchar](30) NOT NULL,
		[TextValue] [varchar](30) NULL,
		[NumericValue] [decimal](12,4) NULL,
		[Comments] [varchar](60) NULL,
		[PathAndFileName] [varchar](255) NULL
	)

	-- TransformMUNISPurchaseOrders
	INSERT INTO [tmp].[PurchaseOrdersVendorContractAttributes]
	SELECT DISTINCT
		LTRIM(RTRIM(CONVERT(VARCHAR, CAST(MPO.[Purchase Order] AS INT)))) [VendorContractID],
		'MUNIS REQ NUMBER' [VendorContractAttributeID],
		MPO.[Requisition] [TextValue],
		NULL [NumericValue],
		'' [Comments],
		'' [PathAndFileName]
	FROM TransformMUNISPurchaseOrders MPO
		INNER JOIN TransformPurchaseOrdersVendorContract povc
			ON LTRIM(RTRIM(CONVERT(VARCHAR, CAST(MPO.[Purchase Order] AS INT)))) = povc.VendorContractID
	WHERE MPO.[Record Type] = 'Header'
		AND LTRIM(RTRIM(CONVERT(VARCHAR, CAST(MPO.[Purchase Order] AS INT)))) LIKE '2016%'
		
	-- TransformPurchaseOrdersVendorContractLineItems
	INSERT INTO [tmp].[PurchaseOrdersVendorContractAttributes]
	SELECT
		LTRIM(RTRIM(CONVERT(VARCHAR, CAST(MPO.[Purchase Order] AS INT)))) [VendorContractID],
		'LINE ITEM DETAILS' [VendorContractAttributeID],
		LTRIM(RTRIM(CONVERT(VARCHAR, CAST(MPO.[PO Line Number] AS INT)))) +
			'.' + LTRIM(RTRIM(CONVERT(VARCHAR, CAST(MPO.[Quantity] AS INT)))) + ' @ ' + 
			LTRIM(RTRIM(CONVERT(VARCHAR, CAST(MPO.[Unit Price] AS INT)))) + 
			' ' + MPO.[Unit of Measure] [TextValue],
		MPO.[Net Price] [NumericValue],
		CASE
			WHEN MPO.[GL Account] LIKE 'E -%' THEN REPLACE(MPO.[GL Account], 'E - ', '')
			WHEN MPO.[GL Account] LIKE 'E -%' THEN REPLACE(MPO.[GL Account], 'B - ', '')
		END [Comments],
		'' [PathAndFileName]
	FROM TransformMUNISPurchaseOrders MPO
	WHERE MPO.[Record Type] = 'Detail Line'
		AND LTRIM(RTRIM(CONVERT(VARCHAR, CAST(MPO.[Purchase Order] AS INT)))) LIKE '2016%'
	ORDER BY LTRIM(RTRIM(CONVERT(VARCHAR, CAST(MPO.[Purchase Order] AS INT))))
	
	-- Copy temp to TransformPurchaseOrdersVendorContractAttributes
	INSERT INTO [dbo].[TransformPurchaseOrdersVendorContractAttributes]
	SELECT DISTINCT
		'[i]' [Control],
		tmp.VendorContractID,
		tmp.VendorContractAttributeID,
		tmp.TextValue,
		tmp.NumericValue,
		tmp.Comments,
		tmp.PathAndFileName,
		GETDATE() [CreateDt]
	FROM [tmp].[PurchaseOrdersVendorContractAttributes] tmp
END
