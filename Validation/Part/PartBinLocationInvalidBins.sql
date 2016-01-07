SELECT t.PartID, t.LocationId, t.BinID, t.PrimaryBin, t.NewBin
FROM TargetPartLocationBin t
LEFT JOIN Staging_ValidBins v
	ON t.LocationId = v.LocationID
	AND t.BinID = v.BinId
WHERE v.LocationID IS NULL
	OR v.BinID IS NULL
	ORDER BY LocationID, BinID