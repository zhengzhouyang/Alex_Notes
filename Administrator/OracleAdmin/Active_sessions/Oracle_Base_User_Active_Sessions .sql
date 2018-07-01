-- -----------------------------------------------------------------------------------
-- File Name    : https://oracle-base.com/dba/monitoring/active_sessions.sql
-- Author       : Tim Hall
-- Description  : Displays information on all active database sessions.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @active_sessions
-- Last Modified: 15-JUL-2000
-- -----------------------------------------------------------------------------------

--User Sessions' information
--12C don't kill OS process to kill the session

SET LINESIZE 500
SET PAGESIZE 1000

COLUMN username FORMAT A10
COLUMN osuser FORMAT A10
COLUMN spid FORMAT A10
COLUMN service_name FORMAT A15
COLUMN module FORMAT A10
COLUMN machine FORMAT A20
COLUMN logon_time FORMAT A20
COLUMN program FORMAT A20

SELECT NVL(s.username, '(oracle)') AS username,
       s.osuser,
	   s.sql_id,
       s.sid,
       s.serial#,
       p.spid, -- Operating system process identifier
       s.lockwait,
       s.status,
       s.module,
       s.machine,
       s.program,
	    decode(command,2,'INSERT',3,'SELECT',6,'UPDATE',7,'Delete',47,'PL/SQL EXE',command) command,
       TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time,
       s.last_call_et AS last_call_et_secs,
	   s.TYPE
FROM   gv$session s,
       gv$process p
WHERE  s.paddr  = p.addr
AND    s.status = 'ACTIVE'
AND	   s.TYPE = 'USER'
ORDER BY s.username, s.osuser;


SET LINESIZE 500
SET PAGESIZE 1000
COLUMN username FORMAT A10
COLUMN osuser FORMAT A10
COLUMN spid FORMAT A10
COLUMN service_name FORMAT A15
COLUMN module FORMAT A10
COLUMN machine FORMAT A20
COLUMN logon_time FORMAT A20
COLUMN program FORMAT A20

SELECT NVL(s.username, '(oracle)') AS username,
       s.osuser,
	   s.sql_id,
       s.sid,
       s.serial#,
       p.spid, -- Operating system process identifier
       s.lockwait,
       s.status,
       s.module,
       s.machine,
       s.program,
       TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time,
       s.last_call_et AS last_call_et_secs,
	   s.TYPE
FROM   gv$session s,
       gv$process p
WHERE  s.paddr  = p.addr
AND    s.status = 'ACTIVE'
AND	   s.TYPE = 'USER'
ORDER BY s.last_call_et;
