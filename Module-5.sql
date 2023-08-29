-- 1. Display the names of the highest paid programmers for each language.
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


-- 2. Display the details of those who are drawing the same salary.
select p1.PNAME,p1.SALARY from programmer p1
join programmer p2
on p1.SALARY=p2.SALARY
where p1.PNAME!=p2.PNAME
order by p1.SALARY

-- 3. Who are the programmers who joined on the same day?
select p1.PNAME,p1.DOJ, day(p1.DOJ) as JoiningDay from programmer p1
join programmer p2
on p1.DOJ=p2.DOJ
where p1.PNAME!=p2.PNAME
order by JoiningDay

select distinct(p1.PNAME),p1.DOJ, day(p1.DOJ) as JoiningDay from programmer p1
join programmer p2
on day(p1.DOJ)=day(p2.DOJ)
where p1.PNAME!=p2.PNAME
order by JoiningDay


-- 4. Who are the programmers who have the same Prof2?
select distinct(p1.PNAME),p2.PROF2 from programmer p1
join programmer p2
on p1.PROF2=p2.PROF2
where p1.PNAME<>p2.PNAME

select * from programmer


-- 5. How many packages were developed by the person who developed the cheapest package? Where did he/she study?
select st.PNAME,st.INSTITUTE, count(so.TITLE) as NoOfPkagDev  from software so
join studies st
on so.PNAME=st.PNAME
where so.DCOST=(select min(DCOST) from software)
group by so.TITLE, st.PNAME, st.INSTITUTE 
