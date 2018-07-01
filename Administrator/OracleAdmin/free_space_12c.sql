@save_sqlplus_settings

column tablespace_name heading 'Tablespace Name' format a30
column contents heading 'T' format a2
column file_type heading 'F' format a2
column extent_management heading 'M' format a2
column segment_space_management heading 'S' format a2
column block_size heading 'BS' format a3
column status heading 'S' format a2
column sumb format 999,999,999
column extents format 9999
column bytes format 999,999,999
column largest format 999,999,999
column Tot_Bytes format 99,999,999,999,999  Heading 'Total|Bytes' justify center
column Free format 9,999,999,999,999  heading 'Free|Bytes' justify center
column Pct_Used format 999 heading 'Pct|Used' justify center
column Chunks_Free format 999,999   heading 'Chunks|Free' Justify center
column Max_Free format 999,999,999,999   heading 'Largest Free|Chunk Size' Justify Center
column extlen format a6 heading 'Extent|Mgmt' Justify Center
column container_name format a10 heading "Container"

set echo off
set pages 1000
set head on
set lines 136
compute sum of Tot_Bytes on Report
compute sum of Free on Report
break on container_name on Report

-- Set todays date, instance_name, hostname for title
column today new_value _date noprint
column instance_name new_value v_instance noprint
column host_name new_value v_hostname noprint
set termout off
select to_char(sysdate,'fmMonth DD, YYYY - HH24:MI') today from dual;
select instance_name, host_name from v$instance;
set termout on

ttitle -
left '            S - Status' -
center 'TABLESPACE FREE SPACE' skip 1 -
left '            T - Tablespace Type' -
center v_hostname ' - ' v_instance skip 1 -
left '            F - File Type' -
center _date skip 2

select /*+ optimizer_features_enable('11.2.0.4') */
   a.name container_name,
   b.tablespace_name,
   b.status,
   b.contents,
   b.file_type,
   b.extlen,
   b.segment_space_management,
   b.block_size,
   b.tot_bytes,
   b.free,
   b.pct_used,
   b.max_free,
   b.chunks_free
from
   v$containers a,
  (select
	   a.con_id,
	   a.tablespace_name,
	   decode(b.status,'READ ONLY','RO','ONLINE','O') status,
	   decode(b.contents,'TEMPORARY','T','PERMANENT','P','UNDO','U',b.contents) contents,
	   'D' file_type,
	   decode(b.extent_management,'LOCAL','L ','DICTIONARY','D ','D ')||
	   lpad(decode(b.allocation_type,'UNIFORM',
			to_char(decode(sign(round(b.min_extlen/1024)-1024),
						   -1,round(b.min_extlen)/1024||'K',
							  round(b.min_extlen/1024/1024)||'M')),
					'SYSTEM','Auto',
					'USER','User',
					''),4,' ') Extlen,
	   decode(b.segment_space_management,'MANUAL','M','AUTO','A',b.segment_space_management) segment_space_management,
	   lpad((round(b.block_size)/1024||'K'),3,' ') Block_Size,
	   sum(a.tots) Tot_Bytes,
	   sum(a.sumb) Free,
	   (sum(a.tots) - sum(a.sumb))*100/sum(a.tots) Pct_Used,
	   sum(a.largest) Max_Free,
	   sum(a.chunks) Chunks_Free
	from
	  (select tablespace_name,con_id, 0 tots,sum(bytes) sumb,
		  max(bytes) largest,count(*) chunks
	   from cdb_free_space a
	   group by tablespace_name, con_id
	   union
	   select tablespace_name,con_id,sum(bytes) tots,0,0,0
	   from cdb_data_files
	   group by tablespace_name, con_id) a,
	   cdb_tablespaces b
	where
	   b.tablespace_name = a.tablespace_name
	  and b.con_id = a.con_id
	group by a.tablespace_name, a.con_id,b.contents, b.extent_management, b.segment_space_management,b.block_size,b.allocation_type, b.min_extlen, b.status
	union
	select
	   a.con_id,
	   a.tablespace_name,
	   decode(b.status,'READ ONLY','RO','ONLINE','O') status,
	   decode(b.contents,'TEMPORARY','T','PERMANENT','P',b.contents) contents,
	   'T' file_type,
	   decode(b.extent_management,'LOCAL','L ','DICTIONARY','D ','D ')||
	   lpad(decode(b.allocation_type,'UNIFORM',
			to_char(decode(sign(round(b.min_extlen/1024)-1024),
						   -1,round(b.min_extlen)/1024||'K',
							  round(b.min_extlen/1024/1024)||'M')),
					'SYSTEM','Auto',
					'USER','User',
					''),4,' ') Extlen,
	   decode(b.segment_space_management,'MANUAL','M','AUTO','A',b.segment_space_management) segment_space_management,
	   lpad((round(b.block_size)/1024||'K'),3,' ') Block_Size,
	   sum(a.tots) Tot_Bytes,
	   sum(a.sumb) Free,
	   (sum(a.tots) - sum(a.sumb))*100/sum(a.tots) Pct_Used,
	   sum(a.largest) Max_Free,
	   sum(a.chunks) Chunks_Free
	from
	  (select tablespace_name,con_id,0 tots,sum(bytes_free) sumb,
		  max(bytes_free) largest,count(*) chunks
	   from v$temp_space_header a
	   group by tablespace_name, con_id
	   union
	   select tablespace_name,con_id,sum(bytes) tots,0,0,0
	   from cdb_temp_files
	   group by tablespace_name, con_id) a,
	   cdb_tablespaces b
	where
	   b.tablespace_name = a.tablespace_name
	and b.con_id = a.con_id
	group by a.tablespace_name, a.con_id,b.contents, b.extent_management, b.segment_space_management,b.block_size,b.allocation_type, b.min_extlen, b.status) b
where b.con_id = a.con_id
order by 1,2
/

ttitle off
@restore_sqlplus_settings


