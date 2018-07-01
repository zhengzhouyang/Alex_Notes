select inst_id,sid,serial#,username,last_call_et/60 last_Call, decode(command,2,'INSERT',3,'SELECT',6,'UPDATE',7,'Delete',47,'PL/SQL EXE',command) command
,machine,sql_id,sql_child_number CN,DECODE(STATE,'WAITING',event,'ACTIVE') "STATE/EVENT"
  from gv$session
 where status = 'ACTIVE'
   and type = 'USER'
and command != 0
order by 4
/
