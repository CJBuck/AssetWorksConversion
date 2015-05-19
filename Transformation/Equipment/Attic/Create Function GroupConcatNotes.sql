USE [AssetWorksConversion]
GO

/****** Object:  UserDefinedFunction [dbo].[GroupConcatNotes]    Script Date: 02/12/2015 16:16:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GroupConcatNotes](@column1 VARCHAR(10)) RETURNS VARCHAR(8000)
AS
BEGIN
	DECLARE @output VARCHAR(8000)

	SELECT @output = COALESCE(@output + ', ', '') + [DATA]
	FROM SourceWicm213Notepad
	WHERE OB_ID = @column1 AND [DATA] > ''
	ORDER BY OB_ID, LINE_SEQ_NO

	RETURN @output
END

GO


