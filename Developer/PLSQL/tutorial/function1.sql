set serveroutput on;

declare 
	a number;
function fact(x in number) 
return number
is
	f number;
begin

	if x=1 then
		 return 1;
	else
		f := x * fact(x-1);
	end if;
	return f;

end;
begin
	
	a := 5;
	
	dbms_output.put_line('The factorial is: '|| fact(a));

end;
/
