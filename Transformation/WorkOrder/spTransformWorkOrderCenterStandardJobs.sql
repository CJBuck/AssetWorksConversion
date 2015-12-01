--	=================================================================================================
--	Created By:		Chris Buck
--	Create Date:	11/30/2015
--	Update Date:
--	Description:	Creates/modifies the spTransformWorkOrderCenterStandardJobs stored procedure.
--					Populates the TransformWorkOrderCenterStandardJobs table.
--	=================================================================================================

--	In order to persist security settings if the SP already exists, we check if
--	it exists and do an ALTER, or a CREATE if it does not.
IF OBJECT_ID('spTransformWorkOrderCenterStandardJobs') IS NULL
    EXEC ('CREATE PROCEDURE dbo.spTransformWorkOrderCenterStandardJobs AS SELECT 1')
GO

ALTER PROCEDURE dbo.spTransformWorkOrderCenterStandardJobs
AS
BEGIN
--	=================================================================================================
--	Build dbo.spTransformWorkOrderCenterStandardJobs
--	=================================================================================================
	IF OBJECT_ID('tmp.WorkOrderCenterStandardJobs') IS NOT NULL
		DROP TABLE tmp.WorkOrderCenterStandardJobs

	CREATE TABLE [tmp].[WorkOrderCenterStandardJobs](
		[RowNum] [int] IDENTITY(1,1) NOT NULL,
		[WorkOrderLocationID] [varchar](10) NOT NULL,
		[WorkOrderYear] [int] NULL,
		[WorkOrderNumber] [varchar](15) NULL,
		[StandardJobID] [varchar](30) NULL
	)

	-- WORKORDERADMIN
	INSERT INTO [tmp].[WorkOrderCenterStandardJobs]
	SELECT DISTINCT woc.WorkOrderLocationID, woc.WorkOrderYear, woc.WorkOrderNumber,
		CASE
			WHEN HA.[OBJECT_ID] LIKE '__A0%' THEN 'PROJECT-AGMT'
			WHEN HA.[OBJECT_ID] LIKE '__AN%' THEN 'PROJECT-MOU'
			WHEN HA.[OBJECT_ID] LIKE '__AH%' THEN 'PROJECT-MOU'
			WHEN HA.[OBJECT_ID] LIKE '__D%' THEN 'PROJECT-DSI'
			WHEN HA.[OBJECT_ID] LIKE '__M%' THEN 'PROJECT-MAINT'
			WHEN HA.[OBJECT_ID] LIKE '__S0%' THEN 'PROJECT-STATE'
			ELSE '** ERROR **'
		END [StandardJobID]
	FROM SourceWicm250WorkOrderHeaderAdmin HA
		INNER JOIN TransformWorkOrderCenter woc ON HA.WO_NUMBER = woc.WorkOrderNumber
			AND HA.LOCATION = woc.Location
	WHERE HA.LOCATION = '04'

	-- Copy temp to TransformWorkOrderCenterStandardJobs
	INSERT INTO TransformWorkOrderCenterStandardJobs
	SELECT DISTINCT
		'[i]' [Control],
		tmp.WorkOrderLocationID,
		tmp.WorkOrderYear,
		tmp.WorkOrderNumber,
		tmp.StandardJobID,
		GETDATE()
	FROM [tmp].[WorkOrderCenterStandardJobs] tmp
END
