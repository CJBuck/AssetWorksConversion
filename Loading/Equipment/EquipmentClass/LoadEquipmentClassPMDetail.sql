SELECT
	'2014' [Control], '[KEY]' [Equipment Class ID],
	'231:3' [PM Service], '231:5' [Oil Change],
	'231:6' [Update Schedule Based On],
	'231:7' [PM Service Priority],
	'231:11' [Extend Date Due If],
	'231:13' [Allow Update PM Schedule Prior Due],
	'231:14' [Meter 1], '231:15' [Meter 2],
	'231:16' [Update Meter Due From Scheduled If Late],
	'231:17' [Update Schedule by Calendar],
	'231:18' [Update to Working Day],
	'231:19' [Calendar ID], '231:20' [Minimum Days Buffer]
UNION ALL
SELECT DISTINCT
	PMD.[Control], PMD.[EquipmentClassID],
	PMD.PMService, PMD.OilChange,
	PMD.UpdateScheduleBasedOn,
	PMD.PMServicePriority,
	PMD.ExtendDateDueIf,
	PMD.AllowUpdatePMSchedulePriorDue,
	PMD.Meter1, PMD.Meter2,
	PMD.UpdateMeterDueFromScheduledIfLate,
	PMD.UpdateScheduleByCalendar,
	PMD.UpdateToWorkingDay,
	PMD.CalendarID, PMD.MinimumDaysBuffer
FROM TargetEquipmentClassPMDetail PMD
