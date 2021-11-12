
-- Question 1
select  concat(actor.first_name, ' ', actor.last_name) as full_name,
        film.title,
        film.description,
        film.length
from actor
join film_actor
on actor.actor_id = film_actor.actor_id
join film
on film.film_id = film_actor.film_id;

-- Question 2
select  concat(actor.first_name, ' ', actor.last_name) as full_name,
        film.title,
        film.description,
        film.length
from actor
join film_actor
on actor.actor_id = film_actor.actor_id
join film
on film.film_id = film_actor.film_id
where film.length>60;

-- Question 3
select  actor.actor_id, 
        concat(actor.first_name, ' ',  actor.last_name) as full_name,
        count(film.title) as num_movies
from actor
join film_actor
on actor.actor_id = film_actor.actor_id
join film
on film.film_id = film_actor.film_id
group by actor.actor_id
order by num_movies desc