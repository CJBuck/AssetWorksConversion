SELECT
	'2014' [Control], '[KEY]' [Equipment Class ID],
	'76:7' [Slot No], '76:8' [PM Service],
	'76:12' [Blank Slot (Y/N]
UNION ALL
SELECT DISTINCT
	PMC.[Control], PMC.[EquipmentClassID],
	ISNULL(CAST(PMC.SlotNo AS VARCHAR), ''),
	PMC.PMService, PMC.BlankSlot
FROM TargetEquipmentClassPMClass PMC
