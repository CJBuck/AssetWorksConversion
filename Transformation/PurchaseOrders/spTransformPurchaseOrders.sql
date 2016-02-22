--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	08/26/2015
--	Updates:
--		CJB 11/02/2015 Added new exclusion logic; modified the population logic for VendorID.
--	Description:	Creates/modifies the spTransformPurchaseOrders stored procedure.  Populates
--					the TransformPurchaseOrders table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformPurchaseOrders') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformPurchaseOrders AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformPurchaseOrders
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformPurchaseOrders
--	=================================================================================================
	IF OBJECT_ID('tmp.PurchaseOrders') IS NOT NULL
		DROP TABLE tmp.PurchaseOrders

	CREATE TABLE [tmp].[PurchaseOrders](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[PurchaseOrderID] [varchar](30) NOT NULL,
		[LocationID] [varchar](10) NULL,
		[Description] [varchar](30) NULL,
		[VendorID] [varchar](15) NULL,
		[Status] [varchar](20) NULL,
		[PurchaseTypeID] [varchar](20) NULL,
		[CurrencyID] [varchar](3) NULL,
		[AccountID] [varchar](30) NULL,
		[RequestedDt] [datetime] NULL,
		[OrderedDt] [datetime] NULL,
		[ExpectedDeliveryDt] [datetime] NULL,
		[OrderedByEmployeeID] [varchar](9) NULL,
		[LineItems] [varchar](30) NULL,
		[RelatedWorkOrders] [varchar](30) NULL,
		[Comments] [varchar](2000) NULL
	)

	-- SourceWicm300CcpHeader
	INSERT INTO [tmp].[PurchaseOrders]
	SELECT DISTINCT
		(LTRIM(RTRIM(CCPH.[TYPE])) + LTRIM(RTRIM(CCPH.[SEQ-NUM]))) [PurchaseOrderID],
		'STOREROOM' [LocationID],
		LTRIM(RTRIM(CCPH.JTEXT15)) [Description],
		v.TargetVendorID [VendorID],
		'OPEN' [Status],
		'HISTORIC WICM CCP' [PurchaseTypeID],
		'USD' [CurrencyID],
		'6000-0000-145300-000000-00000' [AccountID],
		CONVERT(DATETIME, (CCPH.[ORDER-DATE] + ' ' + LEFT(CCPH.[ORDER-TIME], 2) + ':' +
			SUBSTRING(CCPH.[ORDER-TIME], 3, 2)), 101) [RequestedDt],
		CONVERT(DATETIME, (CCPH.[ORDER-DATE] + ' ' + LEFT(CCPH.[ORDER-TIME], 2) + ':' +
			SUBSTRING(CCPH.[ORDER-TIME], 3, 2)), 101) [OrderedDt],
		CASE
			WHEN ISDATE(CCPH.ESTDELDATE) = 1 THEN CCPH.ESTDELDATE
			ELSE NULL
		END [ExpectedDeliveryDt],
		xwalk.EmployeeID [OrderedByEmployeeID],
		'[8874:1;LINES;1:1]' [LineItems],
		'[8904:1;WO;1:1]' [RelatedWorkOrders],
		dbo.TransformPurchaseOrdesConcatComments(LTRIM(RTRIM(CCPH.[TYPE])) + LTRIM(RTRIM(CCPH.[SEQ-NUM]))) [Comments]
	FROM SourceWicm300CcpHeader CCPH
		INNER JOIN TransformVendorSourceToTargetLookup v ON CCPH.VNUMBER = v.WICMVendorNumber
		LEFT JOIN TransformWicmEINXwalk xwalk ON CCPH.BUYERID = xwalk.BuyerID
	WHERE CCPH.[STATUS] <> 'X'
		AND CCPH.[TYPE] <> 'W'
		AND (LTRIM(RTRIM(CCPH.[TYPE])) + LTRIM(RTRIM(CCPH.[SEQ-NUM]))) IN (
			SELECT DISTINCT CCP_NUMBER FROM SourceWicm305CcpDetail WHERE PART_NO NOT LIKE 'N%'
			)

	---- SourceWicm330POHeader
	--INSERT INTO [tmp].[PurchaseOrders]
	--SELECT DISTINCT
	--	POH.PONUMBER [PurchaseOrderID],
	--	'STOREROOM' [LocationID],
	--	LEFT(LTRIM(RTRIM(POH.COMMENT)), 30) [Description],
	--	v.MUNISVendorID [VendorID],
	--	'OPEN' [Status],
	--	'BLANKET AMOUNT PO' [PurchaseTypeID],
	--	'USD' [CurrencyID],
	--	'' [AccountID],
	--	ISNULL(po.[Create Date], NULL) [RequestedDt],
	--	ISNULL(po.[Create Date], NULL) [OrderedDt],
	--	ISNULL(po.[Create Date], NULL) [ExpectedDeliveryDt],
	--	ISNULL(LEFT(LTRIM(RTRIM(m.rh_clerk_id)), 9), '') [OrderedByEmployeeID],
	--	'[8874:1;LINES;1:1]' [LineItems],
	--	'[8904:1;WO;1:1]' [RelatedWorkOrders],
	--	'' [Comments]
	--FROM SourceWicm330POHeader POH
	--	INNER JOIN TransformVendorWicmToMunisLookup v ON POH.VENDORNUMBER = v.WicmVendorNo
	--	LEFT JOIN TransformMUNISOpenRequisitions m ON POH.PONUMBER = LTRIM(RTRIM(CONVERT(VARCHAR, CAST(m.a_purch_order_no AS INT))))
	--	LEFT JOIN TransformMUNISPurchaseOrders po ON POH.PONUMBER = LTRIM(RTRIM(CONVERT(VARCHAR, CAST(po.[Purchase Order] AS INT))))
	--		AND po.[Record Type] = 'Header'
	--WHERE POH.PONUMBER LIKE '2016%'
	
	-- Copy temp to TransformPurchaseOrders
	INSERT INTO [dbo].[TransformPurchaseOrders]
	SELECT DISTINCT
		'[i]' [Control],
		tmp.PurchaseOrderID,
		tmp.LocationID,
		tmp.[Description],
		tmp.VendorID,
		tmp.[Status],
		tmp.PurchaseTypeID,
		tmp.CurrencyID,
		tmp.AccountID,
		tmp.RequestedDt,
		tmp.OrderedDt,
		tmp.ExpectedDeliveryDt,
		tmp.OrderedByEmployeeID,
		tmp.LineItems,
		tmp.RelatedWorkOrders,
		tmp.Comments,
		GETDATE()
	FROM [tmp].[PurchaseOrders] tmp
END
