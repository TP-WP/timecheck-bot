from mysql.connector import pooling
import os
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()

def create_connection_pool():        
    try:
        connection_pool = pooling.MySQLConnectionPool(
            pool_name="pynative_pool",
            pool_size=5,
            pool_reset_session=True,
            autocommit = True,
            host=os.getenv('DB_HOST'),
            database=os.getenv('DB_NAME'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASS')
            )
        return connection_pool
    except NameError:
        print(NameError)

def query(sql, pool, fetch=False):
    connection = pool.get_connection()
    result = ""

    try:
        if(connection.is_connected()):
            cursor = connection.cursor()
            if(fetch==False):
                cursor.execute(sql)
            else:
                cursor.execute(sql)
                result = cursor.fetchall()
    except NameError:
        print(NameError)
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()
            return result

pool = create_connection_pool()

def login(user_id, user_name, guild_id, guild_name):
    now = datetime.now()
    now = now.strftime('%Y-%m-%d %H:%M:%S')
    sql = f"CALL insert_login ('{guild_id}', '{guild_name}', '{user_id}', '{user_name}', '{now}')"
    query(sql, pool)

def logout(user_id, user_name, guild_id, guild_name):
    now = datetime.now()
    now = now.strftime('%Y-%m-%d %H:%M:%S')
    sql = f"CALL insert_time ('{guild_id}', '{guild_name}', '{user_id}', '{user_name}', '{now}')"
    query(sql, pool)

def get_time_en(server_id):
    sql = f"SELECT user_name, connection_time FROM member_list WHERE guild_id={server_id}"
    result = query(sql, pool, True)
    text = ""
    for e in result:
        text += f"user {e[0]} has been connected {e[1]} hours on voice channels\n"
    return text

def get_time_es(server_id):
    sql = f"SELECT user_name, connection_time FROM member_list WHERE guild_id={server_id}"
    result = query(sql, pool, True)
    text = ""
    for e in result:
        text += f"usuario {e[0]} ha estado conectado {e[1]} horas en los canales de voz\n"
    return text