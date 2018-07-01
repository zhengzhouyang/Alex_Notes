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
FROM   v$session s,
       v$process p
WHERE  s.paddr  = p.addr
AND	   s.TYPE = 'USER'
ORDER BY s.logon_Time;

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
       s.program,
       count(*)
FROM   v$session s,
       v$process p
WHERE  s.paddr  = p.addr
AND	   s.TYPE = 'USER'
group by s.username,s.osuser,s.program
order by count(*) desc ;
