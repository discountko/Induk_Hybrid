from django.urls import path

from . import views
app_name = 'boardApp'

urlpatterns = [
    path('', views.list, name='list')
]