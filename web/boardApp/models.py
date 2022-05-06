#from django.db import models

#firebase
import os
from pathlib import Path
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore


ROOT_DIR = Path(__file__).resolve().parent.parent
CONFIG_PATH = os.path.join(ROOT_DIR, 'templates\\induk-hybrid-firebase-adminsdk-2bnfi-1d7fb80f7a.json')

db_url = 'https://induk-hybrid.firebaseio.com/'
cred = credentials.Certificate(CONFIG_PATH)
default_app = firebase_admin.initialize_app(cred, {'databaseURL':db_url})
print(default_app.name)

#firebase db
db = firestore.client()


class PostDslek():
  doc_ref = db.collection(u'users').document(u'user01')
  doc_ref.set({
      u'level': 30,
      u'money': 700,
      u'job': "knight"
  })