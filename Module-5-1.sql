/*Problem Statement:
You have successfully cleared your 4th semester. In the 5th semester you will work with group by, having by clauses and set operators
Tasks to be done:*/

-- 1. Arrange the ‘Orders’ dataset in decreasing order of amount
select * from Order_details
order by Amount desc

-- 2. Create a table with name ‘Employee_details1’ and comprising of these columns – ‘Emp_id’, ‘Emp_name’, ‘Emp_salary’. 
--    Create another table with name ‘Employee_details2’, which comprises of same columns as first table.

select EMPNO, ENAME,SAL into
Employee_details1
from EMP

select * from Employee_details1

select * into Employee_details2
from Employee_details1

select * from Employee_details2


-- 3. Apply the union operator on these two tables

select * from Employee_details1
union
select * from Employee_details2

select * from Employee_details1
union all
select * from Employee_details2

-- 4. Apply the intersect operator on these two tables
select * from Employee_details1
intersect
select * from Employee_details2

-- 5. Apply the except operator on these two tables

select * from Employee_details1
except
select * from Employee_details2

