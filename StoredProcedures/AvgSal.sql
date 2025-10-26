DELIMITER $$
CREATE PROCEDURE avgsale(
out avg_salary Decimal(10,2)
)
BEGIN
SELECT AVG(salary) Into AVG_salary
from employees;
END$$

DELIMITER ; 

 
set @avg = 0;
call avgsale(@avg);
select @avg as avgsale;