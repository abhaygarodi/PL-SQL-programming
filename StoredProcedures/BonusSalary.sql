DELIMITER $$

CREATE PROCEDURE AddBonusAndReturnSal(
    IN p_emp_id INT,
    INOUT p_bonus DECIMAL(10,2)
)
BEGIN
 update employees 
 set salary = salary + P_bonus
 where emp_id = p_emp_id;
     
     select salary into P_bonus
     from employees
     where emp_id = p_emp_id;
END$$

DELIMITER ;
SET @bonus = 5000;
CALL AddBonusAndReturnSal(4, @bonus);
SELECT @bonus AS UpdatedSalary;































