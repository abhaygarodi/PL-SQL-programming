DELIMITER $$
CREATE PROCEDURE ShowDepartmentsInLocation(IN loc VARCHAR(30))
BEGIN
  SELECT * FROM departments WHERE location = loc;
END$$
DELIMITER ;
CALL ShowDepartmentsInLocation('Bangalore');
