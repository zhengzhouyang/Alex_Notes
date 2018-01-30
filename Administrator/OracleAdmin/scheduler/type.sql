CREATE OR REPLACE TYPE super_t AS OBJECT
  (n NUMBER, MEMBER FUNCTION func RETURN NUMBER) NOT final;
/
CREATE OR REPLACE TYPE BODY super_t AS
 MEMBER FUNCTION func RETURN NUMBER IS BEGIN RETURN 1; END; END;
/
CREATE TYPE sub_t UNDER super_t
  (n2 NUMBER,
   OVERRIDING MEMBER FUNCTION func RETURN NUMBER) NOT final;
/
CREATE OR REPLACE TYPE BODY sub_t AS
 OVERRIDING MEMBER FUNCTION func RETURN NUMBER IS BEGIN RETURN 2; END; END;
/

create table test_type 
(
	id 		number,
	t_type	super_t
);

insert into test_type values (1,super_t(1));
insert into test_type values (1,sub_t(1,1));