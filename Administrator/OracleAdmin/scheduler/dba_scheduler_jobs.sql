select Owner, job_name, program_name, schedule_name, schedule_type,
failure_count, last_start_date , comments
from dba_scheduler_jobs
where owner='ORACLE_OCM' and job_name='MGMT_STATS_CONFIG_JOB';

select Owner, job_name,start_date,
failure_count, last_start_date ,NEXT_RUN_DATE, comments
from dba_scheduler_jobs
where owner='APRICOT' and job_name='DAILY_CALL_SYNC';

select job, schema_user, to_char(last_date,'DD-MON-YYYY HH24:MI:SS') "last_date", to_char(next_date,'DD-MON-YYYY HH24:MI:SS') "next_date", 
interval, what, broken, failures from dba_jobs;

SET LINESIZE 250

COLUMN comments FORMAT A40;
COLUMN next_start_date format A40;
COLUMN last_start_date format A40;
COLUMN duration format A20;

SELECT window_name,
       resource_plan,
       enabled,
	   next_start_date,
	   last_start_date,
	   duration,
       active,
       comments
FROM   dba_scheduler_windows
ORDER BY window_name;

select text from all_source
where name = 'AIMS_DATA_COLLECTOR'
order by line;
