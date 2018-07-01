--log into db
sqlplus / as sysdba;

-- db links checking 
select * from dba_db_links;

-- mview query checking, all mv using db link fics

set long 5000000
select OWNER,MVIEW_NAME,QUERY from dba_mviews;

--MV status checking

select OWNER,NAME,REFRESH_METHOD,to_char(LAST_REFRESH,'yyyy-mm-dd hh24:mi:ss'),ERROR,FR_OPERATIONS,CR_OPERATIONS,STATUS from dba_snapshots;

--create testing db links

CREATE PUBLIC DATABASE LINK TEST CONNECT TO "TEST" IDENTIFIED BY "TEST" USING 'TEST_TNSNAME';

CREATE PUBLIC DATABASE LINK TEST1 CONNECT TO "TEST" IDENTIFIED BY "TEST" USING 'TEST_TNSNAME';


--drop testing db_links

drop public DATABASE LINK TEST;

-- recreate db links fics under user CCGP

conn CCGP/password
DROP DATABASE LINK TEST;
CREATE DATABASE LINK TEST CONNECT TO "TEST" IDENTIFIED BY "TEST" USING 'TEST_TNSNAME';

