USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformEquipmentClassPMDetail]    Script Date: 05/22/2015 08:00:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformEquipmentClassPMDetail]') AND type in (N'U'))
DROP TABLE [dbo].[TransformEquipmentClassPMDetail]
GO

/****** Object:  Table [dbo].[TransformEquipmentClassPMDetail]    Script Date: 05/22/2015 08:00:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TransformEquipmentClassPMDetail](
	[Control] [varchar](10) NOT NULL,
	[EquipmentClassID] [varchar](30) NOT NULL,
	[PMService] [varchar](12) NULL,
	[OilChange] [char](1) NULL,
	[UpdateScheduleBasedOn] [varchar](15) NULL,
	[PMServicePriority] [varchar](2) NULL,
	[ExtendDateDueIf] [varchar](3) NULL,
	[AllowUpdatePMSchedulePriorDue] [varchar](3) NULL,
	[Meter1] [varchar](6) NULL,
	[Meter2] [varchar](6) NULL,
	[UpdateMeterDueFromScheduledIfLate] [char](1) NULL,
	[UpdateScheduleByCalendar] [char](1) NULL,
	[UpdateToWorkingDay] [varchar](10) NULL,
	[CalendarID] [varchar](10) NULL,
	[MinimumDaysBuffer] [varchar](4) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO

--
INSERT INTO TransformEquipmentClassPMDetail
SELECT
	'[i]',
	LEFT(LTRIM(RTRIM(PMD.EquipmentClassID)), 30),
	LEFT(LTRIM(RTRIM(PMD.PMService)), 12),
	LEFT(LTRIM(RTRIM(PMD.OilChange)), 1),
	LEFT(LTRIM(RTRIM(PMD.UpdateScheduleBasedOn)), 15),
	LEFT(LTRIM(RTRIM(PMD.PMServicePriority)), 2),
	LEFT(LTRIM(RTRIM(PMD.[ExtendDateDue_service])), 3),
	LEFT(LTRIM(RTRIM(PMD.[AllowUpdatePMSchedulePriorDue_Days])), 3),
	LEFT(LTRIM(RTRIM(PMD.Meter1)), 6),
	LEFT(LTRIM(RTRIM(PMD.Meter2)), 6),
	LEFT(LTRIM(RTRIM(PMD.[UpdateMeterDueFromScheduledIf_late])), 1),
	LEFT(LTRIM(RTRIM(PMD.UpdateScheduleByCalendar)), 1),
	LEFT(LTRIM(RTRIM(PMD.UpdateToWorkingDay)), 10),
	LEFT(LTRIM(RTRIM(PMD.CalendarID)), 10),
	LEFT(LTRIM(RTRIM(PMD.MinimumDaysBuffer)), 4),
	GETDATE()
FROM Staging_TransformEquipmentClassPMDetail PMD
GO
