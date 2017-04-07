--table-based record

set serveroutput on;

DECLARE

	employee_rec employees%rowtype;--record是个逻辑单元，把一行数据拼成一个记录。

BEGIN

	select * into employee_rec from employees where employee_id = 205;
	
	dbms_output.put_line('employee id : '|| employee_rec.employee_id);
	
	dbms_output.put_line('employee first name: ' || employee_rec.first_name);
	
	dbms_output.put_line('employee last name: '|| employee_rec.last_name);
	
	dbms_output.put_line('employee email: '|| employee_rec.email);

END;
/