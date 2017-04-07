--user defined exception
set serveroutput on;

declare

	e_id 		employees.employee_id%type := &ee_id;
	fir_name 	employees.first_name%type;
	lst_name 	employees.last_name%type;
	invaild_id	exception;

begin

	if e_id <0 then
		raise invaild_id;
	end if;

	select 	first_name,last_name 
	into	fir_name,lst_name  
	from 	employees 
	where employee_id = e_id;
	
	DBMS_OUTPUT.PUT_LINE ('first name: '||  fir_name);  
     
	DBMS_OUTPUT.PUT_LINE ('last name: ' || lst_name);
		
	exception
		when invaild_id then
			dbms_output.put_line('Invalid ID');
		when others then
			dbms_output.put_line('Errors');

end;
/
