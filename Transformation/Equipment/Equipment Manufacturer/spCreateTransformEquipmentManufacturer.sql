-- =====================================================================================
-- Created By:	Chris Buck
-- Create Date:	03/04/2015
-- Description: Creates/modifies the spCreateTransformEquipmentManufacturer stored
--				procedure.
-- =====================================================================================

IF OBJECT_ID('spCreateTransformEquipmentManufacturer') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spCreateTransformEquipmentManufacturer AS SELECT 1')
GO

ALTER PROCEDURE dbo.spCreateTransformEquipmentManufacturer
AS
--
BEGIN
	/****** Check if table exists ******/
	IF  EXISTS 
		(
			SELECT * 
			FROM sys.objects
			WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentManufacturer]')
				AND TYPE IN (N'U')
		)
		DROP TABLE [dbo].[TransformEquipmentManufacturer]

	/****** Create the table ******/
	CREATE TABLE [dbo].[TransformEquipmentManufacturer](
		[Control] [varchar] (10) NOT NULL,
		[SourceValue] [varchar](15) NOT NULL,
		[TargetValue] [varchar](15) NOT NULL,
		[ManufacturerName] [varchar] (30) NOT NULL,
		[Source] [varchar] (50) NOT NULL,
		[CreateDt] [datetime] NOT NULL
	) ON [PRIMARY]

	/****** Create dataset from a union ******/
	SELECT u.* INTO #CombinedManIDs
	FROM (
		SELECT '[i]' [Control], SourceValue, TargetValue, ManufacturerName,
			'Valves' [Source], GETDATE() [CreateDate]
		FROM TransformEquipmentDistributionValveManufacturerIDLookup
		UNION ALL
		SELECT '[i]' [Control], SourceValue, TargetValue, ManufacturerName,
			'Facilities' [Source], GETDATE() [CreateDate]
		FROM TransformEquipmentFacilitiesEquipmentManufacturerIDLookup
		UNION ALL
		SELECT '[i]' [Control], SourceValue, TargetManufacturerID, ManufacturerName,
			'Hydrants' [Source], GETDATE() [CreateDate]
		FROM TransformEquipmentHydrantManufacturerIDLookup
		UNION ALL
		SELECT '[i]' [Control], SourceValue, TargetValue, ManufacturerName,
			'Vehicles' [Source], GETDATE() [CreateDate]
		FROM TransformEquipmentVehiclesManufacturerIDLookup
	) u

	/****** Perform the insert table ******/
	INSERT INTO TransformEquipmentManufacturer
	SELECT * FROM #CombinedManIDs
	ORDER BY SourceValue

	-- Clean up
	IF OBJECT_ID('tempdb..#CombinedManIDs') IS NOT NULL
		DROP TABLE #CombinedManIDs
END
