-- materialized view checking
select 
		NAME,
		TABLE_NAME,
		MASTER_VIEW,
		MASTER,
		REFRESH_METHOD,
		TO_CHAR(LAST_REFRESH, 'DD-MON-YYYY HH24:MI:SS'),
		ERROR 
from 
		all_snapshots
where 
		NAME='DC_RUN_LIST_MV';
		
select OWNER,MVIEW_NAME,QUERY,REFRESH_MODE from all_mviews where MVIEW_NAME='DC_RUN_LIST_MV';

select QUERY from all_mviews where MVIEW_NAME='DC_RUN_LIST_MV';

select OWNER,MVIEW_NAME,REFRESH_MODE,REFRESH_METHOD,BUILD_MODE,FAST_REFRESHABLE,LAST_REFRESH_TYPE,QUERY from all_mviews where MVIEW_NAME='DC_RUN_LIST_MV';

select OWNER,MVIEW_NAME,REFRESH_MODE,REFRESH_METHOD,BUILD_MODE,FAST_REFRESHABLE,LAST_REFRESH_TYPE,QUERY from all_mviews where MVIEW_NAME='AD_SOURCE_DIMENSION_DEF';

select dbms_metadata.get_ddl('MATERIALIZED_VIEW', 'EMP_MV') from dual;

select dbms_metadata.get_ddl('MATERIALIZED_VIEW', 'APRICOT.AD_SOURCE_DIMENSION_DEF') from dual;

select 
		owner,
		OBJECT_NAME,
		OBJECT_TYPE,
		STATUS
from
		dba_objects
where 
		OBJECT_NAME in ('AUTOIMS_DATA','ASSET','IMS_AUCTIONS_STATE_ZIP');
		

select OWNER,NAME,MASTER_OWNER,MASTER,to_char(LAST_REFRESH,'yyyy-dd-mm hh24:mi:ss') from ALL_MVIEW_REFRESH_TIMES where name = 'SALESREP';                                                                                                                                                                                           11237 N


select OWNER,NAME,MASTER_OWNER,MASTER,to_char(LAST_REFRESH,'yyyy-dd-mm hh24:mi:ss') from ALL_MVIEW_REFRESH_TIMES where name = 'QUEUE_TYPE';   

select OWNER,NAME,REFRESH_METHOD,to_char(LAST_REFRESH,'yyyy-dd-mm hh24:mi:ss'),ERROR,FR_OPERATIONS,CR_OPERATIONS,STATUS from dba_snapshots where name = 'QUEUE_TYPE';


--dba jobs checking
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
	