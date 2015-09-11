USE [AssetWorksConversion]
GO

/****** Object:  StoredProcedure [dbo].[spLoadPart]    Script Date: 9/4/2015 11:19:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[spLoadAssetHeirarchy]
-- =================================================================================================
-- Created By:	Gerald Davis (Marathon Consulting)
-- Create Date:	09/04/2015
-- 
-- Description: Loads data into asset heirarchy tables
--				TargetAssetHierarchyRelationship - relationship between asset records
-- =================================================================================================
AS
BEGIN

	TRUNCATE TABLE TargetAssetHierarchyRelationship

	INSERT INTO TargetAssetHierarchyRelationship
	(
		[Control],
		AssetWorksEquipmentId,
		ComponentId
	)
	SELECT
		[Control],
		AssetWorksEquipmentId,
		ComponentId
	FROM TransformAssetHierarchyRelationship
	WHERE ComponentId IS NOT NULL
END
GO


