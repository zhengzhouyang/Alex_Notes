-------------------------------------------------------------------------------

-- File Name     : undo.sql

-- Author        : Alex(Zhouyang Zheng)

-- Corporation	 : Cloud Creek Systems, Inc.

-- Call Syntax   : start path/*.sql from sql*plus

-- Requirements  : Access Privileges

-- Last Modified : 04/12/2017

-- Description   : Undo basic operation

-------------------------------------------------------------------------------


-------------------------------------------------------------------------------

-- Create new undo tablespace

-------------------------------------------------------------------------------

	create undo tablespace undo_batch
		datafile '/u01/app/oracle/oradata/ALEXDB2/undo_batch01.dbf'
		size 500m reuse autoextend on;
		
	create undo tablespace undo_bi;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------

-- Query the undo tablespace info

-------------------------------------------------------------------------------

-- undo datafile location and size

	select
			ts.name ts_name,
			df.name df_name,
			bytes/1024/1024 MB
	from
			v$tablespace ts
	join
			v$datafile	 df
	using (ts#)
	where
			ts.name='UNDO_BI';

-- undo_retention parameter

	show parameter undo_retention;
	
-- query online undo tablespace group

	select
			tablespace_name,
			status
	from
			dba_tablespaces
	where
			contents = 'UNDO';
			
-- query active undo tablespace

	show parameter undo_tablespace;
	
/*

active 和 online undo_tablespace的区别是：
active是正在被使用的undo tablespace
而其他的online tablespace都是可以被随时调用的。

不同的undo tablespace适应不同的情况，

速度快但是size小的undo ts适用于OLTP情况，效率是第一位的

速度慢但是size大的undo ts适用于DW的情况，避免undo space不够用
而产生的query / DML 失败。DW的query通常运行时间较长。

可以在transcation active时切换undo tablespace.直到transcation
结束前，老的undo tablespace依然包括undo information,用于提供
roll back.在这期间，undo tablespace不能被offline

*/
	
			
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------

-- set transaction and switch undo tablespace

-------------------------------------------------------------------------------

	set transaction name 'Employee Maintenance';
	--Then DML.....until commit or roll back;
	
	alter system set undo_tablespace = undo_batch;
	--you can run this command anytime
	
	alter tablespace undotbs1 offline;
	--you can't take this tablespace offline if it still contains undo datafile
	
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------

-- size and monitor the undo tablespace

-------------------------------------------------------------------------------

	select
			to_char(end_time,'yyyy-mm-dd hh24:mi') end_time,
			undoblks,
			ssolderrcnt
	from
			v$undostat
	order by 2;
	
/*
	第三个column是说snapshot too old 的错误
	
	通过公式来计算undo tablespace的大小
	
	size = block#/second X block_size X retention + overhead
	
	if turn on retention guarantee;
	DML will fail and read opeartion will be guaranteed
	
*/


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
