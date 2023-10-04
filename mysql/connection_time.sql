CREATE DATABASE IF NOT EXISTS connection_time;

use connection_time;

DROP TABLE IF EXISTS member_list;
DROP TABLE IF EXISTS logins;
DROP PROCEDURE IF EXISTS insert_time;
DROP PROCEDURE IF EXISTS insert_login;

CREATE TABLE member_list
(
    guild_id BIGINT NOT NULL,
    guild_name VARCHAR(40) NOT NULL,
    user_id BIGINT NOT NULL,
    user_name VARCHAR(40) NOT NULL,
    connection_time DECIMAL(20,6),
    PRIMARY KEY (guild_id, user_id)
);

CREATE TABLE logins
(
    guild_id BIGINT NOT NULL,
    guild_name VARCHAR(40) NOT NULL,
    user_id BIGINT NOT NULL,
    user_name VARCHAR(40) NOT NULL,
    login TIMESTAMP,
    PRIMARY KEY (guild_id, user_id)
);

DELIMITER &&  
CREATE PROCEDURE insert_time (
    IN guildId BIGINT,
    IN guildName VARCHAR(40),
    IN userId BIGINT,
    IN userName VARCHAR(40),
    IN logout TIMESTAMP
    )
BEGIN
IF EXISTS (SELECT user_id FROM logins WHERE user_id=userId and guild_id=guildId) THEN
    INSERT INTO member_list
    (guild_id, guild_name, user_id, user_name, connection_time)
	VALUES
    (guildId, guildName, userId, userName, TIMEDIFF(logout,(SELECT login FROM logins WHERE user_id=userId AND guild_id=guildId))/3600)
	ON DUPLICATE KEY UPDATE
    connection_time = connection_time + TIMEDIFF(logout,(SELECT login FROM logins WHERE user_id=userId AND guild_id=guildId))/3600;
END IF;
END&&  
DELIMITER ; 

DELIMITER &&  
CREATE PROCEDURE insert_login (
    IN guildId BIGINT,
    IN guildName VARCHAR(40),
    IN userId BIGINT,
    IN userName VARCHAR(40),
    IN login TIMESTAMP
    )
BEGIN    
    INSERT INTO logins
    (guild_id, guild_name, user_id, user_name, login)
VALUES
    (guildId, guildName, userId, userName, login)
ON DUPLICATE KEY UPDATE
    login = login;
END&&  
DELIMITER ; 