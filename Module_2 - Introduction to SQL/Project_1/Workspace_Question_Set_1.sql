-- Question 1

-- We want to understand more about the movies that families are watching. 
-- The following categories are considered family movies: Animation, Children,
-- Classics, Comedy, Family and Music.

-- Create a query that lists each movie, the film category it is classified in,
-- and the number of times it has been rented out.

--  Category, Film_Category, Inventory, Rental and --- Film
select f.title as film_title,
	   c.name as category_name,
       count(*) as rental_count
	   
from category c
join film_category fc
on c.category_id=fc.category_id
join inventory i
on fc.film_id=i.film_id
join film f
on f.film_id=fc.film_id
join rental r
on r.inventory_id=i.inventory_id
where c.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family','Music')
group by f.title,c.name
order by category_name, film_title



-- Question 2
-- category, film_category, and film tables
select f.title,
	   c.name,
	   f.rental_duration,
       ntile(4) over (order by f.rental_duration) as standard_quartile
       
from category c
join film_category fc
on c.category_id=fc.category_id
join film f
on fc.film_id=f.film_id
where c.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family','Music')


-- Question 3
with q2_tab as (select f.title,
                       c.name,
                       f.rental_duration,
                       ntile(4) over (order by f.rental_duration) as standard_quartile
                    
                from category c
                join film_category fc
                on c.category_id=fc.category_id
                join film f
                on fc.film_id=f.film_id
                where c.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family','Music')
                )
select name as category_name,
       standard_quartile,
       count(*)
from q2_tab
group by name, standard_quartile
order by category_name, standard_quartile