--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	10/29/2015
--	Updates:
--	Description:	Creates/modifies the spTransformRequisitions stored procedure.  Populates
--					the TransformRequisitions table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformRequisitions') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformRequisitions AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformRequisitions
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformRequisitions
--	=================================================================================================
	IF OBJECT_ID('tmp.Requisitions') IS NOT NULL
		DROP TABLE tmp.Requisitions

	CREATE TABLE [tmp].[Requisitions](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[RequisitionID] [varchar](30) NOT NULL,
		[LocationID] [varchar](10) NULL,
		[Description] [varchar](30) NULL,
		[VendorID] [varchar](15) NULL,
		[Status] [varchar](20) NULL,
		[PurchaseTypeID] [varchar](20) NULL,
		[CurrencyID] [varchar](3) NULL,
		[AccountID] [varchar](30) NULL,
		[Approval] [varchar](20) NULL,
		[ApprovalEmployeeID] [varchar](9) NULL,
		[RequestedDt] [datetime] NULL,
		[OrderedDt] [datetime] NULL,
		[ExpectedDeliveryDt] [datetime] NULL,
		[OrderedByEmployeeID] [varchar](9) NULL,
		[LineItems] [varchar](50) NULL,
		[RelatedWorkOrders] [varchar](50) NULL,
		[Attributes] [varchar](50) NULL,
		[Comments] [varchar](2000) NULL
	)

	-- SourceWicm300CcpHeader
	INSERT INTO [tmp].[Requisitions]
	SELECT DISTINCT
		(LTRIM(RTRIM(CCPH.[TYPE])) + LTRIM(RTRIM(CCPH.[SEQ-NUM]))) [RequisitionID],
		'STOREROOM' [LocationID],
		LTRIM(RTRIM(CCPH.JTEXT15)) [Description],
		CASE
			WHEN ISNULL(tv.TargetVendorID, '') = '' THEN ''
			ELSE tv.TargetVendorID
		END [VendorID],
		'OPEN' [Status],
		'RELEASE' [PurchaseTypeID],
		'USD' [CurrencyID],
		'6000-0000-145300-000000-00000' [AccountID],
		'APPROVED' [Approval],
		xwalk.EmployeeID [ApprovalEmployeeID],
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
		'[8904:1;ATTRIBUTES;1:1]' [Attributes],
		dbo.TransformPurchaseOrdesConcatComments(LTRIM(RTRIM(CCPH.[TYPE])) + LTRIM(RTRIM(CCPH.[SEQ-NUM]))) [Comments]
	FROM SourceWicm300CcpHeader CCPH
		LEFT JOIN TransformVendorSourceToTargetLookup tv ON CCPH.VNUMBER = tv.WICMVendorNumber
		LEFT JOIN TransformWicmEINXwalk xwalk ON CCPH.BUYERID = xwalk.BuyerID
	WHERE CCPH.[TYPE] = 'R'
		AND CCPH.PONUMBER like '2016%'
		
		-- Copy temp to TransformRequisitions
	INSERT INTO [dbo].[TransformRequisitions]
	SELECT DISTINCT
		'[i]' [Control],
		tmp.RequisitionID,
		tmp.LocationID,
		tmp.[Description],
		tmp.VendorID,
		tmp.[Status],
		tmp.PurchaseTypeID,
		tmp.CurrencyID,
		tmp.AccountID,
		tmp.Approval,
		tmp.ApprovalEmployeeID,
		tmp.RequestedDt,
		tmp.OrderedDt,
		tmp.ExpectedDeliveryDt,
		tmp.OrderedByEmployeeID,
		tmp.LineItems,
		tmp.RelatedWorkOrders,
		tmp.Attributes,
		tmp.Comments,
		GETDATE()
	FROM [tmp].[Requisitions] tmp
END
