\c connection_time;

DROP PROCEDURE IF EXISTS insert_time;
DROP PROCEDURE IF EXISTS insert_login;
DROP PROCEDURE IF EXISTS get_total_time;
DROP PROCEDURE IF EXISTS get_daily_log;
DROP PROCEDURE IF EXISTS get_total_user_time;
DROP PROCEDURE IF EXISTS get_total_daily_logs;
DROP PROCEDURE IF EXISTS get_user_daily_logs;
DROP PROCEDURE IF EXISTS get_weekly_summary;

CREATE PROCEDURE insert_time (
    guildId BIGINT,
    userId BIGINT,
    logout TIMESTAMP
    )
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO daily_logs
        (guild_id, user_id, day, connection_time)
    VALUES
        (guildId, userId, DATE(logout), (logout - (SELECT login FROM logins WHERE user_id=userId AND guild_id=guildId))/3600)
    ON CONFLICT DO UPDATE SET
        connection_time = connection_time + (logout - (SELECT login FROM logins WHERE user_id=userId AND guild_id=guildId))/3600
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
    ON CONFLICT DO UPDATE SET
        guild_name = guildName,
        user_name = userName,
        guild_nick = guildNick;
    INSERT INTO logins
        (guild_id, user_id, login)
    VALUES
        (guildId, userId, loginTime)
    ON CONFLICT DO UPDATE SET
        login = loginTime;
END;
$$;


CREATE PROCEDURE get_total_user_time (
    guildId BIGINT,
    userId BIGINT
    )
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT member_list.user_name, member_list.guild_nick, SUM(daily_logs.connection_time) 
    FROM member_list INNER JOIN daily_logs 
    USING (user_id, guild_id)
    WHERE guild_id=guildId AND user_id=userId
    GROUP BY user_id, guild_id;

END;
$$;


CREATE PROCEDURE get_daily_log (
    guildId BIGINT,
    userId BIGINT,
    get_day DATE
    )
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT member_list.user_name, member_list.guild_nick, daily_logs.connection_time 
    FROM member_list INNER JOIN daily_logs 
    USING (guild_id, user_id)
    WHERE guild_id=guildId AND user_id=userId AND daily_logs.day=get_day;
END;
$$;


CREATE PROCEDURE get_total_time (
    guildId BIGINT
    )
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT member_list.user_name, member_list.guild_nick, SUM(daily_logs.connection_time) 
    FROM member_list INNER JOIN daily_logs 
    USING (guild_id, user_id)
    WHERE guild_id=guildId 
    GROUP BY user_name, guild_nick;
END;
$$;


CREATE PROCEDURE get_total_daily_logs (
    guildId BIGINT
    )
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT member_list.user_name, member_list.guild_nick, daily_logs.day, daily_logs.connection_time
    FROM member_list INNER JOIN daily_logs 
    USING (guild_id, user_id)
    WHERE guild_id=guildId 
    GROUP BY user_name, guild_nick, day, connection_time;
END;
$$;


CREATE PROCEDURE get_user_daily_logs (
    guildId BIGINT,
    userId BIGINT
    )
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT member_list.user_name, member_list.guild_nick, daily_logs.day, daily_logs.connection_time
    FROM member_list INNER JOIN daily_logs 
    USING (guild_id, user_id)
    WHERE guild_id=guildId AND user_id=userId
    GROUP BY user_name, guild_nick, day, connection_time;
END;
$$;


CREATE PROCEDURE get_weekly_summary (
    guildId BIGINT
    )
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT member_list.user_name, member_list.guild_nick, WEEK(daily_logs.day) AS week, SUM(daily_logs.connection_time) AS hours
    FROM member_list INNER JOIN daily_logs
    USING (user_id, guild_id)
    WHERE guild_id = guildId
    GROUP BY user_id, guild_id, week;
END;
$$;
