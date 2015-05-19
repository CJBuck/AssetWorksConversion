-- =====================================================================================
-- Created By:	Chris Buck
-- Create Date:	04/09/2015
-- Description: Creates/modifies the spCreateTargetEquipmentManufacturer stored
--				procedure.
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
		[Control] [varchar] (10) NOT NULL,
		[SourceValue] [varchar](15) NOT NULL,
		[TargetValue] [varchar](15) NOT NULL,
		[ManufacturerName] [varchar] (30) NOT NULL,
		[Source] [varchar] (50) NOT NULL,
		[CreateDt] [datetime] NOT NULL
	) ON [PRIMARY]
	
	INSERT INTO TargetEquipmentManufacturer
	SELECT
		TEM.[Control],
		TEM.SourceValue,
		TEM.TargetValue,
		TEM.ManufacturerName,
		TEM.[Source],
		GETDATE()
	FROM TransformEquipmentManufacturer TEM
	ORDER BY TEM.TargetValue, TEM.[Source]
END
