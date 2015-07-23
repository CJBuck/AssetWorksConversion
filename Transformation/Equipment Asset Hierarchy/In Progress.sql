--
select *
from TransformEquipmentLegacyXwalk
where LegacyID = '1070020001'

select [OBJECT_ID], OB_EQUIP_D, MFR_NAME, FAC_MODEL
from SourceWicm210ObjectEquipment
where [OBJECT_ID] = '1070020001'

select [OBJECT_ID], OB_EQUIP_D, MFR_NAME, FAC_MODEL
from SourceWicm210ObjectEquipment
where [OBJECT_ID] = '3551020012'

-- Matches
select HMP4.[Component WICM ID] [WICM ID], HMP4.EQUIPDESC [DESCRIPTION], HMP4.MAKE [MAKE], HMP4.MODEL [MODEL]
from EquipmentHierarchyData_ComponentRelationshipHMP4 HMP4
	inner join SourceWicm210ObjectEquipment oe on HMP4.[Component WICM ID] = oe.[OBJECT_ID]
where [Component WICM ID] NOT IN ('N/A', 'DELETE FROM XML')

-- Not in SourceWicm210ObjectEquipment
select HMP4.[Component WICM ID] [WICM ID], HMP4.EQUIPDESC [DESCRIPTION], HMP4.MAKE [MAKE], HMP4.MODEL [MODEL]
from EquipmentHierarchyData_ComponentRelationshipHMP4 HMP4
where HMP4.[Component WICM ID] NOT IN (
	SELECT [OBJECT_ID] FROM SourceWicm210ObjectEquipment
	)
	and [Component WICM ID] NOT IN ('N/A', 'DELETE FROM XML')

select LHTP.[Component WICM ID] [WICM ID], LHTP.EQUIPDESC [DESCRIPTION], LHTP.MAKE [MAKE], LHTP.MODEL [MODEL]
from EquipmentHierarchyData_ComponentRelationshipLHTP LHTP
where LHTP.[Component WICM ID] NOT IN (
	SELECT [OBJECT_ID] FROM SourceWicm210ObjectEquipment
	)
	and [Component WICM ID] NOT IN ('N/A', 'DELETE FROM XML')

-- Not in XLS
with HMP4 as (
select XREF.EquipmentID
from TransformEquipmentLegacyXwalk XREF
	inner join SourceWicm210ObjectEquipment oe ON XREF.LegacyID = oe.[OBJECT_ID]
where XREF.[Source] = 'SourceWicm210ObjectEquipment'
	and oe.[OBJECT_ID] in (select [Component WICM ID] from EquipmentHierarchyData_ComponentRelationshipHMP4)
),
LHTP as (
select XREF.EquipmentID
from TransformEquipmentLegacyXwalk XREF
	inner join SourceWicm210ObjectEquipment oe ON XREF.LegacyID = oe.[OBJECT_ID]
where XREF.[Source] = 'SourceWicm210ObjectEquipment'
	and oe.[OBJECT_ID] in (select [Component WICM ID] from EquipmentHierarchyData_ComponentRelationshipLHTP)
)
select TE.EquipmentID, xref.LegacyID [WICM ID], TE.[Description], TE.ManufacturerID, TE.ModelID, TE.AssetType, oe.[CLASS] [WICM CLASS]
from TransformEquipment TE
	inner join TransformEquipmentLegacyXwalk xref on TE.EquipmentID = xref.EquipmentID and xref.[Source] = 'SourceWicm210ObjectEquipment'
	inner join SourceWicm210ObjectEquipment oe on xref.LegacyID = oe.[OBJECT_ID]
where (TE.EquipmentID not in (select EquipmentID from HMP4))
	and (TE.EquipmentID not in (select EquipmentID from LHTP))

select * from EquipmentHierarchyData_ComponentRelationshipLHTP
where [Component WICM ID] = '3538010024'

select *
from SourceWicm210ObjectEquipment where [OBJECT_ID] = '3538010024'
