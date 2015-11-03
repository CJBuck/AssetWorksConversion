USE [AssetWorksConversion]
GO

/****** Object:  UserDefinedFunction [dbo].[TransformPurchaseOrdesConcatComments]    Script Date: 09/02/2015 09:56:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformPurchaseOrdesConcatComments]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[TransformPurchaseOrdesConcatComments]
GO

USE [AssetWorksConversion]
GO

/****** Object:  UserDefinedFunction [dbo].[TransformPurchaseOrdesConcatComments]    Script Date: 09/02/2015 09:42:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[TransformPurchaseOrdesConcatComments](@ccp_no VARCHAR(30)) RETURNS VARCHAR(8000)
AS
BEGIN
	DECLARE @output VARCHAR(2000)

	SELECT @output = COALESCE(@output + ', ', '') + LTRIM(RTRIM([COMMNT]))
	FROM SourceWicm301CcpComments
	WHERE CCP_NUMB = @ccp_no AND [COMMNT] > ''
	ORDER BY CCP_NUMB, SEQNO

	RETURN @output
END

GO


