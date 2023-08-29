select * from software
select * from programmer
select * from studies

-- 1. How many programmers don’t know Pascal and C?
select COUNT (PNAME) as No_of_Prog from programmer where PROF1 not in ('PASCAL','C') AND PROF2 NOT IN ('PASCAL','C')

-- 2. Display the details of those who don’t know Clipper, COBOL or Pascal.
select * from programmer 
where PROF1 not in ('Clipper','COBOL','Pascal') AND PROF2 NOT IN ('PASCAL','Clipper','COBOL')

-- 3. Display each language name with average development cost, average selling cost and average price per copy.
select DEVELOPIN, AVG(SCOST) as AVG_Sell_Cost, AVG(DCOST) as AVG_Dev_Cost, SCOST as AVG_Price from software
group by DEVELOPIN,SCOST
order by DEVELOPIN

-- 4. List the programmer names (from the programmer table) and the number of packages each have developed.
select p.PNAME, count(*) as No_Packages_Dev from software s
inner join programmer p
on s.PNAME=p.PNAME
group by p.PNAME
order by p.PNAME


-- 5. List each profit with the number of programmers having that PROF and the number of the packages in that PROF.
select p.PNAME,s.DEVELOPIN,(s.SCOST*s.SOLD) as Profit from software s
inner join programmer p on s.PNAME=p.PNAME
where (s.SCOST*s.SOLD)>s.DCOST and s.DEVELOPIN=p.PROF1 or s.DEVELOPIN=p.PROF2

-- 6. How many packages were developed by the most experienced programmer from BDPS?
 select s.PNAME, COUNT(s.DEVELOPIN) as No_Packages_Dev from software s
 inner join programmer p
 on s.PNAME=p.PNAME
 where p.DOJ in (select min(DOJ) from programmer)
 group by s.DEVELOPIN, s.PNAME


-- 7. How many packages were develped by female programmers earning more than the highest paid male programmer?
select s.PNAME ,COUNT(s.DEVELOPIN) as Pack_Dev_Female from software s
inner join programmer p
on s.PNAME=p.PNAME
where p.GENDER='F' -- and s.DEVELOPIN=p.PROF1 or s.DEVELOPIN=p.PROF2
group by p.SALARY, s.PNAME
having p.SALARY> (select MAX(SALARY) from programmer where GENDER='M')

-- 8. How much does the person who developed the highest selling package earn and what course did he/she undergo?
select st.PNAME,st.COURSE,p.SALARY from studies st
inner join programmer p
on st.PNAME=p.PNAME
inner join software s
on s.PNAME=p.PNAME
group by s.SOLD,st.PNAME,p.SALARY,st.COURSE
having s.SOLD in (select MAX(SOLD) from software)

-- 9. In which institute did the person who developed the costliest package study?

select st.PNAME,st.COURSE, s.DEVELOPIN, s.SCOST from software s
inner join studies st
on st.PNAME=s.PNAME
group by st.PNAME,st.COURSE, s.SCOST, s.DEVELOPIN
having s.SCOST in (select max(SCOST) from software)


-- 10. Display the names of the programmers who have not developed any packages.
select p.PNAME from programmer p
left join software s
on p.PNAME=s.PNAME
where p.PNAME not in (select distinct(PNAME) from software)

-- 11. Display the details of the software that has been developed in the language which is neither their first nor second proficiency.
select s.TITLE as Software, s.DEVELOPIN as Lang from software s
 left join programmer p
on s.PNAME=p.PNAME
where s.DEVELOPIN not in (select PROF1 from programmer) and s.DEVELOPIN not in (select PROF2 from programmer)

-- 12. Display the details of the software developed by the male programmers born before 1965 and female programmers born after 1975.
select s.TITLE as Software, s.PNAME as Programmer, p.DOB, p.GENDER from software s
left join programmer p
on s.PNAME=p.PNAME
where (p.GENDER='F' and year(p.DOB)>1975) or (p.GENDER='M' and year (p.DOB)<1965)
order by p.GENDER, p.PNAME

select * from software
select * from programmer


-- 13. Display the number of packages, number of copies sold and the sales value of each programmer institute wise.
select PNAME, (SCOST*SOLD) as Sales_Value,  sum(SOLD) as No_Copies_Sold, count(TITLE) as No_Packages  from software
group by PNAME, (SCOST*SOLD)
order by Sales_Value desc

-- 14. Display the details of the software developed by the male programmers earning more than 3000.
select p.PNAME, s.TITLE as Software from software s
join programmer p
on s.PNAME=p.PNAME
where p.GENDER='F' and p.SALARY>3000

-- 15. Who are the female programmers earning more than the highest paid male programmers?
select PNAME,SALARY from programmer  
where GENDER='F' and SALARY > (select MAX(SALARY) from programmer where GENDER='M')

-- 16. Who are the male programmers earning below the average salary of female programmers?
select PNAME, SALARY from programmer 
where GENDER='M' and SALARY< ( 
select AVG(SALARY) from programmer where GENDER='F')

-- 17. Display the language used by each programmer to develop the highest selling and lowest selling package.

select DEVELOPIN , MIN(SOLD) as Min_Sale, max(SOLD) from software
group by DEVELOPIN, SOLD
having SOLD=(select MIN(SOLD) from software) and SOLD=(select max(SOLD) from software)
order by Min_Sale

select DEVELOPIN , max(SOLD) as Max_Sale from software
group by DEVELOPIN, SOLD
having SOLD=(select max(SOLD) from software)
order by Max_Sale

select * from software

-- 18. Display the names of the packages which have sold less than the average number of copies.
select TITLE, SOLD from software
where SOLD<(select AVG(SOLD) from software)
order by TITLE

-- 19. Which is the costliest package developed in Pascal?
select TITLE as Package, DEVELOPIN as Dev_Lang, DCOST from software
where DCOST=(select MAX(DCOST) from software where DEVELOPIN like '%PASCAL%')

-- 20. How many copies of the package that has the least difference between development and selling cost were sold?
select top 1 TITLE, SCOST, DCOST,ABS(SCOST-DCOST) as Least_diff, SOLD from software
order by Least_diff

-- 21. Which language has been used to develop the package which has the highest sales amount?
select TITLE, MAX(SOLD) as Highest_Sale from software
where SOLD=(select MAX(SOLD) from software)
group by TITLE,SOLD 


-- 22. Who developed the package that has sold the least number of copies?
select TITLE, MIN(SOLD) as Highest_Sale from software
where SOLD=(select MIN(SOLD) from software)
group by TITLE,SOLD 

-- 23. Display the names of the courses whose fees are within 1000 (+ or -) of the average fees 
select  COURSE from studies 
where COURSE_FEE between (select AVG(COURSE_FEE)-1000 from studies)
and (select AVG(COURSE_FEE)+ 1000 from studies)

-- 24. Display the name of the institute and course which has below average course fee.
select INSTITUTE ,COURSE, COURSE_FEE from studies
where COURSE_FEE< (select AVG(COURSE_FEE) from studies)

select * from studies

-- 25. Which Institute conducts the costliest course?
select COURSE,INSTITUTE,COURSE_FEE  from studies
where COURSE_FEE=(select MAX(COURSE_FEE) from studies)

-- 26. What is the costliest course?

select COURSE,INSTITUTE,COURSE_FEE  from studies
where COURSE_FEE=(select MAX(COURSE_FEE) from studies)