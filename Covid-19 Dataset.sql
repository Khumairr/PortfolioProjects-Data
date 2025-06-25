create database covid;
use covid;

/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/
select * from country_wise;

-- Number of Cases per WHO Region
SELECT who_region, SUM(confirmed) AS total_confirmed
FROM country_wise
GROUP BY who_region
ORDER BY total_confirmed DESC;

-- Top 10 Countries with the Highest Confirmed Cases
select country_region, confirmed
from country_wise
order by confirmed desc
limit 10;

-- Countries with the Highest Death Rate
select country_region, deaths_per_100_cases
from country_wise
order by deaths_per_100_cases desc
limit 10;

-- Countries with the Biggest Changes in the Last Week
SELECT country_region, one_week_change, one_week_percent_increase
FROM country_wise
ORDER BY one_week_percent_increase DESC
LIMIT 10;

-- Highest Recovery Rate
select country_region, recovered_per_100_cases
from country_wise
order by recovered_per_100_cases desc
limit 10;

-- Total Global (Worldwide)
SELECT 
  SUM(confirmed) AS total_confirmed,
  SUM(deaths) AS total_deaths,
  SUM(recovered) AS total_recovered,
  SUM(active) AS total_active
FROM country_wise;

-- Total Cases, Deaths, and Recoveries per WHO Region
SELECT 
    who_region,
    SUM(confirmed) AS total_confirmed,
    SUM(deaths) AS total_deaths,
    SUM(recovered) AS total_recovered
FROM country_wise
GROUP BY who_region
ORDER BY total_confirmed DESC;

-- Use CTE to View Countries with the Highest Weekly Increases
WITH weekly_increase AS (
    SELECT 
        country_region,
        one_week_change,
        one_week_percent_increase
    FROM country_wise
)
SELECT * FROM weekly_increase
ORDER BY one_week_percent_increase DESC
LIMIT 10;

-- Use Window Function to Rank Countries Based on Cases
SELECT 
    country_region,
    confirmed,
    RANK() OVER (ORDER BY confirmed DESC) AS rank_confirmed
FROM country_wise;

-- Convert Data Type to Decimal (for example for precision analysis)
SELECT 
    country_region,
    CAST(deaths_per_100_cases AS DECIMAL(5,2)) AS deaths_rate,
    CAST(recovered_per_100_cases AS DECIMAL(5,2)) AS recovered_rate
FROM country_wise;

-- Create a View for Countries with Severe Cases (deaths > 50000)
CREATE VIEW high_death_countries AS
SELECT 
    country_region,
    deaths,
    confirmed,
    (deaths / confirmed) * 100 AS death_rate_percent
FROM country_wise
WHERE deaths > 50000;

-- Join the WHO Region Info Dummy Data
CREATE TEMPORARY TABLE who_info (
    who_region VARCHAR(100),
    region_director VARCHAR(100)
);

SELECT 
    cw.country_region,
    cw.who_region,
    wi.region_director,
    cw.confirmed
FROM country_wise cw
JOIN who_info wi ON cw.who_region = wi.who_region;
