USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformTestResultsDetails]    Script Date: 12/14/2015 13:38:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformTestResultsDetails]') AND TYPE IN(N'U'))
DROP TABLE [dbo].[TransformTestResultsDetails]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformTestResultsDetails]    Script Date: 12/14/2015 13:38:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformTestResultsDetails](
	[Control] [varchar](10) NOT NULL,
	[TestID] [varchar](9) NOT NULL,
	[TestElementID] [varchar](20) NULL,
	[NotPerformed] [char](1) NULL,
	[Result] [varchar](5) NULL,
	[DetectionThreshold] [varchar](12) NULL,
	[AllowableMinimum] [varchar](12) NULL,
	[AllowableMaximum] [varchar](12) NULL,
	[UnitOfMeasure] [varchar](10) NULL,
	[NumericFound] [varchar](20) NULL,
	[NumericValueAfterAdjustment] [varchar](20) NULL,
	[QualitativeFinding] [varchar](30) NULL,
	[Comments] [varchar](60) NOT NULL,
	[ConditionRating] [varchar](20) NULL,
	[Symptom] [varchar](20) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO
