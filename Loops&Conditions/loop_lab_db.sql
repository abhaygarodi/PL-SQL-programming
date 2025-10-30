CREATE DATABASE loop_lab_db;
USE loop_lab_db;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(30),
    salary DECIMAL(10,2)
);

INSERT INTO employees (name, department, salary) VALUES
('Anita', 'HR', 25000),
('Bhavesh', 'IT', 32000),
('Chitra', 'Finance', 28000),
('Deepak', 'IT', 40000),
('Esha', 'HR', 35000),
('Farhan', 'Finance', 30000);




-- 1. Increase salary of first 3 employees by 10%. 
drop procedure if exists increaseFirst3Salaries;
Delimiter $$
create procedure increaseFirst3Salaries()
BEGIN
	 declare i int default 1;
	inc_loop : loop
      update employees 
      set salary = salary * 1.10 
      where id = i;
      set i = i+1;
      if i > 3 then
      leave inc_loop;
       end if ;
      end loop;
end $$
delimiter ;
call IncreaseFirst3Salaries();
select * from employees;

-- 2. Display all employee names using LOOP.
drop procedure if exists displayallemp;
delimiter $$
create procedure displayallemp()
begin 
declare i int default 1 ;
declare total int;

 select count(*) into total from employees ;
  all_emp : loop
  select name from employees where id = i;
  set i = i+1;
 if i > total then
 leave all_emp;
 end if;
 end loop;
end $$
delimiter ;
 call displayallemp();
 
 -- 3.Calculate total salary of all employees using LOOP.
 drop procedure if exists TotalSalaryLoop;
DELIMITER $$
CREATE PROCEDURE TotalSalaryLoop()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE total INT;
    DECLARE sal_sum DECIMAL(10,2) DEFAULT 0;
    SELECT COUNT(*) INTO total FROM employees;
    salary_loop: LOOP
        IF i > total THEN 
            LEAVE salary_loop;
        END IF;
        SET sal_sum = sal_sum + (SELECT salary FROM employees WHERE id = i);
        SET i = i + 1;
    END LOOP;
    SELECT sal_sum AS 'Total Salary';
END$$
DELIMITER ;
CALL TotalSalaryLoop();

-- 4. Insert 3 new temporary employees into the table using LOOP. 
drop procedure if exists tempemployee;
delimiter $$
create procedure tempemployee()
Begin
declare i int default 1;
temp_loop : loop
 if i >3 then
 leave temp_loop;
 end if;
    INSERT INTO employees (name, department, salary)
        VALUES (CONCAT('TempEmp', i), 'Temp', 20000 + (i*1000));
        SET i = i + 1;
 end loop;
end $$
delimiter ;
call tempemployee();
 select * from employees;
 
 -- 5. Display employees having salary greater than ₹30,000.
 drop procedure if exists salgreaterof;
 delimiter $$
 create procedure salgreaterof()
 begin
  declare i int default 1;
 declare total int;
 select count(*)into total from employees ;
 
 while i <= total DO 
  IF (SELECT salary FROM employees WHERE id = i) > 30000 THEN
            SELECT name, salary FROM employees WHERE id = i;
        END IF;
        SET i = i + 1;
  end while;
 end $$
 delimiter ;
 call salgreaterof() ;
 
  -- 6. Increase one employee’s salary incrementally by 5000 
  -- until it reaches ₹50,000
   DELIMITER $$
CREATE PROCEDURE IncrementSalary()
BEGIN
    DECLARE sal DECIMAL(10,2);
    SELECT salary INTO sal FROM employees WHERE id = 1;
    WHILE sal < 50000 DO
        SET sal = sal + 5000;
        UPDATE employees SET salary = sal WHERE id = 1;
    END WHILE;
    SELECT name, salary FROM employees WHERE id = 1;
END$$
DELIMITER ;
CALL IncrementSalary();

-- 7. Count total IT department employees. 
 drop procedure if exists CountITDeptEmployees;
 DELIMITER $$

CREATE PROCEDURE CountITDeptEmployees()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE total INT DEFAULT 0;
    DECLARE emp_count INT;
    DECLARE total_rows INT;
    DECLARE dept_name VARCHAR(50);

    -- Get total employees in the table
    SELECT COUNT(*) INTO total_rows FROM employees;

    WHILE i <= total_rows DO
        SELECT department INTO dept_name 
        FROM employees 
        WHERE id = i;

        IF dept_name = 'IT' THEN
            SET total = total + 1;
        END IF;

        SET i = i + 1;
    END WHILE;

    SELECT total AS Total_IT_Employees;
END$$

DELIMITER ;
CALL CountIDDeptEmployees()

-- Add ₹5,000 to one employee’s salary until 
-- it exceeds ₹40,000

drop procedure if exists IncreaseSalary_Repeat;
DELIMITER $$
CREATE PROCEDURE IncreaseSalary_Repeat()
BEGIN
    DECLARE current_salary DECIMAL(10,2);
    DECLARE emp_id INT;
    -- Get Bhavesh’s id and salary
    SELECT id, salary INTO emp_id, current_salary
    FROM employees 
    WHERE name = 'Bhavesh';
    REPEAT
        SET current_salary = current_salary + 5000;

        UPDATE employees 
        SET salary = current_salary 
        WHERE id = emp_id;   -- ✅ uses key column (safe)

    UNTIL current_salary > 40000
    END REPEAT;

    SELECT CONCAT('Final Salary of Bhavesh: ₹', current_salary) AS Result;
END$$

DELIMITER ;
CALL IncreaseSalary_Repeat();


-- 















 









