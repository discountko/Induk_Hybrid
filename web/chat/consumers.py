# chat/consumers.py
import json
from channels.generic.websocket import AsyncWebsocketConsumer

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.room_name = self.scope['url_route']['kwargs']['room_name']
        self.room_group_name = 'chat_%s' % self.room_name

        # Join room group
        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        await self.accept()

    async def disconnect(self, close_code):
        # Leave room group
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    # Receive message from WebSocket
    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        comment = text_data_json['comment']
        author = text_data_json['author']
        create_date = text_data_json['create_date']

        # Send message to room group
        await self.channel_layer.group_send(
            self.room_group_name,
            {
                'type': 'chat_message',
                'comment': comment,
                'author': author,
                'create_date': create_date,
            }
        )

    # Receive message from room group
    async def chat_message(self, event):
        comment = event['comment']
        author = event['author']
        create_date = event['create_date']

        # Send message to WebSocket
        await self.send(text_data=json.dumps({
            "author": author,
            "comment": comment,
            "create_date": create_date,
        }))