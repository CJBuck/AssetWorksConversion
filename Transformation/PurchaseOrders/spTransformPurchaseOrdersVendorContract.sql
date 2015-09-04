--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	09/04/2015
--	Updates:
--	Description:	Creates/modifies the spTransformPurchaseOrdersVendorContract stored procedure.
--					Populates the TransformPurchaseOrdersVendorContract table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformPurchaseOrdersVendorContract') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformPurchaseOrdersVendorContract AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformPurchaseOrdersVendorContract
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformPurchaseOrdersVendorContract
--	=================================================================================================
	IF OBJECT_ID('tmp.PurchaseOrdersVendorContract') IS NOT NULL
		DROP TABLE tmp.PurchaseOrdersVendorContract

	CREATE TABLE [tmp].[PurchaseOrdersVendorContract](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[VendorContractID] [varchar](30) NOT NULL,
		[Description] [varchar](60) NULL,
		[VendorID] [varchar](15) NULL,
		[BeginDate] [datetime] NULL,
		[EndDate] [datetime] NULL,
		[PurchasingLimit] [decimal](12,2) NULL,
		[NotificationPct] [decimal](5,2) NULL,
		[Comment] [varchar](1000) NULL,
		[ContractLines] [varchar](50) NOT NULL
	)

	-- SourceWicm330POHeader
	INSERT INTO [tmp].[PurchaseOrdersVendorContract]
	SELECT DISTINCT
		POH.PONUMBER [VendorContractID],
		LEFT(LTRIM(RTRIM(POH.COMMENT)), 60) [Description],
		v.VendorID [VendorID],
		NULL [BeginDate],	-- TBD: MUNIS
		NULL [EndDate],	-- TBD: MUNIS
		(CONVERT(DECIMAL(12,2), TOTALAMOUNT) - CONVERT(DECIMAL(12,2), TOTALRELEASEDAMT)) [PurchasingLimit],
		NULL [NotificationPct],
		'' [Comment],
		'[12548:1;ContractLines;1:1]' [ContractLines]
	FROM SourceWicm330POHeader POH
		LEFT JOIN TransformVendor v ON POH.VENDORNUMBER = v.VendorID
	WHERE POH.PONUMBER LIKE '2016%'
		and POH.PONUMBER IN (SELECT PurchaseOrderID FROM TransformPurchaseOrders)

	-- Copy temp to TransformPurchaseOrdersVendorContract
	INSERT INTO [dbo].[TransformPurchaseOrdersVendorContract]
	SELECT DISTINCT
		'[i]' [Control],
		tmp.VendorContractID,
		tmp.[Description],
		tmp.VendorID,
		tmp.BeginDate,
		tmp.EndDate,
		tmp.PurchasingLimit,
		tmp.NotificationPct,
		tmp.Comment,
		tmp.ContractLines,
		GETDATE()
	FROM [tmp].[PurchaseOrdersVendorContract] tmp
END
