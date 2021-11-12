-- Question 1
-- We want to find out how the two stores compare in their count of rental orders during every month
-- for all the years we have data for. Write a query that returns the store ID for the store, the year
-- and month and the number of rental orders each store has fulfilled for that month. Your table should
-- include a column for each of the following: year, month, store ID and count of rental orders fulfilled
-- during that month.

select store.store_id,
	   date_part('month',r.rental_date) as rental_month,
       date_part('year',r.rental_date) as rental_year,
       count(*) as rental_count
from store
join staff
on store.store_id=staff.store_id
join rental r
on r.staff_id=staff.staff_id
group by 1, 2, 3
order by 4 desc


-- Question 2
-- We would like to know who were our top 10 paying customers, how many payments they made on a
-- monthly basis during 2007, and what was the amount of the monthly payments. Can you write a
-- query to capture the customer name, month and year of payment, and total payment amount
-- for each month by these top 10 paying customers?

with table_1 as (select concat(cus.first_name, ' ', cus.last_name) as name
                 from customer cus
                 join payment p
                 on cus.customer_id=p.customer_id
                 group by 1
                 order by sum(p.amount) desc
                 limit 10)

select date_trunc('month', p.payment_date) as pay_month,
	   concat(cus.first_name, ' ', cus.last_name) as full_name,
       sum(p.amount) as pay_amount,
       count(*) as pay_count_per_month
from customer cus
join payment p
on cus.customer_id=p.customer_id
join table_1 t1
on t1.name=concat(cus.first_name, ' ', cus.last_name)
where date_part('year', p.payment_date)=2007
group by 1, 2
order by 2, 1;


-- Question 3
-- Finally, for each of these top 10 paying customers, I would like to find out the difference across their
-- monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each
-- successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful
-- if you can identify the customer name who paid the most difference in terms of payments.

with table_1 as (select concat(cus.first_name, ' ', cus.last_name) as name
                 from customer cus
                 join payment p
                 on cus.customer_id=p.customer_id
                 group by 1
                 order by sum(p.amount) desc
                 limit 10),

     table_2 as (select date_trunc('month', p.payment_date) as pay_month,
                        concat(cus.first_name, ' ', cus.last_name) as full_name,
                        sum(p.amount) as pay_amount,
                        count(*) as pay_count_per_month
                 from customer cus
                 join payment p
                 on cus.customer_id=p.customer_id
                 join table_1 t1
                 on t1.name=concat(cus.first_name, ' ', cus.last_name)
                 where date_part('year', p.payment_date)=2007
                 group by 1,2
                 order by 2, 1),

     table_3 as (select pay_month,
                        full_name,
                        pay_amount,
                        lag(pay_amount) over (partition by full_name) as previous_month_pay
                 from table_2)

select *,
	(pay_amount - previous_month_pay) as monthly_difference
from table_3


-- Question 3 - Check your solution:
-- The customer Eleanor Hunt paid the maximum difference of $64.87 during March 2007 from $22.95 in February of 2007.
with table_1 as (select concat(cus.first_name, ' ', cus.last_name) as name
                 from customer cus
                 join payment p
                 on cus.customer_id=p.customer_id
                 group by 1
                 order by sum(p.amount) desc
                 limit 10),

     table_2 as (select date_trunc('month', p.payment_date) as pay_month,
                        concat(cus.first_name, ' ', cus.last_name) as full_name,
                        sum(p.amount) as pay_amount,
                        count(*) as pay_count_per_month
                 from customer cus
                 join payment p
                 on cus.customer_id=p.customer_id
                 join table_1 t1
                 on t1.name=concat(cus.first_name, ' ', cus.last_name)
                 where date_part('year', p.payment_date)=2007
                 group by 1,2
                 order by 2, 1),

     table_3 as (select pay_month,
                        full_name,
                        pay_amount,
                        lag(pay_amount) over (partition by full_name) as previous_month_pay
                 from table_2)

select *,
	(pay_amount - previous_month_pay) as monthly_difference
from table_3
order by 5 desc