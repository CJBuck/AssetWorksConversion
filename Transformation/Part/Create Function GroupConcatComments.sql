USE [AssetWorksConversion]
GO

/****** Object:  UserDefinedFunction [dbo].[GroupConcatComments]    Script Date: 03/26/2015 15:16:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GroupConcatComments](@column1 VARCHAR(10)) RETURNS VARCHAR(8000)
AS
BEGIN
	DECLARE @output VARCHAR(8000)

	SELECT @output = COALESCE(@output + ', ', '') + 
		LTRIM(RTRIM(pn.PART_NOTE1)) + ' ' + LTRIM(RTRIM(pn.PART_NOTE2)) + ' ' + 
			LTRIM(RTRIM(pn.PART_NOTE3)) + ' ' + LTRIM(RTRIM(pn.PART_NOTE4)) + ' ' + 
			LTRIM(RTRIM(pn.PART_NOTE5)) + ' ' + LTRIM(RTRIM(pn.PART_NOTE6))
	FROM SourceWicm222PartNotepad pn
	WHERE PART_NO = @column1 AND pn.PART_NOTE1 > ''
	ORDER BY PART_NO

	RETURN @output
END

GO


