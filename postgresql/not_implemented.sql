/* add the following functions to connection_time.sql for implementation */

DROP FUNCTION IF EXISTS get_total_user_time;
DROP FUNCTION IF EXISTS get_daily_log;
DROP FUNCTION IF EXISTS get_user_daily_logs;


CREATE OR REPLACE FUNCTION get_total_user_time (
  guildId BIGINT,
  userId BIGINT
) 
	returns table (
		user_name VARCHAR,
		guild_nick VARCHAR,
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

/** once implemented this functions the following lines should be added to the test.sql file */
SELECT * FROM get_user_daily_logs(111,222);
SELECT * FROM get_total_user_time (111,222);
SELECT * FROM get_daily_log(111,222,'2023-10-10');
