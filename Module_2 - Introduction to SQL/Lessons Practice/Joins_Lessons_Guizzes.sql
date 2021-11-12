-- Concept 

-- Question 1
select we.account_id,
	   we.occurred_at,
       we.channel,
       ac.name
from web_events as we
join accounts as ac
on ac.id=we.account_id
where ac.name='Walmart';

-- Question 2
select region.name as rn,
	   sales_reps.name as sn,
       accounts.name as an
from region
join sales_reps
on region.id=sales_reps.region_id
join accounts
on sales_reps.id=accounts.sales_rep_id;

-- Question 3
select region.name as region_name,
	   accounts.name as account_name,
       orders.total_amt_usd/(orders.total + 0.01) as unit_price
from orders
join accounts
on orders.account_id=accounts.id
join sales_reps
on sales_reps.id=accounts.sales_rep_id
join region
on region.id=sales_reps.region_id
