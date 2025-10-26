DELIMITER $$
CREATE PROCEDURE ShowEmployeesAboveSalary(IN min_salary DECIMAL(10,2))
BEGIN
  SELECT * FROM employees WHERE salary > min_salary;
END$$
DELIMITER ;
CALL ShowEmployeesAboveSalary(55000);
