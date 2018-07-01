---dba objects check

	select 
			owner,
			OBJECT_NAME,
			OBJECT_TYPE,
			STATUS
	from
			dba_objects
	where 
			OWNER='RISK_DEPT'
	and
			OBJECT_NAME='';
		

		
--dba_jobs query

select JOB,LOG_USER,PRIV_USER,SCHEMA_USER,LAST_DATE,NEXT_DATE,FAILURES from dba_jobs where job=62;

select grantee,owner,table_name,privilege from dba_tab_privs where grantee=''
and owner in('','');

select * from DBA_SYNONYMS where SYNONYM_NAME ='';

--privilege
select grantee,owner,table_name,privilege from dba_tab_privs where grantee=''
and table_name='';
