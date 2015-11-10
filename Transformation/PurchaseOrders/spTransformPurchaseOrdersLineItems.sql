--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	09/02/2015
--	Updates:
--		CJB 11/03/2015 Modified the population logic for several fields.
--	Description:	Creates/modifies the spTransformPurchaseOrdersLineItems stored procedure.
--					Populates the TransformPurchaseOrdersLineItems table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformPurchaseOrdersLineItems') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformPurchaseOrdersLineItems AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformPurchaseOrdersLineItems
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformPurchaseOrdersLineItems
--	=================================================================================================
	IF OBJECT_ID('tmp.PurchaseOrdersLineItems') IS NOT NULL
		DROP TABLE tmp.PurchaseOrdersLineItems

	CREATE TABLE [tmp].[PurchaseOrdersLineItems](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[PurchaseOrderID] [varchar](30) NOT NULL,
		[LineNumber] [int] NOT NULL,
		[Status] [varchar](20) NULL,
		[LineItemType] [varchar](20) NULL,
		[PartID] [varchar](22) NULL,
		[PartSuffix] [int] NULL,
		[OtherID] [varchar](30) NULL,
		[Description] [varchar](30) NULL,
		[Quantity] [decimal](10,2) NULL,
		[UnitPrice] [decimal](10,4) NULL,
		[LocationID] [varchar](10) NULL,
		[OrderedDt] [datetime] NULL,
		[ExpectedDeliveryDt] [datetime] NULL,
		[SentToVendorDt] [datetime] NULL,
		[VendorContractID] [varchar](15) NULL,
		[UnitOfMeasure] [varchar](4) NULL,
		[AccountID] [varchar](30) NULL
	)

	-- SourceWicm305CcpDetail
	INSERT INTO [tmp].[PurchaseOrdersLineItems]
	SELECT
		po.PurchaseOrderID,
		ROW_NUMBER() OVER(PARTITION BY po.PurchaseOrderID ORDER BY CCPD.[LINENO]) [LineNumber],
		'OPEN' [Status],
		CASE
			WHEN EXISTS (SELECT * FROM TransformPart WHERE PartID = CCPD.PART_NO) THEN 'STOCK PART'
			WHEN CCPD.PART_NO LIKE 'FRT%' THEN 'SHIPPING'
			WHEN (CCPD.PART_NO LIKE 'CRED%') OR (CCPD.PART_NO LIKE 'XCORE%') THEN '???'
			ELSE 'NON-STOCK PART'
		END [LineItemType],
		CASE
			WHEN (CCPD.PART_NO LIKE 'FRT%') OR (CCPD.PART_NO LIKE 'CRED%') OR (CCPD.PART_NO LIKE 'XCORE%') THEN ''
			ELSE CCPD.PART_NO
		END [PartID],
		CASE
			WHEN (CCPD.PART_NO NOT LIKE 'FRT%') OR (CCPD.PART_NO NOT LIKE 'CRED%') OR (CCPD.PART_NO NOT LIKE 'XCORE%') THEN '0'
			ELSE NULL
		END [PartSuffix],
		CASE
			WHEN EXISTS (SELECT * FROM TransformPart WHERE PartID = CCPD.PART_NO) THEN ''
			WHEN (CCPD.PART_NO LIKE 'FRT%') OR (CCPD.PART_NO LIKE 'CRED%') OR (CCPD.PART_NO LIKE 'XCORE%') THEN ''
			ELSE 'HISTORIC WICM PART'
		END [OtherID],
		LEFT(LTRIM(RTRIM(DESC_45)), 30) [Description],
		CASE
			WHEN CCPD.QTYORDERED = CCPD.QTYRECVDTODT THEN QTYORDERED
			ELSE NULL
		END [Quantity],
		CCPD.UNITCOST [UnitPrice],
		'STOREROOM' [LocationID],
		po.OrderedDt [OrderedDt],
		po.ExpectedDeliveryDt [ExpectedDeliveryDt],
		po.OrderedDt [SentToVendorDt],
		'' [VendorContractID],
		CCPD.UNITOFISSUE [UnitOfMeasure],
		'' [AccountID]
	FROM SourceWicm305CcpDetail CCPD
		INNER JOIN TransformPurchaseOrders po ON CCPD.CCP_NUMBER = po.PurchaseOrderID
	WHERE CCPD.PART_NO NOT LIKE 'N%'
	ORDER BY CCPD.CCP_NUMBER, CCPD.[LINENO]
	
	---- SourceWicm330POHeader
	--INSERT INTO [tmp].[PurchaseOrdersLineItems]
	--SELECT
	--	po.PurchaseOrderID,
	--	munis.[PO Line Number] [LineNumber],
	--	'OPEN' [Status],
	--	'NON-STOCK PART' [LineItemType],
	--	'' [PartID],
	--	NULL [PartSuffix],
	--	'MUNIS PO' [OtherID],
	--	ISNULL(LEFT(LTRIM(RTRIM(munis.[PO Detail Description])), 30), '') [Description],
	--	ISNULL(munis.[Quantity], NULL) [Quantity],
	--	ISNULL(munis.[Unit Price], NULL) [UnitPrice],
	--	'STOREROOM' [LocationID],
	--	NULL [OrderedDt],
	--	NULL [ExpectedDeliveryDt],
	--	NULL [SentToVendorDt],
	--	po.PurchaseOrderID [VendorContractID],
	--	ISNULL(LEFT(LTRIM(RTRIM(munis.[Unit of Measure])), 4), '') [UnitOfMeasure],
	--	'' [AccountID]
	--FROM SourceWicm330POHeader POH
	--	INNER JOIN TransformPurchaseOrders po ON POH.PONUMBER = po.PurchaseOrderID
	--	INNER JOIN TransformMUNISPurchaseOrders munis ON POH.PONUMBER = LTRIM(RTRIM(CONVERT(VARCHAR, CAST(munis.[Purchase Order] AS INT))))
	--		AND munis.[Record Type] = 'Detail Line'
	--WHERE POH.PONUMBER LIKE '2016%'
	--ORDER BY POH.PONUMBER
	
	-- Update Quantity where NULL
	UPDATE [tmp].[PurchaseOrdersLineItems]
	SET Quantity = 
		CASE 
			WHEN ccph.[STATUS] IN ('R', 'F') THEN ccpd.QTYRECVDTODT
			WHEN ccph.[STATUS] IN ('A', 'L', 'P') and ccpd.QTYORDERED <> ccpd.QTYRECVDTODT
				THEN ccpd.QTYORDERED
		END
	FROM [tmp].[PurchaseOrdersLineItems] LI
		INNER JOIN SourceWicm305CcpDetail ccpd ON LI.PurchaseOrderID = ccpd.CCP_NUMBER
		INNER JOIN SourceWicm300CcpHeader ccph ON LI.PurchaseOrderID = (LTRIM(RTRIM(ccph.[TYPE])) + LTRIM(RTRIM(ccph.[SEQ-NUM])))
	WHERE Quantity IS NULL
	
	-- Update OrderedDt, ExpectedDeliveryDt, & SentToVendorDt
	UPDATE [tmp].[PurchaseOrdersLineItems]
	SET
		[OrderedDt] = ISNULL(munis.[Create Date], NULL),
		[ExpectedDeliveryDt] = ISNULL(munis.[Create Date], NULL),
		[SentToVendorDt] = ISNULL(munis.[Create Date], NULL)
	FROM TransformMUNISPurchaseOrders MUNIS
		INNER JOIN [tmp].[PurchaseOrdersLineItems] poli ON
			LTRIM(RTRIM(CONVERT(VARCHAR, CAST(munis.[Purchase Order] AS INT)))) = poli.PurchaseOrderID
				AND MUNIS.[Record Type] = 'Header'
	
	-- Update AccountID
	UPDATE [tmp].[PurchaseOrdersLineItems]
	SET AccountID = SUBSTRING((ISNULL((LEFT(LTRIM(RTRIM(MUNIS.[GL Account])), 30)), 30)), 4, 30)
	FROM TransformMUNISPurchaseOrders MUNIS
		INNER JOIN [tmp].[PurchaseOrdersLineItems] poli ON
			LTRIM(RTRIM(CONVERT(VARCHAR, CAST(munis.[Purchase Order] AS INT)))) = poli.PurchaseOrderID
				AND MUNIS.[Acct Line Number] = poli.LineNumber AND MUNIS.[Record Type] = 'Account'
	
	-- Copy temp to TransformPurchaseOrdersLineItems
	INSERT INTO [dbo].[TransformPurchaseOrdersLineItems]
	SELECT DISTINCT
		'[i]' [Control],
		tmp.PurchaseOrderID,
		tmp.LineNumber,
		tmp.[Status],
		tmp.LineItemType,
		tmp.PartID,
		tmp.PartSuffix,
		tmp.OtherID,
		tmp.[Description],
		tmp.Quantity,
		tmp.UnitPrice,
		tmp.LocationID,
		tmp.OrderedDt,
		tmp.ExpectedDeliveryDt,
		tmp.SentToVendorDt,
		tmp.VendorContractID,
		tmp.UnitOfMeasure,
		tmp.AccountID,
		GETDATE()
	FROM [tmp].[PurchaseOrdersLineItems] tmp
END
