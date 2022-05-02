from django.urls import path

from . import views
app_name = 'changeApp'

urlpatterns = [
    path('main/', views.main, name='change_api')
]