ALTER PROCEDURE [dbo].[spLoadEquipmentIndividualPM]
-- =================================================================================================
-- Created By:	Gerald Davis (Marathon Consulting)
-- Create Date:	07/13/2015
-- 
-- Description: Loads TargetEquipmentIndividualPM 
-- =================================================================================================
AS BEGIN
	TRUNCATE TABLE TargetEquipmentIndividualPM

	INSERT INTO TargetEquipmentIndividualPM
	(
		[Control],
		PMKey,
		PMServiceType,
		NextDueDate,
		NumberOfTimeUnits,
		TimeUnit
	)
	SELECT
		'[i]' AS Control, 
		PMKey,
		PMServiceType,
		CONVERT(VARCHAR(10), NextDueDate, 101) AS NextDueDate,
		NumberOfTimeUnits,
		TimeUnit
	FROM dbo.TransformEquipmentIndividualPM
	WHERE PMServiceType IN ('EM01','EQ01','ES01','EY01','EY02','EY03','EY05','IM01','IM02','IQ01','IS01','IY01','MM01','MM02','MQ01','MS01','MY01','MY02','MY03','MY05','MY10')
	OR PMServiceType IN 
	(
		SELECT DISTINCT PMService FROM TransformEquipmentGSPMTasks
		UNION
		SELECT DISTINCT PMService FROM SourceProjectPMDateLookup
	)

END

	