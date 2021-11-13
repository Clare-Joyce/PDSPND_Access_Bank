
-- Question 1
/* We want to understand more about the movies that families are watching.
The following categories are considered family movies: Animation, Children,
Classics, Comedy, Family and Music.
Create a query that lists each movie, the film category it is classified in,
and the number of times it has been rented out.
Category, Film_Category, Inventory, Rental and --- Film */
SELECT   f.title  AS film_title,
         c.name   AS category_name,
         COUNT(*) AS rental_count
FROM     category c
JOIN     film_category fc
ON       c.category_id=fc.category_id
JOIN     inventory i
ON       i.film_id=fc.film_id
JOIN     film f
ON       f.film_id=fc.film_id
JOIN     rental r
ON       i.inventory_id=r.inventory_id
WHERE    c.name IN ('Animation',
                    'Children',
                    'Classics',
                    'Comedy',
                    'Family',
                    'Music')
GROUP BY f.title,
         c.name
ORDER BY category_name,
         film_title;


-- Question 2
/* category, film_category, and film tables
Now we need to know how the length of rental duration of these family-friendly
movies compares to the duration that all movies are rented for. Can you provide
a table with the movie titles and divide them into 4 levels (first_quarter,
second_quarter, third_quarter, and final_quarter) based on the quartiles (25%,
50%, 75%) of the rental duration for movies across all categories? Make sure to
also indicate the category that these family-friendly movies fall into. */
SELECT   f.title,
         c.name,
         f.rental_duration,
         NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
FROM     category c
JOIN     film_category fc
ON       c.category_id=fc.category_id
JOIN     film f
ON       f.film_id=fc.film_id
WHERE    c.name IN ('Animation',
                    'Children',
                    'Classics',
                    'Comedy',
                    'Family',
                    'Music');

-- Question 3
/* Finally, provide a table with the family-friendly film category, each of the quartiles,
and the corresponding count of movies within each combination of film category for each
corresponding rental duration category. The resulting table should have three columns:

* Category
* Rental length category
* Count */
WITH q2_tab AS
         (
                  SELECT   f.title,
                           c.name,
                           f.rental_duration,
                           NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
                  FROM     category c
                  JOIN     film_category fc
                  ON       c.category_id=fc.category_id
                  JOIN     film f
                  ON       f.film_id=fc.film_id
                  WHERE    c.name IN ('Animation',
                                      'Children',
                                      'Classics',
                                      'Comedy',
                                      'Family',
                                      'Music') )
SELECT   name AS category_name,
         standard_quartile,
         Count(*)
FROM     q2_tab
GROUP BY name,
         standard_quartile
ORDER BY category_name,
         standard_quartile