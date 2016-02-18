-- =============================================
-- Author:		Gerald Davis (Marathon Consulting)
-- Create date: 02/11/2016
-- Description:	
-- =============================================
CREATE PROCEDURE dbo.spTransformLinearShape
AS
BEGIN
	DELETE FROM TransformLinearShape
	DELETE FROM TransformLinearShapePoint

	INSERT INTO [dbo].[TransformLinearShape]
           ([Control]
           ,[ShapeId]
           ,[Points])
	SELECT
		'[i]' AS [Control],
		SegmentID AS ShapeId,
		'[12429:4,Points:1:1]' AS Points
	FROM TransformLinearSegment


	INSERT INTO [dbo].[TransformLinearShapePoint]
			   ([Control]
			   ,[ShapeID]
			   ,[Latitude]
			   ,[Longitude]
			   ,[PointIndex])
	SELECT
		'[i]' AS [Control],
		s.SegmentId AS ShapeId,
		v.Latitude,
		v.Longitude,
		v.VertexID AS PointIndex 
	FROM TransformLinearSegment s
	INNER JOIN AssetWorksGIS.sdeDataOwner.WPM_DISSOLVED_VERTICES v
		ON s.SegmentId = 'DPI' + RIGHT('0000000' + CAST(v.SegmentId AS nvarchar(20)), 7)
END


