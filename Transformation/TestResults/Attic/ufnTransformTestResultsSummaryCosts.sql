USE [AssetWorksConversion]
GO

/****** Object:  UserDefinedFunction [dbo].[ufnTransformTestResultsSummaryCosts]    Script Date: 01/15/2016 11:43:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufnTransformTestResultsSummaryCosts]') AND TYPE IN (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ufnTransformTestResultsSummaryCosts]
GO

USE [AssetWorksConversion]
GO

/****** Object:  UserDefinedFunction [dbo].[ufnTransformTestResultsSummaryCosts]    Script Date: 01/15/2016 11:43:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Author:		Chris Buck (Marathon Consulting)
-- Create Date: 01/16/2016
-- Description:	Perform LTRIM & RTRIM
-- ==========================================================================================
CREATE FUNCTION [dbo].[ufnTransformTestResultsSummaryCosts] 
(
	-- Add the parameters for the function here
	@WONumber		VARCHAR(15),
	@TestElementID	VARCHAR(20)
)
RETURNS VARCHAR(30)
AS
BEGIN
	DECLARE @ReturnVal VARCHAR(30)
	
	IF @TestElementID = 'PRJ-135'
		BEGIN
			SELECT @ReturnVal = (Act_Cost_1 + Act_Cost_2 + Act_Cost_3 + Act_Cost_4 + Act_Cost_5)
			FROM (
				SELECT TCO.WO_NUMBER,
					CASE
						WHEN EXISTS (
							SELECT * FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
							WHERE WO_NUMBER = @WONumber and OBJ_TYPE_1 = 'WPO'
							)
							THEN (
								SELECT CONVERT(DECIMAL, ACT_COST_1)
								FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
								WHERE WO_NUMBER = @WONumber and OBJ_TYPE_1 = 'WPO'
							)
							ELSE 0.00
					END AS Act_Cost_1,
					CASE
						WHEN EXISTS (
							SELECT * FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
							WHERE WO_NUMBER = @WONumber and OBJ_TYPE_2 = 'WPO'
							)
							THEN (
								SELECT CONVERT(DECIMAL, ACT_COST_2)
								FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
								WHERE WO_NUMBER = @WONumber and OBJ_TYPE_2 = 'WPO'
							)
							ELSE 0.00
					END AS Act_Cost_2,
					CASE
						WHEN EXISTS (
							SELECT * FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
							WHERE WO_NUMBER = @WONumber and OBJ_TYPE_3 = 'WPO'
							)
							THEN (
								SELECT CONVERT(DECIMAL, ACT_COST_3)
								FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
								WHERE WO_NUMBER = @WONumber and OBJ_TYPE_3 = 'WPO'
							)
							ELSE 0.00
					END AS Act_Cost_3,
					CASE
						WHEN EXISTS (
							SELECT * FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
							WHERE WO_NUMBER = @WONumber and OBJ_TYPE_4 = 'WPO'
							)
							THEN (
								SELECT CONVERT(DECIMAL, ACT_COST_4)
								FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
								WHERE WO_NUMBER = @WONumber and OBJ_TYPE_4 = 'WPO'
							)
							ELSE 0.00
					END AS Act_Cost_4,
					CASE
						WHEN EXISTS (
							SELECT * FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
							WHERE WO_NUMBER = @WONumber and OBJ_TYPE_5 = 'WPO'
							)
							THEN (
								SELECT CONVERT(DECIMAL, ACT_COST_5)
								FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
								WHERE WO_NUMBER = @WONumber and OBJ_TYPE_5 = 'WPO'
							)
							ELSE 0.00
					END AS Act_Cost_5
				FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2] TCO
				WHERE WO_NUMBER = @WONumber
				) Details
			WHERE Details.WO_NUMBER = @WONumber
		END
	IF @TestElementID = 'PRJ-136'
		BEGIN
			SELECT @ReturnVal = (Est_Cost_1 + Est_Cost_2 + Est_Cost_3 + Est_Cost_4 + Est_Cost_5)
			FROM (
				SELECT TCO.WO_NUMBER,
					CASE
						WHEN EXISTS (
							SELECT * FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
							WHERE WO_NUMBER = @WONumber and OBJ_TYPE_1 = 'WPO'
							)
							THEN (
								SELECT CONVERT(DECIMAL, EST_COST_1)
								FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
								WHERE WO_NUMBER = @WONumber and OBJ_TYPE_1 = 'WPO'
							)
							ELSE 0.00
					END AS Est_Cost_1,
					CASE
						WHEN EXISTS (
							SELECT * FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
							WHERE WO_NUMBER = @WONumber and OBJ_TYPE_2 = 'WPO'
							)
							THEN (
								SELECT CONVERT(DECIMAL, EST_COST_2)
								FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
								WHERE WO_NUMBER = @WONumber and OBJ_TYPE_2 = 'WPO'
							)
							ELSE 0.00
					END AS Est_Cost_2,
					CASE
						WHEN EXISTS (
							SELECT * FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
							WHERE WO_NUMBER = @WONumber and OBJ_TYPE_3 = 'WPO'
							)
							THEN (
								SELECT CONVERT(DECIMAL, EST_COST_3)
								FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
								WHERE WO_NUMBER = @WONumber and OBJ_TYPE_3 = 'WPO'
							)
							ELSE 0.00
					END AS Est_Cost_3,
					CASE
						WHEN EXISTS (
							SELECT * FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
							WHERE WO_NUMBER = @WONumber and OBJ_TYPE_4 = 'WPO'
							)
							THEN (
								SELECT CONVERT(DECIMAL, EST_COST_4)
								FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
								WHERE WO_NUMBER = @WONumber and OBJ_TYPE_4 = 'WPO'
							)
							ELSE 0.00
					END AS Est_Cost_4,
					CASE
						WHEN EXISTS (
							SELECT * FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
							WHERE WO_NUMBER = @WONumber and OBJ_TYPE_5 = 'WPO'
							)
							THEN (
								SELECT CONVERT(DECIMAL, EST_COST_5)
								FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
								WHERE WO_NUMBER = @WONumber and OBJ_TYPE_5 = 'WPO'
							)
							ELSE 0.00
					END AS Est_Cost_5
				FROM [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2] TCO
				WHERE WO_NUMBER = @WONumber
				) Details
			WHERE Details.WO_NUMBER = @WONumber
		END
	IF @TestElementID = 'PRJ-FLUSH-17'
		BEGIN
			SELECT @ReturnVal = (
				Point_Chk_01 + ',' + Point_Chk_02 + ',' + Point_Chk_03 + ',' + Point_Chk_04 + ',' + Point_Chk_05 + ',' +
				Point_Chk_06 + ',' + Point_Chk_07 + ',' + Point_Chk_08 + ',' + Point_Chk_09 + ',' + Point_Chk_10 + ',' +
				Point_Chk_11 + ',' + Point_Chk_12 + ',' + Point_Chk_13 + ',' + Point_Chk_14 + ',' + Point_Chk_15 + ',' +
				Point_Chk_16
				)
			FROM (
				SELECT IFP.WO_NUMBER,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CK_01
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_01,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_02
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_02,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_03
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_03,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_04
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_04,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_05
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_05,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_06
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_06,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_07
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_07,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_08
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_08,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_09
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_09,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_10
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_10,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_11
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_11,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_12
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_12,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_13
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_13,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_14
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_14,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_15
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_15,
					CASE
						WHEN EXISTS (
							SELECT * FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
							WHERE WO_NUMBER = @WONumber
							)
							THEN (
								SELECT POINT_CHK_16
								FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending
								WHERE WO_NUMBER = @WONumber
							)
							ELSE 0.00
					END AS Point_Chk_16
				FROM SourceWicm253WorkOrderExtensionAdminWOInspectionFlushingPending IFP
				WHERE WO_NUMBER = @WONumber
				) Details
			WHERE Details.WO_NUMBER = @WONumber
		END
		
		RETURN @ReturnVal
END
GO
