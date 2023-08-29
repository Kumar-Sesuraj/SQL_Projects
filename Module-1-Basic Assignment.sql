select * from studies;
select * from software;
select * from programmer;

-- 1. Find out the average selling cost for packages developed in Pascal
select AVG(SCOST) as AVG_Selling_Cost from software WHERE DEVELOPIN LIKE '%PASCAL'

-- 2. Display the names and ages of all programmers.
select PNAME, YEAR(getdate())-YEAR(DOB) as AGE from programmer;

-- 3. Display the names of those who have done the DAP Course.
select PNAME from studies where COURSE='DAP'

-- 4. Display the names and date of birth of all programmers born in January.
select PNAME from programmer where MONTH(DOB)=01;

-- 5. Display the details of the software developed by Ramesh
select DEVELOPIN from software where PNAME='RAMESH';

-- 6. Display the details of packages for which development costs have been recovered
select *, (SCOST*SOLD) AS SOLD_AMOUNT from software WHERE DCOST<(SCOST*SOLD)

-- 7. Display the details of the programmers knowing C.
select * from programmer WHERE PROF1='C' OR PROF2='C'

-- 8. What are the languages studied by male programmers
select PROF1 AS LANG from programmer WHERE GENDER='M' 
UNION 
SELECT PROF2 FROM programmer WHERE GENDER='M'

-- 9. Display the details of the programmers who joined before 1990
select * from programmer WHERE YEAR(DOJ)<1990

-- 10. Who are the authors of the packages which have recovered more than double the development cost?
select * from software;
select PNAME, DCOST, (SOLD*SCOST) AS SOLD_AMOUNT from software WHERE (SOLD*SCOST)>=2*DCOST;