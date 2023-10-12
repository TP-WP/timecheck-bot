\c connection_time;

DROP FUNCTION IF EXISTS get_total_user_time;
DROP FUNCTION IF EXISTS get_daily_log;
DROP FUNCTION IF EXISTS get_total_time;
DROP FUNCTION IF EXISTS get_total_daily_logs;
DROP FUNCTION IF EXISTS get_user_daily_logs;
DROP FUNCTION IF EXISTS get_weekly_summary;



CREATE OR REPLACE FUNCTION get_total_user_time (
  guildId BIGINT,
  userId BIGINT
) 
	RETURNS TABLE (
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
        USING (user_id, guild_id)
        WHERE guild_id=guildId AND user_id=userId
        GROUP BY user_id, guild_id;
END;
$$;


CREATE OR REPLACE FUNCTION get_daily_log (
    guildId BIGINT,
    userId BIGINT,
    get_day DATE
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
        SELECT member_list.user_name, member_list.guild_nick, daily_logs.connection_hours 
        FROM member_list INNER JOIN daily_logs 
        USING (guild_id, user_id)
        WHERE guild_id=guildId AND user_id=userId AND daily_logs.day=get_day;
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


CREATE OR REPLACE FUNCTION get_user_daily_logs (
    guildId BIGINT,
    userId BIGINT
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
        WHERE guild_id=guildId AND user_id=userId
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
