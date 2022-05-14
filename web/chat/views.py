# chat/views.py
from django.contrib.auth.decorators import login_required
from django.http import HttpResponseRedirect
from pytz import timezone
from datetime import datetime
from . import dbFunctions  #파이어베이스 컨넥트 함수
from firebase_admin import auth #파이어베이스 사용자 데이터
from django.shortcuts import render
from django.http import JsonResponse

def index(request):
    return render(request, 'chat/index.html', {})

def room(request):
    login(request) #로그인 임시 사용 수정필요!
    
    return render(request, 'chat/room.html', {
        'room_name': 'chat',
        'user': request.session.get('user'),
        'comments':dbFunctions.getAllListByToday(),
    })

def test(request):
    return render(request, 'chat/test.html', {})

def login(request):
    
    #loginId = request.POST['loginId'] 수정필요!
    loginId = 'test@test.com' # 수정필요!
    user = auth.get_user_by_email(loginId).email

    print('session add = {}'.format(user))

    #세션 추가
    request.session['user'] = user

    return HttpResponseRedirect('/chat')  #메인페이지로 수정필요!


def logout(request):
    if request.session.get('user'):
        request.session['user'] = False

    return HttpResponseRedirect('/board')  #메인페이지로 수정필요!


def post(request):
    now = datetime.now(timezone('Asia/Seoul'))
    params = {}

    if request.method == "POST":
        user = request.session.get('user')
        #로그인 여부 확인
        if not user:
            params["result"] = "F"
            params["message"] = "로그인이 필요한 서비스 입니다."
            print("게시글 작성 실패 - 로그인이 필요한 서비스 입니다.")
            return JsonResponse(params)

        dic_parmas = {}
        dic_parmas["author"] = request.POST['author']
        dic_parmas["comment"] = request.POST['comment']
        dic_parmas["create_date"] = request.POST['create_date']

        params["dic_parmas"] = dic_parmas
        dbFunctions.post(params)

        dic_parmas["result"] = "S"
        return JsonResponse(dic_parmas)