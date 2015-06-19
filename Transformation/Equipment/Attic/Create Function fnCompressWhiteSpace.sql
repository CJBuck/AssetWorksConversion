USE [AssetWorksConversion]
GO

/****** Object:  UserDefinedFunction [dbo].[fnCompressWhiteSpace]    Script Date: 06/19/2015 08:15:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnCompressWhiteSpace]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnCompressWhiteSpace]
GO

USE [AssetWorksConversion]
GO

/****** Object:  UserDefinedFunction [dbo].[fnCompressWhiteSpace]    Script Date: 06/19/2015 08:15:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnCompressWhiteSpace](@columntext VARCHAR(8000)) RETURNS VARCHAR(8000)
AS
BEGIN
	DECLARE @output VARCHAR(8000)
	
	SET @output = @columntext
	
	WHILE CHARINDEX('  ',@output  ) > 0
	BEGIN
	   SET @output = REPLACE(@output, '  ', ' ')
	END
	
	RETURN LTRIM(RTRIM(@output))
END

GO
