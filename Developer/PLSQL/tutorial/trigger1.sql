--triger tutorial

set serveroutput on;

create or replace trigger display_salary_diff
before update on employees
for each row
declare

	sal_diff number;

begin

	sal_diff := :NEW.salary - :OLD.salary;
	
	dbms_output.put_line('The old salary of this is: ' || :OLD.salary);
	
	dbms_output.put_line('The new salary of this is: ' || :NEW.salary);
	
	dbms_output.put_line('The diff salary of this is: ' || sal_diff);

end;
/

update employees set salary = salary + 500 where employee_id = 199;