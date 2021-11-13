
-- Question 1
/* We want to find out how the two stores compare in their count of rental orders during every month
for all the years we have data for. Write a query that returns the store ID for the store, the year
and month and the number of rental orders each store has fulfilled for that month. Your table should
include a column for each of the following: year, month, store ID and count of rental orders fulfilled
during that month.*/
SELECT   store.store_id,
         DATE_PART('month',r.rental_date) AS rental_month,
         DATE_PART('year',r.rental_date)  AS rental_year,
         COUNT(*)                         AS rental_count
FROM     store
JOIN     staff
ON       store.store_id=staff.store_id
JOIN     rental r
ON       r.staff_id=staff.staff_id
GROUP BY 1,
         2,
         3
ORDER BY 4 DESC


-- Question 2
/* We would like to know who were our top 10 paying customers, how many payments they made on a
monthly basis during 2007, and what was the amount of the monthly payments. Can you write a
query to capture the customer name, month and year of payment, and total payment amount
for each month by these top 10 paying customers?*/

WITH table_1 AS
         (
                  SELECT   CONCAT(cus.first_name, ' ', cus.last_name) AS name
                  FROM     customer cus
                  JOIN     payment p
                  ON       cus.customer_id=p.customer_id
                  GROUP BY 1
                  ORDER BY SUM(p.amount) DESC limit 10)

SELECT   DATE_TRUNC('month', p.payment_date)                 AS pay_month,
         CONCAT(cus.first_name, ' ', cus.last_name)          AS full_name,
         SUM(p.amount)                                       AS pay_amount,
         COUNT(*)                                            AS pay_count_per_month
FROM     customer cus
JOIN     payment p
ON       cus.customer_id=p.customer_id
JOIN     table_1 t1
ON       t1.name=CONCAT(cus.first_name, ' ', cus.last_name)
WHERE    DATE_PART('year', p.payment_date)=2007
GROUP BY 1,
         2
ORDER BY 2,
         1;



-- Question 3
/* Finally, for each of these top 10 paying customers, I would like to find out the difference across their
monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each
successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful
if you can identify the customer name who paid the most difference in terms of payments.*/
WITH table_1 AS
(
         SELECT   CONCAT(cus.first_name, ' ', cus.last_name) AS NAME
         FROM     customer cus
         JOIN     payment p
         ON       cus.customer_id=p.customer_id
         GROUP BY 1
         ORDER BY SUM(p.amount) DESC LIMIT 10),

table_2 AS
(
         SELECT   DATE_TRUNC('month', p.payment_date)                 AS pay_month,
                  CONCAT(cus.first_name, ' ', cus.last_name)          AS full_name,
                  SUM(p.amount)                                       AS pay_amount,
                  COUNT(*)                                            AS pay_count_per_month
         FROM     customer cus
         JOIN     payment p
         ON       cus.customer_id=p.customer_id
         JOIN     table_1 t1
         ON       t1.name=CONCAT(cus.first_name, ' ', cus.last_name)
         WHERE    DATE_PART('year', p.payment_date)=2007
         GROUP BY 1,
                  2
         ORDER BY 2,
                  1),
 
table_3 AS
(
       SELECT pay_month,
              full_name,
              pay_amount,
              LAG(pay_amount) OVER (PARTITION BY full_name) AS previous_month_pay
       FROM   table_2)
SELECT *,
       (pay_amount - previous_month_pay) AS monthly_difference
FROM   table_3


-- Question 3 - Check your solution:
/*The customer Eleanor Hunt paid the maximum difference of $64.87 during March 2007 from
$22.95 in February of 2007.*/

WITH table_1 AS
       (
                SELECT   CONCAT(cus.first_name, ' ', cus.last_name) AS name
                FROM     customer cus
                JOIN     payment p
                ON       cus.customer_id=p.customer_id
                GROUP BY 1
                ORDER BY SUM(p.amount) DESC limit 10),
       table_2 AS
       (
                SELECT   DATE_TRUNC('month', p.payment_date)                 AS pay_month,
                         CONCAT(cus.first_name, ' ', cus.last_name)          AS full_name,
                         SUM(p.amount)                                       AS pay_amount,
                         COUNT(*)                                            AS pay_count_per_month
                FROM     customer cus
                JOIN     payment p
                ON       cus.customer_id=p.customer_id
                JOIN     table_1 t1
                ON       t1.name=CONCAT(cus.first_name, ' ', cus.last_name)
                WHERE    DATE_PART('year', p.payment_date)=2007
                GROUP BY 1,
                         2
                ORDER BY 2,
                         1),
       table_3 AS
       (
              SELECT pay_month,
                     full_name,
                     pay_amount,
                     LAG(pay_amount) OVER (PARTITION BY full_name) AS previous_month_pay
              FROM   table_2)
SELECT   *,
         (pay_amount - previous_month_pay) AS monthly_difference
FROM     table_3
ORDER BY 5 DESC