-- =============================================
-- Author:		Gerald Davis (Marathon Consulting)
-- Create date: 02/09/2016
-- Description:	
-- =============================================
CREATE PROCEDURE dbo.spTransformLinearMarker
AS
BEGIN
	DELETE FROM [TransformLinearMarker]

	-- insert begining markers
	INSERT INTO [dbo].[TransformLinearMarker]
	(
		[Control]
		,[MarkerID]
		,[MarkerDescription]
		,[SegmentID]
		,[OffsetFromSegment]
		,[Latitude]
		,[Longitude]
		,[MarkerType]
		,[Active]
	)
	 SELECT
		'[i]' AS [Control],
		a.NetworkSegmentId + ' Beg' AS MarkerID,
		a.NetworkSegmentId + ' Beg' AS MarkerDescription,
		a.NetworkSegmentId AS SegmentId,
		0 AS OffsetFromSegment,
		v.Latitude,
		v.Longitude,
		'Reference' AS MarkerType,
		'Y' As Active
	FROM
	(
		SELECT 
			SegmentID,
			'DPI' + RIGHT('0000000' + CAST(SegmentId AS nvarchar(20)), 7) AS NetworkSegmentId, --formatted segmentid
			MIN(VertexID) AS BeginingVertex
		FROM AssetWorksGIS.sdeDataOwner.WPM_DISSOLVED_VERTICES
		GROUP BY SegmentID
	) AS a
	INNER JOIN AssetWorksGIS.sdeDataOwner.WPM_DISSOLVED_VERTICES v
		ON a.SegmentID = v.SegmentID
		AND a.BeginingVertex = v.VertexID
	ORDER BY a.SegmentID

	-- insert ending markers
	INSERT INTO [dbo].[TransformLinearMarker]
	(
		[Control]
		,[MarkerID]
		,[MarkerDescription]
		,[SegmentID]
		,[OffsetFromSegment]
		,[Latitude]
		,[Longitude]
		,[MarkerType]
		,[Active]
	)
	 SELECT
		'[i]' AS [Control],
		a.NetworkSegmentId + ' End' AS MarkerID,
		a.NetworkSegmentId + ' End' AS MarkerDescription,
		a.NetworkSegmentId AS SegmentId,
		s.SegmentLength AS OffsetFromSegment,
		v.Latitude,
		v.Longitude,
		'Reference' AS MarkerType,
		'Y' As Active
	FROM
	(
		SELECT 
			SegmentID,
			'DPI' + RIGHT('0000000' + CAST(SegmentId AS nvarchar(20)), 7) AS NetworkSegmentId, --formatted segmentid
			MAX(VertexID) AS EndingVertex
		FROM AssetWorksGIS.sdeDataOwner.WPM_DISSOLVED_VERTICES
		GROUP BY SegmentID
	) AS a
	INNER JOIN AssetWorksGIS.sdeDataOwner.WPM_DISSOLVED_VERTICES v
		ON a.SegmentID = v.SegmentID
		AND a.EndingVertex = v.VertexID
	INNER JOIN TransformLinearSegment s
		ON a.NetworkSegmentId = s.SegmentId
	ORDER BY a.SegmentID
END


GO


