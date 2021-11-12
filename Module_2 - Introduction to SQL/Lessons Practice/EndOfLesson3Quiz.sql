-- Question 1
select account_id,
	   total_amt_usd,
	   case when total_amt_usd>=3000 then 'larger'
            when total_amt_usd<3000 then 'smaller'
            end as category
from orders;

-- Question 2
select category, count(*)
from
    (select account_id,
           total,
           case when total>=2000 then 'At Least 2000'
                when total between 1000 and 2000 then 'Between 1000 and 2000'
                when total<1000 then 'Less than 1000'
                end as category
    from orders) as t1
group by category;

-- Question 3
select accounts.name,
       sum(orders.total_amt_usd) as amt_usd,
       case when sum(orders.total_amt_usd)>=200000 then 'higher'
       		when sum(orders.total_amt_usd) between 100000 and 200000 then 'middle'
            when sum(orders.total_amt_usd)<100000 then 'lower'
            end as level
from orders
join accounts
on accounts.id=orders.account_id
group by accounts.name
order by amt_usd desc;

-- Question 4
select accounts.name,
       sum(orders.total_amt_usd) as amt_usd,
       case when sum(orders.total_amt_usd)>=200000 then 'higher'
       		when sum(orders.total_amt_usd) between 100000 and 200000 then 'middle'
            when sum(orders.total_amt_usd)<100000 then 'lower'
            end as level
from orders
join accounts
on accounts.id=orders.account_id
where orders.occurred_at>='2016-01-01'
group by accounts.name
order by amt_usd desc;

-- Question 5
select sales_reps.name,
	   count(orders.*) as num_orders,
       case when count(orders.*)>200 then 'top'
       else 'low'
       end as performance
from sales_reps
join accounts
on sales_reps.id=accounts.sales_rep_id
join orders
on accounts.id=orders.account_id
group by sales_reps.name
order by num_orders desc;
    

-- Question 6
select sales_reps.name,
	   count(orders.*) as num_orders,
       sum(orders.total_amt_usd) as total,
       case when count(orders.*)>200 or sum(orders.total_amt_usd)>750000 then 'top'
        when count(orders.*)> 150 or sum(orders.total_amt_usd)>500000 then 'middle'
       else 'low'
       end as performance
from sales_reps
join accounts
on sales_reps.id=accounts.sales_rep_id
join orders
on accounts.id=orders.account_id
group by sales_reps.name
order by total desc;
    