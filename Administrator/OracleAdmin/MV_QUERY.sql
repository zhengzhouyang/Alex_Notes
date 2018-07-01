SELECT what, job, priv_user,
           TO_CHAR(last_date, 'MM/DD/YYYY HH24:MI:SS') last,
           DECODE(this_date, NULL, 'NO', 'YES') running,
           TO_CHAR(next_date, 'MM/DD/YYYY HH24:MI:SS') next,
           interval, total_time, broken
    FROM   dba_jobs
	WHERE JOB = 206;
	
SELECT what, job, priv_user,
           TO_CHAR(last_date, 'MM/DD/YYYY HH24:MI:SS') last,
           DECODE(this_date, NULL, 'NO', 'YES') running,
           TO_CHAR(next_date, 'MM/DD/YYYY HH24:MI:SS') next,
           interval, total_time, broken
    FROM   dba_jobs
	WHERE JOB = 245;	
	
	
WHAT
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
       JOB PRIV_USER                      LAST                RUN NEXT
---------- ------------------------------ ------------------- --- -------------------
INTERVAL                                                                                                                                                                                             TOTAL_TIME B
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------- -
dbms_refresh.refresh('"APRICOT"."SALESREP"');
       206 APRICOT                        01/15/2018 06:55:10 NO  01/15/2018 07:25:10
SYSDATE+30/1440


select OWNER,NAME,MASTER_OWNER,MASTER,to_char(LAST_REFRESH,'yyyy-dd-mm hh24:mi:ss') from ALL_MVIEW_REFRESH_TIMES where name = 'SALESREP';                                                                                                                                                                                           11237 N


select OWNER,NAME,MASTER_OWNER,MASTER,to_char(LAST_REFRESH,'yyyy-dd-mm hh24:mi:ss') from ALL_MVIEW_REFRESH_TIMES where name = 'QUEUE_TYPE';   

select OWNER,NAME,REFRESH_METHOD,to_char(LAST_REFRESH,'yyyy-dd-mm hh24:mi:ss'),ERROR,FR_OPERATIONS,CR_OPERATIONS,STATUS from dba_snapshots where name = 'QUEUE_TYPE';