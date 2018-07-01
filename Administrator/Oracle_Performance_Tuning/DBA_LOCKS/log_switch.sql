select to_char(first_time,'YYYY-MM-DD HH24') as hour,count(*) as num_switches, sum(blocks*block_size) as redo_bytes
from gv$archived_log 
group by to_char(first_time,'YYYY-MM-DD HH24')
order by 1;

col redo_bytes for 999,999,999,999,999

select to_char(first_time,'YYYY-MM-DD') as hour,count(*) as num_switches, sum(blocks*block_size) as redo_bytes
from gv$archived_log 
group by to_char(first_time,'YYYY-MM-DD')
order by 1;