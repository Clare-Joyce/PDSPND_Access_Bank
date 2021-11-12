-- Note: Never use (= Null), use (IS Null)
-- COUNT does not consider rows that have NULL values.
-- SUM will ignore NULL values, nulls are treated as 0


-- aggregators only aggregate vertically - the values of a column.

-- Quiz 1
-- Question 1
select sum(poster_qty) as sum_poster_qty
from orders;

-- Question 2
select sum(standard_qty) as sum_standard_qty
from orders;

-- Question 3
select sum(total_amt_usd) as sum_total_amt_usd
from orders;

-- Question 4
select standard_amt_usd + gloss_amt_usd as amount_spent
from orders;

-- Question 5
select sum(standard_amt_usd)/sum(gloss_amt_usd) as standard_amt_usd_per_unit
from orders;

-- MIN and MAX are similar to COUNT in that they can be used on non-numerical columns
-- AVG returns the mean of the data

-- Check out how to find the MEDIAN(interview question)

-- Quiz 2
-- Question 1
select occurred_at
from orders
order by occurred_at
limit 1;

-- Question 2
select min(occurred_at)
from orders;

-- Question 3
select occurred_at
from web_events
order by occurred_at desc
limit 1;

-- Question 4
select max(occurred_at)
from web_events;

-- Question 5
select avg(standard_qty) avg_standard,
       avg(gloss_qty) avg_gloss,
       avg(poster_qty) avg_poster,
       avg(standard_amt_usd) avg_standard_usd,
       avg(gloss_amt_usd) avg_gloss_usd,
       avg(poster_amt_usd) avg_poster_usd
FROM orders;

-- Question 6: MEDIAN
-- 3457 because the table had 6912 records
select avg(total_amt_usd) as median
from (select *
      from (select total_amt_usd
            from orders
            order by total_amt_usd
            limit 3457) as t1
      order by total_amt_usd desc
      limit 2) as t2;

-- Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.
-- The GROUP BY always goes between WHERE and ORDER BY

-- Quiz 3
-- Question 1
select accounts.name,
	   avg(orders.standard_qty) as avg_sq,
       avg(orders.gloss_qty) as avg_gq,
       avg(orders.poster_qty) as avg_pq
from orders
join accounts
on accounts.id=orders.account_id
group by accounts.name;

-- Question 2
select accounts.name,
	   avg(orders.standard_amt_usd) as avg__amt_sq,
       avg(orders.gloss_amt_usd) as avg_amt_gq,
       avg(orders.poster_amt_usd) as avg_amt_pq
from orders
join accounts
on accounts.id=orders.account_id
group by accounts.name;

-- Question 3
select sales_reps.name,
	   web_events.channel,
       count(web_events.channel) as num
from sales_reps
join accounts
on sales_reps.id=accounts.sales_rep_id
join web_events
on accounts.id=web_events.account_id
group by sales_reps.name, web_events.channel
order by num desc;

-- Question 4
select region.name,
	   web_events.channel,
       count(web_events.channel) as num
from region
join sales_reps
on sales_reps.region_id=region.id
join accounts
on accounts.sales_rep_id=sales_reps.id
join web_events
on accounts.id=web_events.account_id
group by region.name, web_events.channel
order by num desc;


-- Quiz 4
-- Question 1
select accounts.name as a_name,
	   region.name as r_name,
       count(accounts.name) as num
from accounts
join sales_reps
on sales_reps.id=accounts.sales_rep_id
join region
on region.id=sales_reps.region_id
group by accounts.name, region.name
order by num desc;

-- Question 2: method 1
select distinct sales_reps.name,
	   accounts.sales_rep_id
from sales_reps
join accounts
on sales_reps.id=accounts.sales_rep_id;

-- Question 2: method 2
select sales_reps.name,
	   accounts.sales_rep_id, 
       count(accounts.sales_rep_id) as num
from sales_reps
join accounts
on sales_reps.id=accounts.sales_rep_id
group by sales_reps.name, accounts.sales_rep_id
order by num desc;

-- HAVING is the “clean” way to filter a query that has been aggregated
-- Anytime you think of using WHERE in aggregated data, chnage it to HAVING

-- Quiz 5
-- Question 1
select count(*)
from (select sales_reps.name,
             accounts.sales_rep_id, 
             count(accounts.sales_rep_id) as num
      from sales_reps
      join accounts
      on sales_reps.id=accounts.sales_rep_id
      group by sales_reps.name, accounts.sales_rep_id
      having count(accounts.sales_rep_id)>5
      order by num desc) as t1;

-- Question 2
select count(*)
from (select orders.account_id,
	   		 count(orders.account_id) as num_orders
      from orders
      group by orders.account_id
      having count(orders.account_id)>20) as t2;

-- Question 3
select accounts.name,
	   count(orders.*) as count_orders
from accounts
join orders
on accounts.id=orders.account_id
group by accounts.name
order by count_orders desc
limit 1;

-- Question 4
select orders.account_id, accounts.name,
	   sum(orders.total_amt_usd) as amt_spent
from orders
join accounts
on orders.account_id=accounts.id
group by orders.account_id, accounts.name
having sum(orders.total_amt_usd) >30000
order by amt_spent;

-- Question 5
select orders.account_id, accounts.name,
	   sum(orders.total_amt_usd) as amt_spent
from orders
join accounts
on orders.account_id=accounts.id
group by orders.account_id, accounts.name
having sum(orders.total_amt_usd)<1000
order by amt_spent;

-- Question 6
select orders.account_id, accounts.name,
	   sum(orders.total_amt_usd) as amt_spent
from orders
join accounts
on orders.account_id=accounts.id
group by orders.account_id, accounts.name
order by amt_spent desc
limit 1;

-- Question 7
select orders.account_id, accounts.name,
	   sum(orders.total_amt_usd) as amt_spent
from orders
join accounts
on orders.account_id=accounts.id
group by orders.account_id, accounts.name
order by amt_spent
limit 1;

-- Question 8
select accounts.name, 
	   accounts.id,
	   web_events.channel,
       count(web_events.channel) as num_channel_use
from accounts
join web_events
on accounts.id=web_events.account_id
where web_events.channel='facebook'
group by accounts.name, 
	     accounts.id,
	     web_events.channel
having count(web_events.channel)>6
order by num_channel_use;

-- Question 9
select accounts.name, 
	   accounts.id,
	   web_events.channel,
       count(web_events.channel) as num_channel_use
from accounts
join web_events
on accounts.id=web_events.account_id
where web_events.channel='facebook'
group by accounts.name, 
	     accounts.id,
	     web_events.channel
order by num_channel_use desc
limit 1;

-- Question 10
select accounts.name, 
	   accounts.id,
	   web_events.channel,
       count(web_events.channel) as num_channel_use
from accounts
join web_events
on accounts.id=web_events.account_id
group by accounts.name, 
	     accounts.id,
	     web_events.channel
order by num_channel_use desc;


-- DATE_TRUNC allows you to truncate your date to a particular part of your date-time column
-- DATE_PART can be useful for pulling a specific portion of a date, but notice pulling month
-- or day of the week (dow) means that you are no longer keeping the years in order


-- Quiz 6
-- Question 1
select date_part('year', occurred_at) as year,
	   sum(total_amt_usd) as total
from orders
group by  date_part('year', occurred_at)
order by total desc;

-- Question 2
select date_trunc('month', occurred_at) as month,
	   sum(total_amt_usd) as total
from orders
group by  date_trunc('month', occurred_at)
order by total desc;

-- Question 2: After checking if months are evenly distributed
select date_part('month', occurred_at) as month,
	   sum(total_amt_usd) as total
from orders
where occurred_at between '2014-01-01' and '2017-01-01'
group by  date_part('month', occurred_at)
order by total desc;

-- Question 3
select date_part('year', occurred_at) as year,
	   count(*) as total
from orders
group by  date_part('year', occurred_at)
order by total desc
limit 1;

-- Question 4
select date_part('month', occurred_at) as year,
	   count(*) as total
from orders
where occurred_at between '2014-01-01' and '2017-01-01'
group by  date_part('month', occurred_at)
order by total desc
limit 1;

-- Question 5
select date_trunc('month', orders.occurred_at) as year_month,
       sum(orders.gloss_amt_usd) as sum_spent,
accounts.name
from orders
join accounts
on accounts.id=orders.account_id
where accounts.name='Walmart'
group by date_trunc('month', orders.occurred_at), accounts.name
order by sum_spent desc
limit 1;


-- The CASE statement always goes in the SELECT clause.
-- CASE must include the following components: WHEN, THEN, and END.
-- ELSE is an optional component to catch cases that didn’t meet any
-- of the other previous CASE conditions

                                            