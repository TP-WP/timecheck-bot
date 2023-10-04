import mysql_con
def handle_response(message, is_private) -> str:
    p_message = message.content.lower()
    if is_private:
        p_message = p_message[1:]

    if p_message == "hello there":
        return "general kenobi"
    
    if p_message == "get connection time":
        return mysql_con.get_time_en(message.guild.id)
    
    if p_message == "querido bot, podrias decirme los tiempos de conexion porfavor?":
        return mysql_con.get_time_es(message.guild.id)
    
    if p_message == "!help":
        return "`help message`"
    