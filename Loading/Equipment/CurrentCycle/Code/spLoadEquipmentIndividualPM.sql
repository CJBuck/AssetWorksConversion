ALTER PROCEDURE [dbo].[spLoadEquipmentIndividualPM]
-- =================================================================================================
-- Created By:	Gerald Davis (Marathon Consulting)
-- Create Date:	07/13/2015
-- 
-- Description: Loads TargetEquipmentIndividualM
-- =================================================================================================
AS BEGIN
	TRUNCATE TABLE TargetEquipmentIndividualPM

	INSERT INTO TargetEquipmentIndividualPM
	(
		PMKey,
		PMServiceType,
		NextDueDate,
		NumberOfTimeUnits,
		TimeUnit
	)
	SELECT 
		PMKey,
		PMServiceType,
		NextDueDate,
		NumberOfTimeUnits,
		TimeUnit
	  FROM dbo.TransformEquipmentIndividualPM
	  WHERE PMServiceType IN
	('EM01','EQ01','ES01','EY01','EY02','EY03','EY05','IM01','IM02','IQ01','IS01','IY01','MM01','MM02','MQ01','MS01','MY01','MY02','MY03','MY05','MY10')
END