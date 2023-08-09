/*
	in a package
*/

	PACKAGE company IS
		CURSOR company_cur (id_in number) RETURN company%ROWTYPE;
	END company;
	
	PACKAGE BODY company IS
		CURSOR company_cur(id_in number) RETURN company%ROWTYPE IS
			SELECT * FROM company ......;
	END company;
	
/*
	parameter based curosr
	table based cursor
	developer defined cursor
*/

------------------------------------------------------------------------
	
	CURSOR parameter_based_cur (character_in IN VARCHAR2) IS
		select ... from tab_name where col_name = character_in;
	
	parameter_based_rec parameter_based_cur%ROWTYPE;
	
	OPEN parameter_based_cur('Who I AM');
	
	FETCH parameter_based_cur INTO parameter_based_rec;
	
	CLOSE;
	
------------------------------------------------------------------------	
	
	CURSOR table_based_cur IS
		select * from tab_name;
	
	table_based_rec table_based_cur%ROWTYPE;
	
	OPEN
	
	FETCH table_based_cur INTO table_based_rec;
	
	CLOSE
	
------------------------------------------------------------------------

	TYPE full_rectype is RECORD
	(col_1 tab_name.col_1%TYPE;
	 col_2 tab_name.col_2%TYPE;
	)
	full_rec full_rectype%TYPE;
	
	OPEN
	
	FETCH cursors INTO full_rec;
	
	CLOSE
	
/*
	cursor attributes,
	These attributes only can be used in PLSQL code
	CAN'T be used in SQL statement
*/

	IF NOT cur%ISOPEN THEN 
		OPEN cur;
	END IF;
	
	EXIT WHEN cur%NOTFOUND;
	
	EXIT WHEN cur%ROWCOUNT > 10;

	IF cur%ISOPEN THEN 
		CLOSE cur;
	END IF;
	
	
	
	
	
	