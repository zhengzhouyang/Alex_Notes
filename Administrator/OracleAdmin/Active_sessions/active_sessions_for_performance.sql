col inst_id for 999
col sid	for 999
col serial#	for 999,999
col event for a20
col machine for a15
col sql_text for a15 
col service_name for a15


select 
		g.inst_id, 
		g.sid, 
		g.serial#, 
		g.sql_id, 
		g.event,
		g.machine, 
		g.sql_exec_start, 
		l.sql_text,
		l.PLAN_HASH_VALUE, 
		g.blocking_session, 
		g.SERVICE_NAME,
		g.status, 
		g.LOGON_TIME
from 
		gv$session g , 
		(select distinct sql_id, 
						 CHILD_NUMBER,
						 PLAN_HASH_VALUE, 
						 SQL_text from gv$sql) l
where 
		g.username is not null 
and 
		status = 'ACTIVE'
and 
		g.sql_id = l.SQL_ID 
and 
		g.SQL_CHILD_NUMBER =l.CHILD_NUMBER
order by g.sql_exec_start ; 