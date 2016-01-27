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
-- Author:		Gerald Davis (Marathon Consulting)
-- Create Date: 06/01/2015
-- Description:	Perform LTRIM & RTRIM
-- ==========================================================================================
CREATE FUNCTION [dbo].[ufnTransformTestResultsSummaryCosts] 
(
	-- Add the parameters for the function here
	@WONumber	VARCHAR(15),
	@Type		VARCHAR(3)
)
RETURNS VARCHAR(30)
AS
BEGIN
RETURN (
	SELECT Cost1.WO_NUMBER, Cost1.Act_Cost
	FROM
		(
			select C1.WO_NUMBER, (CONVERT(DECIMAL, C1.Act_Cost_1) + Cost2.Act_Cost) [Act_Cost]
			from [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2] C1
				left join (
							select WO_NUMBER, CONVERT(DECIMAL, c2.Act_Cost_2) [Act_Cost]
							from [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2] c2
							where WO_NUMBER = '602166' and OBJ_TYPE_2 = 'WPO'
					) Cost2 on C1.WO_NUMBER = Cost2.WO_NUMBER
			where C1.WO_NUMBER = '602166' and OBJ_TYPE_1 = 'WPO'
		) Cost1
)

		--with Cost1 as (
		--	select WO_NUMBER, OBJ_TYPE_1 [Obj_Type], isnull(ACT_COST_1, 0.00) [Act_Cost]
		--	from [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
		--	where WO_NUMBER = '602166' and OBJ_TYPE_1 = 'WPO'
		--),
		--Cost2 as (
		--	select WO_NUMBER, OBJ_TYPE_2 [Obj_Type], isnull(ACT_COST_2, 0.00) [Act_Cost]
		--	from [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
		--	where WO_NUMBER = '602166' and OBJ_TYPE_2 = 'WPO'
		--),
		--Cost3 as (
		--	select WO_NUMBER, OBJ_TYPE_3 [Obj_Type], ACT_COST_3 [Act_Cost]
		--	from [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
		--	where WO_NUMBER = '602166' and OBJ_TYPE_3 = 'WPO'
		--),
		--Cost4 as (
		--	select WO_NUMBER, OBJ_TYPE_4 [Obj_Type], ACT_COST_4 [Act_Cost]
		--	from [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
		--	where WO_NUMBER = '602166' and OBJ_TYPE_4 = 'WPO'
		--),
		--Cost5 as (
		--	select WO_NUMBER, OBJ_TYPE_5 [Obj_Type], ACT_COST_5 [Act_Cost]
		--	from [SourceWicm253WorkOrderExtensionAdminWOMatlEstimatesPressureTestCloseOut1-2]
		--	where WO_NUMBER = '602166' and OBJ_TYPE_5 = 'WPO'
		--),
		--SubTotal as (
		--	select WO_NUMBER, CAST(Act_Cost as decimal) [Act_Cost] from Cost1
		--	union all
		--	select WO_NUMBER, CAST(Act_Cost as decimal) [Act_Cost] from Cost2
		--	union all
		--	select WO_NUMBER, CAST(Act_Cost as decimal) [Act_Cost] from Cost3
		--	union all
		--	select WO_NUMBER, CAST(Act_Cost as decimal) [Act_Cost] from Cost4
		--	union all
		--	select WO_NUMBER, CAST(Act_Cost as decimal) [Act_Cost] from Cost5
		--)
		--select SUM(Act_Cost)
		--from SubTotal
		--group by WO_NUMBER
END
GO


