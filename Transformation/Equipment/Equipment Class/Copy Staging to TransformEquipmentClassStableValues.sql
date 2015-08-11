--
INSERT INTO TransformEquipmentClassStableValues
SELECT
	LEFT(LTRIM(RTRIM(TESV.[Equipment Class ID])), 30),
	LEFT(LTRIM(RTRIM(TESV.[Description])), 30),
	LEFT(LTRIM(RTRIM(TESV.[Class type])), 2),
	LTRIM(RTRIM(TESV.[Overhead amount])),
	LEFT(LTRIM(RTRIM(TESV.[Meter 1 type])), 10),
	LEFT(LTRIM(RTRIM(TESV.[Meter 2 type])), 10),
	LTRIM(RTRIM(TESV.[Meter 1 edit range])),
	LTRIM(RTRIM(TESV.[Meter 2 edit range])),
	LTRIM(RTRIM(TESV.[Meter 1 Max Value])),
	LTRIM(RTRIM(TESV.[Meter 2 Max Value])),
	LTRIM(RTRIM(TESV.[Comeback range (days)])),
	LTRIM(RTRIM(TESV.[PM soon due (days)])),
	LTRIM(RTRIM(TESV.[PM fuel quantity override])),
	LTRIM(RTRIM(TESV.[PM services in one cycle])),
	LTRIM(RTRIM(TESV.[PM quantity of time units])),
	LEFT(LTRIM(RTRIM(TESV.[PM time unit])), 15),
	LEFT(LTRIM(RTRIM(TESV.[Meter Soon Due])), 25),
	LEFT(LTRIM(RTRIM(TESV.[Class PM Cycles])), 25),
	LEFT(LTRIM(RTRIM(TESV.[PM Details])), 25),
	LEFT(LTRIM(RTRIM(TESV.[Individual PM])), 25),
	LEFT(LTRIM(RTRIM(TESV.[Value depreciation ID])), 8),
	LEFT(LTRIM(RTRIM(TESV.[Meter types])), 1),
	LEFT(LTRIM(RTRIM(TESV.Maintenance)), 1),
	LEFT(LTRIM(RTRIM(TESV.[PM Program])), 1),
	LEFT(LTRIM(RTRIM(TESV.Standards)), 1),
	LEFT(LTRIM(RTRIM(TESV.[Rental Rates])), 1),
	LEFT(LTRIM(RTRIM(TESV.Resources)), 1),
	LEFT(LTRIM(RTRIM(TESV.[Source])), 100),
	GETDATE()
FROM Staging_TransformEquipmentClassStableValues TESV
WHERE [Equipment Class ID] IS NOT NULL
