/* Курс "Базы данных"
Урок 7. "Видеоурок. Сложные запросы"
Задача 1.
Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
*/

USE shop;

SELECT id, name FROM users where id IN (SELECT user_id FROM orders);

-- a number of orders done by each user

SELECT user_id, (SELECT name FROM users WHERE id = user_id) AS name, COUNT(*) 
FROM orders 
GROUP BY user_id;



/* Задача 2.
Выведите список товаров products и разделов catalogs, который соответствует товару.
*/

-- the first version
SELECT name, price, (SELECT name FROM catalogs WHERE catalog_id = id) AS `catalog` FROM products;

-- the second version
SELECT p.name AS `name`, p.price AS `price`, c.name AS `catalog` 
FROM products AS p JOIN catalogs AS c ON c.id = p.catalog_id;



/* Задача 3.
 Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
 Поля from, to и label содержат английские названия городов, поле name — русское. 
 Выведите список рейсов flights с русскими названиями городов.
 */

DROP DATABASE IF EXISTS schedule;
CREATE DATABASE schedule;

USE schedule;


DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
    id SERIAL PRIMARY KEY,
    from_city VARCHAR(255),
    to_city VARCHAR(255)
);

INSERT INTO flights (from_city, to_city) VALUES
('moscow', 'omsk'),
('novgorod', 'kazan'),
('irkutsk', 'moscow'),
('omsk', 'irkutsk'),
('moscow', 'kazan');

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    ru_name VARCHAR(255) UNIQUE,
    en_name VARCHAR(255) UNIQUE
);

INSERT INTO cities (ru_name, en_name) VALUES
('Москва', 'moscow'),
('Омск', 'omsk'),
('Новгород', 'novgorod'), 
('Казань', 'kazan'),
('Иркутск', 'irkutsk');

-- the first version
SELECT id, (SELECT ru_name FROM cities WHERE en_name = from_city) as `from`,
           (SELECT ru_name FROM cities WHERE en_name = to_city) as `to`
FROM flights;


-- the second version
SELECT `from`.ru_name AS `вылет`, `to`.ru_name AS `прилет`
FROM flights 
JOIN cities AS `from` ON flights.from_city = `from`.en_name
JOIN cities AS `to`   ON flights.to_city   = `to`.en_name;


