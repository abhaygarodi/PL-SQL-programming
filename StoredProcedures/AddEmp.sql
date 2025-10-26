DELIMITER $$

CREATE PROCEDURE AddEmp()
BEGIN
   insert into employees values(50,'abhay',25000,'IT');
END$$

DELIMITER ;

call  AddEmp();

select * from employees;