
USE sakila;

-- 1. Write a query to display for each store its store ID, city, and country.
/*
What tables are required: 4 tables: store, address, city, country
Check if they have a common column: store-address(address_id), address-city(city_id), city-country(country_id)
Need inner join and 2 left joins
*/
SELECT * FROM store;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

SELECT s.store_id, ci.city, co.country  FROM store as s
JOIN address as a
ON s.address_id = a.address_id
left join sakila.city AS ci
ON a.city_id = ci.city_id
LEFT JOIN sakila.country AS co
ON ci.country_id = co.country_id;

-- 2. Write a query to display how much business, in dollars, each store brought in
/*
What tables are required: 3 tables: store, staff, payment
Check if they have a common column: store-staff(store_id), staff-payment(staff_id)
Lets do inner join and one left join
*/
SELECT * FROM store;
SELECT * FROM staff;
SELECT * FROM payment;

SELECT s.store_id, concat('$', format(sum(p.amount), 2)) AS "Amount in Dollars" FROM sakila.store AS s
JOIN sakila.staff AS st
ON s.store_id = st.store_id
LEFT JOIN sakila.payment AS p
ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- 3. What is the average running time of films by category?
SELECT c.name,AVG(f.length)
FROM film_category fc 
INNER JOIN category c ON c.category_id = fc.category_id
INNER JOIN  film f ON f.film_id = fc.film_id
GROUP BY c.category_id DESC;



-- 4. Which film categories are longest?
-- Answer: Sports Films
/*
Which tables are needed: 3 tables: category, film_category and film
Do they have a common column: category-film(category_id), film_category-film(film_id)
Lets do inner join and one left join
*/
SELECT c.category_id, c.name, ROUND(AVG(fi.length),2) AS avg_length FROM sakila.category AS c
JOIN sakila.film_category AS fc
ON c.category_id = fc.category_id
LEFT JOIN sakila.film as fi
ON fc.film_id = fi.film_id
GROUP BY c.category_id
ORDER BY avg_length DESC;


-- 5. Display the most frequently rented movies in descending order.
-- Answer: Bucket Brotherhood with 34 times rented
/*
Which tables are needed: 3 tables: film, inventory, rental
Do they have a common column: film-inventory(film_id), inventory-rental(inventory_id0
Lets do inner join and one left join
*/
SELECT * FROM inventory;
SELECT * FROM rental;

SELECT f.film_id, f.title, COUNT(r.inventory_id) AS "No of Times Rented" FROM sakila.film AS f
JOIN sakila.inventory AS i
ON f.film_id = i.film_id
LEFT JOIN sakila.rental AS r
ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY COUNT(r.rental_id) DESC;


-- 6. List the top five genres in gross revenue in descending order.
/*
Which tables are needed: 5 tables category, film_category, film, inventory, rental, payment
Do they have a common column: category_id, film_id, film_id, inventory_id, rental_id
Lets do inner join and one left join
*/
SELECT * FROM sakila.category;

SELECT c.category_id, c.name, SUM(p.amount) AS total_revenue FROM sakila.category AS c
JOIN sakila.film_category AS fc
ON c.category_id = fc.category_id
LEFT JOIN sakila.film AS f
ON fc.film_id = f.film_id
LEFT JOIN sakila.inventory AS i
ON f.film_id = i.film_id
LEFT JOIN sakila.rental AS r
ON i.inventory_id = r.inventory_id
LEFT JOIN sakila.payment AS p
ON r.rental_id = p.rental_id
GROUP BY c.category_id
ORDER BY total_revenue DESC
LIMIT 5;

-- 7. Is "Academy Dinosaur" available for rent from Store 1?
-- Yes it is in the inventory of Store 1
/*
Which tables are needed:  2 TABLES film and inventory
Do they have a common column: film_id
Lets do inner join
*/

SELECT * FROM inventory;

SELECT i.inventory_id, f.film_id, f.title, i.store_id FROM sakila.film AS f
JOIN sakila.inventory AS i
ON f.film_id = i.film_id
WHERE f.title = "ACADEMY DINOSAUR" AND i.store_id = 1;
