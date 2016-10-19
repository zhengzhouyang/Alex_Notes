-------------------------------------------------------------------------------

-- File Name     : SessionRunningSameSql.sql

-- Author        : Alex(Zhouyang Zheng)

-- Corporation	 : Cloud Creek Systems, Inc.

-- Call Syntax   : start path/*.sql from sql*plus

-- Requirements  : SYS Privileges, sql_id

-- Last Modified : 10/11/2016

-- Description   : Checking the session running same sql and start time

-------------------------------------------------------------------------------

SELECT s.inst_id,
       s.sid,
       s.serial#,
       p.spid,
       s.username,
       s.program,
	   s.SQL_EXEC_START
FROM   gv$session s
       JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id
WHERE  s.type != 'BACKGROUND' and sql_id = '&sqlid'
order by s.SQL_EXEC_START; 