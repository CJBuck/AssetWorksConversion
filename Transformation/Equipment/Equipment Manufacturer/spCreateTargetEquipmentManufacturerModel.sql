-- =====================================================================================
-- Created By:	Chris Buck
-- Create Date:	04/09/2015
-- Description: Creates/modifies the spCreateTargetEquipmentManufacturerModel stored
--				procedure.
-- Updated: 05/28/2015 (Gerald Davis)
--			Changed output to reflect final export structure to prevent transform being
--			spread across SSIS package and SQL Server.
-- =====================================================================================

IF OBJECT_ID('spCreateTargetEquipmentManufacturerModel') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spCreateTargetEquipmentManufacturerModel AS SELECT 1')
GO

ALTER PROCEDURE dbo.spCreateTargetEquipmentManufacturerModel
AS
--
BEGIN
	/****** Check if table exists ******/
	IF  EXISTS 
		(
			SELECT * 
			FROM sys.objects
			WHERE object_id = OBJECT_ID(N'[dbo].[TargetEquipmentManufacturerModel]')
				AND TYPE IN (N'U')
		)
		DROP TABLE [dbo].[TargetEquipmentManufacturerModel]

	/****** Create the table ******/
	CREATE TABLE [dbo].[TargetEquipmentManufacturerModel](
		[Control] varchar(255) NOT NULL,
		[ManufacturerID] varchar(255) NOT NULL,
		[ModelID] varchar(15) NOT NULL,
		[ModelName] varchar(30) NOT NULL,
		[Active] char(1) NOT NULL
	) ON [PRIMARY]

	INSERT INTO TargetEquipmentManufacturerModel
	SELECT DISTINCT
		TEMM.[Control],
		TEMM.CleansedManufacturerID,
		TEMM.CleansedModelID,
		TEMM.ModelName,
		'Y'
	FROM TransformEquipmentManufacturerModel TEMM
	ORDER BY TEMM.CleansedModelID
END
