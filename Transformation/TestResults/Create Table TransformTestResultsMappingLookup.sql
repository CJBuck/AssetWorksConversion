USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformTestResultsMappingLookup]    Script Date: 12/22/2015 09:43:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformTestResultsMappingLookup]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformTestResultsMappingLookup]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformTestResultsMappingLookup]    Script Date: 12/22/2015 09:43:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformTestResultsMappingLookup](
	[OBJECT_ID] [nvarchar](255) NULL,
	[Test Type ID] [nvarchar](255) NULL,
	[Test Element ID] [nvarchar](255) NULL,
	[Target Test Element Description] [nvarchar](255) NULL,
	[Source Table] [nvarchar](255) NULL,
	[Source Column mapped to Qualitative Field] [nvarchar](255) NULL,
	[Source Column mapped to Comments Field] [nvarchar](255) NULL,
	[Source Column mapped to Numeric Field] [nvarchar](255) NULL,
	[Logic] [nvarchar](255) NULL,
) ON [PRIMARY]

GO

INSERT INTO TransformTestResultsMappingLookup
SELECT
	LTRIM(RTRIM(S.[OBJECT_ID])),
	LTRIM(RTRIM(S.[Test Type ID])),
	LTRIM(RTRIM(S.[Test Element ID])),
	LTRIM(RTRIM(S.[Target Test Element Description])),
	LTRIM(RTRIM(S.[Source Table])),
	LTRIM(RTRIM(S.[Source Column mapped to Qualitative Field])),
	LTRIM(RTRIM(S.[Source Column mapped to Comments Field])),
	LTRIM(RTRIM(S.[Source Column mapped to Numeric Field])),
	LTRIM(RTRIM(S.[Logic]))
FROM Staging_TransformTestResultsMappingLookup S

