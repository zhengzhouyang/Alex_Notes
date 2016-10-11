-------------------------------------------------------------------------------

-- File Name     : rman_status.sql

-- Author        : Alex(Zhouyang Zheng)

-- Corporation	 : Cloud Creek Systems, Inc.

-- Call Syntax   : @*.sql from sql*plus

-- Requirements  : Sysdba

-- Last Modified : 09/23/2016

-- Description   : RMAN history log 

-------------------------------------------------------------------------------

set lines 220
set pages 1000
col sid for 9,9
col recid for 9,999
col parent_recid for 9,999 heading "p_recid"
col row_type for a6 heading "row_ty"
col command_id for a20
col operation for a10

select 
command_id,
operation,
status,
MBYTES_PROCESSED,
start_time,
end_time,
input_bytes/1024/1024 "input_MB",
output_bytes/1024/1024 "output_MB",
optimized,
object_type
from v$rman_status 
where OPERATION in('BACKUP','DELETE','RMAN') and start_time>sysdate-&numberOfDay
order by start_time;