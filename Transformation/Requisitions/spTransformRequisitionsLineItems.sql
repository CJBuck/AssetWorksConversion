--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	10/29/2015
--	Updates:
--	Description:	Creates/modifies the spTransformRequisitionsLineItems stored procedure.
--					Populates the TransformRequisitionsLineItems table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformRequisitionsLineItems') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformRequisitionsLineItems AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformRequisitionsLineItems
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformRequisitionsLineItems
--	=================================================================================================
	IF OBJECT_ID('tmp.RequisitionsLineItems') IS NOT NULL
		DROP TABLE tmp.RequisitionsLineItems

	CREATE TABLE [tmp].[RequisitionsLineItems](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[RequisitionID] [varchar](30) NOT NULL,
		[LineNumber] [int] NULL,
		[Status] [varchar](20) NULL,
		[LineItemType] [varchar](20) NULL,
		[PartID] [varchar](22) NULL,
		[PartSuffix] [int] NULL,
		[PartDescription] [varchar](40) NULL,
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
		[AccountID] [varchar](30) NULL,
		[Action] [varchar](20) NULL,
		[AddToPurchasingID] [varchar](30) NULL,
		[Comments] [varchar](60) NULL
	)

	-- SourceWicm305CcpDetail
	INSERT INTO [tmp].[RequisitionsLineItems]
	SELECT
		r.RequisitionID,
		ROW_NUMBER() OVER(PARTITION BY r.RequisitionID ORDER BY CCPD.[LINENO]) [LineNumber],
		'OPEN' [Status],
		CASE
			WHEN EXISTS (SELECT * FROM TransformPart WHERE PartID = CCPD.PART_NO) THEN 'STOCK PART'
			WHEN CCPD.PART_NO LIKE 'FRT%' THEN 'SHIPPING'
			WHEN CCPD.PART_NO LIKE 'XCORE%' THEN 'FEE'
			WHEN CCPD.PART_NO LIKE 'CRED%' THEN '??'
			ELSE 'NON-STOCK PART'
		END [LineItemType],
		CASE
			WHEN (CCPD.PART_NO LIKE 'FRT%') OR (CCPD.PART_NO LIKE 'XCORE%') OR (CCPD.PART_NO LIKE 'CRED%') THEN ''
			ELSE CCPD.PART_NO
		END [PartID],
		CASE
			WHEN (CCPD.PART_NO NOT LIKE 'FRT%') OR (CCPD.PART_NO NOT LIKE 'XCORE%') OR (CCPD.PART_NO NOT LIKE 'CRED%') THEN '0'
			ELSE NULL
		END [PartSuffix],
		'' [PartDescription],	-- Missing from spec; may remain blank/null.
		CASE
			WHEN EXISTS (SELECT * FROM TransformPart WHERE PartID = CCPD.PART_NO) THEN ''
			WHEN (CCPD.PART_NO LIKE 'FRT%') OR (CCPD.PART_NO LIKE 'XCORE%') OR (CCPD.PART_NO LIKE 'CRED%') THEN ''
			ELSE 'HISTORIC WICM PART'
		END [OtherID],
		LEFT(LTRIM(RTRIM(DESC_45)), 30) [Description],
		CCPD.QTYORDERED [Quantity],
		CCPD.UNITCOST [UnitPrice],
		'STOREROOM' [LocationID],
		r.OrderedDt [OrderedDt],
		r.ExpectedDeliveryDt [ExpectedDeliveryDt],
		r.OrderedDt [SentToVendorDt],
		'' [VendorContractID],	-- Missing from spec; may remain blank/null.
		CASE
			WHEN LTRIM(RTRIM(CCPD.UNITOFISSUE)) = 'BAG' THEN 'BG'
			WHEN LTRIM(RTRIM(CCPD.UNITOFISSUE)) = 'FO' THEN 'FOOT'
			WHEN LTRIM(RTRIM(CCPD.UNITOFISSUE)) = 'LOT' THEN 'EA'
			ELSE ''
		END [UnitOfMeasure],
		'' [AccountID],		-- Updated below.
		'PURCHASE ORDER' [Action],
		'' [AddToPurchasingID],
		LEFT(LTRIM(RTRIM(DESC_45)), 30) [Comments]
	FROM SourceWicm305CcpDetail CCPD
		INNER JOIN TransformRequisitions r ON CCPD.CCP_NUMBER = r.RequisitionID
	WHERE CCPD.PART_NO NOT LIKE 'N%'
	ORDER BY CCPD.CCP_NUMBER, CCPD.[LINENO]
	
	-- Update AccountID
	UPDATE [tmp].[RequisitionsLineItems]
	SET AccountID = SUBSTRING((ISNULL((LEFT(LTRIM(RTRIM(MUNIS.[GL Account])), 30)), 30)), 4, 30)
	FROM TransformMUNISPurchaseOrders MUNIS
		INNER JOIN [tmp].[RequisitionsLineItems] poli ON
			LTRIM(RTRIM(CONVERT(VARCHAR, CAST(munis.[Purchase Order] AS INT)))) = poli.RequisitionID
				AND MUNIS.[Acct Line Number] = poli.LineNumber AND MUNIS.[Record Type] = 'Account'
	
	-- Copy temp to TransformRequisitionsLineItems
	INSERT INTO [dbo].[TransformRequisitionsLineItems]
	SELECT DISTINCT
		'[i]' [Control],
		tmp.RequisitionID,
		tmp.LineNumber,
		tmp.[Status],
		tmp.LineItemType,
		tmp.PartID,
		tmp.PartSuffix,
		tmp.PartDescription,
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
		tmp.[Action],
		tmp.AddToPurchasingID,
		tmp.Comments,
		GETDATE()
	FROM [tmp].[RequisitionsLineItems] tmp
END
