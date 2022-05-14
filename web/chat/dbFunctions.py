#from django.db import models
#firebase
import os
from pathlib import Path
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime
from pytz import timezone

ROOT_DIR = Path(__file__).resolve().parent.parent
CONFIG_PATH = os.path.join(ROOT_DIR, 'templates\\induk-hybrid-firebase-adminsdk-2bnfi-1d7fb80f7a.json')

db_url = 'https://induk-hybrid.firebaseio.com/'
cred = credentials.Certificate(CONFIG_PATH)
default_app = firebase_admin.initialize_app(cred, {'databaseURL':db_url})
#print(default_app.name)

#firebase db
db = firestore.client()

#댓글 작성 함수
def post(params):

  commentNum = commentAutoIncrement()   #autho increment
  docName = 'comment{}'.format(commentNum) #firebase 문서명

  doc_ref = db.collection(u'comments').document(u''+ docName)
  doc_ref.set({
      u'id': commentNum,
      u'author': params["dic_parmas"]["author"],
      u'comment': params["dic_parmas"]["comment"],
      u'create_date': params["dic_parmas"]["create_date"],
  })
  print('------댓글 작성: {}-----'.format(doc_ref))
  

#모든 댓글 가져오기
def getAllList():
  comments_ref = db.collection(u'comments')
  commentsStream = comments_ref.stream()

  comments = []
  { comment.id: comments.append(comment.to_dict()) for comment in commentsStream }
  return comments

#댓글 하나 가져오기
def getByPK(pk):
  docName = 'comment{}'.format(pk) #firebase 문서명
  print("comment: ".format(docName))

  comment_ref = db.collection(u'comments').document(u'' + docName)
  comment = comment_ref.get()

  print("comment: ".format(comment))
  return comment

#오늘자 댓글만 가져오기
def getAllListByToday():
  comments_ref = db.collection(u'comments')
  commentsStream = comments_ref.stream()

  comments = []
  { comment.id: comments.append(comment.to_dict()) for comment in commentsStream }
  
  now = datetime.now()
  todayComments = []

  for comment in comments:
    past = datetime.strptime(comment['create_date'],"%Y/%m/%d %H:%M:%S")
    diff = now - past
    #print('now= {}'.format(now))
    #print('past= {}'.format(past))
    if(diff.days < 1):
      #print('diff.days= {}'.format(diff.days))
      #print('diff.seconds= {}'.format(diff.seconds))
      todayComments.append(comment)

  return comments


# 댓글 autho increment함수
def commentAutoIncrement():
  comments_ref = db.collection(u'comments')
  commentsStream = comments_ref.stream()

  increment = 1
  for comment in commentsStream:
    if increment <= int(comment.to_dict()['id']):
      increment = int(comment.to_dict()['id']) + 1
  
  return increment

