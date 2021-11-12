-- SubQueries

-- Quiz 1
-- Question 1
select date_trunc('day', occurred_at) as day,
	   channel,		
	   count(*) as num_events
from web_events
group by date_trunc('day',web_events.occurred_at), channel
order by num_events desc;

-- Question 2
select channel, avg(num_events) as avg_num
from (
    select date_trunc('day', occurred_at) as day,
           channel,
           count(channel) as num_events
    from web_events
    group by channel,
             date_trunc('day', occurred_at)       
    ) as t1
group by channel
order by avg_num desc

-- Note that you should not include an alias when you write a subquery in a conditional statement.
-- This is because the subquery is treated as an individual value (or set of values in the IN case)
-- rather than as a table.

-- Quiz 2
-- Question 1
select *
from orders
where date_trunc('month', occurred_at) = (select date_trunc('month', min(occurred_at))
                                          from orders)

-- Question 2
select date_part('month', occurred_at),
		avg(standard_qty) as avg_std, 
        avg(gloss_qty) as avg_gls,
        avg(poster_qty) as avg_pos
from (
      select *
      from orders
      where date_trunc('month', occurred_at) = (select date_trunc('month', min(occurred_at))
      from orders)) as t2
group by date_part('month', occurred_at)


-- Quiz 3
-- Question 1: Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

select t3.sales_rep_name,
       t2.region_name,
       t2.total
from (
        select region_name,
               max(total) as total
        from (
                select sales_reps.name as sales_rep_name,
                       region.name as region_name,
                       sum(orders.total_amt_usd) as total
                from sales_reps
                join region
                on sales_reps.region_id=region.id
                join accounts
                on sales_reps.id=accounts.sales_rep_id
                join orders
                on accounts.id=orders.account_id
                group by sales_reps.name, region.name
             ) as t1
        group by region_name
      ) as t2

join (
        select sales_reps.name as sales_rep_name,
        region.name as region_name,
        sum(orders.total_amt_usd) as total
        from sales_reps
        join region
        on sales_reps.region_id=region.id
        join accounts
        on sales_reps.id=accounts.sales_rep_id
        join orders
        on accounts.id=orders.account_id
        group by sales_reps.name, region.name
     ) as t3
on t2.total=t3.total


-- Question 2: For the region with the largest sales total_amt_usd, how many total orders were placed?

select region.name, 
       count(orders.*)
from region
join sales_reps
on region.id=sales_reps.region_id
join accounts
on accounts.sales_rep_id=sales_reps.id
join orders 
on orders.account_id=accounts.id
group by region.name
having region.name = (select region_name
                      from (
                            select region.name as region_name,
                                   sum(orders.total_amt_usd) as total
                            from sales_reps
                            join region
                            on sales_reps.region_id=region.id
                            join accounts
                            on sales_reps.id=accounts.sales_rep_id
                            join orders
                            on accounts.id=orders.account_id
                            group by region.name
                            ) as t1
                       order by t1.total desc
                       limit 1);

-- Question 3: How many accounts had more total purchases than the account name which has
--             bought the most standard_qty paper throughout their lifetime as a customer?

select count(*)
from(
    select accounts.name,
           sum(orders.total) as sum_tot_2
    from accounts
    join orders
    on accounts.id=orders.account_id
    group by accounts.name      
    having sum(orders.total) > (select sum_tot
                                from (
                                    select accounts.name,
                                        sum(orders.standard_qty) as sum_std,
                                        sum(orders.total) as sum_tot
                                    from accounts
                                    join orders
                                    on accounts.id=orders.account_id
                                    group by accounts.name
                                    order by sum_std desc
                                    ) as t1
                                limit 1
                                ) 
    ) as t2


-- Question 4: For the customer that spent the most (in total over their lifetime as a customer)
--             total_amt_usd, how many web_events did they have for each channel?
select accounts.name,
	   web_events.channel,
       count(web_events.channel) as channel_use
from accounts
join web_events
on accounts.id=web_events.account_id
group by accounts.name, web_events.channel
having accounts.name =  (select name
                        from (
                            select accounts.name,
                                sum(orders.total_amt_usd) as sum_tot,
                                count(web_events.*) as num_events
                            from accounts
                            join orders
                            on accounts.id=orders.account_id
                            join web_events
                            on accounts.id=web_events.account_id
                            group by accounts.name
                            order by sum_tot desc
                             ) as t1
                        limit 1
                        )
order by channel_use desc

-- Question 5: What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

select avg(sum_tot)
from(
    select accounts.name,
        sum(orders.total_amt_usd) as sum_tot
    from accounts
    join orders
    on accounts.id=orders.account_id
    group by accounts.name
    order by sum_tot desc
    limit 10
    ) as t1

-- Question 6: What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent
--             more per order, on average, than the average of all orders.

select avg(avg_tot)
from (
    select accounts.name,
           avg(orders.total_amt_usd) as avg_tot
    from accounts
    join orders
    on accounts.id=orders.account_id
    group by accounts.name
    having avg(orders.total_amt_usd)>(select avg(orders.total_amt_usd) 
                                     from orders
                                     )
    ) as t2



-- WITH clause for subqueries

-- When creating multiple tables using WITH, you add a comma after every table except the last table leading to your final query.
-- The new table name is always aliased using table_name AS, which is followed by your query nested between parentheses.


-- Quiz 4
-- Question 1: Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

with t3 as (select sales_reps.name as sales_rep_name,
                    region.name as region_name,
                    sum(orders.total_amt_usd) as total
            from sales_reps
            join region
            on sales_reps.region_id=region.id
            join accounts
            on sales_reps.id=accounts.sales_rep_id
            join orders
            on accounts.id=orders.account_id
            group by sales_reps.name, region.name
            ),

     t1 as (select sales_reps.name as sales_rep_name,
                   region.name as region_name,
                   sum(orders.total_amt_usd) as total
            from sales_reps
            join region
            on sales_reps.region_id=region.id
            join accounts
            on sales_reps.id=accounts.sales_rep_id
            join orders
            on accounts.id=orders.account_id
            group by sales_reps.name, region.name
            ),
     t2 as (select region_name,
                max(total) as total
        from t1
        group by region_name)

select t3.sales_rep_name,
       t2.region_name,
       t2.total
from  t2
join t3
on t2.total=t3.total


-- Question 2: For the region with the largest sales total_amt_usd, how many total orders were placed?
with t1 as (select region.name as region_name,
                   sum(orders.total_amt_usd) as total
            from sales_reps
            join region
            on sales_reps.region_id=region.id
            join accounts
            on sales_reps.id=accounts.sales_rep_id
            join orders
            on accounts.id=orders.account_id
            group by region.name
            )

select region.name, 
       count(orders.*)
from region
join sales_reps
on region.id=sales_reps.region_id
join accounts
on accounts.sales_rep_id=sales_reps.id
join orders 
on orders.account_id=accounts.id
group by region.name
having region.name = (select region_name
                      from t1
                      order by t1.total desc
                      limit 1);


-- Question 3: How many accounts had more total purchases than the account name which has
--             bought the most standard_qty paper throughout their lifetime as a customer?
with t1 as (
            select accounts.name,
                sum(orders.standard_qty) as sum_std,
                sum(orders.total) as sum_tot
            from accounts
            join orders
            on accounts.id=orders.account_id
            group by accounts.name
            order by sum_std desc
            ),
    
      t2 as (select accounts.name,
                  sum(orders.total) as sum_tot_2
            from accounts
            join orders
            on accounts.id=orders.account_id
            group by accounts.name      
            having sum(orders.total) > (select sum_tot
                                        from t1
                                        limit 1
                                        )
            ) 

select count(*)
from t2;


-- Question 4: For the customer that spent the most (in total over their lifetime as a customer)
--             total_amt_usd, how many web_events did they have for each channel?

with  t1 as (
            select accounts.name,
                sum(orders.total_amt_usd) as sum_tot,
                count(web_events.*) as num_events
            from accounts
            join orders
            on accounts.id=orders.account_id
            join web_events
            on accounts.id=web_events.account_id
            group by accounts.name
            order by sum_tot desc
            )

select accounts.name,
	   web_events.channel,
       count(web_events.channel) as channel_use
from accounts
join web_events
on accounts.id=web_events.account_id
group by accounts.name, web_events.channel
having accounts.name =  (select name
                        from  t1
                        limit 1
                        )
order by channel_use desc;

-- Question 5: What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
with t1 as (
            select accounts.name,
                sum(orders.total_amt_usd) as sum_tot
            from accounts
            join orders
            on accounts.id=orders.account_id
            group by accounts.name
            order by sum_tot desc
            limit 10
            ) 
select avg(sum_tot)
from t1;

-- Question 6: What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent
--             more per order, on average, than the average of all orders.
with t2 as (
            select accounts.name,
                avg(orders.total_amt_usd) as avg_tot
            from accounts
            join orders
            on accounts.id=orders.account_id
            group by accounts.name
            having avg(orders.total_amt_usd) >  (select avg(orders.total_amt_usd) 
                                                from orders
                                                ))
select avg(avg_tot)
from t2;