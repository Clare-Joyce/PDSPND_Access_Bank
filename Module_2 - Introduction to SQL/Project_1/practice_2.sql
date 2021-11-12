-- Question 1
select  concat(actor.first_name, ' ', actor.last_name) as full_name,
        film.title,
        film.length,
        case when film.length <=60 then '1 hour or less'
        when film.length >60 and film.length<=120 then 'Between 1-2 hours'
        when film.length >120 and film.length<=180 then 'Between 2-3 hours'
        when film.length >180 then 'More than 3 hours'
        end as length_cat
from actor
join film_actor
on actor.actor_id = film_actor.actor_id
join film
on film.film_id = film_actor.film_id


-- Question 2
 with new_table as (select  concat(actor.first_name, ' ', actor.last_name) as full_name,
                            film.title as title,
                            film.length,
                            case when film.length <=60 then '1 hour or less'
                            when film.length >60 and film.length<=120 then 'Between 1-2 hours'
                            when film.length >120 and film.length<=180 then 'Between 2-3 hours'
                            when film.length >180 then 'More than 3 hours'
                            end as length_cat
                    from actor
                    join film_actor
                    on actor.actor_id = film_actor.actor_id
                    join film
                    on film.film_id = film_actor.film_id)
select length_cat, count(title)
from new_table
group by length_cat