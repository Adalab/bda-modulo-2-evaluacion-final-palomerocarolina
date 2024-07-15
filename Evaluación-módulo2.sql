USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title
FROM film;


-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT*FROM film; -- primero veo toda la tabla para ver en qué columna está lo que me piden.


SELECT title
FROM film 
WHERE rating = "PG-13";


-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

 -- SELECT*FROM film;

SELECT title, description
FROM film 
WHERE description LIKE "%amazing%";


-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

 -- SELECT*FROM film;

SELECT title
FROM film 
WHERE`length` > 120;


-- 5. Recupera los nombres de todos los actores.

 -- SELECT*FROM actor;

SELECT first_name 
FROM actor;


-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name, last_name
FROM actor
WHERE last_name = "Gibson";


-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;


-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title
FROM film
WHERE rating <> "R" "PG-13";


-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT rating, COUNT(*) AS total_peliculas
FROM film
GROUP BY rating; -- para que nos agrupe todas las filas que tienen el mismo valor en la columna rating.


-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT customer_id, first_name, last_name, COUNT(*) AS rentals_per_customer
FROM customer
INNER JOIN rental
USING (customer_id)
GROUP BY customer_id;


-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

-- SELECT*FROM sakila.category -- ahora quiero llegar hasta el rental_id para hacer el recuento

SELECT name AS Categoria, COUNT(r.rental_id) AS Total_peliculas_alquiladas
FROM category c 
	INNER JOIN film_category fc USING (category_id)
	INNER JOIN film f USING (film_id)
	INNER JOIN inventory i USING (film_id)
	INNER JOIN rental r USING (inventory_id)
GROUP BY Categoria;


-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT AVG(`length`), rating
FROM film
GROUP BY rating;


-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT first_name,last_name 
FROM actor AS a
	INNER JOIN film_actor USING (actor_id)
	INNER JOIN film USING (film_id)
WHERE title = "Indian Love";


-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title
FROM film
WHERE description LIKE "%dog%" OR description LIKE "%cat%";


-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.

SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (
	SELECT actor_id 
	FROM film_actor);

	-- otra forma de hacerlo
	SELECT first_name, last_name
	FROM actor
	INNER JOIN film_actor USING (actor_id)
	WHERE actor_id IS NULL;


-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title
FROM film 
WHERE release_year BETWEEN "2005" AND "2010";


-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT title
FROM film
	INNER JOIN film_category USING(film_id)
WHERE category_id = 8;

	-- consulto las tablas con las que se relaciona la tabla film para ver de dónde puedo sacar la categoría.
	-- SELECT*FROM sakila.film_category;
	-- SELECT*FROM sakila.category -- veo que la categoría Family tiene el id 8



-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT first_name, last_name
FROM actor 
WHERE actor_id IN (SELECT actor_id 
	FROM film_actor
	GROUP BY actor_id 
	HAVING COUNT(film_id) > 10);

	-- hago varias consultas entre las tablas en común para ver cómo lo puedo relacionar

		-- SELECT * FROM sakila.film_actor
	 
		-- SELECT actor_id 
		-- FROM film_actor
		-- GROUP BY actor_id 
		-- HAVING COUNT(film_id) > 10



-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title
FROM film 
WHERE rating = "R" AND `length` > 120;



-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT AVG(length), category_id
FROM film 
	INNER JOIN film_category USING (film_id)
	GROUP BY category_id
	HAVING AVG(length) > 120
	
	-- como nos piden la categoría, tengo que ir a la tabla de film_category que se relacionan con el film_id

	-- SELECT category_id
	-- FROM sakila.film_category
	-- GROUP BY category_id



-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT first_name, last_name, COUNT(film_id) AS NºPeliculas 
FROM actor 
INNER JOIN film_actor USING (actor_id)
GROUP BY actor_id 
HAVING COUNT(film_id) >= 5;



-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids 
--	con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT title, rental_duration
FROM film
WHERE rental_duration > 5


-- Para llegar a los rental_id tenemos que pasar por la tabla inventory

SELECT title, rental_duration, r.rental_id
FROM film
	INNER JOIN inventory i USING (film_id)
	INNER JOIN rental AS r USING (inventory_id)
WHERE r.rental_id IN (
	SELECT rental_id 
   	FROM rental
   	WHERE rental_duration > 5)
    
--  Otra forma de encontrar la fecha es:  DATEDIFF(return_date, rental_date) > 5);



-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar 
-- los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

	SELECT first_name, last_name
	FROM actor 
		
	-- Ahora tenemos que llegar a la categoría
	SELECT actor_id
	    FROM film_actor 
	    INNER JOIN film USING (film_id)
	    INNER JOIN film_category USING (film_id)
	    INNER JOIN category USING (category_id)
		WHERE name = "Horror";


-- juntamos todo haciendo una subconsulta

SELECT first_name, last_name
FROM actor 
WHERE actor_id NOT IN (
SELECT actor_id
    FROM film_actor 
    INNER JOIN film USING (film_id)
    INNER JOIN film_category USING (film_id)
    INNER JOIN category USING (category_id)
	WHERE name = "Horror");



-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

	SELECT title 
	FROM film
	WHERE `length`> 180
	
	-- Ahora hay que filtrar por la categoría 
	SELECT * FROM category c -- veo que comedy tiene el category_id 5
	SELECT*FROM film_category fc 

SELECT title 
FROM film
INNER JOIN film_category fc USING (film_id)
WHERE `length`> 180 AND category_id = 5



