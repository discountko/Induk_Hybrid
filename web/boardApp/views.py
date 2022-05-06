from django.contrib.auth.decorators import login_required
from django.shortcuts import render

# Create your views here.
def list(request):
    return render(request, 'board/list.html')
