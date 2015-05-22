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

SET ANSI_PADDING OFF
GO
