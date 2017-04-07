set serveroutput on;

declare 

	a number;
	
procedure squareNum(x in out number) is
begin

	x := x*x;

end;
begin
	
	a := 2;
	
	squareNum(a);
	
	dbms_output.put_line('The squareNum(a) is:' || a);

end;
/