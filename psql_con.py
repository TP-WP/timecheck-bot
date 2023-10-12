import psycopg2.pool
import os
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()

def create_connection_pool():        
    try:
        connection_pool = psycopg2.pool.SimpleConnectionPool(
            1,
            20,
            host=os.getenv('DB_HOST'),
            database=os.getenv('DB_NAME'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASS'),
            port=os.getenv('DB_PORT')
            )
        if (connection_pool):
            print("Connection pool created successfully")

        return connection_pool
    except NameError:
        print(NameError)

def call_proc(pool, proc, args):
    connection = pool.getconn()
    results = []
    try:
        if(connection):
            print("connected from pool")
            cursor = connection.cursor()
            cursor.callproc(proc,args)
            results = cursor.fetchall()
            print("results",results)
            
    except NameError:
        print(NameError)
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()
            return results

pool = create_connection_pool()

def login( guild_id, guild_name, user_id, user_name, guild_nick):
    now = datetime.now()
    now = now.strftime('%Y-%m-%d %H:%M:%S')
    call_proc(pool, "insert_login", [guild_id, guild_name, user_id, user_name, guild_nick, now])

def logout( guild_id, user_id):
    now = datetime.now()
    now = now.strftime('%Y-%m-%d %H:%M:%S')
    call_proc(pool, "insert_time", [guild_id, user_id, now])

def get_total_time_es(server_id):
    result = call_proc(pool, "get_total_time",[server_id])
    text=""
    for e in result:
        text+=f"{e[0]} o {e[1]}, se ha conectado {e[2]} horas\n"
    return text

def get_total_daily_logs_es(server_id):
    result = call_proc(pool, "get_total_daily_logs",[server_id])
    text=""
    for e in result:
        text+=f"{e[0]} o {e[1]}, se ha conectado {e[3]} horas el dia {e[2]}\n"
    return text

def get_weekly_summary_es(server_id):
    result = call_proc(pool, "get_weekly_summary",[server_id])
    text=""
    for e in result:
        text+=f"{e[0]} o {e[1]} en la semana {e[2]} se conecto {e[3]} horas\n"
    return text

#funciones en not_implemented.sql
#horas de conexion de single user
#registros diarios de single user
#un solo registro diario