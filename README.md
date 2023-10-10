discord bot to measure connection time of members of a discord server

to setup db:
mysql connection_time < ./mysql/connection_time.sql

to start bot:
py main.py

pip install mysql-connector-python
pip install discord.py
pip install python-dotenv

STORED PROCEDURES

insert_login (guild_id, guild_name, user_id, user_name, guild_nick, login_time)
//insert or updates member on server and insert or updates login time
//is called when a user joins a voice channel and before_channel == none
//this is to prevent logging in when switching channels
guild_id BIGINT
guild_name VARCHAR(40)
user_id BIGINT
user_name VARCHAR(40)
guild_nick VARCHAR(40)
login_time TIMESTAMP

insert_time (guild_id, user_id, logout_time)
//insert or updates connection time on daily log
//is called when a user leaves a voice channel an after_channel == none
//this is to prevent logging out when switching channel
guild_id BIGINT
user_id BIGINT
logout_time TIMESTAMP

get_total_time (guild_id)
//gets server total connection times
//is called on chat message "connection time total" or "tiempo de conexion total"
params
@guild_id BIGINT
returns
-user.name
-guild.nick
-total connection time

get_total_user_time (guild_id, user_id)
//gets user total connection time on server
//is called on chat message "connection time user user_name" or "tiempo de conexion usuario user_name"
guild_id BIGINT
user_id BIGINT

get_daily_log(guild_id,user_id,day)
//gets single daily log
//is called on chat message "connection time user user_name day day" or "tiempo de conexion usuario user_name day dia"
params
@guild_id BIGINT
@user_id BIGINT
@day DATE // "YYYY-MM-DD"
returns
-user.name
-guild.nick
-day
-connection_time

get_total_daily_logs(guild_id)
//gets server total daily logs
//is called on chat message "connection time daily logs" or "tiempo de conexion registros diarios"
guild_id BIGINT

get_user_daily_logs(guild_id, user_id)
//gets user daily logs on server
//is called on chat message "connection time daily logs user user_name" or "tiempo de conexion registros diarios usuario user_name"
guild_id BIGINT
user_id BIGINT
