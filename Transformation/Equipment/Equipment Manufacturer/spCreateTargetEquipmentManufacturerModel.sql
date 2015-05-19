-- =====================================================================================
-- Created By:	Chris Buck
-- Create Date:	04/09/2015
-- Description: Creates/modifies the spCreateTargetEquipmentManufacturerModel stored
--				procedure.
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
		[Control] [varchar](10) NOT NULL,
		[CleansedManufacturerID] [varchar](15) NOT NULL,
		[SourceModelID] [varchar](100) NOT NULL,
		[CleansedModelID] [varchar](15) NOT NULL,
		[ModelName] [varchar](30) NOT NULL,
		[Source] [varchar](50) NOT NULL,
		[CreateDt] [datetime] NOT NULL
	) ON [PRIMARY]
	
	INSERT INTO TargetEquipmentManufacturerModel
	SELECT
		TEMM.[Control],
		TEMM.CleansedManufacturerID,
		TEMM.SourceModelID,
		TEMM.CleansedModelID,
		TEMM.ModelName,
		TEMM.[Source],
		GETDATE()
	FROM TransformEquipmentManufacturerModel TEMM
	ORDER BY TEMM.CleansedModelID, TEMM.[Source]
END
