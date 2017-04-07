--package tutorials

set serveroutput on;

--package specfication must be declared firstly
--before creating package body
CREATE OR REPLACE PACKAGE empl_sal_pack AS 
   PROCEDURE find_sal(e_id employees.employee_id%type); 
END empl_sal_pack; 
/


create or replace package body empl_sal_pack as
	procedure find_sal (e_id employees.employee_id%type) is
		e_sal 	employees.salary%type;
	begin
		
		select salary into e_sal from employees
			where employee_id = e_id;

		dbms_output.put_line('Salary is: ' || e_sal);
		
	end find_sal;
end empl_sal_pack;
/

begin
	empl_sal_pack.find_sal(&ee_id);
end;
/
