import requests
import json

data_country = list()
data_currencyCode = list()
data_basePrice = list()
data_changePrice = list()
data_signedChangeRate = list()
dict_data = dict()

def check_api():
    url = "https://quotation-api-cdn.dunamu.com/v1/forex/recent?codes=FRX.KRWUSD,FRX.KRWJPY,FRX.KRWCNY,FRX.KRWEUR,FRX.KRWHKD,FRX.KRWTHB,FRX.KRWGBP,FRX.KRWCAD,FRX.KRWCAD,,FRX.KRWMYR,,FRX.KRWRUB,,FRX.KRWZAR,,FRX.KRWNOK,,FRX.KRWDKK"

    res = requests.get(url)
    content = res.text
    json_db = json.loads(content)

    data_country = list()
    data_currencyCode = list()
    data_basePrice = list()
    data_changePrice = list()
    data_signedChangeRate = list()
    dict_data = dict()

    for i in json_db:
        data_currencyCode.append(i['currencyCode'])
        data_country.append(i['country'])
        data_basePrice.append(i['basePrice'])
        data_changePrice.append(i['changePrice'])

        data = round(abs(i['signedChangeRate'] * 100), 2)
        data_signedChangeRate.append(data)

        dict_data['코드'] = data_currencyCode
        dict_data['나라'] = data_country
        dict_data['매매기준율'] = data_basePrice
        dict_data['전일대비'] = data_changePrice
        dict_data['등락률'] = data_signedChangeRate
    return dict_data
