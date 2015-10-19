ALTER PROCEDURE [dbo].[spTransformEquipmentSubsystemParts]
-- =================================================================================================
-- Created By:	Gerald Davis (Marathon Consulting)
-- Create Date:	09/21/2015
-- 
-- Description: Generates TransformEquipmentSubsystemParts & TransformEquipmentSubsystemPartsProperty
--              from static values stored in Staging_SubsystemProperty as well as dynamic lookup of
--              values.
-- =================================================================================================
AS BEGIN

	-- Drop and recreate transform tables
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentSubsystemParts]') AND type in (N'U'))
	DROP TABLE [dbo].[TransformEquipmentSubsystemParts]

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentSubsystemPartsProperty]') AND type in (N'U'))
	DROP TABLE [dbo].[TransformEquipmentSubsystemPartsProperty]


	CREATE TABLE [dbo].[TransformEquipmentSubsystemParts]
	(
		[Control] [nvarchar](50) NOT NULL,
		[EquipmentID] [nvarchar](50) NOT NULL,
		[SubsystemID] [nvarchar](50) NOT NULL,
		[PrintOnPMOrders] [nchar](10) NOT NULL CONSTRAINT [DF_TransformEquipmentSubsystemParts_PrintOnPMOrders]  DEFAULT ('Y'),
		[SubsystemProperty] [nvarchar](50) NOT NULL CONSTRAINT [DF_TransformEquipmentSubsystemParts_SubsystemProperty]  DEFAULT ('[541:3;SubsystemParts;1-2:1-2]')
	) ON [PRIMARY]

	CREATE TABLE [dbo].[TransformEquipmentSubsystemPartsProperty]
	(
		[Control] [nvarchar](50) NOT NULL,
		[EquipmentID] [nvarchar](50) NOT NULL,
		[SubsystemID] [nvarchar](50) NOT NULL,
		[PropertyID] [nvarchar](50) NOT NULL,
		[Description] [nvarchar](100) NULL,
		[DisplayOnEQPrimary] [nchar](10) NOT NULL CONSTRAINT [DF_TransformEquipmentSubsystemPartsProperty_DisplayOnEQPrimary]  DEFAULT ('Y'),
		[Active] [nchar](10) NOT NULL CONSTRAINT [DF_TransformEquipmentSubsystemPartsProperty_Active]  DEFAULT ('Y')
	) ON [PRIMARY]

	--Insert SubsystemPartProperty records (just properties, all values null)
	INSERT INTO [dbo].[TransformEquipmentSubsystemPartsProperty]
	(
		[Control],
		EquipmentID,
		SubsystemID,
		PropertyID,
		DisplayOnEQPrimary,
		Active
	)
	SELECT
		'[i]' AS [Control],
		e.EquipmentID,
		p.SubsystemID,
		p.Property,
		'Y' AS DisplayOnEQPrimary,
		CASE e.LifeCycleStatusCodeID WHEN 'A' THEN 'Y' ELSE 'N' END AS Active
	FROM Staging_SubsystemProperty p
	INNER JOIN TransformEquipment e
		ON p.AssetCategory = e.AssetCategoryID
	INNER JOIN TransformEquipmentLegacyXwalk x
		ON e.EquipmentID = x.EquipmentID
	WHERE p.Exclude != 'Y'

	-- Create summary table for loading dynamically.
	INSERT INTO [dbo].[TransformEquipmentSubsystemParts]
    (
		[Control],
        EquipmentID,
        SubsystemID,
        SubsystemProperty,
		PrintOnPMOrders
	)
	SELECT DISTINCT
		'[i]' AS [Control],
		EquipmentID,
		SubsystemID,
		'[541:3;SubsystemParts;1-2:1-2]' AS Subsystem_Property,
		Active AS PrintOnPMOrders -- same logic for Active & PrintOnPMOrders
	FROM TransformEquipmentSubsystemPartsProperty

	-- drop temp tables property value and mapping tables (used in SELECT INTO)
	IF OBJECT_ID('tmp.EquipmentSubsystemPropertySourceMap') IS NOT NULL
		DROP TABLE tmp.EquipmentSubsystemPropertySourceMap

	IF OBJECT_ID('tmp.EquipmentSubsystemPropertyValue') IS NOT NULL
		DROP TABLE tmp.EquipmentSubsystemPropertyValue

	-- Create temp mapping table
	SELECT
		e.EquipmentID,
		x.LegacyID,
		p.SubsystemID,
		p.Property,
		p.SourceTable,
		p.SourceColumn
	INTO tmp.EquipmentSubsystemPropertySourceMap
	FROM Staging_SubsystemProperty p
	INNER JOIN TransformEquipment e
		ON p.AssetCategory = e.AssetCategoryID
	INNER JOIN TransformEquipmentLegacyXwalk x
		ON e.EquipmentID = x.EquipmentID
	WHERE p.Exclude != 'Y'
	AND p.Populate = 'Y'

	CREATE TABLE [tmp].[EquipmentSubsystemPropertyValue]
	(
		[EquipmentId] [varchar](20) NOT NULL,
		[SubsystemId] [nvarchar](20) NOT NULL,
		[Property] [nvarchar](50) NOT NULL,
		[Value] [varchar](100) NULL
	) ON [PRIMARY]

	DECLARE @SourceTable nvarchar(256)
	DECLARE @SourceColumn nvarchar(256)

	DECLARE PropCursor CURSOR
	FOR SELECT DISTINCT SourceTable, SourceColumn
	FROM Staging_SubsystemProperty
	WHERE Exclude != 'Y'
		AND Populate = 'Y'

	OPEN PropCursor

	WHILE 1= 1
	BEGIN
		FETCH NEXT FROM PropCursor INTO @SourceTable, @SourceColumn

		IF @@FETCH_STATUS != 0
		BEGIN
			BREAK
		END

		--SELECT @SourceTable, @SourceColumn
		EXEC spLookupSubsystemProperty @SourceTable, @SourceColumn
	END

	CLOSE PropCursor
	DEALLOCATE PropCursor

	-- Set property value for records where a non-empty value exists
	UPDATE p
	SET p.Description = dbo.TRIM(v.Value)
	FROM TransformEquipmentSubsystemPartsProperty p
	INNER JOIN tmp.EquipmentSubsystemPropertyValue v
		ON p.EquipmentID = v.EquipmentId
		AND p.SubsystemID = v.SubsystemId
		AND p.PropertyID = v.Property
	WHERE NULLIF(dbo.TRIM(v.Value), '') IS NOT NULL
END

