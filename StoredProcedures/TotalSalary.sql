--Create a procedure to find the total salary paid in a department (IN and OUT
parameter).
DELIMITER $$

CREATE PROCEDURE Total_Salary(
  IN deptname VARCHAR(30),
  INOUT total_salary DECIMAL(10,2)
)
BEGIN
  SELECT IFNULL(SUM(salary), 0)
  INTO total_salary
  FROM employees
  WHERE department = deptname;
END$$

DELIMITER ;
SET @total_sal = 0;
CALL Total_Salary('IT', @total_sal);
SELECT @total_sal AS Total_Salary_Paid;