import os
from dotenv import load_dotenv
from pymongo import MongoClient

load_dotenv()

MONGO_URI = os.getenv("MONGO_URI")
client = MongoClient(MONGO_URI)
db = client['blood_bank_db']

admins_collection = db['admins']
donors_collection = db['donors']
requests_collection = db['requests']
