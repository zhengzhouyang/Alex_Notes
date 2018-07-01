alter profile DEFAULT limit PASSWORD_LIFE_TIME  unlimited;

select username, account_status, EXPIRY_DATE from dba_users where username='&UNAME';

select username, account_status, EXPIRY_DATE,PROFILE from dba_users where username LIKE '%ORDS%';

alter profile DEFAULT limit PASSWORD_VERIFY_FUNCTION null; ORA12C_STRONG_VERIFY_FUNCTION