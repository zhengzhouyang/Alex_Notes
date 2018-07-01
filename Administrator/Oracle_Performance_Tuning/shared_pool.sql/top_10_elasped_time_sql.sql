--Top 10 elapsed time 

set pages 5000
set lines 220

select
		sql_id,
		child_number,
		sql_text,
		elapsed_time 
from
	(
		select sql_id,
				child_number,
				sql_text,
				elapsed_time,
				cpu_time,
				disk_reads,
				rank () over(order by elapsed_time DESC) as elapsed_rank
		from 
				v$sql
	)
where
	elapsed_rank <= 10;
	
--Execution Plan

select * from table(dbms_xplan.display_cursor('f5xyumadyzp4r','0','TYPICAL -BYTES'));