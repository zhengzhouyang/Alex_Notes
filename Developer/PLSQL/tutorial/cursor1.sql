set serveroutput on;

create or replace procedure playCursor is
begin
	
	declare
		
		id 				employees.employee_id%type;
		
		fir_name 		employees.first_name%type;
		
		lst_name 		employees.last_name%type;
		
		email	 		employees.email%type;
	
		CURSOR e_list is
			select employee_id,first_name,last_name,email from employees where rownum <=10;
	begin
	
		open e_list;
	
		loop
		
			exit when e_list%notfound;
			
			fetch e_list into id,fir_name,lst_name,email;
			
			dbms_output.put_line('The customer info is: '|| id || ' , ' || fir_name ||' ' || lst_name || ' , ' || email);
			
		end loop;
		
		close e_list;
	
	end;

end;
/

begin
		playCursor;
end;
/