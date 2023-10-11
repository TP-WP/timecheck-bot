DROP DATABASE IF EXISTS connection_time;
CREATE DATABASE connection_time;

\c connection_time;

DROP TABLE IF EXISTS member_list;
DROP TABLE IF EXISTS logins;
DROP TABLE IF EXISTS daily_logs;


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