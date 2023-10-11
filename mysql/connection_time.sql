CREATE DATABASE IF NOT EXISTS connection_time;

use connection_time;

DROP TABLE IF EXISTS member_list;
DROP TABLE IF EXISTS logins;
DROP TABLE IF EXISTS daily_logs;
DROP PROCEDURE IF EXISTS insert_time;
DROP PROCEDURE IF EXISTS insert_login;
DROP PROCEDURE IF EXISTS get_total_time;
DROP PROCEDURE IF EXISTS get_daily_log;
DROP PROCEDURE IF EXISTS get_total_user_time;
DROP PROCEDURE IF EXISTS get_total_daily_logs;
DROP PROCEDURE IF EXISTS get_user_daily_logs;

CREATE TABLE member_list
(
    guild_id BIGINT NOT NULL,
    guild_name VARCHAR(40) NOT NULL,
    user_id BIGINT NOT NULL,
    user_name VARCHAR(40) NOT NULL,
    guild_nick VARCHAR(40),
    PRIMARY KEY (guild_id, user_id)
);

CREATE TABLE logins
(
    guild_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    login TIMESTAMP,
    PRIMARY KEY (guild_id, user_id)
);

CREATE TABLE daily_logs
(
    guild_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    day DATE,
    connection_time DECIMAL(10,4),
    PRIMARY KEY (guild_id, user_id, day)
);

DELIMITER &&  
CREATE PROCEDURE insert_time (
    IN guildId BIGINT,
    IN userId BIGINT,
    IN logout TIMESTAMP
    )
BEGIN
    IF EXISTS (SELECT user_id FROM logins WHERE user_id=userId AND guild_id=guildId) THEN
        INSERT INTO daily_logs
            (guild_id, user_id, day, connection_time)
        VALUES
            (guildId, userId, DATE(logout), TIMEDIFF(logout,(SELECT login FROM logins WHERE user_id=userId AND guild_id=guildId))/3600)
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
    IN guildNick VARCHAR(40),
    IN loginTime TIMESTAMP
    )
BEGIN
    INSERT INTO member_list
        (guild_id, guild_name, user_id, user_name, guild_nick)
    VALUES
        (guildId, guildName, userId, userName, guildNick)
    ON DUPLICATE KEY UPDATE
        guild_name = guildName,
        user_name = userName,
        guild_nick = guildNick;
    INSERT INTO logins
        (guild_id, user_id, login)
    VALUES
        (guildId, userId, loginTime)
    ON DUPLICATE KEY UPDATE
        login = loginTime;
END&&
DELIMITER ; 

DELIMITER &&  
CREATE PROCEDURE get_total_user_time (
    IN guildId BIGINT,
    IN userId BIGINT
    )
BEGIN
    SELECT member_list.user_name, member_list.guild_nick, SUM(daily_logs.connection_time) 
    FROM member_list INNER JOIN daily_logs 
    USING (user_id, guild_id)
    WHERE guild_id=guildId AND user_id=userId
    GROUP BY user_id, guild_id;

END&&
DELIMITER ; 


DELIMITER &&  
CREATE PROCEDURE get_daily_log (
    IN guildId BIGINT,
    IN userId BIGINT,
    IN get_day DATE
    )
BEGIN
    SELECT member_list.user_name, member_list.guild_nick, daily_logs.connection_time 
    FROM member_list INNER JOIN daily_logs 
    USING (guild_id, user_id)
    WHERE guild_id=guildId AND user_id=userId AND daily_logs.day=get_day;

END&&
DELIMITER ; 

DELIMITER &&  
CREATE PROCEDURE get_total_time (
    IN guildId BIGINT
    )
BEGIN
    SELECT member_list.user_name, member_list.guild_nick, SUM(daily_logs.connection_time) 
    FROM member_list INNER JOIN daily_logs 
    USING (guild_id, user_id)
    WHERE guild_id=guildId 
    GROUP BY user_name, guild_nick;

END&&
DELIMITER ; 

DELIMITER &&  
CREATE PROCEDURE get_total_daily_logs (
    IN guildId BIGINT
    )
BEGIN
    SELECT member_list.user_name, member_list.guild_nick, daily_logs.day, daily_logs.connection_time
    FROM member_list INNER JOIN daily_logs 
    USING (guild_id, user_id)
    WHERE guild_id=guildId 
    GROUP BY user_name, guild_nick, day, connection_time;

END&&
DELIMITER ; 

DELIMITER &&  
CREATE PROCEDURE get_user_daily_logs (
    IN guildId BIGINT,
    IN userId BIGINT
    )
BEGIN
    SELECT member_list.user_name, member_list.guild_nick, daily_logs.day, daily_logs.connection_time
    FROM member_list INNER JOIN daily_logs 
    USING (guild_id, user_id)
    WHERE guild_id=guildId AND user_id=userId
    GROUP BY user_name, guild_nick, day, connection_time;

END&&
DELIMITER ; 

DELIMITER &&  
CREATE PROCEDURE get_weekly_summary (
    IN guildId BIGINT
    )
BEGIN
    SELECT member_list.user_name, member_list.guild_nick, WEEK(daily_logs.day) AS week, SUM(daily_logs.connection_time) AS hours
    FROM member_list INNER JOIN daily_logs
    USING (user_id, guild_id)
    WHERE guild_id = guildId
    GROUP BY user_id, guild_id, week;

END&&
DELIMITER ; 