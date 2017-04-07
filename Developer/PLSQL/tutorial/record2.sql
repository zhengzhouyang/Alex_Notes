--cursor based record
set serveroutput on;

declare
	
	CURSOR employee_cur is 
			select employee_id, first_name, last_name, email from employees where employee_id=205;
			
	employee_rec employee_cur%rowtype;

begin

	open employee_cur;
	
	fetch employee_cur into employee_rec;
	
	dbms_output.put_line(employee_rec.first_name || ' ' || employee_rec.last_name || ' is writing PLSQL');
	
	close employee_cur;

end;
/