DELIMITER $$
CREATE PROCEDURE IncreaseSalaryByPer(
    IN p_emp_id INT,
    IN p_percent DECIMAL(5,2)
)
BEGIN
    UPDATE employees
    SET salary = salary + (salary * p_percent / 100)
    WHERE emp_id = p_emp_id;
END$$
DELIMITER ;
-- ✅ Now call it properly:
CALL IncreaseSalaryByPer (2, 10);
select * from employees;