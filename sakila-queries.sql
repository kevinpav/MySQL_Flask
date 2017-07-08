-- Queries

-- 1. What query would you run to get all the customers inside city_id = 312?
-- Your query should return customer first name, last name, email, and address.
select t.city_id, t.city, c.first_name, c.last_name, c.email, a.address
from customer c
join city t, address a
where c.address_id = a.address_id
and a.city_id = t.city_id
and t.city_id = 312;

-- 2. What query would you run to get all comedy films?
-- Your query should return film title, description, release year, rating, special features, and genre (category).
select f.film_id, f.title, f.description, f.release_year, f.rating, f.special_features, g.name genre
from film f
join film_category fc, category g
where f.film_id = fc.film_id
and fc.category_id = g.category_id 
and g.name = 'Comedy';

-- Alternate form
select f.film_id, f.title, f.description, f.release_year, f.rating, f.special_features, g.name genre
from film f, film_category fc, category g
where f.film_id = fc.film_id
and fc.category_id = g.category_id 
and g.name = 'Comedy';

-- 3. What query would you run to get all the films joined by actor_id=5?
-- Your query should return the actor id, actor name, film title, description, and release year.
select a.actor_id, concat_ws(' ', a.first_name, a.last_name) actor_name, f.film_id, f.title, f.description, f.release_year
from actor a
join film f, film_actor fa
where a.actor_id = fa.actor_id
and fa.film_id = f.film_id
and a.actor_id = 5;

-- 4. What query would you run to get all the customers in store_id = 1 and inside these cities (1, 42, 312 and 459)?
-- Your query should return customer first name, last name, email, and address.
select c.store_id, a.city_id, c.first_name, c.last_name, a.address
from customer c
join address a
where c.address_id = a.address_id
and c.store_id = 1
and a.city_id in(1,42,312,459);

-- 5. What query would you run to get all the films with a "rating = G"
-- and "special feature = behind the scenes", joined by actor_id = 15?
-- Your query should return the film title, description, release year, rating, and special feature.
-- Hint: You may use LIKE function in getting the 'behind the scenes' part.
select f.title, f.description, f.release_year, f.rating, f.special_features
from film f
join film_actor fa
where f.film_id = fa.film_id
and fa.actor_id = 15
and f.special_features like '%Behind the Scenes%';

-- 6. What query would you run to get all the actors that joined in the film_id = 369?
-- Your query should return the film_id, title, actor_id, and actor_name.
select f.film_id, f.title, fa.actor_id, concat_ws(' ', a.first_name, a.last_name) actor_name
from film f
join film_actor fa, actor a
where f.film_id = fa.film_id
and fa.actor_id = a.actor_id
and f.film_id = 369;

-- 7. What query would you run to get all drama films with a rental rate of 2.99?
-- Your query should return film title, description, release year, rating, special features, and genre (category).
select f.film_id, f.title, f.description, f.release_year, f.rating, f.special_features, g.name, f.rental_rate
from film f
join film_category fc, category g
where f.film_id = fc.film_id
and fc.category_id = g.category_id
and f.rental_rate = 2.99;

-- 8. What query would you run to get all the action films which are joined by SANDRA KILMER?
-- Your query should return film title, description, release year, rating, special features, genre (category),
-- and actor's first name and last name.
select a.actor_id, concat_ws(' ', a.first_name, a.last_name) actor_name, f.film_id, f.title, f.description,
	f.release_year, f.rating, f.special_features, g.name
from actor a
join film f, film_actor fa, film_category fc, category g
where a.actor_id = fa.actor_id
and fa.film_id = f.film_id
and f.film_id = fc.film_id
and fc.category_id = g.category_id
and g.name = 'Action'
and a.first_name = 'SANDRA'
and a.last_name = 'KILMER';
