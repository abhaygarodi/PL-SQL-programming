 DELIMITER $$

CREATE PROCEDURE DeleteEmpByNam(
    IN emp_name VARCHAR(50)
)
BEGIN
    DELETE FROM employees
    WHERE name = 'smith';
END$$

DELIMITER ;

set sql_safe_updates = 0;
CALL DeleteEmpByNam('SMITH');
set sql_safe_updates = 1;
select * from employees;
 
