CREATE PROCEDURE [dbo].[spLoadEquipmentSubsystem]
-- =================================================================================================
-- Created By:	Gerald Davis (Marathon Consulting)
-- Create Date:	09/21/2015
-- 
-- Description: Generates target tables in format identical to load file template
-- =================================================================================================
AS BEGIN

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetEquipmentSubsystem]') AND type in (N'U'))
	DROP TABLE [dbo].[TargetEquipmentSubsystem]

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TargetEquipmentSubsystemProperty]') AND type in (N'U'))
	DROP TABLE [dbo].[TargetEquipmentSubsystemProperty]

	CREATE TABLE [dbo].[TargetEquipmentSubsystem]
	(
		[Control] [nvarchar] (10) NOT NULL,
		[SubsystemID] [nvarchar](20) NOT NULL,
		[SubsystemProperty] [nvarchar](50) NOT NULL,
	) ON [PRIMARY]

	CREATE TABLE [dbo].[TargetEquipmentSubsystemProperty]
	(
		[Control] [nvarchar] (10) NOT NULL,
		[SubsystemID] [nvarchar](20) NOT NULL,
		[PropertyID] [nvarchar](50) NOT NULL,
		[InputType] [nvarchar](20) NULL,
		[ListTypeID] [nvarchar](20) NULL,
	) ON [PRIMARY]

	INSERT INTO TargetEquipmentSubsystemProperty
	(
		[Control],
		[SubsystemID],
		[PropertyID],
		[InputType],
		[ListTypeID]
	)
	SELECT
		[Control],
		[SubsystemID],
		[PropertyID],
		[InputType],
		[ListTypeID]
	FROM TransformEquipmentSubsystemProperty

	INSERT INTO TargetEquipmentSubsystem
	(
		[Control],
		[SubsystemID],
		[SubsystemProperty]
	)
	SELECT
		[Control],
		[SubsystemID],
		[SubsystemProperty]
	FROM TransformEquipmentSubsystem
END
