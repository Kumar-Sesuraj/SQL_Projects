-- 1. Display the details of the software developed in dBase by male programmers who belong to the institute with the 
-- most number of programmers.

select p.PNAME, so.TITLE, st.INSTITUTE  from software so
join programmer p
on so.PNAME=p.PNAME
join studies st
on p.PNAME=st.PNAME
where so.DEVELOPIN like '%dbase%' and p.GENDER='M'
group by st.INSTITUTE, so.TITLE, p.PNAME
having COUNT(st.INSTITUTE)>0


-- 2. In which language are most of the programmer’s proficient?

with ds as (
  SELECT PROF1 AS Language, PNAME
  FROM programmer
  UNION ALL
  SELECT PROF2 AS Language, PNAME
  FROM programmer
) 
select top 5 Language, COUNT(Language) as countLang from ds
group by Language
order by countLang desc



-- 3. In which month did the most number of programmers join?

select top 1 MONTH(DOJ) as JoiningMonth, count(*) as MostNumberofJoiners from programmer 
group by MONTH(DOJ)
order by MostNumberofJoiners desc

with MostNumberofJoiners as (
select  MONTH(DOJ) as JoiningMonth, count(*) as MostNumberofJoiners,
rank() over (order by count(*) desc) as ranking
from programmer 
group by MONTH(DOJ))
select JoiningMonth, MostNumberofJoiners from MostNumberofJoiners where ranking=1


-- 4. In which year the most number of programmers were born?
with MostBornMonth as (
select  MONTH(DOB) as BornMonth, count(*) as MostBorn,
rank() over (order by count(*) desc) as ranking
from programmer 
group by MONTH(DOB))
select BornMonth, MostBorn from MostBornMonth where ranking=1


-- 5. Which programmer has developed the highest number of packages?
with HighestNumberPack as (
select PNAME, COUNT(*) as NumberofPack,
rank() over(order by count(*) desc) as ranking
from software
GROUP by PNAME)
select PNAME, NumberofPack from HighestNumberPack where ranking=1


-- 6. Which language was used to develop the most number of packages?
with MostNumberofLang as (
select DEVELOPIN as Lang, COUNT(*) as NumberofLang,
rank() over(order by count(*) desc) as ranking
from software
GROUP by DEVELOPIN)
select Lang, NumberofLang from MostNumberofLang where ranking=1

-- 7. Which course has below average number of students?
with AvgNumberofStudents as (
select COURSE, COUNT(*) as NumberofStudents,
rank() over(order by count(*)) as ranking
from studies
group by COURSE)
select COURSE, NumberofStudents from AvgNumberofStudents where ranking=1

-- 8. Which course has been done by the most of the students?
with MostStudent as (
select COURSE, COUNT(*) as NumberofStudents,
rank() over(order by count(*) desc) as ranking
from studies
group by COURSE)
select COURSE, NumberofStudents from MostStudent where ranking=1

-- 9. Which institute has the most number of students?
with MostStudent as (
select INSTITUTE, COUNT(*) as NumberofStudents,
rank() over(order by count(*) desc) as ranking
from studies
group by INSTITUTE)
select INSTITUTE, NumberofStudents from MostStudent where ranking=1

-- 10. Who is the above programmer referred to in 50 ?
select PNAME, (YEAR(GETDATE())-YEAR(DOB)) as Age from programmer
where (YEAR(GETDATE())-YEAR(DOB))>50

-- 11. Display the names of the highest paid programmers for each language.

with ds as (
SELECT Language, MAX(SALARY) AS MaxSalary
FROM (
  SELECT PROF1 AS Language, SALARY, PNAME
  FROM programmer
  UNION ALL
  SELECT PROF2 AS Language, SALARY, PNAME
  FROM programmer
) AS CombinedTable
GROUP BY CombinedTable.Language)
select Language, MaxSalary, p.PNAME from ds
join programmer p on ds.MaxSalary=p.SALARY
order by ds.Language

-- 12. Display the names of the highest paid programmers for each language.

with ds as (
SELECT Language, MAX(SALARY) AS MaxSalary
FROM (
  SELECT PROF1 AS Language, SALARY, PNAME
  FROM programmer
  UNION ALL
  SELECT PROF2 AS Language, SALARY, PNAME
  FROM programmer
) AS CombinedTable
GROUP BY CombinedTable.Language)
select Language, MaxSalary, p.PNAME from ds
join programmer p on ds.MaxSalary=p.SALARY
order by ds.Language