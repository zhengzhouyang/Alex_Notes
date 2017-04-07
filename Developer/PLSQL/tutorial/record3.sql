--user defined record
set serveroutput on;

declare 
	
	type book is record
	(
		bookid 		number,
		title 		varchar2(50),
		author		varchar2(50),
		subject		varchar2(50)
	);
	
	book1 book;
	book2 book;
	
begin

	book1.bookid 	:= 	1;
	book1.title		:= 	'Hello World!';
	book1.author	:= 	'ALEX';
	book1.subject	:=	'pl/sql';
	
	book2.bookid	:=	2;
	book2.title		:=	'How are you?';
	book2.author	:=	'ALEX';
	book2.author	:=	'pl/sql';
	
	dbms_output.put_line('book1.id ' ||book1.bookid);
	dbms_output.put_line('book1.title '||book1.title);
	dbms_output.put_line('book1.author '||book1.author);
	dbms_output.put_line('book1.subject '||book1.subject);
	
	dbms_output.put_line('book2.id ' ||book2.bookid);
	dbms_output.put_line('book2.title '||book2.title);
	dbms_output.put_line('book2.author '||book2.author);
	dbms_output.put_line('book2.subject '||book2.subject);
	
end;
/