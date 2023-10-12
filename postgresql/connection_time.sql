DROP DATABASE IF EXISTS connection_time;
CREATE DATABASE connection_time;

\c connection_time;

DROP TABLE IF EXISTS member_list;
DROP TABLE IF EXISTS logins;
DROP TABLE IF EXISTS daily_logs;

DROP PROCEDURE IF EXISTS insert_time;
DROP PROCEDURE IF EXISTS insert_login;

DROP FUNCTION IF EXISTS get_total_time;
DROP FUNCTION IF EXISTS get_total_daily_logs;
DROP FUNCTION IF EXISTS get_weekly_summary;


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
    connection_hours DECIMAL,
    PRIMARY KEY (guild_id, user_id, day)
);


CREATE PROCEDURE insert_time (
    guildId BIGINT,
    userId BIGINT,
    logout TIMESTAMP
    )
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO daily_logs
        (guild_id, user_id, day, connection_hours)
    VALUES
        (guildId, userId, DATE(logout), TRUNC(EXTRACT(EPOCH FROM logout - (SELECT login FROM logins WHERE user_id=userId AND guild_id=guildId))/3600,4 ))
    ON CONFLICT (guild_id, user_id, day) DO UPDATE SET
        connection_hours = daily_logs.connection_hours + TRUNC(EXTRACT(EPOCH FROM logout - (SELECT login FROM logins WHERE user_id=userId AND guild_id=guildId))/3600, 4)
    WHERE EXISTS (SELECT user_id FROM logins WHERE user_id=userId AND guild_id=guildId);
END;
$$;


CREATE PROCEDURE insert_login (
    guildId BIGINT,
    guildName VARCHAR(40),
    userId BIGINT,
    userName VARCHAR(40),
    guildNick VARCHAR(40),
    loginTime TIMESTAMP
    )
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO member_list
        (guild_id, guild_name, user_id, user_name, guild_nick)
    VALUES
        (guildId, guildName, userId, userName, guildNick)
    ON CONFLICT (guild_id, user_id) DO UPDATE SET
        guild_name = guildName,
        user_name = userName,
        guild_nick = guildNick;
    INSERT INTO logins
        (guild_id, user_id, login)
    VALUES
        (guildId, userId, loginTime)
    ON CONFLICT (guild_id, user_id) DO UPDATE SET
        login = loginTime;
END;
$$;


CREATE OR REPLACE FUNCTION get_total_time (
    guildId BIGINT
)
    RETURNS TABLE(
        user_name VARCHAR(40),
        guild_nick VARCHAR(40),
        connection_hours DECIMAL
    )
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT member_list.user_name, member_list.guild_nick, SUM(daily_logs.connection_hours) 
        FROM member_list INNER JOIN daily_logs 
        USING (guild_id, user_id)
        WHERE guild_id=guildId 
        GROUP BY member_list.user_name, member_list.guild_nick;
END;
$$;


CREATE OR REPLACE FUNCTION get_total_daily_logs (
    guildId BIGINT
)
    RETURNS TABLE(
        user_name VARCHAR(40),
        guild_nick VARCHAR(40),
        day DATE,
        connection_hours DECIMAL
    )
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT member_list.user_name, member_list.guild_nick, daily_logs.day, daily_logs.connection_hours
        FROM member_list INNER JOIN daily_logs 
        USING (guild_id, user_id)
        WHERE guild_id=guildId 
        GROUP BY member_list.user_name, member_list.guild_nick, daily_logs.day, daily_logs.connection_hours;
END;
$$;


CREATE OR REPLACE FUNCTION get_weekly_summary (
    guildId BIGINT
)
    RETURNS TABLE(
        user_name VARCHAR(40),
        guild_nick VARCHAR(40),
        day DOUBLE PRECISION,
        connection_hours DECIMAL
    )
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT member_list.user_name, member_list.guild_nick, DATE_PART('week',daily_logs.day) AS week, SUM(daily_logs.connection_hours) AS hours
        FROM member_list INNER JOIN daily_logs
        USING (user_id, guild_id)
        WHERE guild_id = guildId
        GROUP BY member_list.user_id, member_list.guild_id, week;
END;
$$;
