--
select SERVICELOCATIONID, COUNT(ServiceLocationID)
from sdeDataOwner.WSERVICELOCATION
group by SERVICELOCATIONID
having COUNT(ServiceLocationID) > 1

select TAPID, COUNT(TAPID)
from sdeDataOwner.WLATERAL
group by TAPID
having COUNT(TAPID) > 1

select *
from sdeDataOwner.WLATERAL
where TAPID is null

select WSL.SERVICELOCATIONID
from sdeDataOwner.WSERVICELOCATION WSL
where WSL.SERVICELOCATIONID IN (
	select SERVICELOCATIONID
	from sdeDataOwner.WLATERAL
	where TAPID is null
)

select *
from sdeDataOwner.WMETER

select WM.SERVICELOCATIONID, COUNT(WM.SERVICELOCATIONID)
from sdeDataOwner.WMETER WM
group by WM.SERVICELOCATIONID
having COUNT(WM.SERVICELOCATIONID) > 1
