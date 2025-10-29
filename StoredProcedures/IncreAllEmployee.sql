DELIMITER $$

CREATE PROCEDURE IncreaseSalariesBy5Per()
BEGIN
   
   Update employees 
   set salary = salary * 1.05;
END$$

DELIMITER ;


select * from employees;