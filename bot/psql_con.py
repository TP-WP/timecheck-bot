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
            port=os.getenv('DB_PORT'),
            )
        if (connection_pool):
            print("Connection pool created successfully")

        return connection_pool
    except NameError:
        print(NameError)

def call_func(pool, func, args):
    connection = pool.getconn()
    results = []
    try:
        if(connection):
            cursor = connection.cursor()
            cursor.callproc(func,args)
            results = cursor.fetchall()
    except NameError:
        print(NameError)
    finally:
        if(connection):
            connection.commit()
            cursor.close()
            pool.putconn(connection)
            #connection.close()
            return results
        
def call_proc(pool, proc ):
    connection = pool.getconn()
    try:
        if(connection):
            cursor = connection.cursor()
            cursor.execute(proc)
            
    except NameError:
        print(NameError)
    finally:
        if(connection):
            connection.commit()
            cursor.close()
            pool.putconn(connection)

pool = create_connection_pool()

async def login( guild_id, guild_name, user_id, user_name, guild_nick):
    now = datetime.now()
    now = now.strftime('%Y-%m-%d %H:%M:%S')
    call_proc(pool, f"CALL insert_login ('{guild_id}', '{guild_name}', '{user_id}', '{user_name}', '{guild_nick}', '{now}')" )

async def logout( guild_id, user_id):
    now = datetime.now()
    now = now.strftime('%Y-%m-%d %H:%M:%S')
    call_proc(pool, f"CALL insert_time ('{guild_id}', '{user_id}', '{now}')")

async def get_total_time_es(server_id):
    result = call_func(pool, "get_total_time",[server_id])
    text=""
    for e in result:
        text+=f"{e[0]} o {e[1]}, se ha conectado {e[2]} horas\n"
    return text

async def get_total_daily_logs_es(server_id):
    result = call_func(pool, "get_total_daily_logs",[server_id])
    text=""
    for e in result:
        text+=f"{e[0]} o {e[1]}, se ha conectado {e[3]} horas el dia {e[2]}\n"
    return text

async def get_weekly_summary_es(server_id):
    result = call_func(pool, "get_weekly_summary",[server_id])
    text=""
    for e in result:
        text+=f"{e[0]} o {e[1]} en la semana {e[2]} se conecto {e[3]} horas\n"
    return text

#funciones en not_implemented.sql
#horas de conexion de single user
#registros diarios de single user
#un solo registro diario