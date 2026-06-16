# Week 3: SQL & Data Querying

## AnalystLab Africa Data Analytics Internship Program 


------------------------------------------------------------------------

## Overview

This week focused on building SQL querying skills using two datasets.
The tasks covered database setup, core SQL queries, advanced SQL
concepts including joins, subqueries, and window functions, business
problem solving, and query optimisation.

------------------------------------------------------------------------

# Dataset 1: Chinook Digital Music Store

## About the Dataset

A relational database representing a digital music store. It contains 11
tables and over 15,000 rows covering artists, albums, tracks, customers,
employees, invoices, and playlists.

## Tasks Completed

-   Explored all 11 tables and identified:
    -   Data types
    -   Row counts
    -   Primary keys
    -   Table relationships
-   Wrote core SQL queries to analyse:
    -   Customers by country
    -   Revenue by country
    -   Tracks by genre
    -   Monthly revenue trends
-   Applied advanced SQL concepts:
    -   INNER JOIN and LEFT JOIN across up to 4 tables
    -   Subqueries to identify above-average spenders
    -   Window functions for:
        -   Country-level rankings
        -   Cumulative revenue analysis
        -   First purchase identification
-   Solved business questions covering:
    -   Top customers
    -   Best-selling tracks
    -   Support representative performance
    -   Top albums
    -   Media type revenue
    -   Average order value by country
-   Verified database performance by:
    -   Checking indexes using `SHOW INDEX`
    -   Reviewing query execution plans using `EXPLAIN`

## Key Findings

-   USA generated the highest total revenue (\$523), while Chile and
    Czech Republic recorded the highest average order value per
    purchase.
-   Rock had the largest catalogue size (1,297 tracks) and the highest
    number of units sold (835 units).
-   TV shows generated higher revenue per title than music albums due to
    higher unit pricing.
-   No single track dominated sales, with the best-selling tracks
    reaching only 2 units sold each.
-   Only 3 support representatives manage all 59 customers, and major
    tables already have indexing in place.

------------------------------------------------------------------------

# Dataset 2: Sales Sample Dataset

## About the Dataset

A flat sales dataset containing 2,832 rows and 25 columns. It includes
sales order information for a company selling scale model vehicles
across multiple countries and territories.

## Tasks Completed

-   Explored table structure and identified:
    -   25 columns
    -   Numerical fields
    -   Categorical fields
    -   Text-based date fields
    -   Absence of indexes after import
-   Created SQL queries analysing:
    -   Order status distribution
    -   Revenue by product line
    -   Revenue by country
    -   Deal size performance
    -   Yearly sales trends
    -   Territory performance
    -   Numerical summary statistics
-   Applied advanced SQL techniques:
    -   Subqueries for above-average orders and customers
    -   Window functions for:
        -   Global customer rankings
        -   Country-level rankings
        -   Cumulative monthly revenue
-   Solved business questions covering:
    -   Top-performing products
    -   Monthly sales trends
    -   Deal size behaviour
    -   Highest-value customers
    -   Product line contribution
-   Improved performance by:
    -   Creating 6 indexes on frequently queried columns
    -   Applying key length limits for text columns
    -   Validating index usage using `EXPLAIN`

## Key Findings

-   Classic Cars contributed 39% of total revenue and dominated the top
    10 best-selling products.
-   November consistently recorded the highest revenue each year,
    showing a strong seasonal trend.
-   Euro Shopping Channel from Spain was the highest-value customer at
    \$912,294.
-   Medium deal size was the most common deal type across all countries.
-   Classic Cars and Vintage Cars together generated 58% of total
    revenue despite being only 2 of 7 product lines.

------------------------------------------------------------------------

## Skills Practiced

-   Database exploration
-   SQL querying
-   Filtering and aggregation
-   Joins
-   Subqueries
-   Window functions
-   Business analysis
-   Query optimisation
-   Index management
-   Execution plan analysis

------------------------------------------------------------------------


-   MySQL Workbench
-   SQL
