
CREATE DATABASE handler_lab;
USE handler_lab;

CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE
);

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(100) UNIQUE,
    salary DECIMAL(10,2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 1. Add Department with EXIT Handler for duplicates
DELIMITER //
CREATE PROCEDURE add_department(IN dname VARCHAR(50))
BEGIN
   DECLARE EXIT HANDLER FOR 1062
   BEGIN
       SELECT 'Department already exists' AS message;
   END;
  
   INSERT INTO departments(dept_name) VALUES (dname);
   SELECT 'Department added successfully' AS message;
END//
DELIMITER ;

-- Example
CALL add_department('HR');
 

-- 2. Add Employee with EXIT Handler for duplicates
DELIMITER //
CREATE PROCEDURE add_employee(IN name VARCHAR(100), IN sal DECIMAL(10,2), IN did INT)
BEGIN
   DECLARE EXIT HANDLER FOR 1062
   BEGIN
       SELECT 'Employee already exists' AS message;
   END;

   INSERT INTO employees(emp_name, salary, dept_id)
   VALUES (name, sal, did);
   SELECT 'Employee added successfully' AS message;
END//
DELIMITER ;

CALL add_employee('Alice', 50000, 1);
CALL add_employee('Alice', 60000, 1);

-- 3. CONTINUE Handler - Bulk insert 5 employees skipping duplicates
DELIMITER //
CREATE PROCEDURE bulk_insert_employees()
BEGIN
   DECLARE i INT DEFAULT 1;
   DECLARE CONTINUE HANDLER FOR 1062
   BEGIN
       SELECT CONCAT('Duplicate found at record ', i) AS warning;
   END;

   WHILE i <= 5 DO
       INSERT INTO employees(emp_name, salary, dept_id)
       VALUES (CONCAT('Emp', i), 3000*i, 1);
       SET i = i + 1;
   END WHILE;
   SELECT 'Bulk insert complete' AS message;
END//
DELIMITER ;

CALL bulk_insert_employees();
	
-- 4. SIGNAL + EXIT Handler - Low salary check
DELIMITER //
CREATE PROCEDURE check_salary(IN sal DECIMAL(10,2))
BEGIN
   DECLARE low_salary CONDITION FOR SQLSTATE '45000';
   DECLARE EXIT HANDLER FOR low_salary
   BEGIN
       SELECT 'Salary too low' AS message;
   END;

   IF sal < 1000 THEN
       SIGNAL low_salary;
   ELSE
       SELECT 'Salary acceptable' AS message;
   END IF;
END//
DELIMITER ;

CALL check_salary(800);
CALL check_salary(5000);

-- 5. FUNCTION - Annual salary
DELIMITER //
CREATE FUNCTION annual_salary(monthly DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
   RETURN monthly * 12;
END//
DELIMITER ;

SELECT emp_name, salary, annual_salary(salary) AS yearly FROM employees;

-- 6. CONTINUE Handler - Count employees ignoring null departments
DELIMITER //
CREATE PROCEDURE count_employees()
BEGIN
   DECLARE done INT DEFAULT 0;
   DECLARE total INT DEFAULT 0;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  
   SELECT COUNT(*) INTO total FROM employees WHERE dept_id IS NOT NULL;
   SELECT CONCAT('Total employees (with dept): ', total) AS message;
END//
DELIMITER ;

CALL count_employees();
-- 7. EXIT Handler - Delete employee if exists, otherwise show message
DELIMITER //
CREATE PROCEDURE delete_employee(IN eid INT)
BEGIN
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   BEGIN
       SELECT 'Error deleting employee' AS message;
   END;

   IF (SELECT COUNT(*) FROM employees WHERE emp_id = eid) = 0 THEN
       SELECT 'No such employee' AS message;
   ELSE
       DELETE FROM employees WHERE emp_id = eid;
       SELECT 'Employee deleted' AS message;
   END IF;
END//
DELIMITER ;

CALL delete_employee(10);

-- 8. SIGNAL - Add employee only if department exists
DELIMITER //
CREATE PROCEDURE safe_add_employee(IN name VARCHAR(100), IN sal DECIMAL(10,2), IN did INT)
BEGIN
   DECLARE invalid_dept CONDITION FOR SQLSTATE '45000';
   DECLARE EXIT HANDLER FOR invalid_dept
   BEGIN
       SELECT 'Invalid Department ID' AS message;
   END;

   IF (SELECT COUNT(*) FROM departments WHERE dept_id = did) = 0 THEN
       SIGNAL invalid_dept;
   ELSE
       INSERT INTO employees(emp_name, salary, dept_id)
       VALUES (name, sal, did);
       SELECT 'Employee added safely' AS message;
   END IF;
END//
DELIMITER ;

CALL safe_add_employee('Bob', 7000, 1);
CALL safe_add_employee('Charlie', 6000, 99);

-- 9. CONTINUE Handler - Increase salary by 10%, skip NULLs
DELIMITER //
CREATE PROCEDURE increase_salary()
BEGIN
   DECLARE done INT DEFAULT 0;
   DECLARE eid INT;
   DECLARE sal DECIMAL(10,2);
   DECLARE cur CURSOR FOR SELECT emp_id, salary FROM employees;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

   OPEN cur;
   loop1: LOOP
       FETCH cur INTO eid, sal;
       IF done THEN
           LEAVE loop1;
       END IF;

       IF sal IS NULL THEN
           ITERATE loop1;
       END IF;

       UPDATE employees SET salary = salary * 1.10 WHERE emp_id = eid;
   END LOOP;
   CLOSE cur;

   SELECT 'Salaries increased by 10 percent' AS message;
END//
DELIMITER ;

CALL increase_salary();

-- 10. CURSOR with CONTINUE Handler - List employees in department
DELIMITER //
CREATE PROCEDURE list_department_employees(IN did INT)
BEGIN
   DECLARE done INT DEFAULT 0;
   DECLARE ename VARCHAR(100);
   DECLARE cur CURSOR FOR SELECT emp_name FROM employees WHERE dept_id = did;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

   OPEN cur;
   loop2: LOOP
       FETCH cur INTO ename;
       IF done THEN
           LEAVE loop2;
       END IF;
       SELECT ename AS employee_name;
   END LOOP;
   CLOSE cur;
END//
DELIMITER ;

CALL list_department_employees(1);





