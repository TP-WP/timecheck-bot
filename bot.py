# This example requires the 'message_content' intent.
import discord
from discord.ext import tasks
import responses
import os
from dotenv import load_dotenv
import mysql_con
load_dotenv()

intents = discord.Intents.default()
intents.message_content = True

async def send_message(message, is_private):
    try:
        response = responses.handle_response(message, is_private)
        await message.author.send(response) if is_private else await message.channel.send(response)
    except Exception as e:
        print(e)

def run_discord_bot():
    client = discord.Client(intents=intents)

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
    async def on_message(message):
        if message.author == client.user:
            return 

        if message.content[0] == '?':
            await send_message(message, is_private=True)
        else:
            await send_message(message, is_private=False)

    @client.event
    async def on_voice_state_update(member, before, after):
        if not member.bot:
            if before.channel == None:
                mysql_con.login(member.guild.id, member.guild.name, member.id, member.global_name, member.nick )
                
            if after.channel == None:
                mysql_con.logout(member.guild.id, member.guild.name, member.id, member.global_name, member.nick)

    
    client.run(os.getenv('TOKEN'))

