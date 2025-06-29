create database online_retail;

use online_retail;

create table OnlineRetail (
    InvoiceNo varchar(20),
    StockCode varchar(20),
    Description text,
    Quantity int,
    InvoiceDate date,
    UnitPrice float,
    CustomerID int,
    Country varchar(100)
);

select * from OnlineRetail limit 10;

select count(*) from OnlineRetail;

select distinct country from OnlineRetail;

/*Getting Reference Date (Latest Purchase Date)*/
select max(InvoiceDate) from OnlineRetail;

/*Calculating Recency for each customer-
 Customers who purchased more recently get a lower Recency score (which is good).*/
create table RecencyTable as 
select CustomerId, datediff('2011-12-09', max(InvoiceDate)) as Recency
from OnlineRetail
where CustomerId is not null
group by CustomerID
order by CustomerId;

/*Calculating Frequency-
 Customers who bought more often get a higher Frequency*/
create table FrequencyTable as 
select CustomerId, count(distinct InvoiceNo) as Frequency 
from OnlineRetail
where CustomerId is not null
group by CustomerId
order by CustomerId;

/*Calculating Monetary-
Measures total spending per customer*/
create table MonetaryTable as 
select CustomerId, round(sum(Quantity * UnitPrice), 2) as Monetary
from OnlineRetail
where CustomerId is not null
group by CustomerId
order by CustomerId;

/*Combining into Final RFM Table*/
create table RFM_Table as
select r.CustomerId, r.Recency, f.Frequency, m.Monetary from RecencyTable r
join FrequencyTable f on r.CustomerId = f.CustomerId
join MonetaryTable m on r.CustomerId = m.CustomerId;

/*Adding RFM Scores (Quantile-based)*/
create table RFM_Score as 
select *,
ntile(5) over (order by Recency desc) as R_Score,
ntile(5) over (order by Frequency) as F_Score,
ntile(5) over (order by Monetary) as M_Score
from RFM_Table;

/*Segmenting the Customers*/
create view v_CustomerSegments as
select *,
  concat(R_Score, F_Score, M_Score) as RFM_Score,
  case
    when R_Score >= 4 and F_Score >= 4 and M_Score >= 4 then 'Champions'
    when R_Score >= 3 and F_Score >= 3 then 'Loyal Customers'
    when R_Score >= 4 then 'Recent Customers'
    when F_Score >= 4 then 'Frequent Buyers'
    when M_Score >= 4 then 'Big Spenders'
    else 'At Risk'
  end as Segment
from RFM_Score;

select Segment, count(*) from v_CustomerSegments group by Segment;

select Segment, count(*) as Num_Of_Customers
from v_CustomerSegments
group by Segment
order by Num_Of_Customers desc;

select Segment, round(avg(Monetary), 2) as Avg_Revenue
from v_CustomerSegments
group by Segment
order by Avg_Revenue desc;

select RFM_Score, count(*) as CustomerCount
from v_CustomerSegments
group by RFM_Score
order by CustomerCount desc;

select * from v_CustomerSegments
where Segment = 'Champions'
order by Monetary desc
limit 10;