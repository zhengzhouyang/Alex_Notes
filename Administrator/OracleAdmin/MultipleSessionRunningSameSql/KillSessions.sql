-------------------------------------------------------------------------------

-- File Name     : KillSessions.sql

-- Author        : Alex(Zhouyang Zheng)

-- Corporation	 : Cloud Creek Systems, Inc.

-- Call Syntax   : start path/*.sql from sql*plus

-- Requirements  : sid serial# to identify the unique session

-- Last Modified : 10/11/2016

-- Description   : Dangerous!Double confirm before killing a session

-------------------------------------------------------------------------------
ALTER SYSTEM KILL SESSION '&sid,&serial';