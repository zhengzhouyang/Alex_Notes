-- PLSQL enable monitor index usage

BEGIN

	FOR r IN (select index_name
				from user_indexes
				where index_type != 'LOB')
	loop
	
		execute immediate 'alter index '|| r.index_name ||
			' monitoring usage';
	
	end loop;

END;

select index_name, index_type from user_indexes;

-- query index usage info

select
		index_name,
		table_name,
		used,
		start_monitoring
from
		v$object_usage
where
		monitoring = 'YES';
		
--在不enable monitoring的情况下，可以使用以下sql来查询，但是如果cached sql aged out, 那么就无法查询所有的信息

with in_plan_objects as 
	(select distinct object_name
					from v$sql_plan
					where object_owner = USER)
SELECT table_name,index_name,
		CASE WHEN object_name is null
			 THEN 'NO'
			 ELSE 'YES'
		END AS in_cached_plan
FROM
		user_indexes left outer join in_plan_objects
on
		(index_name = object_name);
		

