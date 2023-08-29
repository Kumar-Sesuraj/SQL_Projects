select * from studies
select * from software
select * from programmer

-- 1. What is the Highest Number of copies sold by a Package?
select MAX(SOLD) as highest_sold 
from software

--2. Display lowest course Fee.
select MIN(COURSE_FEE) AS min_course_fee 
from studies

--3. How old is the Oldest Male Programmer.
select MAX(YEAR(getdate())-YEAR(DOB)) AS Oldest_Male_Pro 
from programmer 
where GENDER='M'

--4. What is the AVG age of Female Programmers?
select AVG(YEAR(getdate())-YEAR(DOB)) as AVG_age_Female_pro 
from programmer 
where GENDER='F'

--5. Calculate the Experience in Years for each Programmer and Display with their names in Descending order.
select PNAME, DATEDIFF(YEAR,DOJ,GETDATE()) as Exp_Year 
from programmer
order by PNAME

--6. How many programmers have done the PGDCA Course?
select COUNT(*) as Pro_done_PGDCA from studies where COURSE='PGDCA'

--7. How much revenue has been earned thru sales of Packages Developed in C.
select ((SCOST*21)-3100) as Revenue_Dev_C from software where DEVELOPIN='C'

--8. How many Programmers Studied at Sabhari?
select COUNT(*) as Pro_studied_at_Sabhari from studies where INSTITUTE='SABHARI'

--9. How many Packages Developed in DBASE?
select COUNT(*) as Pack_Dev_DBASE from software where DEVELOPIN like '%DBASE%'

--10. How many programmers studied in Pragathi?
select COUNT(*) as Pro_studied_Pragathi from studies where INSTITUTE='PRAGATHI'

--11. How many Programmers Paid 5000 to 10000 for their course?
select count(*) as Pro_paid_5000_10000 from studies where COURSE_FEE between 5000 and 10000

--12. How many Programmers know either COBOL or PASCAL?
select COUNT(*) as Pro_know_COBOL_or_PASCAL 
from programmer where PROF1='COBOL' or PROF2='PASCAL' or PROF1= 'PASCAL' or PROF2='COBOL'

--13. How many Female Programmers are there?
select COUNT(*) as Female_Pro from programmer where GENDER='F'

-- 14) What is the AVG Salary?
select AVG(SALARY) as Avg_Salary from programmer

-- 15) How many people draw salary 2000 to 4000?
select count(1) as Sal_2000_4000 from programmer where SALARY between 2000 and 4000

-- 16) Display the sales cost of the packages Developed by each Programmer Language wise
select PNAME,DEVELOPIN,SCOST from software
order by DEVELOPIN

-- 17) Display the details of the software developed by the male students of Sabhari.
select s.DEVELOPIN as Software_Dev_Male from software s
join programmer p
on s.PNAME=p.PNAME
where p.GENDER='M'

-- 18) Who is the oldest Female Programmer who joined in 1992?
	WITH oldestFe as
	(SELECT ROW_NUMBER() OVER(ORDER BY DOB) AS IDNO, * FROM programmer
	WHERE GENDER='F' AND YEAR(DOJ)=1992)
	select PNAME from oldestFe where IDNO=1

select PNAME as oldest_F_pro from programmer where DOB in (
select Min(DOB) from programmer where GENDER='F' and YEAR(DOJ)=1992)



-- 19) Who is the youngest male Programmer born in 1965?
	WITH youngMa as
	(SELECT ROW_NUMBER() OVER(ORDER BY DOB) AS IDNO1, * FROM programmer
	WHERE GENDER='M' AND YEAR(DOB)=1965)
	select PNAME as Youngest_Male_Pro from youngMa where IDNO1=1


-- 20) Which Package has the lowest selling cost?
select distinct(DEVELOPIN) as Lowest_Sel_Pkg from software where SCOST in (
select MIN(SCOST) from software)


-- 21) Which Female Programmer earning more than 3000 does not know C, C++, ORACLE or DBASE?
select PNAME as Female_pro from programmer 
where GENDER='F' and SALARY>3000 
and PROF1 not in ('C', 'C++', 'ORACLE', 'DBASE') 
and PROF2 not in ('C', 'C++', 'ORACLE', 'DBASE')

-- 22) Who is the Youngest Programmer knowing DBASE?
select PNAME as Youngest_Pro from programmer where DOB in (
select MAX(DOB) from programmer 
where PROF1 ='DBASE' or PROF2='DBASE')

-- 23) Which Language is known by only one Programmer?



-- 24) Who is the most experienced male programmer knowing PASCAL?
select PNAME as most_exp_male_pro from programmer where  DOJ in (
select MIN(DOJ) from programmer where GENDER='M' and PROF1 ='PASCAL' or PROF2='PASCAL')
order by DOJ
OFFSET 1 ROWS
FETCH NEXT 1 ROWS ONLY

-- 25) Who is the least experienced Programmer?

select PNAME as least_Exp_Pro from programmer where DOJ in (
select MAX(DOJ) from programmer)

-- 26) Display the Number of Packages in Each Language for which Development Cost is less than 1000.
select count(distinct(DEVELOPIN)) as Number_Packages from software where DCOST>1000

-- 27) Display Highest, Lowest and Average Salaries for those earning more than 2000.
select MAX(SALARY) as Highest_Sal, MIN(SALARY) as Lowest_Sal, AVG(SALARY) as Avg_Sal
from programmer where SALARY>2000


