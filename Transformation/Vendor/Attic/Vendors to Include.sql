with vcd as (
      SELECT DISTINCT VNUMBER, VNAME 
      FROM SourceWicm310Vendor ven
            inner join SourceWicm220PartsHeader parts on ven.VNUMBER = parts.VENDOR_CD 
      ),
vcd2 as (
      SELECT DISTINCT VNUMBER, VNAME 
      FROM SourceWicm310Vendor ven
            inner join SourceWicm220PartsHeader parts on ven.VNUMBER = parts.VENDOR_CD2
      ),
vcd3 as (
      SELECT DISTINCT VNUMBER, VNAME 
      FROM SourceWicm310Vendor ven
            inner join SourceWicm220PartsHeader parts on ven.VNUMBER = parts.VENDOR_CD3
      ),
vcd4 as (
      SELECT DISTINCT VNUMBER, VNAME 
      FROM SourceWicm310Vendor ven
            inner join SourceWicm220PartsHeader parts on ven.VNUMBER = parts.VENDOR_CD4
      ),
vcd5 as (
      SELECT DISTINCT VNUMBER, VNAME 
      FROM SourceWicm310Vendor ven
            inner join SourceWicm220PartsHeader parts on ven.VNUMBER = parts.VENDOR_CD5
      ),
vcd6 as (
      SELECT DISTINCT VNUMBER, VNAME 
      FROM SourceWicm310VENDOR ven
            inner join SourceWicm223PartsHistory parts on ven.VNUMBER = parts.VENDOR_CODE
      ),      
vensummary as (   
      select * from vcd
      union all
      select * from vcd2
      union all
      select * from vcd3
      union all
      select * from vcd4
      union all
      select * from vcd5
      union all
      select * from vcd6
)
select distinct VNUMBER, VNAME
from vensummary
