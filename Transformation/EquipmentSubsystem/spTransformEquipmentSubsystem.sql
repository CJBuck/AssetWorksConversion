CREATE PROCEDURE [dbo].[spTransformEquipmentSubsystem]
-- =================================================================================================
-- Created By:	Gerald Davis (Marathon Consulting)
-- Create Date:	09/21/2015
-- 
-- Description: Generates TransformEquipmentSubsystem & TransformEquipmentSubsystemProperty 
--              from static values stored in Staging_SubsystemProperty.
-- =================================================================================================
AS BEGIN

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentSubsystem]') AND type in (N'U'))
	DROP TABLE [dbo].[TransformEquipmentSubsystem]

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentSubsystemProperty]') AND type in (N'U'))
	DROP TABLE [dbo].[TransformEquipmentSubsystemProperty]

	CREATE TABLE [dbo].[TransformEquipmentSubsystem](
		[Control] [nvarchar] (10) NOT NULL,
		[SubsystemID] [nvarchar](20) NOT NULL,
		[SubsystemProperty] [nvarchar](50) NOT NULL,
	) ON [PRIMARY]

	CREATE TABLE [dbo].[TransformEquipmentSubsystemProperty](
		[Control] [nvarchar] (10) NOT NULL,
		[SubsystemID] [nvarchar](20) NOT NULL,
		[PropertyID] [nvarchar](50) NOT NULL,
		[InputType] [nvarchar](20) NULL,
		[ListTypeID] [nvarchar](20) NULL,
	) ON [PRIMARY]

	INSERT INTO TransformEquipmentSubsystemProperty
	(
		[Control],
		[SubsystemID],
		[PropertyID],
		[InputType],
		[ListTypeID]
	)
	SELECT
		  '[i]' AS [Control], 
		  [KEY] AS SubsystemID,
		  Property AS PropertyID, 
		  InputType,
		  ListTypeID
	FROM Staging_SubsystemProperty
	ORDER BY [KEY], Property

	INSERT INTO TransformEquipmentSubsystem
	(
		[Control],
		[SubsystemID],
		[SubsystemProperty]
	)
	SELECT DISTINCT
		'[i]' AS [Control],
		SubsystemID,
		'[538:2;Subsystem;1:1]' AS Subsystem_Property
	FROM TransformEquipmentSubsystemProperty
END
