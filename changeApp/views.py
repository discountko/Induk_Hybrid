from django.shortcuts import render
from .api import check_api
# Create your views here.

def main(request):
    res = check_api()

    return render(request, 'exchange.html', {
        'dict_data': res
    })

