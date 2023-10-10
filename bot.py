# This example requires the 'message_content' intent.
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
    #client = discord.Client(intents=intents)

    @tasks.loop(seconds=5.0)
    async def upload_records():
        #send records
        #empty records file
        print ("asd")

    @client.event
    async def on_ready():
        #upload_records.start()
        print("logged in as {0}".format(client.user))
    
    @client.event
    async def on_voice_state_update(member, before, after):
        if not member.bot:
            if before.channel == None:
                mysql_con.login(member.guild.id, member.guild.name, member.id, member.global_name, member.nick )
                
            if after.channel == None:
                mysql_con.logout(member.guild.id, member.id)

    @client.command()
    async def get_total_connection_time(ctx):
        asd = mysql_con.get_total_time_en(ctx.guild.id)
        await ctx.send(asd)
    
    client.run(os.getenv('TOKEN'))

