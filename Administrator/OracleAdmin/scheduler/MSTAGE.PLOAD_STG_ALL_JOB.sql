TEXT
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE "PLOAD_STG_ALL_JOB"
(
    p_parent_id in number,
    ---
    p_job_object_type_name in varchar2,
    p_job_object_name in varchar2,
    p_job_dep_location_name in varchar2,
    ---
    p_job_task_name in varchar2,
    p_job_exec_location_name in varchar2,
    ---
    p_activity_task_name in varchar2,
    p_activity_exec_location_name in varchar2,
    --
    p_workspace_owner in varchar2,
    p_workspace_name in varchar2 -- OWB RUNNER MACRO EXTRA COMMA
    -- Executed Object parameters
    -- OWB RUNNER MACRO PARAMETER LIST
)
as
    l_job_audit_execution_id number;
    l_audit_execution_id number;
    l_error_message varchar2(2000);
    l_debug_message varchar2(2000);
    l_stream_id number(22);
    l_result number;
-- OWB RUNNER MACRO LOCAL VARIABLES

 function equals
  (
    str1 IN VARCHAR2,
    str2 IN VARCHAR2
  )
  return boolean
  is
  begin
    if(str1 is null and str2 is not null) then return false; end if;
    if(str1 is not null and str2 is null) then return false; end if;
    if(str1 != str2) then return false; end if;

    return true;
  end;

   procedure println
  (

    str IN VARCHAR2
  )
  as
  begin
    l_debug_message:= l_debug_message ||str;
  end;

   procedure call_custom_proc (p_name IN VARCHAR2)
  as l_message varchar2(4056);
  BEGIN
    EXECUTE IMMEDIATE 'BEGIN ' || p_name || '(' ||
    '  p_job_name=>:1' ||
    ', p_message=>:2' ||
    ', p_job_audit_execution_id=>:3' ||
    ', p_audit_execution_id=>:4' ||
    ', p_parent_id=>:5' ||
    ', p_job_object_type_name=>:6' ||
    ', p_job_object_name=>:7' ||
    ', p_job_dep_location_name=>:8' ||
    ', p_job_task_name=>:9' ||
    ', p_job_exec_location_name=>:10' ||
    ', p_activity_task_name=>:11' ||
    ', p_activity_exec_location_name=>:12' || -- OWB RUNNER MACRO CALL CUSTOM PROC DEF
    '); END;'
	 USING
      'PLOAD_STG_ALL_JOB'
    , in out l_message
    , l_job_audit_execution_id
    , l_audit_execution_id
    , p_parent_id
    , p_job_object_type_name
    , p_job_object_name
    , p_job_dep_location_name
    , p_job_task_name
    , p_job_exec_location_name
    , p_activity_task_name
    , p_activity_exec_location_name -- OWB RUNNER MACRO CALL CUSTOM PROC VALUE
    ;

    println('call_custom_proc ' || p_name);
    println(l_message);
  EXCEPTION
  WHEN others THEN
    IF SQLCODE <> -6550 THEN
      RAISE;
    END IF;
 END;

 begin

    println('Begin.');

-- OWB RUNNER MACRO COPY VARIABLES

  println('l_job_audit_execution_id=' || l_job_audit_execution_id);
  println('p_job_object_type_name=' || p_job_object_type_name);
  println('p_job_object_name=' || p_job_object_name);
  println('p_job_dep_location_name=' || p_job_dep_location_name);
  println('p_job_task_name=' || p_job_task_name);
  println('p_job_exec_location_name=' || p_job_exec_location_name);
  println('p_activity_task_name=' || p_activity_task_name);
  println('p_activity_exec_location_name=' || p_activity_exec_location_name);
  -- OWB RUNNER MACRO PRINT PARAMETER LIST
  println('');

    -- Work around to make sure that package wb_rti_workflow_util is compiled
    begin
      SLOAD_STG_ALL_JOB.initialize;
    EXCEPTION WHEN OTHERS THEN
      SLOAD_STG_ALL_JOB.initialize;
    end;

	   println('Initialize complete.');

    -- Set the workspace
    SLOAD_STG_ALL_JOB.set_workspace(p_workspace_name, p_workspace_owner);
    println(' workspace set.');

    if p_parent_id <= 0
    then
       println(' starting operator.');

       -- Start the Operator
       l_job_audit_execution_id:= SLOAD_STG_ALL_JOB.open_by_name
       (
         null,
         p_job_object_type_name,
         p_job_object_name,
         p_job_dep_location_name,
         p_job_task_name,
         p_job_exec_location_name
       );

       commit;
       -- OWB RUNNER MACRO PARAMETER STATEMENTS
       commit;

       l_result:= SLOAD_STG_ALL_JOB.execute_in_background_and_wait(
         l_job_audit_execution_id, 20);

       println(' execute_in_background complete.');

       commit;

       dbms_scheduler.set_job_argument_value
       (
         job_name=>p_job_task_name,
         argument_position=>1,
         argument_value=>l_job_audit_execution_id
       );

       println(' set_job_argument_value complete.');

    else
      l_job_audit_execution_id:= p_parent_id;
    end if;
 println(' l_job_audit_execution_id= ' || l_job_audit_execution_id || '.');

    commit;

    call_custom_proc('OWB_JOB_OVERRIDE.PRE_JOB');

    l_audit_execution_id:= SLOAD_STG_ALL_JOB.open_by_name
    (
      l_job_audit_execution_id,
      p_job_object_type_name,
      p_job_object_name,
      p_job_dep_location_name,
      p_activity_task_name,
      p_activity_exec_location_name
    );

    -- OWB RUNNER MACRO TASK PARAMETER STATEMENTS

    l_stream_id := SLOAD_STG_ALL_JOB.create_stream;

    SLOAD_STG_ALL_JOB.activate_execution(l_audit_execution_id);

    SLOAD_STG_ALL_JOB.execute_child(l_audit_execution_id, l_stream_id);

    println(' execute_task complete.');
    println(' l_audit_execution_id= ' || l_audit_execution_id || '.');
    println(' l_stream_id= ' || l_stream_id || '.');

    commit;

    SLOAD_STG_ALL_JOB.wait_for_task_then_close(
       l_audit_execution_id,
       l_stream_id
    );

    commit;

    println(' wait_for_task_then_close complete.');

    call_custom_proc('OWB_JOB_OVERRIDE.POST_JOB');

    commit;
EXCEPTION WHEN OTHERS THEN
  BEGIN
    l_error_message:= l_debug_message || ' ' || SQLERRM;
    /*||
      ' p_parent_id =' || p_parent_id ||
      ' p_job_object_type_name =' || p_job_object_type_name ||
      ' p_job_object_name =' || p_job_object_name ||
      ' p_job_dep_location_name =' || p_job_dep_location_name ||
      ' p_job_task_name =' || p_job_task_name ||
      ' p_job_exec_location_name =' || p_job_exec_location_name ||
    raise_application_error(-20001, l_error_message, true);
      ' p_activity_task_name =' || p_activity_task_name ||
      ' p_activity_exec_location_name =' || p_activity_exec_location_name; */

  END;
end;
