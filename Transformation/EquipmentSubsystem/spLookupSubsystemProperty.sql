USE [AssetWorksConversion]
GO
/****** Object:  StoredProcedure [dbo].[spLookupSubsystemProperty]    Script Date: 10/13/2015 8:26:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gerald Davis (Marathon Consulting)
-- Create date: 10/5/2016
-- Description:	Dynamically lookup Subsystem property values
-- =============================================
ALTER PROCEDURE [dbo].[spLookupSubsystemProperty] 

	@SourceTable varchar(1000),
	@SourceColumn varchar(1000)
AS
BEGIN
	DECLARE @sqlCommand varchar(1000) = 
	'INSERT INTO tmp.EquipmentSubsystemPropertyValue
	 SELECT m.EquipmentId, m.SubsystemId, m.Property, s.' + @SourceColumn + ' AS Value' +
	' FROM tmp.EquipmentSubsystemPropertySourceMap m
	INNER JOIN ' + @SourceTable + ' s' +
	' ON m.LegacyID = s.OBJECT_ID' + 
	' WHERE m.SourceTable = ''' + @SourceTable + '''' +
	' AND m.SourceColumn = ''' + @SourceColumn + ''''

	EXECUTE(@sqlCommand)
END
