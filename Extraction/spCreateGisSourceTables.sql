IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('srcGis.Lateral') AND type IN ('U'))
	DROP TABLE srcGis.Lateral

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('srcGis.ServiceLocation') AND type IN ('U'))
	DROP TABLE srcGis.ServiceLocation

USE [AssetWorksConversion]
GO
/****** Object:  StoredProcedure [dbo].[spLoadPart]    Script Date: 6/29/2015 12:52:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spCreateGisSourceTables]
-- =================================================================================================
-- Created By:	Gerald Davis (Marathon Consulting)
-- Create Date:	06/26/2015
-- 
-- Description: (Re)Create tables for holding GIS (Missouri.sdeSourceVector) source extract
-- =================================================================================================
AS
BEGIN
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('srcGis.Lateral') AND type IN ('U'))
		DROP TABLE srcGis.Lateral

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('srcGis.Meter') AND type IN ('U'))
		DROP TABLE srcGis.ServiceLocation

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('srcGis.Hydrant') AND type IN ('U'))
		DROP TABLE srcGis.Hydrant

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('srcGis.Meter') AND type IN ('U'))
		DROP TABLE srcGis.Meter

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('srcGis.SystemValve') AND type IN ('U'))
		DROP TABLE srcGis.SystemValve

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('srcGis.Hydrant_f3680') AND type IN ('U'))
		DROP TABLE srcGis.Hydrant_f3680

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('srcGis.SystemValve_f3679') AND type IN ('U'))
		DROP TABLE srcGis.SystemValve_f3679

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('srcGis.Lateral_f3682') AND type IN ('U'))
		DROP TABLE srcGis.Lateral_f3682

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('srcGis.ServiceLocation_f3687') AND type IN ('U'))
		DROP TABLE srcGis.ServiceLocation_f3687

	CREATE TABLE srcGis.[Lateral](
		[OBJECTID] [int] NOT NULL,
		[SERVICELOCATIONID] [nvarchar](30) NULL,
		[FACILITYID] [numeric](38, 0) NULL,
		[TAPID] [nvarchar](18) NULL,
		[SUBTYPE] [smallint] NULL,
		[LIFECYCLESTATUS] [smallint] NULL,
		[QCSTATUS] [smallint] NULL,
		[MAINDIAMETER] [smallint] NULL,
		[MAINMATERIAL] [smallint] NULL,
		[PRIMARYLINELENGTH] [nvarchar](6) NULL,
		[PRIMARYLINEDIAMETER] [nvarchar](6) NULL,
		[PRIMARYLINEMATERIAL] [smallint] NULL,
		[SECONDARYLINELENGTH] [nvarchar](6) NULL,
		[SECONDARYLINEDIAMETER] [nvarchar](6) NULL,
		[SECONDARYLINEMATERIAL] [smallint] NULL,
		[YOKEBOX] [smallint] NULL,
		[SPRINKLERDIAMETER] [numeric](38, 8) NULL,
		[TAPDIAMETER] [smallint] NULL,
		[DRAWINGNUMBER] [nvarchar](10) NULL,
		[PROJECTNUMBER] [nvarchar](10) NULL,
		[SDCDATE] [datetime] NULL,
		[SDCSTATUS] [smallint] NULL,
		[METERFEEAMOUNT] [numeric](10, 2) NULL,
		[CORPORATIONTYPE] [nvarchar](12) NULL,
		[CORPORATIONSIZE] [nvarchar](6) NULL,
		[ORIGINALTAPNUMBER] [nvarchar](10) NULL,
		[ORIGINALSERVICEDATE] [datetime] NULL,
		[INSTALLATIONPAIDDATE] [datetime] NULL,
		[INSTALLATIONFEEAMOUNT] [numeric](10, 2) NULL,
		[INSTALLATIONDATE] [datetime] NULL,
		[INSTALLER] [nvarchar](12) NULL,
		[CONTRACTOR] [nvarchar](20) NULL,
		[OWNER] [smallint] NULL,
		[COMMENTS] [nvarchar](30) NULL,
		[ACCT_NO] [nvarchar](6) NULL,
		[Enabled] [smallint] NULL,
		[VPObjectID] [int] NULL,
		[District] [smallint] NULL,
		[SHAPE] [int] NULL,
		[GisDiameter] [smallint] NULL
	) ON [PRIMARY]

	CREATE TABLE srcGis.[ServiceLocation](
		[OBJECTID] [int] NOT NULL,
		[SERVICELOCATIONID] [nvarchar](30) NOT NULL,
		[FACILITYID] [numeric](38, 0) NULL,
		[CONNECTIONOBJECTID] [nvarchar](30) NULL,
		[SUBTYPE] [smallint] NOT NULL,
		[LIFECYCLESTATUS] [smallint] NULL,
		[QCSTATUS] [smallint] NULL,
		[ASSOCIATED] [smallint] NULL,
		[HOUSENUMBER] [nvarchar](10) NULL,
		[ADDRESSADDENDUM] [nvarchar](40) NULL,
		[STREET] [nvarchar](60) NULL,
		[PREMISEADDITIONALDATA] [nvarchar](10) NULL,
		[BUILDINGNAME] [nvarchar](40) NULL,
		[CITY] [nvarchar](40) NULL,
		[STATE] [smallint] NULL,
		[ZIPCODE] [nvarchar](10) NULL,
		[CROSSSTREET] [nvarchar](40) NULL,
		[LOT] [nvarchar](20) NULL,
		[SUBDIVISION] [nvarchar](40) NULL,
		[DISTRICT] [smallint] NULL,
		[ADCMAPNUMBER] [nvarchar](10) NULL,
		[ADCGRIDCELL] [nvarchar](10) NULL,
		[WDSMAPNUMBER] [nvarchar](6) NULL,
		[WDSGRIDCELL] [nvarchar](10) NULL,
		[CUSTOMERSERVICEUNIT] [nvarchar](8) NULL,
		[METERREADINGUNIT] [nvarchar](8) NULL,
		[READINGSEQUENCENUMBER] [nvarchar](5) NULL,
		[LOCATION] [smallint] NULL,
		[LOCATIONNOTE] [nvarchar](40) NULL,
		[PREMISETYPE] [nvarchar](8) NULL,
		[INSTALLATIONTYPE] [nvarchar](4) NULL,
		[SERVICES] [smallint] NULL,
		[METERPRESENT] [smallint] NULL,
		[CUSTOMERPRESENT] [smallint] NULL,
		[BACKFLOWPRESENT] [smallint] NULL,
		[BACKFLOWCOUNT] [nvarchar](3) NULL,
		[PORTION] [nvarchar](8) NULL,
		[RATECATEGORY] [nvarchar](10) NULL,
		[WATERQUALITYCONCERN] [smallint] NULL,
		[WATERQUALITYWORKORDERDATE] [datetime] NULL,
		[ROTATION] [numeric](5, 2) NULL,
		[ACCT_NO] [nvarchar](6) NULL,
		[ENABLED] [smallint] NULL,
		[ANCILLARYROLE] [smallint] NULL,
		[GPSCOLLECTIONSTATUS] [nvarchar](9) NULL,
		[GPSQCSTATUS] [smallint] NULL,
		[GPSXCOORDINATE] [numeric](19, 11) NULL,
		[GPSYCOORDINATE] [numeric](19, 11) NULL,
		[VPObjectID] [int] NULL,
		[SHAPE] [int] NULL
	) ON [PRIMARY]

	CREATE TABLE srcGis.[Hydrant](
		[OBJECTID] [int] NOT NULL,
		[HYDRANT_NO] [int] NULL,
		[LIFECYCLESTATUS] [nvarchar](2) NULL,
		[SYMBOLCD] [smallint] NULL,
		[GPS_X_COORD] [numeric](38, 8) NULL,
		[GPS_Y_COORD] [numeric](38, 8) NULL,
		[FILENAME] [nvarchar](12) NULL,
		[COLL_CODE] [nvarchar](9) NULL,
		[OPER_MOVED] [nvarchar](1) NULL,
		[POLYGONID] [int] NULL,
		[SCALE] [numeric](38, 8) NULL,
		[ANGLE] [numeric](38, 8) NULL,
		[District] [smallint] NULL,
		[Enabled] [smallint] NULL,
		[AncillaryRole] [smallint] NULL,
		[VPObjectID] [int] NULL,
		[SHAPE] [int] NULL
	) ON [PRIMARY]

	CREATE TABLE srcGis.[Meter](
		[OBJECTID] [int] NOT NULL,
		[SERIALNUMBER] [nvarchar](18) NOT NULL,
		[MANUFACTURER] [nvarchar](30) NOT NULL,
		[SERVICELOCATIONID] [nvarchar](30) NULL,
		[FACILITYID] [numeric](38, 0) NULL,
		[METERSTATUS] [nvarchar](4) NULL,
		[DEVICECATEGORY] [int] NULL,
		[INSTALLATIONDATE] [datetime] NULL,
		[MODEL] [nvarchar](20) NULL,
		[ACQUISITIONDATE] [datetime] NULL,
		[ACQUISITIONCOST] [numeric](13, 2) NULL,
		[NEXTINSPECTIONDATE] [datetime] NULL,
		[NEXTREPLACEMENTYEAR] [nvarchar](4) NULL,
		[MEASUREMENTPRECISION] [nvarchar](2) NULL,
		[MEASUREMENTUNIT] [smallint] NULL,
		[ACCT_NO] [nvarchar](6) NULL
	) ON [PRIMARY]

	CREATE TABLE srcGis.[SystemValve](
		[OBJECTID] [int] NOT NULL,
		[NUMBER_] [int] NULL,
		[FUNCTION_] [smallint] NULL,
		[SUBTYPE] [nvarchar](10) NULL,
		[HYDRANT_NO] [int] NULL,
		[ACCT_NO] [nvarchar](6) NULL,
		[STATUS] [nvarchar](2) NULL,
		[SYMBOLCD] [smallint] NULL,
		[GPS_X_COORD] [numeric](38, 8) NULL,
		[GPS_Y_COORD] [numeric](38, 8) NULL,
		[FILENAME] [nvarchar](12) NULL,
		[COLL_CODE] [nvarchar](9) NULL,
		[OPER_MOVED] [nvarchar](1) NULL,
		[POLYGONID] [int] NULL,
		[SCALE] [numeric](38, 8) NULL,
		[ANGLE] [numeric](38, 8) NULL,
		[RetirementNumber] [smallint] NULL,
		[District] [smallint] NULL,
		[Enabled] [smallint] NULL,
		[VPObjectID] [int] NULL,
		[SHAPE] [int] NULL
	) ON [PRIMARY]

	CREATE TABLE srcGis.Hydrant_f3680
	(
		[fid] [int] NOT NULL,
		[numofpts] [int] NOT NULL,
		[entity] [smallint] NOT NULL,
		[eminx] [float] NOT NULL,
		[eminy] [float] NOT NULL,
		[emaxx] [float] NOT NULL,
		[emaxy] [float] NOT NULL,
		[eminz] [float] NULL,
		[emaxz] [float] NULL,
		[min_measure] [float] NULL,
		[max_measure] [float] NULL,
		[area] [float] NOT NULL,
		[len] [float] NOT NULL,
		[points] [image] NULL,
		CONSTRAINT [pk_Hydrant_f3680] PRIMARY KEY CLUSTERED 
		(
			[fid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	CREATE TABLE srcGis.SystemValve_f3679
	(
		[fid] [int] NOT NULL,
		[numofpts] [int] NOT NULL,
		[entity] [smallint] NOT NULL,
		[eminx] [float] NOT NULL,
		[eminy] [float] NOT NULL,
		[emaxx] [float] NOT NULL,
		[emaxy] [float] NOT NULL,
		[eminz] [float] NULL,
		[emaxz] [float] NULL,
		[min_measure] [float] NULL,
		[max_measure] [float] NULL,
		[area] [float] NOT NULL,
		[len] [float] NOT NULL,
		[points] [image] NULL,
		CONSTRAINT pk_SystemValve_f3679 PRIMARY KEY CLUSTERED 
		(
			[fid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	CREATE TABLE srcGis.Lateral_f3682
	(
		[fid] [int] NOT NULL,
		[numofpts] [int] NOT NULL,
		[entity] [smallint] NOT NULL,
		[eminx] [float] NOT NULL,
		[eminy] [float] NOT NULL,
		[emaxx] [float] NOT NULL,
		[emaxy] [float] NOT NULL,
		[eminz] [float] NULL,
		[emaxz] [float] NULL,
		[min_measure] [float] NULL,
		[max_measure] [float] NULL,
		[area] [float] NOT NULL,
		[len] [float] NOT NULL,
		[points] [image] NULL,
		CONSTRAINT pk_Lateral_f3682 PRIMARY KEY CLUSTERED 
		(
			[fid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	CREATE TABLE srcGis.ServiceLocation_f3687
	(
		[fid] [int] NOT NULL,
		[numofpts] [int] NOT NULL,
		[entity] [smallint] NOT NULL,
		[eminx] [float] NOT NULL,
		[eminy] [float] NOT NULL,
		[emaxx] [float] NOT NULL,
		[emaxy] [float] NOT NULL,
		[eminz] [float] NULL,
		[emaxz] [float] NULL,
		[min_measure] [float] NULL,
		[max_measure] [float] NULL,
		[area] [float] NOT NULL,
		[len] [float] NOT NULL,
		[points] [image] NULL,
		CONSTRAINT pk_ServiceLocation_f3687 PRIMARY KEY CLUSTERED 
		(
			[fid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

END