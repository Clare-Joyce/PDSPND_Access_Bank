
-- Quiz 1
select accounts.*, sales_reps.*
from accounts
full outer join sales_reps
on accounts.sales_rep_id=sales_reps.id


-- to generate only unmatched rows
select accounts.*, sales_reps.*
from accounts
full outer join sales_reps
on accounts.sales_rep_id=sales_reps.id
where accounts.sales_rep_id is NULL or sales_reps.id is NULL


-- NOTE
-- the join clause is evaluated before the where clause

-- join with conditions
select accounts.name as a_name,
	   accounts.primary_poc,
	   sales_reps.name as sr_name
from accounts
left join sales_reps
on accounts.sales_rep_id=sales_reps.id
and accounts.primary_poc < sales_reps.name


-- Self Joins
SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at, 
       w1.channel as w1_channel,
       w2.channel as w2_channel
  FROM web_events as w1
 LEFT JOIN web_events as w2
   ON w1.account_id = w2.account_id
  AND w2.occurred_at > w1.occurred_at
  AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 days'
ORDER BY w1.account_id, w1.occurred_at


-- UNION
-- Stack one table on top of another

-- SQL's two strict rules for appending data:

-- Both tables must have the same number of columns.
-- Those columns must have the same data types in the same order as the first table.
-- the column nams do not have to be the same
-- UNION removes duplicates.
-- UNION ALL does not remove duplicates.

-- UNION only appends distinct values. More specifically, when you use UNION, the dataset 
-- is appended, and any rows in the appended table that are exactly identical to rows in 
-- the first table are dropped. If you’d like to append all the values from the second 
-- table, use UNION ALL. You’ll likely use UNION ALL far more often than UNION.

-- Note accounts has 351 rows

-- Q1: returns 351 rows
select * 
from accounts
union
select *
from accounts

-- Q2: returns 702 rows
select * 
from accounts
union all
select *
from accounts

-- Q3
-- union and union all retun same results
select * 
from accounts 
where name='Walmart'
union
select *
from accounts
where name='Disney'

-- Q4: another version of Q3
select * 
from accounts 
where name='Walmart' or name='Disney'

-- What affects query run time  :::Worry about the accuracy of your work before worrying about run speed:::
-- * Table size
-- * Joins
-- * Aggregations

-- how to speed up queries
-- * filtering 
-- * limiting time window
-- * subsetting and testing
-- * pre-Aggregations