USE [AssetWorksConversion]
GO

/****** Object:  StoredProcedure [dbo].[spTransformLinearSegment]    Script Date: 2/17/2016 7:24:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gerald Davis (Marathon Consulting)
-- Create date: 02/02/2016
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[spTransformLinearSegment]
AS
BEGIN
	DELETE FROM TransformLinearSegment

	INSERT INTO TransformLinearSegment
			   ([Control]
			   ,SegmentId
			   ,SegmentDescription
			   ,SegmentLength)
	SELECT 
		'[i]' AS [Contro],
		w.NetworkSegmentID AS SegmentID,
		'' AS SegmentDescription,
		w.Shape.STLength() * 3.28084 as SegmentLength -- length stored in meters needs to be converted to feet
	FROM AssetWorksGIS.sdeDataOwner.WPRESSURIZEDMAIN_DISSOLVED w
	LEFT JOIN sys.spatial_reference_systems r
		ON w.Shape.STSrid = r.spatial_reference_id
END

GO


