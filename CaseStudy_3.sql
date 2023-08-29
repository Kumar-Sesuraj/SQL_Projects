select * from Continent
select * from Transactions
select * from Customers

-- 1. Display the count of customers in each region who have done the transaction in the year 2020.

select ct.region_id as Region_ID, COUNT(distinct(cu.customer_id)) as NumberofCust from Continent ct
inner join Customers cu
on ct.region_id=cu.region_id
inner join Transactions tr
on tr.customer_id=cu.customer_id
where YEAR(tr.txn_date)='2020'
group by ct.region_id
order by ct.region_id

-- 2. Display the maximum and minimum transaction amount of each transaction type.
select txn_type, MAX(txn_amount) as Max_Amount, MIN(txn_amount) as Min_Amount from Transactions
group by txn_type
order by txn_type

-- 3. Display the customer id, region name and transaction amount where transaction type is deposit and transaction amount > 2000.
select cu.customer_id, ct.region_name, tr.txn_type, tr.txn_date, tr.txn_amount from Continent ct
inner join Customers cu
on ct.region_id=cu.region_id
inner join Transactions tr
on tr.customer_id=cu.customer_id
where tr.txn_type='deposit' and tr.txn_amount>500
order by cu.customer_id

-- 4. Find duplicate records in the Customer table.
select customer_id, COUNT(customer_id) from Customers
group by customer_id
having COUNT(customer_id)>1
order by customer_id

-- 5. Display the customer id, region name, transaction type and transaction amount for the minimum transaction amount in deposit.
select cu.customer_id, ct.region_name, tr.txn_type, MIN(tr.txn_amount) as Min_Trans_Amount from Continent ct
inner join Customers cu
on ct.region_id=cu.region_id
inner join Transactions tr
on tr.customer_id=cu.customer_id
where tr.txn_type='deposit'
group by cu.customer_id, ct.region_name, tr.txn_type
order by cu.customer_id

select distinct(cu.customer_id), ct.region_name, tr.txn_type, tr.txn_amount from Continent ct
inner join Customers cu
on ct.region_id=cu.region_id
inner join Transactions tr
on tr.customer_id=cu.customer_id
where tr.txn_amount=(select MIN(txn_amount) from Transactions where txn_type='deposit')

select * from Transactions where customer_id=3

-- 6. Create a stored procedure to display details of customers in the Transaction table where the transaction date is greater than Jun 2020.
create or alter procedure sp_Cust
as
begin
	select distinct(customer_id) from Transactions where txn_date>'2020-03-31'
end

exec sp_Cust


create or alter procedure sp_Cust1 (@InputDate date)
as
begin
	select distinct(c.customer_id), t.txn_date,t.txn_amount from Transactions t
	inner join Customers c
	on t.customer_id=c.customer_id
	where txn_date>@InputDate
	order by c.customer_id
end

exec sp_Cust1'2020-03-31'

select distinct(customer_id) from Transactions where txn_date>'2020-03-31'

-- 7. Create a stored procedure to insert a record in the Continent table.
create or alter procedure sp_InsertCont(@region_id int, @region_name varchar(20))
as
begin
	insert into Continent values(@region_id, @region_name)
end

exec sp_InsertCont 7, 'SA'

select * from Continent

-- 8. Create a stored procedure to display the details of transactions that happened on a specific day.
create or alter procedure sp_Trans_Details (@InputDate date)
as
begin
	select * from Transactions
	where txn_date>@InputDate
	order by customer_id
end

exec sp_Trans_Details '2020-03-31'

-- 9. Create a user defined function to add 10% of the transaction amount in a table.
create or alter function fn_add(@x int)
returns int
as
begin
	declare @y decimal (10,2)
	set @y=@x+(@x*0.10)
	return @y
end

select dbo.fn_add(154)


create or alter function fn_update_txn_amount(@custid int)
returns int
as
begin
	declare @y decimal (10,2)
	declare @tenpercent decimal (10,2)
	set @y=(select min(txn_amount) from Transactions where customer_id=@custid and txn_type='deposit')
	return @y+(@y*0.10)
end

select min(txn_amount) from Transactions where customer_id=1 and txn_type='deposit'

select dbo.fn_update_txn_amount(1)

-- 10. Create a user defined function to find the total transaction amount for a given transaction type.
create or alter function fn_total_trans_amount(@type varchar(20))
returns int
as 
begin
	return (select SUM(txn_amount) as Total_Transaction_Amount from Transactions where txn_type=@type)
end

select dbo.fn_total_trans_amount('purchase')

-- 11. Create a table value function which comprises the columns customer_id, region_id ,txn_date , txn_type , txn_amount which will retrieve data from the above table.
select * from Continent
select * from Transactions
select * from Customers

create or alter function fn_Cust_Trans()
returns table
as
	 return (select c.customer_id,c.region_id,t.txn_date,t.txn_type,t.txn_amount from Customers c
	inner join Transactions t
	on c.customer_id=t.customer_id)

select * from dbo.fn_Cust_Trans()

-- 12. Create a TRY...CATCH block to print a region id and region name in a single column.
create or alter procedure SP_Region_nfo
as
begin
	begin try
		select region_id+region_name from Continent
	end try
	begin catch
		print ('Invalid')
	end catch
end

exec SP_Region_nfo 


-- 13. Create a TRY...CATCH block to insert a value in the Continent table.
create or alter procedure SP_Region_insert(@x int, @y varchar(10))
as
begin
	begin try
		insert into Continent values(@x,@y)
		print('inserted')
		select region_id+region_name from Continent
	end try
	begin catch
		print ('Not inserted')
	end catch
end

exec SP_Region_insert 13, 'UAE' 

-- 14. Create a trigger to prevent deleting a table in a database.
CREATE OR ALTER TRIGGER TRIG_DELETE_EMP ON Continent FOR DELETE
AS 
BEGIN
	PRINT 'DELETING IS NOT ALLOWED'
	ROLLBACK
END

DELETE FROM Continent where region_id=1 and region_name='Australia'

select * from Continent

-- 15. Create a trigger to audit the data in a table.
select * from Transactions

Create table Audit_Trans(
customerid int,
trans_date date,
trans_type varchar(20),
trans_amount numeric(10,2),
action_type varchar(20)
)

select * from Audit_Trans
-- entering reocrds while inserting
create trigger insert_trans on Transactions for insert
as
begin
	insert into Audit_Trans select customer_id,txn_date,txn_type,txn_amount,'RECORD INSERTED' from inserted
end

insert into Transactions values(502,GETDATE(),'deposit',9835)
select * from Audit_Trans

-- entering reocrds while updating
create or alter trigger update_trans on Transactions for update
as
begin
	insert into Audit_Trans select customer_id,txn_date,txn_type,txn_amount,'RECORD UPDATED' from deleted
end

UPDATE Transactions set txn_amount=100 where customer_id=502
select * from Audit_Trans

-- entering reocrds while deleting
create or alter trigger update_trans on Transactions for delete
as
begin
	insert into Audit_Trans select customer_id,txn_date,txn_type,txn_amount,'RECORD DELETED' from deleted
end

delete from Transactions where customer_id=502
select * from Audit_Trans

-- 16. Create a trigger to prevent login of the same user id in multiple pages.
drop table UserSessions
CREATE TABLE UserSessions (
    UserID INT IDENTITY(1,1),
	eventVal	xml,
	eventdate	date not null,
    SessionID SYSNAME NOT NULL
)

INSERT INTO UserSessions(eventVal,eventdate,SessionID) VALUES(EVENTDATA(),GETDATE(),USER)
select * from UserSessions

create trigger multi_pages on UserSessions for insert
as
begin
	print 'Login not allowed with the same user id'
	rollback
end

INSERT INTO UserSessions(eventVal,eventdate,SessionID) VALUES(EVENTDATA(),GETDATE(),USER)

-- 17. Display top n customers on the basis of transaction type.
select top 10 customer_id,txn_type, MAX(txn_amount) as Trans_Amount from Transactions
group by txn_type,customer_id
order by Trans_Amount desc

-- 18. Create a pivot table to display the total purchase, withdrawal and deposit for all the customers.

select customer_id, txn_type, sum(txn_amount) as Trans_Amount from Transactions
group by txn_type, customer_id
order by customer_id