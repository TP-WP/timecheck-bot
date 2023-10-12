discord bot to measure connection time of members of a discord server

SETUP DB
psql -U <user> -d connection_time -a -f ./postgresql/connection_time.sql

INSTALL DEPENDENCIES
pip install psycopg2
pip install discord.py
pip install python-dotenv

to start bot:
py main.py

DATABASE
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

FUNCTIONS

get_total_time (guild_id)
//gets server total connection times
//is called on command $horas_de_conexion
returns
-user.name
-guild.nick
-total connection time

get_total_daily_logs(guild_id)
//gets server total daily logs
//is called on command $registros_diarios

get_weekly_summary(guild_id)
//gets weekly summary grouped by guild-user-week using week of the year
//is called on command $resumen_semanal

NOT IMPLEMENTED

get_user_daily_logs(guild_id, user_id)
//gets user daily logs on server
//should be called on command $resumen_semanal "user_name"

get_daily_log(guild_id,user_id,day)
//gets single daily log
//should be called on command $registro_diario "user_name" "dia"

get_total_user_time (guild_id, user_id)
//gets user total connection time on server
//should be called on command $horas_de_conexion "user_name"
