--user defined record in subprogram
declare
	type book is record
	(	
		bookid		number,
		title		varchar2(50),
		author		varchar2(50),
		subject		varchar2(50)
	);
	book1 book;
	book2 book;

procedure displayBook(book# book) is
begin

		dbms_output.put_line('book#.id ' ||book#.bookid);
		dbms_output.put_line('book#.title '||book#.title);
		dbms_output.put_line('book#.author '||book#.author);
		dbms_output.put_line('book#.subject '||book#.subject);

end;
begin

		book1.bookid 	:= 	1;
		book1.title		:= 	'Hello World!';
		book1.author	:= 	'ALEX';
		book1.subject	:=	'pl/sql';
		
		book2.bookid	:=	2;
		book2.title		:=	'How are you?';
		book2.author	:=	'ALEX';
		book2.author	:=	'pl/sql';
		
		displayBook(book1);
		displayBook(book2);

end;
/