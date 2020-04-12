/* Курс "Базы данных"
Урок 5. "Видеоурок. Операторы, фильтрация, сортировка и ограничение. Агрегация данных"

Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”

Задача 1.
Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
*/

USE shop;

SELECT name, created_at, updated_at FROM users;
INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES ('Ivan', '2000-04-12', NULL, NULL);
SELECT name, created_at, updated_at FROM users;

UPDATE users SET created_at = NOW() WHERE created_at IS NULL;
UPDATE users SET updated_at = NOW() WHERE updated_at IS NULL;

SELECT name, created_at, updated_at FROM users;



/* Задача 2.
 Таблица users была неудачно спроектирована. 
 Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". 
 Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
*/

DROP TABLE IF EXISTS users_incorrect_date_type;
CREATE TABLE users_incorrect_date_type (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(20),
  updated_at VARCHAR(20)
);


INSERT INTO users_incorrect_date_type (name, birthday_at, created_at, updated_at) 
VALUES ('Julia', '1996-12-30', '12.02.2020 5:50', '13.03.2020 19:01');
SELECT * FROM users_incorrect_date_type;

ALTER TABLE users_incorrect_date_type ADD COLUMN created_at_correct DATETIME;
ALTER TABLE users_incorrect_date_type ADD COLUMN updated_at_correct DATETIME;
SELECT * FROM users_incorrect_date_type;



UPDATE users_incorrect_date_type SET created_at_correct = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i');
UPDATE users_incorrect_date_type SET updated_at_correct = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
SELECT * FROM users_incorrect_date_type;

ALTER TABLE users_incorrect_date_type DROP COLUMN created_at;
ALTER TABLE users_incorrect_date_type DROP COLUMN updated_at;
ALTER TABLE users_incorrect_date_type RENAME COLUMN created_at_correct TO created_at;
ALTER TABLE users_incorrect_date_type RENAME COLUMN updated_at_correct TO updated_at;
SELECT * FROM users_incorrect_date_type;



/* Задача 3.
 В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
 0, если товар закончился, и выше нуля, если на складе имеются запасы. 
 Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
 Однако, нулевые запасы должны выводиться в конце, после всех записей.
 */

INSERT INTO storehouses_products (storehouse_id, product_id, value)
VALUES 
  (1, 1, 0),
  (1, 2, 10),
  (1, 3, 5),
  (1, 4, 11),
  (1, 5, 0),
  (2, 1, 5),
  (2, 2, 8),
  (2, 3, 0),
  (2, 4, 1),
  (2, 5, 12);


SELECT storehouse_id, product_id, value, IF(value = 0, 'empty', 'not empty') AS `empty` FROM storehouses_products ORDER BY `empty` DESC, value;



/* Задача 4.
Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
Месяцы заданы в виде списка английских названий ('may', 'august')
*/

SELECT name, birthday_at FROM users WHERE MONTHNAME(birthday_at) = 'may' OR MONTHNAME(birthday_at) = 'august';



/* Задача 5.
Из таблицы catalogs извлекаются записи при помощи запроса. 
SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
Отсортируйте записи в порядке, заданном в списке IN.
*/

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2); 



/*
Практическое задание теме “Агрегация данных”

Задача 1.
Подсчитайте средний возраст пользователей в таблице users.
*/

SELECT AVG( FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday_at)) / 365.25) ) FROM users;




/* Задча 2.
 Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 */

SELECT name, WEEKDAY(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))) AS `weekday`
FROM users ORDER BY `weekday`;

SELECT WEEKDAY(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))) AS `weekday`,
       count(name)
FROM users GROUP BY `weekday` ORDER BY `weekday`;



/* Задача 3.
 * Подсчитайте произведение чисел в столбце таблицы
 */

DROP TABLE IF EXISTS tbl_1;
CREATE TABLE tbl_1 (
    num INT
);

INSERT INTO tbl_1 VALUES
(1),
(2),
(3),
(4),
(5);

SELECT EXP(SUM(LOG(num))) FROM tbl_1;
