DELIMITER $$
CREATE PROCEDURE DeleteDepartmentByName(IN deptname VARCHAR(30))
BEGIN
  DELETE FROM departments WHERE dept_name = deptname;
END$$
DELIMITER ;
CALL DeleteDepartmentByName('Marketing');
