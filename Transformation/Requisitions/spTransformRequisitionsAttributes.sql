--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	10/30/2015
--	Updates:
--	Description:	Creates/modifies the spTransformRequisitionsAttributes stored procedure.
--					Populates the TransformRequisitionsAttributes table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformRequisitionsAttributes') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformRequisitionsAttributes AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformRequisitionsAttributes
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformRequisitionsAttributes
--	=================================================================================================
	IF OBJECT_ID('tmp.RequisitionsAttributes') IS NOT NULL
		DROP TABLE tmp.RequisitionsAttributes

	CREATE TABLE [tmp].[RequisitionsAttributes](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[RequisitionID] [varchar](30) NOT NULL,
		[LineNumber] [int] NULL,
		[AttributeID] [varchar](20) NULL,
		[TextValue] [varchar](30) NULL,
		[NumericValue] [decimal](10,2) NULL,
		[Comments] [varchar](60) NULL
	)

	INSERT INTO [tmp].[RequisitionsAttributes]
	SELECT DISTINCT
		r.RequisitionID,
		'1' [LineNumber],
		'FISCAL YEAR' [AttributeID],
		'2016' [TextValue],
		0 [NumericValue],
		'' [Comments]
	FROM TransformRequisitions R
	ORDER BY R.RequisitionID
	
	-- Copy temp to TransformRequisitionsAttributes
	INSERT INTO [dbo].[TransformRequisitionsAttributes]
	SELECT DISTINCT
		'[i]' [Control],
		tmp.RequisitionID,
		tmp.LineNumber,
		tmp.AttributeID,
		tmp.TextValue,
		tmp.NumericValue,
		tmp.Comments,
		GETDATE()
	FROM [tmp].[RequisitionsAttributes] tmp
END
