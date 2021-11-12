-- End of Lesson 2 Quiz

-- Question 1
select  region.name as rn,
		sales_reps.name as srn,
        accounts.name as an
from region
join sales_reps
on region.id=sales_reps.region_id
join accounts
on accounts.sales_rep_id=sales_reps.id
where region.name='Midwest'
order by accounts.name;

-- Question 2
select  region.name as rn,
		sales_reps.name as srn,
        accounts.name as an
from region
join sales_reps
on region.id=sales_reps.region_id
join accounts
on accounts.sales_rep_id=sales_reps.id
where region.name='Midwest' and sales_reps.name like 'S%'
order by accounts.name;

-- Question 3
select  region.name as rn,
		sales_reps.name as srn,
        accounts.name as an
from region
join sales_reps
on region.id=sales_reps.region_id
join accounts
on accounts.sales_rep_id=sales_reps.id
where region.name='Midwest'
order by accounts.name;

-- Question 4
select  region.name as rn,
		sales_reps.name as srn,
        accounts.name as an
from region
join sales_reps
on region.id=sales_reps.region_id
join accounts
on accounts.sales_rep_id=sales_reps.id
where region.name='Midwest' and sales_reps.name like '% K%'
order by accounts.name;

-- Question 5
select  region.name as rn,
		sales_reps.name as srn,
        accounts.name as an
from region
join sales_reps
on region.id=sales_reps.region_id
join accounts
on accounts.sales_rep_id=sales_reps.id
where region.name='Midwest'
order by accounts.name;

-- Question 6
select  region.name as region_name,
        accounts.name as account_name,
        orders.total_amt_usd/(orders.total+0.01) as unit_price
from orders
join accounts
on orders.account_id=accounts.id
join sales_reps
on accounts.sales_rep_id=sales_reps.id
join region
on sales_reps.region_id=region.id
where orders.standard_qty>100 and orders.poster_qty>50
order by unit_price desc;

-- Question 7
select distinct accounts.name,
	   web_events.channel
from accounts
left join web_events
on accounts.id=web_events.account_id
where accounts.id=1001;

-- Question 8
select web_events.occurred_at, 
	   accounts.name,
       orders.total,
       orders.total_amt_usd
from orders
join accounts
on orders.account_id=accounts.id
join web_events on accounts.id=web_events.account_id
where web_events.occurred_at between '01-01-2015' and '01-01-2016'
order by web_events.occurred_at desc;


-- Quiz 3
-- Question 1
select accounts.name,
	   orders.occurred_at
from accounts
join orders
on accounts.id=orders.account_id
order by orders.occurred_at
limit 1;

-- Question 2
select sum(orders.total_amt_usd),
	   accounts.name
from orders
join accounts
on accounts.id=orders.account_id
group by accounts.name;

-- Question 3
select web_events.channel,
	   accounts.name,
       web_events.occurred_at
from web_events
join accounts
on accounts.id=web_events.account_id
order by web_events.occurred_at desc
limit 1;

-- Question 4
select web_events.channel,
	   count(web_events.channel)
from web_events
group by web_events.channel;

-- Question 5
select accounts.primary_poc
from accounts
join web_events
on accounts.id=web_events.account_id
order by web_events.occurred_at desc
limit 1;

-- Question 6
select accounts.name, min(orders.total_amt_usd) as min_order
from orders
join accounts
on accounts.id=orders.account_id
group by accounts.name
order by min_order;

-- Question 7
select region.name, count(sales_reps.region_id) as count_reps
from region
join sales_reps
on region.id=sales_reps.region_id
group by region.name
order by count_reps;
