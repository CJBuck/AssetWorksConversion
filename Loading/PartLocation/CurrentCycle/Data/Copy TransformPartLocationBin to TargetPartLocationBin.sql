INSERT INTO TargetPartLocationBin
SELECT *
FROM TransformPartLocationBin
WHERE
	PartID IS NOT NULL
	AND BinID IS NOT NULL
	AND PrimaryBin IS NOT NULL
	AND NewBin IS NOT NULL
