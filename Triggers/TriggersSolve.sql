
-- =========================================
-- BEFORE INSERT TRIGGERS
-- =========================================

-- Q1: Convert employee name to uppercase before insert
DELIMITER //
CREATE TRIGGER before_insert_uuu
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  SET NEW.emp_name = UPPER(NEW.emp_name);
END;
//
DELIMITER ;

-- Q2: Prevent salary less than 10000 before insert
DELIMITER //
CREATE TRIGGER before_insert_salary_check
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  IF NEW.salary < 10000 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Salary cannot be less than 10000';
  END IF;
END;
//
DELIMITER ;

-- =========================================
-- AFTER INSERT TRIGGERS
-- =========================================

-- Q3: Log new employee addition
DELIMITER //
CREATE TRIGGER after_insert_log
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (message)
  VALUES (CONCAT('New employee added: ', NEW.emp_name));
END;
//
DELIMITER ;

-- Q4: Display welcome message
DELIMITER //
CREATE TRIGGER after_insert_welcome
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
  SELECT CONCAT('Welcome ', NEW.emp_name, '!') AS message;
END;
//
DELIMITER ;

-- =========================================
-- BEFORE UPDATE TRIGGERS
-- =========================================

-- Q5: Prevent salary reduction
DELIMITER //
CREATE TRIGGER before_update_no_salary_cut
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
  IF NEW.salary < OLD.salary THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Salary reduction not allowed';
  END IF;
END;
//
DELIMITER ;

-- Q6: Round updated salary to nearest integer
DELIMITER //
CREATE TRIGGER before_update_round_salary
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
  SET NEW.salary = ROUND(NEW.salary);
END;
//
DELIMITER ;

-- =========================================
-- AFTER UPDATE TRIGGERS
-- =========================================

-- Q7: Log old and new salaries
DELIMITER //
CREATE TRIGGER after_update_log_salary
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (message)
  VALUES (CONCAT('Salary updated for ', OLD.emp_name,
                 ': Old = ', OLD.salary, ', New = ', NEW.salary));
END;
//
DELIMITER ;

-- Q8: Display message when salary increases
DELIMITER //
CREATE TRIGGER after_update_salary_increase
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  IF NEW.salary > OLD.salary THEN
    SELECT CONCAT('Salary increased for ', NEW.emp_name) AS message;
  END IF;
END;
//
DELIMITER ;

-- =========================================
-- BEFORE DELETE TRIGGERS
-- =========================================

-- Q9: Prevent deletion if employee name is CEO
DELIMITER //
CREATE TRIGGER before_delete_no_ceo
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
  IF OLD.emp_name = 'CEO' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot delete the CEO';
  END IF;
END;
//
DELIMITER ;

-- Q10: Log attempt to delete employee
DELIMITER //
CREATE TRIGGER before_delete_log_attempt
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (message)
  VALUES (CONCAT('Attempt to delete employee: ', OLD.emp_name));
END;
//
DELIMITER ;

-- =========================================
-- AFTER DELETE TRIGGERS
-- =========================================

-- Q11: Copy deleted record to deleted_employees
DELIMITER //
CREATE TRIGGER after_delete_copy
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
  INSERT INTO deleted_employees (emp_id, emp_name, salary)
  VALUES (OLD.emp_id, OLD.emp_name, OLD.salary);
END;
//
DELIMITER ;

-- Q12: Log deletion in audit_log
DELIMITER //
CREATE TRIGGER after_delete_log
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (message)
  VALUES (CONCAT('Employee deleted: ', OLD.emp_name));
END;
//
DELIMITER ;