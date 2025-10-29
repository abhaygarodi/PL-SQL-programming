DELIMITER $$

CREATE PROCEDURE ResetAl()
BEGIN
    UPDATE emp2
    SET empsalary = 50000;
END$$

DELIMITER ;

CALL ResetAl();
select * from emp2;

SET SQL_SAFE_UPDATES = 0;
CALL ResetAl();
SET SQL_SAFE_UPDATES = 1;
