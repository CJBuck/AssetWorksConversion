USE [AssetWorksConversion]
GO
/****** Object:  StoredProcedure [dbo].[spLookupSubsystemProperty]    Script Date: 1/11/2016 10:32:24 AM ******/
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
	DECLARE @lookupKey varchar(50) = 'OBJECT_ID'

	--handle cases where primary key is NOT OBJECT_ID

	IF UPPER(@SourceTable) = 'SOURCEPUPS201HYDRANT'
		SET @lookupKey = 'HYD_NO'
	ELSE IF UPPER(@SourceTable) = 'SOURCEPUPS201VALVE'
		SET @lookupKey = 'VALVE_NO'

	DECLARE @sqlCommand varchar(1000) = 
	'INSERT INTO tmp.EquipmentSubsystemPropertyValue
	 SELECT m.EquipmentId, m.SubsystemId, m.Property, s.' + @SourceColumn + ' AS Value' +
	' FROM tmp.EquipmentSubsystemPropertySourceMap m
	INNER JOIN ' + @SourceTable + ' s' +
	' ON m.LegacyID = s.' + @lookupKey + 
	' WHERE m.SourceTable = ''' + @SourceTable + '''' +
	' AND m.SourceColumn = ''' + @SourceColumn + ''''

	--SELECT @sqlCommand
	EXECUTE(@sqlCommand)
END