set serveroutput on;

declare 
	
	a number;
	b number;
	c number;

procedure findMin(x in number, y in number, z out number )is
begin

	if x >= y then
		z := y;
	else 
		z := x;
	end if;

end;
begin

	a := 10;
	
	b := 20;
	
	findMin(x => a, y => b,  z => c);
	
	dbms_output.put_line('The min is: ' || c);

end;
/