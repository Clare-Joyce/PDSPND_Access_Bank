
-- Window functions
-- OVER
-- PARTITION BY

-- Question 1
-- create a running total of standard_amt_usd (in the orders table) over 
-- order time with no date truncation. Your final table should have two 
-- columns: one with the amount being added for each new row, and a 
-- second with the running total.

select standard_amt_usd,
       sum(standard_amt_usd) over(order by occurred_at) as total
from orders

-- Question 2
-- Still create a running total of standard_amt_usd (in the orders table) over order 
-- time, but this time, date truncate occurred_at by year and partition by that same 
-- year-truncated occurred_at variable. Your final table should have three columns: 
-- One with the amount being added for each row, one for the truncated date, and a 
-- final column with the running total within each year.

select date_trunc('year', occurred_at), 
       standard_amt_usd,
	   sum(standard_amt_usd) over(partition by date_trunc('year', occurred_at) order by occurred_at) as total
from orders

-- ROW_NUMBER()
-- RANK()

-- Question 3
-- Ranking Total Paper Ordered by Account
-- Select the id, account_id, and total variable from the orders table, then create a column 
-- called total_rank that ranks this total amount of paper ordered (from highest to lowest) 
-- for each account using a partition. Your final table should have these four columns.
select id,
	   account_id,
       total,
       rank() over(partition by account_id order by total desc) as rank_num
from orders

-- Question 4
SELECT id,
       account_id,
       standard_qty,
       DENSE_RANK() OVER (PARTITION BY account_id) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id) AS max_std_qty
FROM orders

-- Alias window functions: WINDOW clause goes between WHERE and GROUP BY
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))

-- LAG function: It returns the value from a previous row to the current row in the table.
-- LEAD function: Return the value from the row following the current row in the table.
SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders 
 GROUP BY occurred_at
) table_1

-- NTILEs
-- Question 1
select account_id, 
	   occurred_at,
       standard_qty,
       ntile(4) over(partition by account_id order by standard_qty) as standard_quartile
from orders;

-- Question 2
select account_id, 
	   occurred_at,
       gloss_qty,
       ntile(2) over(partition by account_id order by gloss_qty) as gloss_half
from orders;

-- Question 3
select account_id, 
	   occurred_at,
       total_amt_usd,
       ntile(100) over(partition by account_id order by total_amt_usd) as total_percentile
from orders;