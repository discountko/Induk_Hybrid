# chat/urls.py
from django.urls import path

from . import views

urlpatterns = [
    #path('', views.index, name='index'),
    path('', views.room, name='room'),
    path('test', views.test, name='test'),
    path('post', views.post, name='post'),
]