-- TASK 1 - DATA UNDERSTANDING
-- showing all tables
show tables;

-- counting rows ans columns in each table
select 'album'         as table_name, count(*) as row_count from album
union all
select 'artist',        count(*) from artist
union all
select 'customer',      count(*) from customer
union all
select 'employee',      count(*) from employee
union all
select 'genre',         count(*) from genre
union all
select 'invoice',       count(*) from invoice
union all
select 'invoiceline',   count(*) from invoiceline
union all
select 'mediatype',     count(*) from mediatype
union all
select 'playlist',      count(*) from playlist
union all
select 'playlisttrack', count(*) from playlisttrack
union all
select 'track',         count(*) from track;

-- checking data types for each column
describe album;
describe artist;
describe customer;
describe track;
describe invoice;
describe invoiceline;
describe employee;
describe genre;
describe mediatype;
describe playlist;
describe playlisttrack;

-- previewing first few rows
select * from artist limit 5;

select * from  album limit 5;

select * from  track limit 5;

select * from customer limit 5;

select * from invoice limit 5;

select * from invoiceline limit 5;

-- TASK 2 - CORE SQL QUERIES
-- listing all customers from USA
select 
CustomerId,
FirstName,
LastName,
City,
State,
Email
from customer
where Country = 'USA'
order by LastName,FirstName
;

-- Listing tracks priced above 0.99
select
TrackId,
Name,
UnitPrice,
Milliseconds / 6000.0 as duration_minutes
 from track
 where UnitPrice > 0.99
 order by UnitPrice desc;

-- count of tracks priced above $0.99
select count(*) as track_count
from track
where unitprice > 0.99;

-- total revenue  and order count by country
select
BillingCountry as country,
count(InvoiceId) as total_orders,
round(sum(Total), 2) as  total_revenue,
round(avg(Total),2) as average_order_value
 from invoice
 group by BillingCountry
 order by total_revenue desc;
 
-- Number of tracks per genre
select 
g.name as genre,
count(t.TrackId) as track_count
 from genre g
 left join track t on  t.GenreId = g.GenreId
 group by g.name
 order by track_count desc;
 
 -- Total revenue by month
-- task 2: monthly revenue trend
select 
    year(invoicedate) as year,
    month(invoicedate) as month,
    count(invoiceid) as invoice_count,
    round(sum(total), 2) as monthly_revenue
from invoice
group by year(invoicedate), month(invoicedate)
order by year(invoicedate), month(invoicedate);

-- TASK 3 -  ADVANCED SQL  CONCEPTS
-- Inner join - tracks with album and artist names
select
t.name as track_name,
al.Title as album_title,
ar.name  as artist_name
 from track t
inner join album  al on al.AlbumId = t.AlbumId
inner join artist ar on ar.ArtistId = al.ArtistId
order by ar.name
limit 10
;

-- Inner join - customer purchases  with track details
select
c.FirstName as first_name,
c.LastName as last_name,
c.country,
i.InvoiceDate,
t.name as track_name,
il.UnitPrice,
il.Quantity
from customer c
inner join invoice i on i.customerid = c.customerid
inner join invoiceline il on il.invoiceid = i.invoiceid
inner join track t on t.trackid = il.trackid
order by i.invoicedate desc
limit 10;

-- Left join - artsist  with albums
select 
ar.name  as artist,
count(al.albumid) as  album_count
from artist ar
left join album al on al.ArtistId = ar.ArtistId
group by ar.name
order by album_count desc
limit 10;

-- Left join - artists without albums
select 
ar.name  as artist,
count(al.albumid) as  album_count
from artist ar
left join album al on al.ArtistId = ar.ArtistId
group by ar.name
having album_count = 0
order by ar.name;

-- Inner join - support representatives and their customers
select 
    e.firstname as rep_firstname,
    e.lastname as rep_lastname,
    e.title,
    count(c.customerid) as customers_assigned
from employee e
join customer c on c.supportrepid = e.employeeid
group by e.employeeid
order by customers_assigned desc;

-- Subquery - customers above  average spend
select 
    c.firstname,
    c.lastname,
    c.country,
    round(sum(i.total), 2) as lifetime_spend
from customer c
join invoice i on i.customerid = c.customerid
group by c.customerid
having sum(i.total) > (
    select avg(customer_total)
    from (
        select sum(total) as customer_total
        from invoice
        group by customerid
    ) as avg_table
)
order by lifetime_spend desc;

-- Subquery - most popular genre by units sold
select 
    g.name as genre,
    sum(il.quantity) as units_sold
from genre g
join track t on t.genreid = g.genreid
join invoiceline il on il.trackid = t.trackid
where g.genreid in (
    select distinct genreid from track
)
group by g.name
order by units_sold desc
limit 10;

-- Window Function - rank customer by  spend per country
select 
    c.country,
    c.firstname,
    c.lastname,
    round(sum(i.total), 2) as total_spend,
    rank() over (
        partition by c.country
        order by sum(i.total) desc
    ) as country_rank
from customer c
join invoice i on i.customerid = c.customerid
group by c.customerid, c.country
order by c.country, country_rank
limit 15;

-- Window function - cumulative revenue over time
select 
    year(invoicedate) as year,
    month(invoicedate) as month,
    round(sum(total), 2) as monthly_revenue,
    round(sum(sum(total)) over (
        order by year(invoicedate), month(invoicedate)
        rows between unbounded preceding and current row
    ), 2) as cumulative_revenue
from invoice
group by year(invoicedate), month(invoicedate)
order by year(invoicedate), month(invoicedate)
limit 10;


-- Window function - first invoice per customer
select * from (
    select 
        c.firstname,
        c.lastname,
        c.country,
        i.invoicedate,
        i.total,
        row_number() over (
            partition by i.customerid
            order by i.invoicedate
        ) as rn
    from customer c
    join invoice i on i.customerid = c.customerid
) as first_purchase
where rn = 1
order by invoicedate
limit 10;

-- TASK 4 - Business Problem Solving
-- Top 10 customers by lifetime spend
select
c.customerid,
c.FirstName,
c.LastName,
c.country,
count(distinct i.InvoiceId) as total_orders,
round(sum(i.total),2) as total_spend
from customer c
join invoice i on i.CustomerId = c.CustomerId
group by c.customerid
order by total_spend desc
limit 10
;

-- Top 10 best selling tracks
select 
t.name as trak_name,
ar.name as artist_name,
g.name as genre,
sum(il.Quantity) as units_sold,
round(sum(il.quantity * il.unitprice),2) as revenue
from track t
join  album al on al.AlbumId = t.AlbumId
join artist ar on ar.ArtistId = al.ArtistId
join genre g on g.GenreId = t.genreid
join invoiceline il on il.trackid = t.trackid
group by t.trackid
order by units_sold desc
limit 10;

-- Support rep performance by revenue
select 
    e.firstname,
    e.lastname,
    e.title,
    count(distinct c.customerid) as customers_managed,
    count(distinct i.invoiceid) as total_invoices,
    round(sum(i.total), 2) as revenue_generated
from employee e
join  customer c on c.SupportRepId = e.EmployeeId
join invoice i on i.CustomerId = c.CustomerId
group by e.EmployeeId
order by revenue_generated desc;

-- which album generates most revenue
select 
    al.title as album_title,
    ar.name as artist_name,
    count(il.invoicelineid) as tracks_sold,
    round(sum(il.quantity * il.unitprice), 2) as revenue
from album al
join artist ar on ar.artistid = al.artistid
join track t on t.albumid = al.albumid
join invoiceline il on il.trackid = t.trackid
group by al.albumid
order by revenue desc
limit 10;

-- Revenue by media type
select 
    mt.name as media_type,
    count(il.invoicelineid) as units_sold,
    round(sum(il.quantity * il.unitprice), 2) as revenue
from mediatype mt
join track t on t.mediatypeid = mt.mediatypeid
join invoiceline il on il.trackid = t.trackid
group by mt.mediatypeid
order by revenue desc;

-- Top 5 countries by average order value
select 
    billingcountry as country,
    count(invoiceid) as total_orders,
    round(sum(total), 2) as total_revenue,
    round(avg(total), 2) as avg_order_value
from invoice
group by billingcountry
having count(invoiceid) >= 5
order by avg_order_value desc
limit 5;

-- TASK 5 - Query  optimization
show index from invoice;
show index from invoiceline;
show index from track;
show index from customer;

-- Explaining query plan - checking index usage
explain
select 
    c.firstname,
    c.lastname,
    round(sum(i.total), 2) as lifetime_spend
from customer c
join invoice i on i.customerid = c.customerid
group by c.customerid;






