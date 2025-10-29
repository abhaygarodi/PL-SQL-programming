DELIMITER $$
CREATE PROCEDURE highestsal(
OUT max_salary DECIMAL(10,2)
)
BEGIN
select max(salary) INTO 
max_salary from employees;
 End$$
DELIMITER ;

set @highest = 0;
call highestsal(@highest);
select @highest as highestsalary;


 