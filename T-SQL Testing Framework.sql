--drop table #TestResult;
declare @StartTime datetime2;
declare @i int = 0, @NumberOfRuns int = 10;


create table #TestResult (
	QueryNumber int
	, TestQueryText nvarchar(max)
	, StartTime datetime2
	, EndTime datetime2
	, DurationMS as datediff(ms, StartTime, EndTime)
);

while @i < @NumberOfRuns
begin

	set @StartTime = getdate();
	set statistics io on;
	set statistics time on;

	-- query 1 goes here:
	select *
	from SalesLT.SalesOrderHeader soh
	inner join SalesLT.Customer c on soh.CustomerID = c.CustomerID
	inner join SalesLT.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
	inner join SalesLT.Product p on sod.ProductID = p.ProductID
	-- *************** --

	set statistics io off;
	set statistics time off;

	insert into #TestResult (QueryNumber
	, TestQueryText
	, StartTime
	, EndTime)
	select top 1 1
	, [text]
	, @StartTime
	, getdate()
	from sys.dm_exec_query_stats
	cross apply sys.dm_exec_sql_text(sql_handle)
	order by last_execution_time desc;




	set @StartTime = getdate();
	set statistics io on;
	set statistics time on;

	-- query 2 goes here:
	select *
	from SalesLT.SalesOrderHeader soh
	inner join SalesLT.Customer c on soh.CustomerID = c.CustomerID
	inner join SalesLT.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
	inner join SalesLT.Product p on sod.ProductID = p.ProductID
	-- *************** --

	set statistics io off;
	set statistics time off;


	insert into #TestResult (QueryNumber
	, TestQueryText
	, StartTime
	, EndTime)
	select top 1 2
	, [text]
	, @StartTime
	, getdate()
	from sys.dm_exec_query_stats
	cross apply sys.dm_exec_sql_text(sql_handle)
	order by last_execution_time desc;

	set @i += 1;

end


select *
from #TestResult;

select QueryNumber
, TestQueryText
, avg(DurationMS) as 'Avg Query Duration (ms)'
, max(DurationMS) as 'Max Query Duration (ms)'
, min(DurationMS) as 'Min Query Duration (ms)'
from #TestResult
group by QueryNumber
, TestQueryText;
