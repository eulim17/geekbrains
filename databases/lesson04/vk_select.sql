/* Курс "Базы данных"
Урок 4. "Вебинар. CRUD-операции"
Задача 2.
ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке
*/

USE vk;

SELECT DISTINCT firstname FROM users ORDER BY firstname;


/*
 Задача 3.
 Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). 
 Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)
*/

DROP PROCEDURE IF EXISTS alter_table;
DELIMITER //
CREATE PROCEDURE alter_table()
BEGIN
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
  ALTER TABLE profiles ADD COLUMN is_active BOOL DEFAULT TRUE;
END //
DELIMITER ;
CALL alter_table();
DROP PROCEDURE alter_table;


-- SELECT user_id, birthday FROM profiles WHERE birthday >= NOW() - INTERVAL 18 YEAR;
UPDATE profiles SET is_active = FALSE WHERE birthday >= NOW() - INTERVAL 18 YEAR;
SELECT user_id, birthday, is_active FROM profiles WHERE birthday >= NOW() - INTERVAL 18 YEAR;



/*
Задача 4. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
*/

INSERT INTO messages(from_user_id, to_user_id, body, created_at) VALUES ('1','10','Message from Future.','2071-12-19 11:28:41');
SELECT id, body, created_at FROM messages m WHERE created_at > NOW();
DELETE FROM messages WHERE created_at > NOW();
SELECT id, body, created_at FROM messages m WHERE created_at > NOW();


