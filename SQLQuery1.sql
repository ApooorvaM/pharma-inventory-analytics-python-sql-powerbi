--select top 10 * from sales

-- Checking the inventory health
=================================================================================================
-- Ques 1: How many products are Understocked, Healthy and Overstocked? 
=================================================================================================

select  year, stock_status, 
count(product_id) as stock_quantity
from sales 
group by stock_status, year
order by year desc, stock_status

==================================================================================================
--Ques 2: Identifying top 20 product with largest shortage or surplus
==================================================================================================

select top 20 product_id ,
round(abs(avg(inventory_quantity - inventory_req)),2) as inventory_gap
from sales
group by product_id
order by abs(avg(inventory_quantity - inventory_req)) desc;

===================================================================================================
--Ques 3: Which products are consistently in bad inventory health(over/understocked)?
===================================================================================================

with cte_inv_health as
(
select product_id, year, 
count(month) as bad_inventory_month_count,
round(abs(avg((inventory_quantity - inventory_req)/inventory_req)),2) as inventory_gap_ratio,
stock_status
from sales
where stock_status in ('understock','overstock')
group by product_id, year, stock_status
)

select product_id, year, bad_inventory_month_count, inventory_gap_ratio, 'severe'+ ' ' + stock_status as inv_health
from cte_inv_health 
where bad_inventory_month_count > 6 and inventory_gap_ratio > 0.5
order by bad_inventory_month_count desc, inventory_gap_ratio desc;

==================================================================================================
--Ques 4: Which overstocked products have the highest shelf life risk?
==================================================================================================

select product_id, year,inventory_coverage, shelf_life_months,
stock_status
from sales
where inventory_coverage > shelf_life_months and stock_status = 'overstock'


-- Evaluating demand risk

=================================================================================================
-- Ques 5: Checking the products with highest fluctuation in demand 
=================================================================================================

select distinct product_id, year, 
coeff_of_variability
from sales
order by coeff_of_variability desc;

=================================================================================================
-- Ques 6: Checking the high risk products with high variability and in understock 
=================================================================================================

select product_id, year, count(month) as high_risk_months, 
coeff_of_variability, stock_status
from sales
where coeff_of_variability > 50 and stock_status = 'understock'
group by product_id, year , stock_status,coeff_of_variability
order by count(month) desc, coeff_of_variability desc;

=================================================================================================
-- Ques 7: Checking the low risk/stable products with low variability and in overstock 
=================================================================================================

select product_id, year, count(month) as low_risk_months,
coeff_of_variability, stock_status
from sales
where stock_status = 'overstock' and coeff_of_variability < 50
group by product_id, year, stock_status, coeff_of_variability
order by coeff_of_variability desc, count(month) desc;

-- Analysing financial status
=================================================================================================
-- Ques 8: Which overstocked products have highest holding cost?
=================================================================================================

select product_id, avg(holding_cost) as inv_holding_cost, stock_status
from sales
where stock_status = 'overstock'
group by product_id, stock_status
order by avg(holding_cost) desc;

=================================================================================================
-- Ques 9: How does actual sales compare with Finance Plan for each product?
=================================================================================================

create view vw_finance_target as
(
SELECT 
    f.productid,
    Sub.[year],
    Sub.[planned_units]
FROM finance as f
CROSS APPLY (
    VALUES 
        ('2023', f.plan_2023_units),
        ('2024', f.plan_2024_units),
        ('2025', f.plan_2025_units)
) AS Sub([year], [planned_units])
);



with cte_sales as
(
select distinct product_id, year, sum(sales_quantity) as total_sales
from sales 
group by product_id, year
)

select s.product_id, s.year, s.total_sales as actual_sales, f.planned_units as target_sales,
round(100.0*(s.total_sales-f.planned_units)/f.planned_units,2) as percent_diff
from cte_sales as s
left join vw_finance_target as f
on s.product_id = f.productid and s.year = f.year
where s.total_sales < f.planned_units
order by percent_diff asc


=====================================================================================================
-- Ques 10. Which products have the largest gap between planned and actual sales growth across years?
=====================================================================================================

with yearly_sales as
(
select product_id, year, sum(sales_quantity) as total_sales
from sales
group by product_id, year
)
select s.product_id, s.year, f.planned_units, s.total_sales, abs(f.planned_units-s.total_sales) as plan_variance
from yearly_sales as s
left join vw_finance_target as f 
on f.productid = s.product_id and f.year = s.year
order by plan_variance desc
