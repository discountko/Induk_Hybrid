from django.shortcuts import render
from .api import check_api
# Create your views here.

def main(request):
    res = check_api()
    country = res['나라']
    code = res['코드']

    data = code

    return render(request, 'exchange.html', {'country': country, 'code':code, 'data':res})

def result(request):
    nation = list(['USD', 'JPY', 'CNY', 'EUR', 'HKD', "THB", 'GBP', 'CAD', 'MYR'])
    res = check_api()
    for i in range(9):
        if nation[i] in request.POST:
            if nation[i] == 'JPY' :
                name = nation[i]
                korea = request.POST['korea']
                tocountry = int(korea)
                tocountry = round(tocountry / res['매매기준율'][i] * 100, 4)
                return render(request, 'result.html', {'country': tocountry, 'name': name, 'korea': korea})
            else:
                name = nation[i]
                korea = request.POST['korea']
                tocountry = int(korea)
                tocountry = round(tocountry / res['매매기준율'][i], 2)
                return render(request, 'result.html', {'country':tocountry, 'name':name, 'korea':korea})

def about(request):
    return render(request, 'about.html')

