DELIMITER $$

CREATE PROCEDURE ChangeEmp(
    IN emp_name VARCHAR(50),       -- Employee name to identify the record
    IN new_department VARCHAR(30)  -- New department name
)
BEGIN
    -- Update the department for the given employee
    UPDATE employees
    SET department = new_department
    WHERE name = emp_name;

    -- Show how many rows were updated
    SELECT ROW_COUNT() AS RowsUpdated;

    -- Show the updated employee row
    SELECT * FROM employees WHERE name = emp_name;
END$$

DELIMITER ;
CALL ChangeEmpDepart('Alice', 'Finance');
SELECT * FROM departments;
select * from employees;