import discord
from discord.ext import tasks, commands
import os
from dotenv import load_dotenv
import psql_con
from datetime import datetime

load_dotenv()

intents = discord.Intents.default()
intents.message_content = True
client = commands.Bot(command_prefix='$', intents=intents)

def run_discord_bot():

    @tasks.loop(minutes=5.0)
    async def check_if_alive():
        #define a task for keeping bot alive
        print ("i'm alive", datetime.now())

    @client.event
    async def on_ready():
        check_if_alive.start()
        print("logged in as {0}".format(client.user))
    
    @client.event
    async def on_voice_state_update(member, before, after):
        if not member.bot:
            if before.channel == None:
                await psql_con.login(member.guild.id, member.guild.name, member.id, member.global_name, member.nick )
                
            if after.channel == None:
                await psql_con.logout(member.guild.id, member.id)

    @client.command(name="horas_de_conexion")
    async def get_total_connection_time(ctx):
        asd = await psql_con.get_total_time_es(ctx.guild.id)
        await ctx.send(asd)
    
    @client.command(name="registros_diarios")
    async def get_total_daily_logs_es(ctx):
        asd = await psql_con.get_total_daily_logs_es(ctx.guild.id)
        await ctx.send(asd)

    @client.command(name="resumen_semanal")
    async def get_weekly_summary(ctx):
        asd = await psql_con.get_weekly_summary_es(ctx.guild.id)
        await ctx.send(asd)

    #TODO 
    #horas de conexion de single user
    #registros diarios de single user
    #un solo registro diario
    
    client.run(os.getenv('TOKEN'))

