/* Курс "Базы данных"
Урок 6. "Вебинар. Операторы, фильтрация, сортировка и ограничение. Агрегация данных"
Задача 1.
Пусть задан некоторый пользователь. 
Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
*/

USE vk;

-- a list of all messages
SELECT * FROM messages WHERE to_user_id = 1 OR from_user_id = 1;

-- a list of all friends
SELECT id FROM users WHERE id IN (
                            SELECT initiator_user_id FROM friend_requests WHERE (target_user_id = 1) AND status='approved'
                            UNION 
                            SELECT target_user_id FROM friend_requests WHERE (initiator_user_id = 1) AND status='approved'
);


-- a list of all messages with friends
SELECT *
FROM messages 
WHERE (to_user_id = 1 AND from_user_id IN (
        SELECT initiator_user_id FROM friend_requests WHERE (target_user_id = 1) AND status='approved'
        UNION 
        SELECT target_user_id FROM friend_requests WHERE (initiator_user_id = 1) AND status='approved'))
OR
        (from_user_id = 1 AND to_user_id IN (
        SELECT initiator_user_id FROM friend_requests WHERE (target_user_id = 1) AND status='approved'
        UNION 
        SELECT target_user_id FROM friend_requests WHERE (initiator_user_id = 1) AND status='approved'));


-- the most popular correspondent
SELECT IF(from_user_id = 1, to_user_id, from_user_id) AS `correspondent`,
       COUNT(*) AS total
FROM messages 
WHERE (to_user_id = 1 AND from_user_id IN (
        SELECT initiator_user_id FROM friend_requests WHERE (target_user_id = 1) AND status='approved'
        UNION 
        SELECT target_user_id FROM friend_requests WHERE (initiator_user_id = 1) AND status='approved'))
OR
        (from_user_id = 1 AND to_user_id IN (
        SELECT initiator_user_id FROM friend_requests WHERE (target_user_id = 1) AND status='approved'
        UNION 
        SELECT target_user_id FROM friend_requests WHERE (initiator_user_id = 1) AND status='approved'))
GROUP BY `correspondent` ORDER BY total DESC LIMIT 1;




-- JOIN version
SELECT
    correspondent,
    COUNT(*) AS total
FROM (
    SELECT 
        CONCAT(users.firstname, ' ', users.lastname) AS correspondent,
        messages.body 
    FROM users
        JOIN messages ON messages.from_user_id = users.id OR messages.to_user_id = users.id
        JOIN friend_requests AS fr ON fr.initiator_user_id = users.id
    WHERE fr.target_user_id = 1 and fr.status = 'approved'
    UNION
    SELECT 
        CONCAT(users.firstname, ' ', users.lastname) AS correspondent,
        messages.body 
    FROM users
        JOIN messages ON messages.from_user_id = users.id OR messages.to_user_id = users.id
        JOIN friend_requests AS fr ON fr.target_user_id = users.id
    WHERE fr.initiator_user_id = 1 and fr.status = 'approved'
) AS list
GROUP BY correspondent
ORDER BY total DESC LIMIT 1;
    
  
-- another JOIN version
SELECT
    friendname,
    COUNT(*) AS total
FROM (
    SELECT
        users.id,
        CONCAT(users.firstname, ' ', users.lastname) AS friendname
    FROM users
        JOIN friend_requests fr ON fr.initiator_user_id = users.id
    WHERE fr.target_user_id = 1 and fr.status = 'approved'
    UNION
    SELECT
        users.id,
        CONCAT(users.firstname, ' ', users.lastname) AS friendname
    FROM users
        JOIN friend_requests fr ON fr.target_user_id = users.id
    WHERE fr.initiator_user_id = 1 and fr.status = 'approved'
    ) AS friends
JOIN messages ON messages.from_user_id = friends.id OR messages.to_user_id = friends.id
GROUP BY friendname 
ORDER BY total DESC LIMIT 1;




/* Задача 2.
 * Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.
 */

-- a list of all users younger than 10 years 
SELECT * FROM profiles WHERE NOW() <= birthday + INTERVAL 40 YEAR;

-- a list of all media published by users younger than 10 years
SELECT * FROM media WHERE user_id IN (SELECT user_id FROM profiles WHERE NOW() <= birthday + INTERVAL 10 YEAR);

-- a list of all likes given to all media published by users younger than 10 years
SELECT * FROM likes WHERE media_id IN (
        SELECT id FROM media WHERE user_id IN (SELECT user_id FROM profiles WHERE NOW() <= birthday + INTERVAL 10 YEAR)
);


SELECT COUNT(*) FROM likes WHERE media_id IN (
        SELECT id FROM media WHERE user_id IN (SELECT user_id FROM profiles WHERE NOW() <= birthday + INTERVAL 10 YEAR)
);



-- JOIN version
SELECT COUNT(*)
FROM users
    JOIN profiles ON profiles.user_id = users.id
    JOIN media ON media.user_id = users.id
    JOIN likes ON likes.media_id = media.id 
WHERE NOW() <= birthday + INTERVAL 10 YEAR




/* Задача 3.
Определить кто больше поставил лайков (всего) - мужчины или женщины?
*/


SELECT gender, COUNT(gender) AS total FROM profiles WHERE user_id IN (SELECT user_id FROM likes) 
GROUP BY gender ORDER BY total DESC LIMIT 1;


-- JOIN version
SELECT 
    gender,
    COUNT(*) AS total
FROM users
    JOIN profiles ON profiles.user_id = users.id 
    JOIN likes ON likes.user_id = users.id 
GROUP BY gender
ORDER BY total DESC;