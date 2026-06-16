create database salesdb;
use salesdb;

show tables;
describe sales_data_sample;

-- TASK 1 - Data understanding
select * from sales_data_sample
limit 5;

-- row count
select count(*) as total_rows 
from sales_data_sample;

-- distinct values
select distinct status 
from sales_data_sample;

select distinct productline 
from sales_data_sample;

select distinct dealsize 
from sales_data_sample;

select distinct territory 
from sales_data_sample;

-- TASK 2 - CORE SQL QUERIES
-- total rows per order status
select
status,
count(*) as order_count
from sales_data_sample
group by  status
order by order_count;

-- Total revenue by product line
select 
count(*) as order_count,
productline,
round(sum(sales),2) as Revenue
from sales_data_sample
group by productline
order by revenue desc;

-- Total revenue by country
select
count(*) as order_count,
country,
round(sum(sales),2) as revenue
from sales_data_sample
group by country
order by revenue desc;

-- Revenue by deal size
select 
    dealsize,
    count(*) as order_count,
    round(sum(sales), 2) as total_revenue,
    round(avg(sales), 2) as avg_order_value
from sales_data_sample
group by dealsize
order by total_revenue desc;

-- Revenue by year
select 
    year_id,
    count(*) as order_count,
    round(sum(sales), 2) as total_revenue
from sales_data_sample
group by year_id
order by year_id;

-- Revenue by territory
select 
    territory,
    count(*) as order_count,
    round(sum(sales), 2) as total_revenue,
    round(avg(sales), 2) as avg_order_value
from sales_data_sample
group by territory
order by total_revenue desc;

-- Summary statistics for numerical columns
select 
    round(avg(sales), 2) as avg_sales,
    round(min(sales), 2) as min_sales,
    round(max(sales), 2) as max_sales,
    round(avg(quantityordered), 2) as avg_quantity,
    round(min(quantityordered), 2) as min_quantity,
    round(max(quantityordered), 2) as max_quantity,
    round(avg(priceeach), 2) as avg_price,
    round(min(priceeach), 2) as min_price,
    round(max(priceeach), 2) as max_price
from sales_data_sample;

-- TASK 3 - ADVANCED SQL QUERIES
-- Subquery - orders above average sale value
SELECT 
    ordernumber,
    customername,
    country,
    sales,
    avg_sales
FROM
(
    SELECT 
        ordernumber,
        customername,
        country,
        sales,
        AVG(sales) OVER() AS avg_sales
    FROM sales_data_sample
) AS orders
WHERE sales > avg_sales
ORDER BY sales DESC
LIMIT 10;

-- Subquery-  Top performing customers above average revenue
select 
    customername,
    country,
    count(*) as order_count,
    round(sum(sales), 2) as total_revenue
from sales_data_sample
group by customername, country
having sum(sales) > (
    select avg(customer_total)
    from (
        select sum(sales) as customer_total
        from sales_data_sample
        group by customername
    ) as avg_table
)
order by total_revenue desc
limit 10;

-- Window Function - rank customers by revenue
select 
    customername,
    country,
    round(sum(sales), 2) as total_revenue,
    rank() over (
        order by sum(sales) desc
    ) as revenue_rank
from sales_data_sample
group by customername, country
order by revenue_rank
limit 10;

-- Window function - rank customers by revenue within each country
select 
    customername,
    country,
    round(sum(sales), 2) as total_revenue,
    rank() over (
        partition by country
        order by sum(sales) desc
    ) as country_rank
from sales_data_sample
group by customername, country
order by country, country_rank
limit 15;

-- Window function - cumulative revenue by month and year
select 
    year_id,
    month_id,
    round(sum(sales), 2) as monthly_revenue,
    round(sum(sum(sales)) over (
        order by year_id, month_id
        rows between unbounded preceding and current row
    ), 2) as cumulative_revenue
from sales_data_sample
group by year_id, month_id
order by year_id, month_id;

-- TASK 4 - BUSINES PROBLEM SOLVING
-- Top 10 best selleing products by revenue
select 
    productcode,
    productline,
    round(sum(sales), 2) as total_revenue,
    sum(quantityordered) as total_units,
    rank() over (
        order by sum(sales) desc
    ) as revenue_rank
from sales_data_sample
group by productcode, productline
order by revenue_rank
limit 10;

-- Monthly revenue trend by year
select 
    year_id,
    month_id,
    round(sum(sales), 2) as monthly_revenue,
    round(avg(sales), 2) as avg_order_value,
    count(*) as order_count
from sales_data_sample
group by year_id, month_id
order by year_id, month_id;

-- Customer purchasing behaviour by deal size and country
select 
    country,
    dealsize,
    count(*) as order_count,
    round(sum(sales), 2) as total_revenue
from sales_data_sample
group by country, dealsize
order by country, total_revenue desc
limit 15;

-- Top 10 customers by total revenue
select 
    customername,
    country,
    territory,
    count(*) as order_count,
    round(sum(sales), 2) as total_revenue,
    round(avg(sales), 2) as avg_order_value
from sales_data_sample
group by customername, country, territory
order by total_revenue desc
limit 10;

-- Revenue contribution by product line with percentage
select 
    productline,
    count(*) as order_count,
    round(sum(sales), 2) as total_revenue,
    round(sum(sales) * 100.0 / sum(sum(sales)) over (), 2) as pct_of_total
from sales_data_sample
group by productline
order by total_revenue desc;

-- TASK 5 - QUERY OPTIMIZATION
-- Check existing indexes
show index from sales_data_sample;

-- Creating  indexes on frequently queried columns
create index idx_country on sales_data_sample(country(50));
create index idx_productline on sales_data_sample(productline(50));
create index idx_status on sales_data_sample(status(50));
create index idx_year on sales_data_sample(year_id);
create index idx_customername on sales_data_sample(customername(50));
create index idx_dealsize on sales_data_sample(dealsize(50));

show index from sales_data_sample;

-- Verifying index usage with explain
explain
select 
    country,
    round(sum(sales), 2) as total_revenue
from sales_data_sample
where country = 'USA'
group by country;



