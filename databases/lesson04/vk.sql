-- vk.sql
-- Тема: DDL = Data Definition Language (язык определения данных)

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE 
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(100),
    phone VARCHAR(12),
    
    INDEX users_phone_idx(phone),
    INDEX (firstname, lastname)
);


DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    
    INDEX (from_user_id),
    INDEX (to_user_id),
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
    initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'unfriended', 'declined'),
    requested_at DATETIME DEFAULT now(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (initiator_user_id, target_user_id),
    INDEX (initiator_user_id),
    INDEX (target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200),
 --   admin_user_id BIGINT UNSIGNED NOT NULL,
    
    INDEX (name)
 --   INDEX (admin_user_id),
 --   FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

-- M x M

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities (
    user_id BIGINT UNSIGNED NOT NULL,
    community_id BIGINT UNSIGNED NOT NULL,
    
    PRIMARY KEY (user_id, community_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);


DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

);


DROP TABLE IF EXISTS media;
CREATE TABLE media (
    id SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    filename VARCHAR(255),
    `size` INT,
    metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    
    INDEX (user_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);


DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
    id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);


DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
    `id` SERIAL PRIMARY KEY,
    `name` VARCHAR(200),
    `user_id` BIGINT UNSIGNED NOT NULL,
    
    FOREIGN KEY (`user_id`) REFERENCES users(id)
);


DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
    `id` SERIAL PRIMARY KEY,
    `media_id` BIGINT UNSIGNED NOT NULL,
    `album_id` BIGINT UNSIGNED NOT NULL,
    
    FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);


-- 1 x 1

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
    user_id SERIAL PRIMARY KEY,
    gender CHAR(1),
    birthday DATE,
    photo_id BIGINT UNSIGNED NULL,
    hometown VARCHAR(100),
    created_at DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (photo_id) REFERENCES media(id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

/* ALTER TABLE profiles ADD CONSTRAINT vk_user_id 
FOREIGN KEY (user_id) REFERENCES users(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;*/














