/* Курс "Базы данных"
Урок 2 "Управление БД. Язык запросов SQL."
Задача 2
Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
*/

DROP DATABASE IF EXISTS example;
CREATE DATABASE example;
USE example;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT,
    name CHAR
);
