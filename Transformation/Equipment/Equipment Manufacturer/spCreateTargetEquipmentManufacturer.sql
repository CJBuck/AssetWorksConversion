-- =====================================================================================
-- Created By:	Chris Buck
-- Create Date:	04/09/2015
-- Description: Creates/modifies the spCreateTargetEquipmentManufacturer stored
--				procedure.
-- Updated: 05/28/2015 (Gerald Davis)
--			Changed output to reflect final export structure to prevent transform being spread
--			across SSIS package and SQL Server
-- =====================================================================================

IF OBJECT_ID('spCreateTargetEquipmentManufacturer') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spCreateTargetEquipmentManufacturer AS SELECT 1')
GO

ALTER PROCEDURE dbo.spCreateTargetEquipmentManufacturer
AS
--
BEGIN
	/****** Check if table exists ******/
	IF  EXISTS 
		(
			SELECT * 
			FROM sys.objects
			WHERE object_id = OBJECT_ID(N'[dbo].[TargetEquipmentManufacturer]')
				AND TYPE IN (N'U')
		)
		DROP TABLE [dbo].[TargetEquipmentManufacturer]

	/****** Create the table ******/
	CREATE TABLE [dbo].[TargetEquipmentManufacturer](
		[Control] varchar(10) NOT NULL,
		ManufacturerID varchar(255) NOT NULL,
		ManufacturerName varchar(255) NOT NULL,
		Active char(1) NOT NULL,
		Models varchar(255) NOT NULL
	) ON [PRIMARY]

	INSERT INTO TargetEquipmentManufacturer
	SELECT DISTINCT
		TEM.[Control],
		TEM.TargetValue,
		TEM.ManufacturerName,
		'Y', 
		'[534:4;Model;1:1]'
	FROM TransformEquipmentManufacturer TEM
	ORDER BY TEM.TargetValue
END
