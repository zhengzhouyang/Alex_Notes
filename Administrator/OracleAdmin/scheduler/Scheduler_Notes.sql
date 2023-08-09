--------------------------------------------------------Step 1 create program--------------------------------------------------------
BEGIN
  DBMS_SCHEDULER.create_program(
  program_name => 'CORE_PURGE_SIT',
  program_type => 'STORED_PROCEDURE',
  program_action => 'CHTR.PKG_CORE_PRUGE_DBMS_SCHED_SIT.process_account_hard_delete',
  number_of_arguments => 1,
  enabled => FALSE,
  comments => 'Program to purge old data in chtr.t_account');

  DBMS_SCHEDULER.define_program_argument(
   program_name => 'HARD_ACC_DEL_SIT',
   argument_name => 'P_AUDIT_USER',
   argument_position => 1,
   argument_type => 'VARCHAR2',
   default_value => 'HARD-ACC-DEL_SIT');

  DBMS_SCHEDULER.enable (name=>'HARD_ACC_DEL_SIT');
END;
/

BEGIN
  DBMS_SCHEDULER.create_program(
  program_name => 'CORE_PURGE_SIT',
  program_type => 'STORED_PROCEDURE',
  program_action => 'CHTR.PKG_CORE_PRUGE_DBMS_SCHED_SIT.CORE_PURGE_SIT',
  enabled => true,
  comments => 'Core Purge Job SIT');
END;
/

SELECT owner, program_name, enabled FROM dba_scheduler_programs where program_name like 'HARD_ACC_DEL_SIT';

--------------------------------------------------------Step 2 Create schedule--------------------------------------------------------
BEGIN
DBMS_SCHEDULER.create_schedule (
  schedule_name => 'core_purge_daily_sched',
  start_date => SYSTIMESTAMP,
  repeat_interval => 'freq=daily; byhour=16; byminute=51; bysecond=0;',
  end_date => NULL,
  comments => 'Core Purge Job Daily Schedule at 9PM ET');
END;
/

BEGIN
DBMS_SCHEDULER.create_schedule (
  schedule_name => 'core_purge_hourly_sched',
  start_date => SYSTIMESTAMP,
  repeat_interval => 'freq=hourly; byminute=0; bysecond=0;',
  end_date => NULL,
  comments => 'Core Purge Job hourly Schedule');
END;
/

--------------------------------------------------------STEP 3 –Create job--------------------------------------------------------
BEGIN
DBMS_SCHEDULER.create_job (
  job_name => 'CORE_PURGE_SIT_JOB',
  program_name => 'CORE_PURGE_SIT',
  schedule_name => 'core_purge_daily_sched',
  enabled => TRUE,
  comments => 'CORE_PURGE');
END;
/

--------------------------------------------------------operation--------------------------------------------------------

--------------------------------------------------------Program related--------------------------------------------------------
--------------------------------------------------------drop a program--------------------------------------------------------
BEGIN
  DBMS_SCHEDULER.drop_program(program_name=>'plsql_program');
END;
/


--------------------------------------------------------to disable a program--------------------------------------------------------
BEGIN
  DBMS_SCHEDULER.disable (name=>'plsql_program');
END;
/

--------------------------------------------------------to enable a program--------------------------------------------------------
BEGIN
  DBMS_SCHEDULER.enable (name=>'plsql_program');
END;
/

--------------------------------------------------------View program details--------------------------------------------------------
set lines 999;
col owner for a20;
col program_name for a30;
SELECT owner, program_name, enabled FROM dba_scheduler_programs where program_name like 'HARD_ACC_DEL_SIT';

--------------------------------------------------------Drop a schedule--------------------------------------------------------
BEGIN
  DBMS_SCHEDULER.drop_schedule (schedule_name => 'daily_sched');
END;
/

--------------------------------------------------------Schedule related--------------------------------------------------------
--------------------------------------------------------View schedule details--------------------------------------------------------
set lines 999;
col schedule_name for a30;
SELECT owner, schedule_name from DBA_SCHEDULER_SCHEDULES;

--------------------------------------------------------More schedule examples--------------------------------------------------------
run everyday at midnight
'freq=daily; byhour=0; byminute=0; bysecond=0;'

run everyday at 4 pm
'freq=daily; byhour=16; byminute=0; bysecond=0;'

run every hour at 10 minutes. 1:10, 2:10 …..
'freq=hourly; byminute=10; bysecond=0;'

run every 5 minutes
'freq=minutely; interval=5; bysecond=0;'

run every monday and thursday at 9 pm
'freq=weekly, byday=mon,thu; byhour=21; byminute=0; bysecond=0;'

run friday of each quarter
'freq=monthly; bymonth=1,4,7,10; byday=fri;'

--------------------------------------------------------To drop a job--------------------------------------------------------
BEGIN
  DBMS_SCHEDULER.drop_job (job_name=>'test_sched_job');
END;
/

--------------------------------------------------------to disable a job--------------------------------------------------------
BEGIN
  DBMS_SCHEDULER.disable (name=>'test_sched_job');
END;
/

--------------------------------------------------------to enable a job--------------------------------------------------------
BEGIN
  DBMS_SCHEDULER.enable (name=>'test_sched_job');
END;

--------------------------------------------------------View job details--------------------------------------------------------
set lines 999;
col job_name for a30;
select owner, job_name, enabled from dba_scheduler_jobs;

--------------------------------------------------------Run jobs manually--------------------------------------------------------
BEGIN
  DBMS_SCHEDULER.run_job (job_name => 'test_sched_job', use_current_session => TRUE);
END;
/

--------------------------------------------------------View job status--------------------------------------------------------
select job_name, status, run_duration
from dba_scheduler_job_run_details
where job_name='CORE_PURGE_JOB';


--------------------------------------------------------Find the details of the program attached to a job--------------------------------------------------------
SELECT job_name, enabled, program_name
FROM dba_scheduler_jobs
WHERE job_name LIKE 'TEST%';


--------------------------------------------------------Find schedule details attached to a job--------------------------------------------------------
SELECT job_name, schedule_name, start_date
FROM dba_scheduler_jobs
WHERE job_name like 'TEST%';

--------------------------------------------------------Find job current status if it is running or not--------------------------------------------------------
SELECT JOB_NAME, STATE FROM DBA_SCHEDULER_JOBS
WHERE JOB_NAME LIKE 'TEST%';

--------------------------------------------------------Check progress of all running jobs--------------------------------------------------------
SELECT * FROM ALL_SCHEDULER_RUNNING_JOBS;

--------------------------------------------------------Find the log details of job runs--------------------------------------------------------
SELECT to_char(log_date, 'DD-MON-YY HH24:MM:SS') TIMESTAMP, job_name, status,
SUBSTR(additional_info, 1, 40) ADDITIONAL_INFO
FROM user_scheduler_job_run_details
WHERE job_name like 'TEST%'
ORDER BY log_date ;

reference link:https://www.support.dbagenesis.com/post/scheduling-jobs-with-dbms_scheduler