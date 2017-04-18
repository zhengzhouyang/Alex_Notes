-------------------------------------------------------------------------------

-- File Name     : flashback.txt

-- Author        : Alex(Zhouyang Zheng)

-- Corporation	 : Cloud Creek Systems, Inc.

-- Call Syntax   : start path/*.sql from sql*plus

-- Requirements  : Access Privileges

-- Last Modified : 04/12/2017

-- Description   : Flashback query

-------------------------------------------------------------------------------


-------------------------------------------------------------------------------

-- flashback query

-------------------------------------------------------------------------------

	insert into hr.employees_archive
			select * from hr.employees
				as of timestamp systimestamp - interval '60' minute
				where hr.employees.employee_id not in
					(select employee_id from hr.employees);

	create table employees_deleted as
			select * from hr.employees
				as of timestamp systimestamp - interval '60' minute
				where hr.employees.employee_id not in
					(select employee_id from hr.employees);
					
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------

-- DBMS_FLASHBACK

-------------------------------------------------------------------------------

-- ONLY available in her session level

	execute dbms_flashback.enable_at_time(
			to_timestamp(sysdate - interval '45' minute));
			
- Using PLSQL to insert the record back.


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------

- Flashback table

-------------------------------------------------------------------------------

	flashback table employees 
			to timestamp systimestamp - interval '15' minute;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------

-- flashback version / transcation query

-------------------------------------------------------------------------------
--Testing query before the version query
	
	update hr.employees set salary = salary * 1.2;
	
	commit;
	
	select DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER from dual;
	
	update hr.employees set manager_id=100 where employee_id = 195;

	commit;

	select DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER from dual;
			
-- You must need to know the exact version number to make the following version query work

	select 
			versions_startscn 	startscn,
			versions_endscn 	endscn,
			versions_xid		xid,
			versions_operation	oper,
			/*table column*/
			employee_id			empid,
			last_name			name,
			manager_id			mgrid,
			salary				salary
	from 
			hr.employees
	versions between scn 13653220 and 13653402;
	
	
	
-- You must know the exact transcation_id(xid) to get the transcation info

	select
			start_scn,
			commit_scn,
			logon_user,
			operation,
			table_name,
			undo_sql
	from
			FLASHBACK_TRANSACTION_QUERY
	where
			xid = hextoraw('0A000E00BD6F0100');
	-- it probably don't log the enough information

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------

-- Flashback archive

-------------------------------------------------------------------------------

-- flashback archive only keep update and delete dml
-- need a specific tablespace

	create tablespace archive fb_es
	tablespace ts_name retention 10 years;
	
	create flashback archive fb_fi
	tablespace ts_name quota 500m retention 7 year;
	
	create flashback archive default db_default
	tablespace ts_name quota 250m retention 2 year; -- default flashback archive
	
	ALTER TABLE oe.customers FLASHBACK ARCHIVE; -- start to tracing table by using default
	
	ALTER TABLE oe.customers FLASHBACK ARCHIVE fb_es; -- specify the FB name
	
	DROP FLASHBACK ARCHIVE fb_es;-- Drop it

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------

-- flashback archive management

-------------------------------------------------------------------------------

	select
			flashback_archive_name,
			flashback_archive#,
			retention_in_days,
			status
	from
			dba_flashback_archive;
			
	select * from dba_flashback_archive_ts;
	
	select * from dba_flashback_archive_tables;
	
-- add more space into flashback archive
	
	alter flashback archive db_dflt
	add tablespace users3 quota 400m;
	
-- purge flashback archive

	alter flashback archive fb_dflt
	purge before timestamp
	to_timestamp('2005-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS');
	
	
	
