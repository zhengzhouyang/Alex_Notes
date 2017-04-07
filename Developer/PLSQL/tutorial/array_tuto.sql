set serveroutput on;

DECLARE

	CURSOR e_employee is 
			select first_name||' '||last_name as fullName from employees;
			
	type e_list is VARRAY(10) of employees.first_name%type;
	
	name_list e_list := e_list();--这个是用e_list类新建一个name_list变量
	
	counter integer := 0;

BEGIN 

	for n in e_employee loop
	
		counter : = counter + 1;
		
		name_list.extend;--name_list向后移一个index
		
		name_list(counter) := n.fullName;
		
		dbms_output.put_line('Company('||counter||'): '||name_list(counter));
		
		exit when counter > 9;
	
	end loop;
	
END;
/