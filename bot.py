import discord
from discord.ext import tasks, commands
import os
from dotenv import load_dotenv
import mysql_con
load_dotenv()

intents = discord.Intents.default()
intents.message_content = True
client = commands.Bot(command_prefix='$', intents=intents)

def run_discord_bot():

    @tasks.loop(seconds=5.0)
    async def delete_old_records():
        #delete older than 3 month old records
        print ("asd")

    @client.event
    async def on_ready():
        #delete_old_records.start()
        print("logged in as {0}".format(client.user))
    
    @client.event
    async def on_voice_state_update(member, before, after):
        if not member.bot:
            if before.channel == None:
                mysql_con.login(member.guild.id, member.guild.name, member.id, member.global_name, member.nick )
                
            if after.channel == None:
                mysql_con.logout(member.guild.id, member.id)

    @client.command(name="horas_de_conexion")
    async def get_total_connection_time(ctx):
        asd = mysql_con.get_total_time_es(ctx.guild.id)
        await ctx.send(asd)
    
    @client.command(name="registros_diarios")
    async def get_total_daily_logs_es(ctx):
        asd = mysql_con.get_total_daily_logs_es(ctx.guild.id)
        await ctx.send(asd)

    client.run(os.getenv('TOKEN'))

