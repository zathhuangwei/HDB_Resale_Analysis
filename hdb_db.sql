select *
from hdb;

-- simple data cleaning

alter table hdb
add column resale_date date;

update hdb
set resale_date = str_to_date(concat(month, '-01'), '%Y-%m-%d');

alter table hdb
add column year_date int,
add column month_date int;

update hdb
set year_date = substring(month, 1, 4);

update hdb
set month_date = substring(month, 6, 2);

alter table hdb
add column remaining_lease_years int,
add column remaining_lease_months int,
add column remaining_lease_duration_in_years decimal(4,2);

update hdb
set remaining_lease_years = cast(substring_index(remaining_lease, ' years', 1) as unsigned); #substring_index returns the substring before the ' years' delimiter. 1 is used to return left, -1 is used to return right

update hdb
set remaining_lease_months = case
								when locate('months', remaining_lease) > 0 then
									cast(substring(remaining_lease, locate('years', remaining_lease) + 6, 2) as unsigned)
								else 0
							end;

update hdb
set remaining_lease_duration_in_years = round(remaining_lease_years + remaining_lease_months/12, 2);

-- Questions

-- 1. Price Trends Over Time: How have the resale prices changed over time

-- Random queries to visualise data

--  Exploratory data analysis
select town, flat_type, month, avg(resale_price) as avg
from hdb
group by town, flat_type, month
order by town, flat_type, month;

select town, avg(resale_price) as avg
from hdb
group by town
order by avg desc;

select flat_type, avg(resale_price) as avg
from hdb
group by flat_type
order by avg desc;

select storey_range, avg(resale_price) as avg
from hdb
group by storey_range
order by avg desc;

select town, flat_type, avg(resale_price/floor_area_sqm) as price_per_sqm
from hdb
group by town, flat_type
order by price_per_sqm desc;

select town, flat_type, avg(resale_price/remaining_lease_duration_in_years) as price_per_remaining_lease
from hdb
group by town, flat_type
order by price_per_remaining_lease desc;

select town, avg(resale_price) as avg
from hdb
group by town
order by avg desc
limit 5;

select town, avg(resale_price) as avg
from hdb
group by town
order by avg asc
limit 5;



