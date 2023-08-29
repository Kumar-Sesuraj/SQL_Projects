-- 1. What is the cost of the costliest software development in Basic?
create or alter function Costliest_Software()
returns table
as
	return (select TITLE, MAX(DCOST) as Dev_cost from software where DEVELOPIN like '%basic%' group by TITLE)

select * from Costliest_Software()


-- 2. Display details of packages whose sales crossed the 2000 mark.

create or alter function Package_Crossed_2000()
returns table
as
	return (select TITLE, (SOLD*SCOST) as Selling_Cost from software where (SOLD*SCOST)>2000)

select * from Package_Crossed_2000()

-- 3. Who are the programmers who celebrate their birthdays during the current month?
create or alter function Current_Month_Birthday()
returns table
as
	return (select PNAME from programmer where MONTH(GETDATE())=MONTH(DOB))

select * from Current_Month_Birthday()

-- 4. Display the cost of the package developed by each programmer.
create or alter function Package_Dev_each_Pro()
returns table
as
	return (
		select p.PNAME,s.DCOST from programmer p
		join software s
		on p.PNAME=s.PNAME)

select * from Package_Dev_each_Pro()

-- 5. Display the sales values of the packages developed by each programmer.
create or alter function Package_Value()
returns table
as
	return (
		select PNAME,(SOLD*SCOST) as Sales_Value from software
		group by PNAME, (SOLD*SCOST))

select * from Package_Value()

-- 6. Display the number of packages sold by each programmer.
create or alter function Number_of_Packages_Sold()
returns table
as
	return (select PNAME, sum (SOLD) as Number_of_Packages_Sold from software
	group by PNAME)

select * from Number_of_Packages_Sold()

-- 7. Display each programmer’s name, costliest and cheapest packages developed by him or her.
create or alter function Costliest_and_Cheapes_Pck()
returns table
as
	return(
		SELECT
			p.PNAME AS ProgrammerName,
			MAX(s.DCOST) AS CostliestPackage,
			MIN(s.DCOST) AS CheapestPackage
		FROM
			Programmer p
			LEFT JOIN Software s ON p.PNAME = s.PNAME
		GROUP BY
			p.PNAME)

select * from Costliest_and_Cheapes_Pck()

-- 8. Display each institute’s name with the number of courses and average cost per course.
create or alter function Courses_AvgCourseFee()
returns table
as
	return(
		select INSTITUTE, count(COURSE) as NumberOfCourses, AVG(COURSE_FEE) as AvgCourseFee from studies
		group by INSTITUTE)

select * from Courses_AvgCourseFee()


-- 9. Display each institute’s name with the number of students.
create or alter function NumberOfStudents()
returns table
as
	return(select INSTITUTE, COUNT(*) as NumberOfStudents from studies
			group by INSTITUTE)

select * from NumberOfStudents()

-- 10. List the programmers (from the software table) and the institutes they studied at.
create or alter function StuInstituteName()
returns table
as
	return(select distinct so.PNAME, st.INSTITUTE from software so
			inner join studies st
			on so.PNAME=st.PNAME)

select * from StuInstituteName()

-- 11. How many packages were developed by students who studied in institutes that charge the lowest course fee?
create or alter function Dev_low_course_fee_stu()
returns table
as
	return(
			select st.PNAME, COUNT(so.TITLE) as Dev_low_course_fee_stu from studies st
			inner join software so
			on st.PNAME=so.PNAME
			where st.COURSE_FEE=(select MIN(st.COURSE_FEE) from studies st)
			group by st.PNAME)

select * from Dev_low_course_fee_stu()


-- 12. What is the average salary for those whose software sales are more than 50,000?
create or alter function AVG_Salary1()
returns table
as
	return (select avg(SALARY) as AVG_Salary from programmer where PNAME in (
	select PNAME from software where (SCOST*SOLD)>50000))

select * from AVG_Salary1()

-- 13. Which language listed in PROF1, PROF2 has not been used to develop any package?

create or alter function Not_used_lang()
returns table
as
	return(
			select PROF1 from programmer where PROF1 not in (select distinct DEVELOPIN from software)
			union
			select PROF2 from programmer where PROF2 not in (select distinct DEVELOPIN from software)
			)
select * from Not_used_lang()

-- 14. Display the total sales value of the software institute wise.
create or alter function Sales_Value_Ins_Wise()
returns table
as
	return(select st.INSTITUTE, sum(so.SCOST*so.SOLD) as Sales_Value from studies st
			inner join software so
			on so.PNAME=st.PNAME
			group by st.INSTITUTE)

select * from Sales_Value_Ins_Wise()


-- 15. Display the details of the software developed in C by female programmers of Pragathi.
create or alter function Software_dev()
returns table
as
	return(select so.TITLE as Software_dev from software so
			join studies st
			on st.PNAME=so.PNAME
			join programmer p
			on p.PNAME=st.PNAME
			where so.DEVELOPIN='C' and st.INSTITUTE='Pragathi' and p.GENDER='M')

select * from Software_dev()

-- 16. Display the details of the packages developed in Pascal by female programmers.
create or alter function Pascal_F_Pro()
returns table
as
	return(select p.PNAME,s.TITLE from software s
			join programmer p
			on s.PNAME=p.PNAME
			where s.DEVELOPIN like '%PASCAL%' and p.GENDER='F')

select * from Pascal_F_Pro()

-- 17. Which language has most of the programmers stated as being proficient in?

select * into Lang from (
select PROF1 as Lang from programmer
union all
select PROF2 from programmer) as t1

select * from Lang

create or alter function Most_Proficient_Lang()
returns table
as
	return (select top 1 Lang, count(Lang) as count1 from Lang
		group by Lang
		having count(Lang)>1
		order by count1 desc)

select * from Most_Proficient_Lang()


-- 18. Who is the author of the costliest package?
select * from software
			where DCOST=(select MAX(SCOST) from software))
create or alter function Author_Costliest_Pkg()
returns table
as
	return (
select * from Author_Costliest_Pkg()

-- 19. Which package has the highest development cost?
create or alter function Highest_Dev_cost()
returns table
as
	return (select TITLE from software
			where DCOST=(select MAX(DCOST) from software))

select * from Highest_Dev_cost()

-- 20. Who is the highest paid female COBOL programmer?
create or alter function HighestPaidFemaleProg()
returns table
as
	return (select PNAME from programmer
			where SALARY=(select MAX(SALARY) from programmer where GENDER='F'
			and PROF1='COBOL' or PROF2='COBOL'))

select * from HighestPaidFemaleProg()

-- 21. Display the names and packages of the programmers.
create or alter function ProNameandPackages()
returns table
as
	return (select PNAME, TITLE from software)

select * from ProNameandPackages()

-- 22. Display the number of packages in each language except C and C++.
create or alter function Package_each_Lang()
returns table
as
	return (select DEVELOPIN, COUNT(TITLE) as Package from software
			where DEVELOPIN !='C' and DEVELOPIN !='C++'
			group by DEVELOPIN)

select * from Package_each_Lang()

-- 23. Display the average difference between SCOST and DCOST for each package.
create or alter function AVG_Difference()
returns table
as
	return (
	select TITLE, avg(DCOST-SCOST) as AVG_Difference from software
	group by TITLE)


select * from AVG_Difference()

-- 24. Display the total SCOST and DCOST and the amount to be recovered for each programmer for those whose cost has not yet been recovered.
create or alter function To_be_Recovered()
returns table
as
	return (select PNAME, DCOST, (SCOST*SOLD) as SellingCost, ( DCOST - (SCOST*SOLD)) as To_be_Recovered  
			from software
			group by PNAME, SCOST, SOLD, DCOST
			having (SCOST*SOLD)<DCOST)

select * from To_be_Recovered()

-- 25. Who is the highest paid C programmer?
create or alter function HighestPaid_C_pro()
returns table
as
	return (
			select PNAME from programmer
			where SALARY=(select MAX(SALARY) from programmer where PROF1='C' or PROF2='C' ))

select * from HighestPaid_C_pro()

-- 26. Who is the highest paid female COBOL programmer?

create or alter function HighestPaidFemaleProg()
returns table
as
	return (select PNAME, SALARY from programmer
			where SALARY=(select MAX(SALARY) from programmer where GENDER='F'
			and PROF1='COBOL' or PROF2='COBOL'))

select * from HighestPaidFemaleProg()